#!/usr/bin/env python3
"""Convert an AE2440 chapter .tex file to a MATLAB plain-text live script .m file.

Usage:
  tex2mlive.py CHAPTER.tex [...]           write CHAPTER.m beside the source (refuses to overwrite)
  tex2mlive.py --force CHAPTER.tex          overwrite an existing CHAPTER.m
  tex2mlive.py --diff CHAPTER.tex           unified diff of the existing .m against a fresh conversion; writes nothing
  tex2mlive.py --check CHAPTER.tex          verify the existing .m is current and that headings, exercises and
                                            figures match the .tex; exit 1 on any mismatch or unresolved reference
  tex2mlive.py --images link CHAPTER.tex    reference images by relative path instead of embedding them

The .tex is the single source. Fix the converter or the .tex, never the generated .m.

Directives are LaTeX comments, invisible in the PDF, placed on their own line
immediately before the environment they modify:

  % mlive: noexec   the next code/lstlisting block is shown as a non-running example
  % mlive: error    the next code block stays runnable but gets its own %% section
                    and a note that it stops with an error on purpose
  % mlive: skip     the next code/stdout/lstlisting/figure/includepdf is omitted

Pipeline (order matters):
1. Strip subfile/document wrappers; read directives; read the chapter number from book.aux.
2. Stash verbatim environments (code, stdout, lstlisting, lstinputlisting, figure,
   includepdf) in one pass so document order is kept for numbering.
3. `\lstinline` family to backticks, then strip LaTeX `%` comments and `\index{}`.
4. Inline LaTeX to markdown on the prose: SI units, math, formatting, refs, typography.
5. Stash lists (innermost first), tabbing, quote and exercise environments.
6. Headings with numbers from the chapter counter.
7. Restore stashes and assemble: one `%[text]` line per paragraph, runnable code bare,
   embedded images in the appendix, required footer.

Output rules:
- `\begin{code}` blocks become runnable cells. `>>` prompts and echoed output are
  dropped; a block that is only a prompt is shown as an example instead.
- `stdout` blocks and `noexec` code are `matlabCodeExample` fenced blocks in prose.
- Cross-references resolve through book.aux: `\ref` gives the number the PDF shows.
- Figures are embedded as `text:image` appendix entries (PNG); run `make images-png`
  in book/ first when a figure only exists as PDF or EPS.
"""

from __future__ import annotations

import argparse
import base64
import difflib
import hashlib
import re
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

DIRECTIVES = ("noexec", "error", "skip")
ERROR_NOTE = '%[text] *This section stops with an error on purpose. Use "Run to End" to continue.*'
FOOTER = ['%[appendix]{"version":"1.0"}', "%---", "%[metadata:view]", '%   data: {"layout":"inline"}', "%---"]
KIND_WORD = {
    "chapter": "Chapter", "section": "Section", "subsection": "Section", "subsubsection": "Section",
    "figure": "Figure", "lstlisting": "Listing", "ex": "Exercise", "equation": "Equation", "table": "Table",
}
RASTER_EXTS = (".png", ".jpg", ".jpeg", ".gif", ".bmp")
VECTOR_EXTS = (".pdf", ".eps", ".svg")
MIME = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".gif": "image/gif", ".bmp": "image/bmp"}

_CODE, _ENDCODE, _SECTION = "\x02CODE\x02", "\x02ENDCODE\x02", "\x02SECTION\x02"


class ConversionError(Exception):
    pass


# ---------------------------------------------------------------------------
# Stash machinery
# ---------------------------------------------------------------------------

class Stash:
    def __init__(self, letter: str) -> None:
        self.letter = letter
        self.items: list[str] = []
        self.marker_re = re.compile("\x00" + letter + r"(\d+)\x00")

    def add(self, chunk: str) -> str:
        self.items.append(chunk)
        return f"\x00{self.letter}{len(self.items) - 1}\x00"

    def restore(self, text: str) -> str:
        # Markers can nest (a list stashed inside an exercise body), so loop
        # until nothing changes.
        for _ in range(20):
            new = self.marker_re.sub(lambda m: self.items[int(m.group(1))], text)
            if new == text:
                return text
            text = new
        raise ConversionError("stash restore did not converge")


# ---------------------------------------------------------------------------
# Brace-balanced helpers
# ---------------------------------------------------------------------------

def balanced(text: str, i: int) -> tuple[str | None, int]:
    """`text[i]` is just past an opening brace. Return (content, index after the
    closing brace), or (None, i) if unbalanced."""
    depth = 1
    j = i
    while j < len(text):
        ch = text[j]
        if ch == "\\":
            j += 2
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return text[i:j], j + 1
        j += 1
    return None, i


def take_args(text: str, i: int, n: int) -> tuple[list[str] | None, int]:
    """Read `n` consecutive `{…}` groups starting at `text[i]` (whitespace allowed
    between them)."""
    args: list[str] = []
    for _ in range(n):
        while i < len(text) and text[i].isspace():
            i += 1
        if i >= len(text) or text[i] != "{":
            return None, i
        arg, i = balanced(text, i + 1)
        if arg is None:
            return None, i
        args.append(arg)
    return args, i


def sub_balanced(text: str, head_re: re.Pattern, fn) -> str:
    """For each match of `head_re` (which must end just past an opening brace),
    read the balanced argument and replace the match plus argument with
    `fn(match, arg)`."""
    out: list[str] = []
    pos = 0
    while True:
        m = head_re.search(text, pos)
        if not m:
            out.append(text[pos:])
            break
        arg, end = balanced(text, m.end())
        if arg is None:
            out.append(text[pos:m.end()])
            pos = m.end()
            continue
        out.append(text[pos:m.start()])
        out.append(fn(m, arg))
        pos = end
    return "".join(out)


def strip_command_balanced(text: str, command: str) -> str:
    """Remove every `\\command{…}` (nested braces allowed) plus a trailing `%`."""
    head = re.compile(r"\\" + re.escape(command) + r"\{")

    def drop(m: re.Match, arg: str) -> str:
        return ""

    text = sub_balanced(text, head, drop)
    return text


_FMT_RE = re.compile(r"\\(texttt|textbf|textit|emph|mbox|hbox|keycap|footnote|textsf|textsc)\s*\{")


def _fmt(cmd: str, arg: str) -> str:
    if cmd == "texttt":
        return f"`{arg}`"
    if cmd in ("textbf", "keycap"):
        return f"**{arg}**"
    if cmd in ("textit", "emph"):
        return f"*{arg}*"
    if cmd == "footnote":
        return f" (note: {arg.strip()})"
    return arg


def sub_formatting(text: str) -> str:
    """Convert text-formatting commands innermost first, so nested forms such as
    `\\mbox{\\emph{always}}` and `\\textbf{\\lstinline{…}}` come out right."""
    while True:
        pos = 0
        changed = False
        while True:
            m = _FMT_RE.search(text, pos)
            if not m:
                break
            arg, end = balanced(text, m.end())
            if arg is None or _FMT_RE.search(arg):
                pos = m.end()
                continue
            text = text[:m.start()] + _fmt(m.group(1), arg) + text[end:]
            changed = True
            break
        if not changed:
            return text


# ---------------------------------------------------------------------------
# Labels from book.aux
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class Label:
    kind: str
    number: str
    title: str


_NEWLABEL_RE = re.compile(
    r"\\newlabel\{([^}]+)\}\{\{([^}]*)\}\{[^}]*\}\{((?:[^{}]|\{[^{}]*\})*)\}\{([^}]*)\}"
)


_TOC_CHAPTER_RE = re.compile(r"\\contentsline \{chapter\}\{\\numberline \{([^}]*)\}([^}]*)\}")


def load_labels(aux_path: Path) -> dict[str, Label]:
    """Labels from `\\newlabel` plus one synthetic `chapter:<title>` entry per
    chapter from the table-of-contents lines, for chapters without a label."""
    labels: dict[str, Label] = {}
    for line in aux_path.read_text(encoding="utf-8", errors="replace").splitlines():
        t = _TOC_CHAPTER_RE.search(line)
        if t:
            labels.setdefault(f"chapter:{t.group(2).strip()}", Label("chapter", t.group(1), t.group(2).strip()))
        m = _NEWLABEL_RE.search(line)
        if not m:
            continue
        name, number, title, anchor = m.groups()
        if name.endswith("@cref"):
            continue
        kind = anchor.split(".")[0]
        title = re.sub(r"\\relax\b", "", title).strip()
        labels[name] = Label(kind, number, title)
    return labels


# ---------------------------------------------------------------------------
# Math conversion
# ---------------------------------------------------------------------------

def _convert_math_body(body: str) -> str:
    body = body.strip()
    body = re.sub(r"\\label\{[^{}]*\}", "", body)
    # MATLAB's live-script LaTeX vocabulary does not include `\uvec` (a custom
    # unit-vector macro from book.tex); `\hat` renders.
    body = re.sub(r"\\uvec\b", r"\\hat", body)
    body = re.sub(r"\\-", "", body)
    body = body.replace("\\", "\\\\")
    # MATLAB escapes these inside `$...$` on re-save; emitting them keeps the
    # round trip clean.
    body = body.replace("_", "\\_").replace("[", "\\[").replace("]", "\\]").replace(">", "\\>")
    return re.sub(r"\s+", " ", body)


def _find_unescaped(text: str, ch: str, start: int) -> int:
    i = start
    while i < len(text):
        if text[i] == "\\" and i + 1 < len(text):
            i += 2
            continue
        if text[i] == ch:
            return i
        i += 1
    return -1


def convert_inline_math(text: str, math: Stash) -> str:
    text = re.sub(r"\\\((.+?)\\\)",
                  lambda m: math.add("$" + _convert_math_body(m.group(1)) + "$"),
                  text, flags=re.S)
    out: list[str] = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "\\" and i + 1 < len(text):
            out.append(text[i:i + 2])
            i += 2
            continue
        if ch == "$" and (i + 1 >= len(text) or text[i + 1] != "$"):
            j = _find_unescaped(text, "$", i + 1)
            if j == -1:
                out.append(text[i:])
                break
            out.append(math.add("$" + _convert_math_body(text[i + 1:j]) + "$"))
            i = j + 1
        else:
            out.append(ch)
            i += 1
    return "".join(out)


def convert_display_math(text: str, math: Stash) -> str:
    def display(body: str) -> str:
        return '\n\n%[text]{"align":"center"} ' + math.add("$" + _convert_math_body(body) + "$") + "\n\n"

    text = re.sub(r"\\\[(.+?)\\\]", lambda m: display(m.group(1)), text, flags=re.S)
    for env in ("equation", "equation*", "align", "align*"):
        pat = re.compile(rf"\\begin\{{{re.escape(env)}\}}(.*?)\\end\{{{re.escape(env)}\}}", re.S)
        text = pat.sub(lambda m: display(m.group(1)), text)
    for env in ("eqnarray", "eqnarray*"):
        pat = re.compile(rf"\\begin\{{{re.escape(env)}\}}(.*?)\\end\{{{re.escape(env)}\}}", re.S)
        text = pat.sub(lambda m: display(r"\begin{array}{rcl}" + m.group(1) + r"\end{array}"), text)
    return text


# ---------------------------------------------------------------------------
# Code emission
# ---------------------------------------------------------------------------

def _emit_runnable_code(body: str) -> str:
    """`>> …` interactive session to runnable MATLAB. The `>>` and the echoed
    output lines are dropped; `...` continuations are honored."""
    lines = body.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        stripped = lines[i].strip()
        if stripped.startswith(">>"):
            cmd = stripped[2:].lstrip()
            if cmd:
                out.append(cmd)
            i += 1
            while out and out[-1].rstrip().endswith("...") and i < len(lines):
                cont = lines[i]
                out.append(cont.rstrip())
                if not cont.rstrip().endswith("..."):
                    i += 1
                    break
                i += 1
            while i < len(lines):
                nxt = lines[i].strip()
                if nxt.startswith(">>") or nxt == "":
                    break
                i += 1
        else:
            i += 1
    return "\n".join(out)


def _emit_example(body: str) -> str:
    """Non-running code shown in prose as a `matlabCodeExample` fenced block, the
    one fenced form known to be real syntax (MathWorks' R2026b template)."""
    lines = body.splitlines()
    while lines and lines[0].strip() == "":
        lines.pop(0)
    while lines and lines[-1].strip() == "":
        lines.pop()
    out = ["%[text] ```matlabCodeExample"]
    for ln in lines:
        out.append(f"%[text] {ln.rstrip()}" if ln.strip() else "%[text] ")
    out.append("%[text] ```")
    return "\n".join(out)


def _runnable(code: str) -> str:
    return f"\n\n{_CODE}\n{code}\n{_ENDCODE}\n\n"


def _read_file_range(path: Path, firstline: int | None, lastline: int | None) -> str:
    lines = path.read_text(encoding="utf-8").splitlines()
    return "\n".join(lines[(firstline or 1) - 1:lastline or len(lines)])


# ---------------------------------------------------------------------------
# Images
# ---------------------------------------------------------------------------

def image_dims(data: bytes) -> tuple[int, int] | None:
    if data[:8] == b"\x89PNG\r\n\x1a\n":
        w, h = struct.unpack(">II", data[16:24])
        return w, h
    if data[:2] == b"\xff\xd8":
        i = 2
        while i + 9 < len(data):
            if data[i] != 0xFF:
                i += 1
                continue
            marker = data[i + 1]
            if marker in (0xC0, 0xC1, 0xC2):
                h, w = struct.unpack(">HH", data[i + 5:i + 9])
                return w, h
            i += 2 + struct.unpack(">H", data[i + 2:i + 4])[0]
    return None


# ---------------------------------------------------------------------------
# Converter
# ---------------------------------------------------------------------------

_DIR_LINE_RE = re.compile(r"^[ \t]*%[ \t]*mlive:[ \t]*(\w+)[ \t]*$", re.M)
_DIR_TOKEN_RE = re.compile(r"\x03(\w+)\x03\s*")
_VERBATIM_RE = re.compile(
    r"(?:\x03(?P<dir>\w+)\x03\s*)?(?:"
    r"\\begin\{code\}(?P<code>.*?)\\end\{code\}"
    r"|\\begin\{stdout\}(?P<stdout>.*?)\\end\{stdout\}"
    r"|\\begin\{lstlisting\}(?P<lstopts>\[[^\]]*\])?(?P<lst>.*?)\\end\{lstlisting\}"
    r"|\\lstinputlisting(?P<lstinopts>\[[^\]]*\])?\s*\{(?P<lstin>[^}]+)\}"
    r"|\\begin\{figure\}(?:\[[^\]]*\])?(?P<figure>.*?)\\end\{figure\}"
    r"|\\includepdf(?:\[[^\]]*\])?\{(?P<pdf>[^}]+)\}"
    r")",
    re.S,
)
_HEAD_RE = re.compile(r"\\(section|subsection|subsubsection|paragraph)(\*?)(?:\[[^\]]*\])?\s*\{")
_LIST_BEGIN_RE = re.compile(r"\\begin\{(enumerate|itemize|description)\}(?:\[[^\]]*\])?")
_LIST_ITEM_RE = re.compile(r"^(\s*)((?:[-*]\s|\d+\.\s).*)$")


@dataclass
class Converter:
    source_path: Path | None = None
    book_root: Path | None = None
    labels: dict[str, Label] = field(default_factory=dict)
    images: str = "embed"
    image_width: int = 560
    title_hint: str = ""
    warnings: list[str] = field(default_factory=list)

    def __post_init__(self) -> None:
        self.chapter_num: str | None = None
        self.chapter_title = ""
        self.counts = {"section": 0, "subsection": 0, "subsubsection": 0, "figure": 0, "listing": 0, "ex": 0}
        self.image_entries: list[tuple[str, str]] = []
        self.used_ids: set[str] = set()
        self.verb = Stash("V")
        self.block = Stash("B")
        self.math = Stash("M")

    def warn(self, msg: str) -> None:
        self.warnings.append(msg)

    # -- numbering ---------------------------------------------------------

    def _num(self, kind: str) -> str:
        """Advance the counter for `kind` and return its PDF-style number."""
        c = self.counts
        if kind == "section":
            c["section"] += 1
            c["subsection"] = c["subsubsection"] = 0
            parts = [c["section"]]
        elif kind == "subsection":
            c["subsection"] += 1
            c["subsubsection"] = 0
            parts = [c["section"], c["subsection"]]
        elif kind == "subsubsection":
            c["subsubsection"] += 1
            parts = [c["section"], c["subsection"], c["subsubsection"]]
        else:
            c[kind] += 1
            parts = [c[kind]]
        if self.chapter_num is None:
            return ""
        return ".".join([self.chapter_num] + [str(p) for p in parts])

    def _resolve_chapter(self, tex: str) -> None:
        m = re.search(r"\\chapter\*?\s*\{", tex)
        if m:
            title, end = balanced(tex, m.end())
            self.chapter_title = re.sub(r"\s+", " ", title or "").strip() or self.title_hint
            lab = re.match(r"\s*\\label\{([^}]*)\}", tex[end:])
            if lab and lab.group(1) in self.labels and self.labels[lab.group(1)].kind == "chapter":
                self.chapter_num = self.labels[lab.group(1)].number
        else:
            self.chapter_title = self.title_hint or "Chapter"
        if self.chapter_num is None:
            for lb in self.labels.values():
                if lb.kind == "chapter" and lb.title == self.chapter_title:
                    self.chapter_num = lb.number
                    break
        if self.chapter_num is None:
            self.warn("chapter number not found in book.aux; headings and references are unnumbered")

    def _check_numbering(self, tex: str) -> None:
        """Compare in-order heading numbers with book.aux for labelled headings;
        a mismatch means the aux is stale relative to the .tex."""
        if self.chapter_num is None:
            return
        c = {"section": 0, "subsection": 0, "subsubsection": 0}
        for m in _HEAD_RE.finditer(tex):
            kind, star = m.group(1), m.group(2)
            if kind == "paragraph" or star:
                continue
            if kind == "section":
                c["section"] += 1
                c["subsection"] = c["subsubsection"] = 0
                num = f"{self.chapter_num}.{c['section']}"
            elif kind == "subsection":
                c["subsection"] += 1
                c["subsubsection"] = 0
                num = f"{self.chapter_num}.{c['section']}.{c['subsection']}"
            else:
                c["subsubsection"] += 1
                num = f"{self.chapter_num}.{c['section']}.{c['subsection']}.{c['subsubsection']}"
            _, end = balanced(tex, m.end())
            lab = re.match(r"\s*\\label\{([^}]*)\}", tex[end:])
            if lab and lab.group(1) in self.labels and self.labels[lab.group(1)].number != num:
                self.warn(f"heading number {num} disagrees with book.aux ({self.labels[lab.group(1)].number}) "
                          f"for label `{lab.group(1)}`; rebuild with `make book`")

    # -- references --------------------------------------------------------

    def _ref(self, label: str, with_word: bool) -> str:
        lb = self.labels.get(label)
        if lb is None:
            self.warn(f"unresolved reference `{label}` (not in book.aux)")
            return f"§{label}"
        word = KIND_WORD.get(lb.kind, lb.kind.capitalize())
        if lb.kind == "chapter":
            text = f"{word} {lb.number}" if with_word else lb.number
            return f"{text}, {lb.title}" if lb.title else text
        return f"{word} {lb.number}" if with_word else lb.number

    def render_refs(self, text: str) -> str:
        text = re.sub(r"(?:page[~ ])?\\pageref\{([^}]*)\}", lambda m: self._ref(m.group(1), True), text)
        text = re.sub(r"\\nameref\{([^}]*)\}",
                      lambda m: f"*{self.labels[m.group(1)].title}*" if m.group(1) in self.labels
                      else self._ref(m.group(1), True), text)
        text = re.sub(r"\\(?:autoref|Cref)\{([^}]*)\}", lambda m: self._ref(m.group(1), True), text)
        text = re.sub(r"\\ref\{([^}]*)\}", lambda m: self._ref(m.group(1), False), text)
        return text

    # -- inline prose pass ---------------------------------------------------

    def _in_math(self, text: str, pos: int) -> bool:
        before = text[:pos]
        if before.rfind("\\[") > before.rfind("\\]"):
            return True
        return len(re.findall(r"(?<!\\)\$", before)) % 2 == 1

    def render_si(self, text: str) -> str:
        unit_map = {
            "meter": "m", "metre": "m", "meters": "m", "second": "s", "seconds": "s",
            "minute": "min", "minutes": "min", "kilogram": "kg", "kilograms": "kg",
            "gram": "g", "grams": "g", "celsius": "°C", "degree": "°", "radian": "rad",
            "kilometer": "km", "kilometers": "km", "newton": "N", "hertz": "Hz",
        }

        def unit_text(unit: str) -> str:
            unit = re.sub(r"\\per\b", "/", unit)
            unit = re.sub(r"\\squared\b", "^2", unit)
            unit = re.sub(r"\\cubed\b", "^3", unit)
            for k, v in unit_map.items():
                unit = re.sub(rf"\\{k}\b", v, unit)
            if re.search(r"\\[a-zA-Z]+", unit):
                self.warn(f"unknown SI unit in `{unit}`")
            unit = re.sub(r"\\[a-zA-Z]+", "", unit)
            return unit.replace("{", "").replace("}", "").strip()

        def si(m: re.Match) -> str:
            val, unit = m.group(1).strip(), unit_text(m.group(2))
            if self._in_math(m.string, m.start()):
                return f"{val}\\,\\mathrm{{{unit}}}" if unit else val
            return f"{val} {unit}".strip()

        text = re.sub(r"\\SI\s*\{([^}]*)\}\s*\{([^}]*)\}", si, text)
        text = re.sub(r"\\si\s*\{([^}]*)\}",
                      lambda m: (f"\\mathrm{{{unit_text(m.group(1))}}}" if self._in_math(m.string, m.start())
                                 else unit_text(m.group(1))), text)
        return text

    def inline(self, s: str) -> str:
        """Inline LaTeX to markdown on prose that has had comments and `\\index`
        removed. Math is stashed so its backslashes are doubled exactly once."""
        s = self.render_si(s)
        s = convert_display_math(s, self.math)
        s = convert_inline_math(s, self.math)
        s = sub_formatting(s)
        s = re.sub(r"\{\\(bf|em|it|tt)\s+([^{}]*)\}",
                   lambda m: f"**{m.group(2)}**" if m.group(1) == "bf" else
                   (f"`{m.group(2)}`" if m.group(1) == "tt" else f"*{m.group(2)}*"), s)
        s = re.sub(r"\\textunderscore\s*", "_", s)
        s = re.sub(r"\\textdegree\s*", "°", s)

        s = re.sub(r"\\(?:l|d)?dots\b", "…", s)
        s = re.sub(r"\\LaTeX\b", "LaTeX", s)
        s = sub_balanced(s, re.compile(r"\\href\s*\{"),
                         lambda m, url: self._href(m.string, m, url))
        s = re.sub(r"\\url\{([^}]*)\}", lambda m: f"<{m.group(1)}>", s)
        s = re.sub(r"\\linebreak\b", " ", s)
        s = re.sub(r"\\ ", " ", s)
        s = s.replace("\\$", "$").replace("\\%", "%").replace("\\&", "&").replace("\\#", "#")
        s = re.sub(r"\\_", "_", s)
        s = s.replace("\\-", "")
        s = re.sub(r"\\[,;:!]", " ", s)
        s = self.render_refs(s)
        s = re.sub(r"\\label\{[^}]*\}", "", s)
        s = self._epigraphs(s)
        for needle, repl in (("~", " "), ("---", "—"), ("--", "–"), ("``", "“"), ("''", "”")):
            s = _replace_outside_backticks(s, needle, repl)
        return s

    def _href(self, text: str, m: re.Match, url: str) -> str:
        # `\href{url}{label}`: sub_balanced consumed the first argument; the
        # second is still in the text right after it, so mark it for a fix-up.
        return f"\x04HREF{url}\x04"

    def _fix_hrefs(self, s: str) -> str:
        return sub_balanced(s, re.compile(r"\x04HREF([^\x04]*)\x04\s*\{"),
                            lambda m, label: f"[{label}]({m.group(1)})")

    @staticmethod
    def _split_italic_links(s: str) -> str:
        """An italic span holding a link is written split around the link.
        Not idempotent: apply once, after links are resolved."""
        return re.sub(r"(?<![*\\])\*([^*\n]*\[[^\]]*\]\([^)]*\)[^*\n]*)\*(?!\*)",
                      lambda m: _italic_para(m.group(1)), s)

    def _epigraphs(self, s: str) -> str:
        out: list[str] = []
        pos = 0
        head = re.compile(r"\\epigraph\s*")
        while True:
            m = head.search(s, pos)
            if not m:
                out.append(s[pos:])
                break
            args, end = take_args(s, m.end(), 2)
            if args is None:
                out.append(s[pos:m.end()])
                pos = m.end()
                continue
            quote = re.sub(r"\s+", " ", re.sub(r"\\\\", " ", args[0])).strip()
            author = re.sub(r"\s+", " ", args[1]).strip()
            out.append(s[pos:m.start()])
            out.append(f'\n\n%[text]{{"align":"center"}} {_italic_para(quote)} — {author}\n\n')
            pos = end
        return "".join(out)

    # -- verbatim environments -----------------------------------------------

    def _caption_text(self, raw: str) -> str:
        raw = strip_command_balanced(raw, "index")
        raw = re.sub(r"\\label\{[^}]*\}", "", raw)
        raw = re.sub(r"\\lstinline\{([^}]*)\}", lambda m: f"`{m.group(1)}`", raw)
        return re.sub(r"\s+", " ", self._split_italic_links(self._fix_hrefs(self.inline(raw)))).strip()

    @staticmethod
    def _alt_text(raw: str) -> str:
        s = strip_command_balanced(raw, "index")
        s = re.sub(r"\\label\{[^}]*\}", "", s)
        s = s.replace("$", "")
        s = re.sub(r"\\[A-Za-z]+\*?", "", s)
        s = s.replace("{", "").replace("}", "").replace("[", "(").replace("]", ")")
        return re.sub(r"\s+", " ", s).strip()

    def _captions(self, text: str) -> list[str]:
        out: list[str] = []
        pos = 0
        pat = re.compile(r"\\caption\s*\{")
        while True:
            m = pat.search(text, pos)
            if not m:
                return out
            arg, end = balanced(text, m.end())
            if arg is None:
                return out
            out.append(arg)
            pos = end

    def _resolve_image(self, path: str) -> Path | None:
        if self.book_root is None:
            return None
        p = self.book_root / path
        candidates = [p] if p.suffix else []
        candidates += [p.with_suffix(ext) for ext in RASTER_EXTS + VECTOR_EXTS]
        rasters = [c for c in candidates if c.suffix.lower() in RASTER_EXTS and c.exists()]
        if rasters:
            return rasters[0]
        vectors = [c for c in candidates if c.suffix.lower() in VECTOR_EXTS and c.exists()]
        if vectors:
            raise ConversionError(f"figure `{path}` exists only as {vectors[0].suffix}; run `make images-png` in book/")
        self.warn(f"figure `{path}` not found under {self.book_root}")
        return None

    def _image_ref(self, path: str, alt: str) -> str:
        resolved = self._resolve_image(path)
        if resolved is None:
            return f'%[text]{{"align":"center"}} *(missing figure: {path})*'
        if self.images == "link":
            rel = Path(_relpath(resolved, self.source_path.parent if self.source_path else Path.cwd()))
            return f'%[text]{{"align":"center"}} ![{alt}]({rel.as_posix()})'
        data = resolved.read_bytes()
        digest = hashlib.sha1(data).hexdigest()
        img_id = next(digest[i:i + 4] for i in range(0, 36) if digest[i:i + 4] not in self.used_ids)
        self.used_ids.add(img_id)
        dims = image_dims(data)
        if dims is None:
            self.warn(f"could not read the size of `{resolved.name}`; MATLAB will use its own")
            size = ""
        else:
            w, h = dims
            dw = min(w, self.image_width)
            dh = round(h * dw / w)
            size = f'"height":{dh},'
            size_w = f',"width":{dw}'
        src = f"data:{MIME[resolved.suffix.lower()]};base64," + base64.b64encode(data).decode("ascii")
        src = src.replace("/", "\\/")
        entry = f'%   data: {{"align":"baseline",{size}"src":"{src}"{size_w if dims else ""}}}'
        self.image_entries.append((img_id, entry))
        return f'%[text]{{"align":"center"}} ![{alt}](text:image:{img_id})'

    def render_figure(self, body: str) -> str:
        body = _strip_comments(body)
        captions = self._captions(body)
        outer_raw = captions[-1] if captions else ""
        num = self._num("figure")
        subfigs: list[tuple[str, str]] = []
        for sfm in re.finditer(r"\\begin\{subfigure\}.*?\\end\{subfigure\}", body, flags=re.S):
            sub = sfm.group(0)
            img = re.search(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}", sub)
            caps = self._captions(sub)
            if img:
                subfigs.append((img.group(1), caps[0] if caps else ""))
        if not subfigs:
            subfigs = [(pm.group(1), "") for pm in
                       re.finditer(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}", body)]
        lines: list[str] = []
        for i, (path, cap_raw) in enumerate(subfigs):
            alt = self._alt_text(cap_raw or outer_raw)
            lines.append(self._image_ref(path, alt))
            if cap_raw and len(subfigs) > 1:
                lines.append(f'%[text]{{"align":"center"}} *({chr(97 + i)}) {self._caption_text(cap_raw)}*')
        if outer_raw:
            label = f"Figure {num}: " if num else "Figure: "
            lines.append(f'%[text]{{"align":"center"}} *{label}{self._caption_text(outer_raw)}*')
        if not lines:
            lines.append("%[text] *(figure)*")
        return "\n\n" + "\n".join(lines) + "\n\n"

    def render_listing(self, opts: str, body: str, directive: str | None, source: str = "") -> str:
        cap_raw = None
        m = re.search(r"caption\s*=\s*\{", opts)
        if m:
            cap_raw, _ = balanced(opts, m.end())
        lang = re.search(r"language\s*=\s*([A-Za-z]+)", opts)
        lang = lang.group(1).lower() if lang else "matlab"
        prefix = ""
        if cap_raw is not None:
            num = self._num("listing")
            label = f"**Listing {num}.** " if num else "**Listing.** "
            prefix = f"%[text] {label}{self._caption_text(cap_raw)}\n"
        if directive == "noexec" or lang != "matlab":
            return f"\n\n{prefix}{_emit_example(body)}\n\n"
        return f"\n\n{prefix}{_CODE}\n{body.strip(chr(10))}\n{_ENDCODE}\n\n"

    def render_verbatim(self, m: re.Match) -> str:
        # Comments are stripped after this pass (code bodies may hold `%`), so
        # an environment that starts on a commented line is left alone here and
        # the comment stripper removes the line.
        line_start = m.string.rfind("\n", 0, m.start()) + 1
        if re.search(r"(?<!\\)%", m.string[line_start:m.start()]):
            if "\n" in m.group(0).strip():
                self.warn("a commented-out environment spans several lines; only its first line is a comment")
            return m.group(0)
        directive = m.group("dir")
        if directive is not None and directive not in DIRECTIVES:
            self.warn(f"unknown directive `mlive: {directive}`")
            directive = None
        if directive == "skip":
            return "\n\n"
        if m.group("code") is not None:
            body = m.group("code")
            if directive == "noexec":
                return "\n\n" + _emit_example(body) + "\n\n"
            if re.search(r"^\s*>>", body, flags=re.M):
                code = _emit_runnable_code(body)
                if not code.strip():
                    return "\n\n" + _emit_example(body) + "\n\n"
            else:
                code = re.sub(r"\n\s*$", "", body.strip("\n"))
            if directive == "error":
                return f"\n\n{_SECTION}\n{ERROR_NOTE}\n{_CODE}\n{code}\n{_ENDCODE}\n{_SECTION}\n\n"
            return _runnable(code)
        if m.group("stdout") is not None:
            return "\n\n" + _emit_example(m.group("stdout")) + "\n\n"
        if m.group("lst") is not None:
            return self.render_listing(m.group("lstopts") or "", m.group("lst"), directive)
        if m.group("lstin") is not None:
            opts = m.group("lstinopts") or ""
            rel = m.group("lstin").strip()
            first = re.search(r"firstline\s*=\s*(\d+)", opts)
            last = re.search(r"lastline\s*=\s*(\d+)", opts)
            body = ""
            if self.book_root is not None and (self.book_root / rel).exists():
                body = _read_file_range(self.book_root / rel,
                                        int(first.group(1)) if first else None,
                                        int(last.group(1)) if last else None)
            if not body:
                self.warn(f"lstinputlisting source `{rel}` not found")
                return f"\n\n%[text] **Listing** (source: `{rel}`).\n\n"
            return self.render_listing(opts, body, directive)
        if m.group("figure") is not None:
            return self.render_figure(m.group("figure"))
        if m.group("pdf") is not None:
            # A PDF page (a live-script export in chapter 2) is shown as an
            # image of its first page; `make images-png` writes the PNG twin.
            name = m.group("pdf")
            stem = name[:-4] if name.lower().endswith(".pdf") else name
            return "\n\n" + self._image_ref(stem, f"Page 1 of {Path(name).name}") + "\n\n"
        return m.group(0)

    # -- lists and other block environments ----------------------------------

    def _render_list(self, kind: str, body: str) -> str:
        items = re.split(r"\\item\b", body)[1:]
        out: list[str] = []
        for k, it in enumerate(items, 1):
            it = self.block.restore(it)
            head_lines: list[str] = []
            rest: list[str] = []
            for ln in it.splitlines():
                if not ln.strip():
                    continue
                if rest or _LIST_ITEM_RE.match(ln) or ln.lstrip().startswith(("%[", _CODE, _ENDCODE)):
                    rest.append(ln)
                else:
                    head_lines.append(ln.strip())
            head = " ".join(" ".join(head_lines).split())
            if kind == "enumerate":
                marker = f"{k}. "
            elif kind == "itemize":
                marker = "- "
            else:
                marker = "- "
                if head.startswith("["):
                    label, rest_text = _split_desc_label(head)
                    if label is not None:
                        head = f"**{label}** {rest_text}" if label.endswith(":") else f"**{label}** — {rest_text}"
            out.append(marker + head)
            for ln in rest:
                out.append(ln if ln.startswith("%[") or ln.startswith("\x02") else "  " + ln)
        # MATLAB marks the end of a list with ` \` on its last item and adds it
        # on re-save; emitting it keeps the round trip clean.
        out[-1] = out[-1] + " \\"
        return "\n\n" + "\n".join(out) + "\n\n"

    def stash_lists(self, s: str) -> str:
        """Stash list environments innermost first so nested lists convert
        correctly (the earlier non-greedy regex mis-paired them)."""
        while True:
            m = _LIST_BEGIN_RE.search(s)
            if not m:
                return s
            # Find the innermost list starting at or after this one.
            start = m
            while True:
                kind = start.group(1)
                end = re.compile(r"\\end\{" + kind + r"\}").search(s, start.end())
                if end is None:
                    self.warn(f"unterminated {kind} environment")
                    return s
                inner = _LIST_BEGIN_RE.search(s, start.end(), end.start())
                if inner is None:
                    break
                start = inner
            body = s[start.end():end.start()]
            s = s[:start.start()] + self.block.add(self._render_list(start.group(1), body)) + s[end.end():]

    def render_ex(self, m: re.Match) -> str:
        body = m.group(1).strip()
        num = self._num("ex")
        label = f"**Exercise {num}.**" if num else "**Exercise.**"
        paras = re.split(r"\n\s*\n", body, maxsplit=1)
        first = " ".join(paras[0].split())
        if first and not first.startswith(("\x00", "\x02", "%[", "-", "1.")):
            head = f"%[text] {label} {first}"
            rest = paras[1] if len(paras) > 1 else ""
        else:
            head = f"%[text] {label} "
            rest = body
        return f"\n\n{head}\n\n{rest}\n\n"

    # -- main ----------------------------------------------------------------

    def convert(self, tex: str) -> str:
        s = tex
        s = re.sub(r"\\documentclass\b.*?(?=\\begin\{document\})", "", s, flags=re.S)
        s = re.sub(r"\\(?:begin|end)\{document\}", "", s)

        s = _lift_heading_footnotes(s)

        # Directives become tokens glued to the following environment.
        s = _DIR_LINE_RE.sub(lambda m: f"\x03{m.group(1).lower()}\x03", s)

        raw_no_comments = _strip_comments(s)
        self._resolve_chapter(raw_no_comments)
        self._check_numbering(raw_no_comments)

        # 2. Verbatim environments, one pass, document order.
        s = _VERBATIM_RE.sub(lambda m: self.verb.add(self.render_verbatim(m)), s)
        leftover = _DIR_TOKEN_RE.findall(s)
        if leftover:
            self.warn(f"directive(s) {leftover} were not followed by a code, stdout, listing or figure environment")
            s = _DIR_TOKEN_RE.sub("", s)

        # 3. Inline code to backticks before comment stripping (`\lstinline{%f}`).
        s = sub_balanced(s, re.compile(r"\\lstinline(?:\[[^\]]*\])?\s*\{"), lambda m, a: f"`{a}`")
        s = re.sub(r"\\lstinline(?:\[[^\]]*\])?([^\sA-Za-z{\[])(.*?)\1", lambda m: f"`{m.group(2)}`", s)
        s = re.sub(r"\\Verb([^\sA-Za-z{\[])(.*?)\1", lambda m: f"`{m.group(2)}`", s)
        s = sub_balanced(s, re.compile(r"\\mcode\s*\{"), lambda m, a: f"`{a}`")
        s = _strip_comments(s)

        # 4. `\index{}` and layout-only tokens.
        s = strip_command_balanced(s, "index")
        for tok in ("noindent", "clearpage", "pagebreak", "newpage", "bigskip", "medskip", "smallskip",
                    "centering", "protect", "linewidth", "textwidth", "maxdimen"):
            s = re.sub(r"\\" + tok + r"\b", "", s)
        s = sub_balanced(s, re.compile(r"\\centerline\s*\{"), lambda m, a: a)
        s = re.sub(r"\\hspace\*?\{[^}]*\}", " ", s)
        s = re.sub(r"\\vspace\*?\{[^}]*\}", "", s)
        s = re.sub(r"\\(?:binop|rel)penalty\s*=\s*\S+", "", s)

        # 5. Inline prose pass.
        s = self.inline(s)
        s = self._split_italic_links(self._fix_hrefs(s))

        # 6. Block environments.
        s = self.stash_lists(s)

        def render_tabbing(m: re.Match) -> str:
            body = re.sub(r"\\hspace\{[^}]*\}", "", m.group(1))
            body = re.sub(r"\\(?:kill|>|=)", "", body)
            body = re.sub(r"\\\\", "  ", body)
            return "\n\n" + body.strip() + "\n\n"
        s = re.sub(r"\\begin\{tabbing\}(.*?)\\end\{tabbing\}",
                   lambda m: self.block.add(render_tabbing(m)), s, flags=re.S)

        def render_quote(m: re.Match) -> str:
            # Blockquotes (`> `) are not live-script markdown: MATLAB shows the
            # line as code and mangles the marker on re-save. Centered italics
            # carry the same weight.
            paras = [" ".join(p.split()) for p in re.split(r"\n\s*\n", m.group(1).strip()) if p.strip()]
            return "\n\n" + "\n".join(f'%[text]{{"align":"center"}} {_italic_para(p)}' for p in paras) + "\n\n"
        s = re.sub(r"\\begin\{quote\}(.*?)\\end\{quote\}",
                   lambda m: self.block.add(render_quote(m)), s, flags=re.S)
        s = re.sub(r"\\begin\{ex\}(.*?)\\end\{ex\}",
                   lambda m: self.block.add(self.render_ex(m)), s, flags=re.S)

        # 7. Headings.
        s = sub_balanced(s, re.compile(r"\\chapter\*?\s*\{"), lambda m, a: "")

        def heading(m: re.Match, title: str) -> str:
            kind, star = m.group(1), m.group(2)
            title = " ".join(title.split())
            if kind == "paragraph":
                return f"\n%[text] **{title}**\n"
            num = "" if star else self._num(kind)
            text = f"{num} {title}".strip()
            if kind == "section":
                return f"\n{_SECTION}\n%[text] ## {text}\n"
            if kind == "subsection":
                return f"\n%[text] ### {text}\n"
            return f"\n%[text] #### {text}\n"
        s = sub_balanced(s, _HEAD_RE, heading)

        # 8. Restore and assemble.
        s = self.block.restore(s)
        s = self.verb.restore(s)
        s = self.math.restore(s)
        s = self._fix_hrefs(s)

        out = self._finalize(s)
        self._hygiene(out)
        return out

    def _finalize(self, body: str) -> str:
        """One `%[text]` line per paragraph, bare runnable code, no blank lines at
        text/code boundaries or before `%%`, one blank line before the footer."""
        raw_lines = body.splitlines()
        title = f"Chapter {self.chapter_num}: {self.chapter_title}" if self.chapter_num else self.chapter_title
        out: list[str] = [f"%[text] # {title}"]
        i, n = 0, len(raw_lines)
        in_fence = False
        while i < n:
            ln = raw_lines[i]
            stripped = ln.strip()
            if stripped == _CODE:
                i += 1
                code: list[str] = []
                while i < n and raw_lines[i].strip() != _ENDCODE:
                    code.append(raw_lines[i].rstrip())
                    i += 1
                while code and code[0].strip() == "":
                    code.pop(0)
                while code and code[-1].strip() == "":
                    code.pop()
                out.extend(code)
                i += 1
                continue
            if stripped == "":
                i += 1
                continue
            if stripped == _SECTION:
                if out and out[-1] != "%%":
                    out.append("%%")
                i += 1
                continue
            if stripped.startswith("%[") or stripped.startswith("%%"):
                # `%[text] ` with a trailing space is an empty paragraph; keep it.
                if stripped == "%[text]":
                    out.append("%[text] ")
                elif "```" in stripped:
                    in_fence = not in_fence
                    out.append(stripped)
                elif in_fence or not stripped.startswith("%[text"):
                    out.append(stripped)
                else:
                    tm = re.match(r"(%\[text\](?:\{[^}]*\})? )(.*)$", stripped)
                    out.append(tm.group(1) + _escape_prose(tm.group(2)) if tm else stripped)
                i += 1
                continue
            lm = _LIST_ITEM_RE.match(ln)
            if lm:
                out.append(f"%[text] {lm.group(1)}{_escape_prose(lm.group(2).rstrip())}")
                i += 1
                continue
            para = [stripped]
            i += 1
            while i < n:
                nxt = raw_lines[i]
                ns = nxt.strip()
                if ns == "" or ns.startswith(("%[", "%%", _CODE, _ENDCODE, _SECTION)) or _LIST_ITEM_RE.match(nxt):
                    break
                para.append(ns)
                i += 1
            joined = re.sub(r"\s+", " ", " ".join(para)).strip()
            if joined:
                out.append(f"%[text] {_escape_prose(joined)}")
        while out and out[-1] in ("", "%%"):
            out.pop()
        out.append("")
        out.extend(FOOTER)
        for img_id, entry in self.image_entries:
            out.extend([f"%[text:image:{img_id}]", entry, "%---"])
        return "\n".join(out) + "\n"

    def _hygiene(self, text: str) -> None:
        bad = sorted({ch for ch in text if ord(ch) < 32 and ch not in "\n\t"})
        if bad:
            raise ConversionError(f"control characters left in output: {[hex(ord(c)) for c in bad]}")
        text.encode("utf-8")
        for lineno, ln in enumerate(text.splitlines(), 1):
            if ln.startswith("%[appendix]"):
                break
            if not ln.startswith("%[text"):
                continue
            if "```" in ln:
                continue
            prose = re.sub(r"`[^`]*`", "", re.sub(r"(?<!\\)\$[^$]*\$", "", ln))
            for cmd in re.findall(r"\\[A-Za-z]+", prose):
                self.warn(f"line {lineno}: LaTeX command `{cmd}` left in prose")
            if "§" in prose:
                self.warn(f"line {lineno}: unresolved reference marker")


# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------

_PROSE_SKIP_RE = re.compile(r"`[^`]*`|(?<!\\)\$[^$]*\$|\]\([^)]*\)")


def _escape_prose(text: str) -> str:
    """Escape `_` and `>` the way MATLAB writes them, outside code spans, math
    and link targets (verified by re-save in R2026b; URLs are left alone)."""
    out = []
    pos = 0
    for m in _PROSE_SKIP_RE.finditer(text):
        out.append(_escape_run(text[pos:m.start()]))
        out.append(m.group(0))
        pos = m.end()
    out.append(_escape_run(text[pos:]))
    return "".join(out)


def _escape_run(text: str) -> str:
    text = re.sub(r"(?<!\\)_", r"\\_", text)
    return re.sub(r"(?<!\\)>", r"\\>", text)


def _lift_heading_footnotes(s: str) -> str:
    """`\\section{Title\\footnote{note}}` becomes `\\section{Title}` followed by the
    note as its own italic paragraph; a note inside a heading renders badly."""
    head = re.compile(r"\\(section|subsection|subsubsection)(\*?)(\[[^\]]*\])?\s*\{")

    def lift(m: re.Match, title: str) -> str:
        fm = re.search(r"\\protect\s*\\footnote\s*\{|\\footnote\s*\{", title)
        if not fm:
            return m.group(0) + title + "}"
        note, end = balanced(title, fm.end())
        if note is None:
            return m.group(0) + title + "}"
        clean = (title[:fm.start()] + title[end:]).strip()
        return f"\\{m.group(1)}{m.group(2)}{m.group(3) or ''}{{{clean}}}\n\n\\emph{{{note.strip()}}}\n\n"
    return sub_balanced(s, head, lift)


def _strip_comments(s: str) -> str:
    """Drop `%` comments (not `\\%`, not inside backticks), line by line."""
    new_lines = []
    for ln in s.splitlines():
        out = []
        i = 0
        in_tick = False
        while i < len(ln):
            ch = ln[i]
            if ch == "\\" and i + 1 < len(ln):
                out.append(ln[i:i + 2])
                i += 2
                continue
            if ch == "`":
                in_tick = not in_tick
            elif ch == "%" and not in_tick:
                break
            out.append(ch)
            i += 1
        new_lines.append("".join(out))
    return "\n".join(new_lines)


def _replace_outside_backticks(text: str, needle: str, repl: str) -> str:
    out = []
    i = 0
    in_tick = False
    while i < len(text):
        if not in_tick and text.startswith(needle, i):
            out.append(repl)
            i += len(needle)
            continue
        ch = text[i]
        if ch == "`":
            in_tick = not in_tick
        out.append(ch)
        i += 1
    return "".join(out)


def _italic_para(text: str) -> str:
    """Wrap a paragraph in italics the way MATLAB writes it back (verified by
    re-save in R2026b): the span is split around an inner `*x*`, which becomes
    bold-italic, and around a link, keeping the original spacing:
    `*a* ***x*** *b*` and `*a,* [x](u)*, b*`."""
    parts = re.split(r"(?<!\*)\*([^*]+)\*(?!\*)|(\[[^\]]*\]\([^)]*\))", text)
    out = []
    for i, part in enumerate(parts):
        if part is None:
            continue
        if i % 3 == 0:
            if part.strip():
                lead = part[:len(part) - len(part.lstrip())]
                trail = part[len(part.rstrip()):]
                out.append(f"{lead}*{part.strip()}*{trail}")
            else:
                out.append(part)
        elif i % 3 == 1:
            out.append(f"***{part}***")
        else:
            out.append(part)
    return "".join(out).strip()


def _split_desc_label(it: str) -> tuple[str | None, str]:
    i = 1
    in_tick = False
    while i < len(it):
        ch = it[i]
        if ch == "`":
            in_tick = not in_tick
        elif ch == "]" and not in_tick:
            return it[1:i].strip(), it[i + 1:].strip()
        i += 1
    return None, it


def _relpath(target: Path, start: Path) -> str:
    import os
    return os.path.relpath(str(target.resolve()), str(start.resolve()))


def _find_book_root(p: Path) -> Path | None:
    for ancestor in [p, *p.parents]:
        if ancestor.name == "book":
            return ancestor
        if (ancestor / "book").is_dir():
            return ancestor / "book"
    return None


# ---------------------------------------------------------------------------
# Counts for --check
# ---------------------------------------------------------------------------

def tex_counts(tex: str) -> dict[str, int]:
    s = _strip_comments(tex)
    s = re.sub(r"\x03skip\x03\s*\\begin\{figure\}.*?\\end\{figure\}", "", s, flags=re.S)
    s = _DIR_LINE_RE.sub("", s)
    return {
        "sections": len(re.findall(r"\\section(?:\[[^\]]*\])?\s*\{", s)),
        "subsections": len(re.findall(r"\\subsection(?:\[[^\]]*\])?\s*\{", s)),
        "exercises": len(re.findall(r"\\begin\{ex\}", s)),
        "figures": len(re.findall(r"\\begin\{figure\}", s)),
    }


def m_counts(m_text: str) -> dict[str, int]:
    body = m_text.split("\n%[appendix]", 1)[0]
    lines = body.splitlines()
    return {
        "sections": sum(1 for ln in lines if ln.startswith("%[text] ## ")),
        "subsections": sum(1 for ln in lines if ln.startswith("%[text] ### ")),
        "exercises": sum(1 for ln in lines if ln.startswith("%[text] **Exercise")),
        "figures": sum(1 for ln in lines if re.match(r"%\[text\](?:\{[^}]*\})? \*Figure", ln)),
        "unresolved": sum(ln.count("§") for ln in lines if ln.startswith("%[text")),
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def run_one(in_path: Path, args: argparse.Namespace) -> int:
    tex = in_path.read_text(encoding="utf-8")
    book_root = _find_book_root(in_path.parent)
    aux = Path(args.aux) if args.aux else (book_root / "book.aux" if book_root else None)
    labels: dict[str, Label] = {}
    conv = Converter(source_path=in_path, book_root=book_root, images=args.images,
                     image_width=args.image_width, title_hint=in_path.stem.replace("_", " ").title())
    if aux is not None and aux.exists():
        labels = load_labels(aux)
        if aux.stat().st_mtime < in_path.stat().st_mtime:
            conv.warn(f"{aux} is older than {in_path.name}; numbering may be stale (run `make book`)")
    else:
        conv.warn("book.aux not found; references and heading numbers are unresolved (run `make book`)")
    conv.labels = labels
    try:
        out = conv.convert(tex)
    except ConversionError as e:
        print(f"tex2mlive: {in_path.name}: ERROR {e}", file=sys.stderr)
        return 2
    for w in conv.warnings:
        print(f"tex2mlive: {in_path.name}: WARN {w}", file=sys.stderr)

    out_path = Path(args.output) if args.output else in_path.with_suffix(".m")
    existing = out_path.read_text(encoding="utf-8", errors="replace") if out_path.exists() else None

    if args.diff:
        diff = difflib.unified_diff((existing or "").splitlines(), out.splitlines(),
                                    fromfile=str(out_path), tofile=f"{in_path.name} (converted)", lineterm="")
        sys.stdout.write("\n".join(diff) + ("\n" if diff else ""))
        return 0

    if args.check:
        ok = True
        if existing is None:
            print(f"{out_path}: missing")
            ok = False
        elif existing != out:
            n = sum(1 for d in difflib.unified_diff(existing.splitlines(), out.splitlines(), lineterm="")
                    if d.startswith(("+", "-")) and not d.startswith(("+++", "---")))
            print(f"{out_path}: differs from a fresh conversion ({n} changed lines); rerun with --force")
            ok = False
        else:
            print(f"{out_path}: up to date")
        tc, mc = tex_counts(tex), m_counts(out)
        for key in ("sections", "subsections", "exercises", "figures"):
            flag = "ok" if tc[key] == mc[key] else "MISMATCH"
            if flag != "ok":
                ok = False
            print(f"  {key:<12} tex {tc[key]:>3}  m {mc[key]:>3}  {flag}")
        print(f"  unresolved refs {mc['unresolved']}" + ("" if mc["unresolved"] == 0 else "  FAIL"))
        ok = ok and mc["unresolved"] == 0
        return 0 if ok else 1

    if existing is not None and not args.force:
        print(f"tex2mlive: {out_path} exists; use --force to overwrite or --diff to compare", file=sys.stderr)
        return 1
    out_path.write_text(out, encoding="utf-8")
    print(f"wrote {out_path}")
    return 0


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("tex", nargs="+", help="chapter .tex file(s)")
    ap.add_argument("-o", "--output", help="output .m path (single input only)")
    ap.add_argument("--force", action="store_true", help="overwrite an existing .m")
    ap.add_argument("--diff", action="store_true", help="show a diff against the existing .m; write nothing")
    ap.add_argument("--check", action="store_true", help="verify the existing .m is current and consistent")
    ap.add_argument("--images", choices=("embed", "link"), default="embed",
                    help="embed images in the appendix (default) or link by relative path")
    ap.add_argument("--image-width", type=int, default=560, help="maximum display width of embedded images")
    ap.add_argument("--aux", help="path to book.aux (default: book/book.aux)")
    args = ap.parse_args(argv)
    if args.output and len(args.tex) > 1:
        ap.error("-o accepts a single input")
    rc = 0
    for arg in args.tex:
        rc = max(rc, run_one(Path(arg).resolve(), args))
    return rc


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Convert an AE2440 chapter .tex file to a MATLAB plain-text live script .m file.

Pipeline (order matters):
1. Strip subfile/document wrappers.
2. Stash *verbatim* environments (code, lstlisting, stdout, figure) before
   anything else; their bodies must not be touched by inline LaTeX → markdown
   substitutions or LaTeX comment stripping.
3. Strip LaTeX `%` comments (line-trailing) and `\index{...}` (with nested
   braces).
4. Strip miscellaneous standalone tokens (`\linebreak`, `\noindent`, etc.).
5. Run inline LaTeX → markdown substitutions (math, emph, textbf, lstinline,
   mbox, SI units, refs, epigraph, …) on the *prose*.
6. Stash other multi-line environments (ex, quote, enumerate, itemize,
   description) so the structural-pass regexes do not punch holes in them.
7. Convert structural commands (chapter / section / subsection / paragraph)
   into markdown headings + `%%` cell breaks.
8. Restore stashes (deepest first) and assemble the final live-script body —
   prose paragraphs become `%[text] ...` lines, runnable code stays bare.

Output rules:
- `\begin{code}` blocks containing `>>` interactive prompts become runnable
  cells (the `>>` is stripped, the implicit `ans = …` reply is dropped).
- Other code, lstlisting, and stdout environments render as fenced markdown
  code blocks inside `%[text]` lines so they display but do not execute.
- Required `%[appendix] / %[metadata:view]` footer is appended.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


# ---------------------------------------------------------------------------
# Stash machinery
# ---------------------------------------------------------------------------

_PH_VERBATIM = "\x00V{idx}\x00"
_PH_BLOCK = "\x00B{idx}\x00"
_PH_MATH = "\x00M{idx}\x00"


class Stash:
    def __init__(self, marker_fmt: str) -> None:
        self.fmt = marker_fmt
        self.items: list[str] = []

    def add(self, chunk: str) -> str:
        self.items.append(chunk)
        return self.fmt.format(idx=len(self.items) - 1)

    def restore(self, text: str) -> str:
        prefix = self.fmt.replace("{idx}", "")
        # The format string is e.g. "\x00V{idx}\x00" → marker is "\x00V<digits>\x00".
        marker_re = re.escape(self.fmt.split("{")[0]) + r"(\d+)" + re.escape(self.fmt.rsplit("}", 1)[1])
        return re.sub(marker_re, lambda m: self.items[int(m.group(1))], text)


# ---------------------------------------------------------------------------
# Brace-balanced extraction (for \index{…} with nesting, etc.)
# ---------------------------------------------------------------------------

def strip_command_balanced(text: str, command: str) -> str:
    """Remove every occurrence of `\\command{…}` where `{…}` may contain nested
    braces. Trailing `%` (LaTeX line-suppress) is also consumed."""
    pattern = re.compile(r"\\" + re.escape(command) + r"\{")
    out = []
    i = 0
    while i < len(text):
        m = pattern.search(text, i)
        if not m:
            out.append(text[i:])
            break
        out.append(text[i:m.start()])
        # walk past matching brace
        depth = 1
        j = m.end()
        while j < len(text) and depth > 0:
            ch = text[j]
            if ch == "\\" and j + 1 < len(text):
                j += 2
                continue
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
            j += 1
        # consume optional trailing `%` and following newline (LaTeX line tie)
        if j < len(text) and text[j] == "%":
            j += 1
        i = j
    return "".join(out)


# ---------------------------------------------------------------------------
# Math conversion
# ---------------------------------------------------------------------------

def _convert_math_body(body: str) -> str:
    body = body.strip()
    # strip `\label{…}` (does not survive in live-script math)
    body = re.sub(r"\\label\{[^{}]*\}", "", body)
    # MATLAB's live-script LaTeX vocabulary does not include `\uvec` (a
    # custom unit-vector macro from book.tex) — fall back to `\hat`, which
    # renders.
    body = re.sub(r"\\uvec\b", r"\\hat", body)
    # `\-` is a LaTeX optional-hyphen hint — drop it.
    body = re.sub(r"\\-", "", body)
    # double every backslash for the live-script renderer
    body = body.replace("\\", "\\\\")
    # escape underscores so markdown italics do not eat them
    body = body.replace("_", "\\_")
    # collapse whitespace
    body = re.sub(r"\s+", " ", body)
    return body


def _find_unescaped(text: str, ch: str, start: int) -> int:
    """Index of the next `ch` at or after `start` that is not preceded by a
    backslash. Returns -1 if not found."""
    i = start
    while i < len(text):
        if text[i] == "\\" and i + 1 < len(text):
            i += 2
            continue
        if text[i] == ch:
            return i
        i += 1
    return -1


def convert_inline_math(text: str, math_stash: "Stash") -> str:
    # `\(...\)` → `$…$`
    text = re.sub(r"\\\((.+?)\\\)",
                  lambda m: math_stash.add("$" + _convert_math_body(m.group(1)) + "$"),
                  text, flags=re.S)

    # `$…$` (single-dollar inline). Skip `$$` and `\$`.
    out = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "\\" and i + 1 < len(text):
            # `\$` etc. — pass through both chars, do not start math.
            out.append(text[i:i + 2])
            i += 2
            continue
        if ch == "$" and (i + 1 >= len(text) or text[i + 1] != "$"):
            j = _find_unescaped(text, "$", i + 1)
            if j == -1:
                out.append(text[i:])
                break
            body = text[i + 1:j]
            out.append(math_stash.add("$" + _convert_math_body(body) + "$"))
            i = j + 1
        else:
            out.append(ch)
            i += 1
    return "".join(out)


def _eqnarray_to_array(body: str) -> str:
    """`eqnarray` uses `&=&` column markers — `\\begin{array}{rcl}` is the
    closest equivalent that the live-script LaTeX renderer understands."""
    return r"\begin{array}{rcl}" + body + r"\end{array}"


def convert_display_math(text: str, math_stash: "Stash") -> str:
    # `\[ ... \]`
    text = re.sub(r"\\\[(.+?)\\\]",
                  lambda m: "\n\n%[text] " + math_stash.add("$" + _convert_math_body(m.group(1)) + "$") + "\n\n",
                  text, flags=re.S)

    # equation / align environments — single equation, no column markers.
    for env in ("equation", "equation*", "align", "align*"):
        pat = re.compile(rf"\\begin\{{{re.escape(env)}\}}(.*?)\\end\{{{re.escape(env)}\}}", re.S)
        text = pat.sub(
            lambda m: "\n\n%[text] " + math_stash.add("$" + _convert_math_body(m.group(1)) + "$") + "\n\n",
            text,
        )

    # eqnarray uses `&=&` column markers — convert to `\begin{array}{rcl}…\end{array}`
    # which the live-script renderer handles inside `$…$`.
    for env in ("eqnarray", "eqnarray*"):
        pat = re.compile(rf"\\begin\{{{re.escape(env)}\}}(.*?)\\end\{{{re.escape(env)}\}}", re.S)
        text = pat.sub(
            lambda m: "\n\n%[text] " + math_stash.add(
                "$" + _convert_math_body(_eqnarray_to_array(m.group(1))) + "$"
            ) + "\n\n",
            text,
        )

    return text


# ---------------------------------------------------------------------------
# Emit code / stdout / figure stashes
# ---------------------------------------------------------------------------

def _emit_runnable_code(body: str) -> str:
    """`>> …` interactive session → runnable MATLAB cell. The `>>` and the
    implicit echoed-output line(s) are dropped. MATLAB `…` line continuations
    are honored: a `>>` command ending in `...` keeps consuming the next
    source lines until one does not end with `...`."""
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
            # If the command ended with `...`, keep appending continuation
            # lines until one does not end with `...`. Those continuation
            # lines are *part of the command*, not output.
            while out and out[-1].rstrip().endswith("...") and i < len(lines):
                cont = lines[i]
                out.append(cont.rstrip())
                if not cont.rstrip().endswith("..."):
                    i += 1
                    break
                i += 1
            # skip ensuing implicit-output line(s) until next `>>` or blank
            while i < len(lines):
                nxt = lines[i].strip()
                if nxt.startswith(">>") or nxt == "":
                    break
                i += 1
        else:
            i += 1
    return "\n".join(out)


def _emit_text_codeblock(body: str, lang: str = "matlab") -> str:
    """Render code as a markdown fenced block inside `%[text]` lines."""
    lines = body.splitlines()
    while lines and lines[0].strip() == "":
        lines.pop(0)
    while lines and lines[-1].strip() == "":
        lines.pop()
    out = [f"%[text] ```{lang}"]
    for ln in lines:
        out.append(f"%[text] {ln.rstrip()}" if ln.strip() else "%[text] ")
    out.append("%[text] ```")
    return "\n".join(out)


# ---------------------------------------------------------------------------
# Top-level convert
# ---------------------------------------------------------------------------

def _resolve_image(path: str, book_root: Path | None, m_dir: Path | None) -> str:
    """Resolve a `\\includegraphics{path}` argument to an actual file relative
    to the .m output location. Tries common extensions in order of suitability
    for live-script display (PNG > JPG > SVG > GIF > PDF > EPS > BMP).

    `path` is the raw argument from the LaTeX (typically relative to the book
    root). Returns a path string suitable for `![](…)` in the .m file. If the
    file cannot be located, returns `path` unchanged."""
    if book_root is None or m_dir is None:
        return path
    p = Path(path)
    candidates: list[Path] = []
    # If path already has an extension, try it first.
    base = book_root / p
    if p.suffix:
        candidates.append(base)
    else:
        for ext in (".png", ".jpg", ".jpeg", ".svg", ".gif", ".pdf", ".eps", ".bmp"):
            candidates.append(base.with_suffix(ext))
    for c in candidates:
        if c.exists():
            try:
                return str(c.resolve().relative_to(m_dir.resolve()))
            except ValueError:
                # Fall back to a manually-computed relative path.
                import os as _os
                return _os.path.relpath(str(c.resolve()), str(m_dir.resolve()))
    return path


def _balanced_arg(text: str, cmd: str) -> str | None:
    """Return the content of the *first* `\\<cmd>{…}` invocation in `text`,
    handling nested braces (e.g. `\\caption{foo $\\vec{V}$ bar}`). Returns
    None if not found."""
    pat = re.compile(r"\\" + re.escape(cmd) + r"\s*\{")
    m = pat.search(text)
    if not m:
        return None
    depth = 1
    i = m.end()
    start = i
    while i < len(text) and depth > 0:
        ch = text[i]
        if ch == "\\" and i + 1 < len(text):
            i += 2
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return text[start:i]
        i += 1
    return None


def _read_file_range(path: Path, firstline: int | None, lastline: int | None) -> str:
    """Read the given file and return the inclusive [firstline, lastline] slice
    (1-indexed), or the whole file if either bound is None."""
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    if firstline is None:
        firstline = 1
    if lastline is None:
        lastline = len(lines)
    return "\n".join(lines[firstline - 1:lastline])


def convert(tex: str, title_hint: str = "", source_path: Path | None = None,
            book_root: Path | None = None) -> str:
    """Convert LaTeX `tex` into a plain-text MATLAB live script.

    `source_path` is the path of the input `.tex` file (used to locate the .m
    output and to compute relative image paths). `book_root` is the directory
    that contains the document — typically `book/` in this repo. If either is
    missing, image and `\\lstinputlisting` paths are emitted as-is."""
    s = tex
    m_dir = source_path.parent if source_path is not None else None

    # 1. Strip subfile/document wrappers.
    s = re.sub(r"\\documentclass\b.*?(?=\\begin\{document\})", "", s, flags=re.S)
    s = re.sub(r"\\begin\{document\}", "", s)
    s = re.sub(r"\\end\{document\}", "", s)

    # 2. Stash verbatim environments before any text mangling.
    verb = Stash(_PH_VERBATIM)

    def stash_verbatim(pat: str, render):
        nonlocal s
        rgx = re.compile(pat, re.S)
        s = rgx.sub(lambda m: verb.add(render(m)), s)

    # `\begin{code}` — emit as runnable code in both cases. Interactive `>>`
    # sessions get the `>>` and implicit-output lines stripped; non-`>>`
    # blocks are emitted as bare runnable MATLAB so that `function` defs etc.
    # become local functions in the live script.
    def render_code(m: re.Match) -> str:
        body = m.group(1)
        if re.search(r"^\s*>>", body, flags=re.M):
            code = _emit_runnable_code(body)
        else:
            code = body.strip("\n")
            # Drop trailing blank lines but keep internal ones for readability.
            code = re.sub(r"\n\s*$", "", code)
        return f"\n\n\x02CODE\x02\n{code}\n\x02ENDCODE\x02\n\n"
    stash_verbatim(r"\\begin\{code\}(.*?)\\end\{code\}", render_code)

    def render_stdout(m: re.Match) -> str:
        return "\n\n" + _emit_text_codeblock(m.group(1), "text") + "\n\n"
    stash_verbatim(r"\\begin\{stdout\}(.*?)\\end\{stdout\}", render_stdout)

    def render_lstlisting(m: re.Match) -> str:
        opts = m.group(1) or ""
        body = m.group(2)
        cap_match = re.search(r"caption=\{([^{}]*)\}", opts)
        lang_match = re.search(r"language=([A-Za-z]+)", opts)
        lang = (lang_match.group(1) if lang_match else "matlab").lower()
        out = []
        if cap_match:
            cap = cap_match.group(1).strip()
            cap = re.sub(r"\\ref\{[^}]*\}", "", cap)
            out.append(f"%[text] **Listing.** {cap}")
        out.append(_emit_text_codeblock(body, lang))
        return "\n\n" + "\n".join(out) + "\n\n"
    stash_verbatim(r"\\begin\{lstlisting\}(\[[^\]]*\])?(.*?)\\end\{lstlisting\}", render_lstlisting)

    def render_lstinputlisting(m: re.Match) -> str:
        opts = m.group(1) or ""
        rel_path = m.group(2).strip()
        cap_match = re.search(r"caption=\{([^{}]*)\}", opts)
        first_match = re.search(r"firstline\s*=\s*(\d+)", opts)
        last_match = re.search(r"lastline\s*=\s*(\d+)", opts)
        firstline = int(first_match.group(1)) if first_match else None
        lastline = int(last_match.group(1)) if last_match else None
        cap = cap_match.group(1).strip() if cap_match else ""
        # Try to read the file content from book_root.
        body = ""
        if book_root is not None:
            file_path = book_root / rel_path
            if file_path.exists():
                try:
                    body = _read_file_range(file_path, firstline, lastline)
                except Exception:
                    body = ""
        if not body:
            # File missing — fall back to a markdown note.
            return f"\n\n%[text] **Listing** (source: `{rel_path}`).\n\n"
        # Emit caption (if any) above the runnable code.
        prefix = f"%[text] **Listing.** {cap}\n" if cap else ""
        return f"\n\n{prefix}\x02CODE\x02\n{body}\n\x02ENDCODE\x02\n\n"
    # Note: `re.S` lets the args span multiple lines (the brace-group can
    # appear on the next line in the source).
    stash_verbatim(r"\\lstinputlisting(\[[^\]]*\])?\s*\{([^}]+)\}", render_lstinputlisting)

    def _alt_text(s: str) -> str:
        """Make a caption safe to drop inside markdown image `![alt](…)`
        brackets: strip math regions, LaTeX commands, and stray braces — the
        full caption is emitted on a separate `*Figure: …*` line where it
        gets the normal prose-pipeline treatment."""
        # Drop `$…$` math (cannot survive inside markdown alt text).
        s = re.sub(r"\$[^$]*\$", "", s)
        # Drop any remaining LaTeX commands `\foo` and stray braces.
        s = re.sub(r"\\[A-Za-z]+\*?", "", s)
        s = s.replace("{", "").replace("}", "")
        # Brackets are still problematic.
        s = s.replace("[", "(").replace("]", ")")
        # Collapse whitespace.
        return re.sub(r"\s+", " ", s).strip()

    def _all_captions(text: str) -> list[str]:
        """Find every `\\caption{…}` (balanced-brace) in document order."""
        out = []
        i = 0
        pat = re.compile(r"\\caption\s*\{")
        while i < len(text):
            m = pat.search(text, i)
            if not m:
                break
            depth = 1
            j = m.end()
            start = j
            while j < len(text) and depth > 0:
                ch = text[j]
                if ch == "\\" and j + 1 < len(text):
                    j += 2
                    continue
                if ch == "{":
                    depth += 1
                elif ch == "}":
                    depth -= 1
                    if depth == 0:
                        out.append(text[start:j])
                        j += 1
                        break
                j += 1
            i = j
        return out

    def _clean_caption(s: str) -> str:
        s = re.sub(r"\\(?:label|index)\{[^}]*\}", "", s)
        return re.sub(r"\s+", " ", s).strip()

    def render_figure(m: re.Match) -> str:
        body = m.group(1)
        captions = _all_captions(body)
        outer_caption = _clean_caption(captions[-1]) if captions else ""
        # Collect subfigure pairs (image, optional caption).
        subfigs: list[tuple[str, str]] = []
        for sfm in re.finditer(r"\\begin\{subfigure\}.*?\\end\{subfigure\}", body, flags=re.S):
            sub_body = sfm.group(0)
            sub_img = re.search(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}", sub_body)
            sub_caps = _all_captions(sub_body)
            if sub_img:
                cap = _clean_caption(sub_caps[0]) if sub_caps else ""
                subfigs.append((sub_img.group(1), cap))
        # Figures without subfigures: scan for top-level `\includegraphics`.
        if not subfigs:
            for pm in re.finditer(r"\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}", body):
                subfigs.append((pm.group(1), ""))
        lines: list[str] = []
        for path, cap in subfigs:
            resolved = _resolve_image(path, book_root, m_dir)
            alt = _alt_text(cap or outer_caption)
            lines.append(f"%[text] ![{alt}]({resolved})")
        if outer_caption:
            lines.append(f"%[text] *Figure: {outer_caption}*")
        if not lines:
            lines.append("%[text] *(figure)*")
        return "\n\n" + "\n".join(lines) + "\n\n"
    stash_verbatim(r"\\begin\{figure\}(?:\[[^\]]*\])?(.*?)\\end\{figure\}", render_figure)

    # `\includepdf{file}` — note as a placeholder.
    s = re.sub(r"\\includepdf(?:\[[^\]]*\])?\{([^}]+)\}",
               lambda m: verb.add(f"\n\n%[text] *(embedded PDF: {m.group(1)})*\n\n"),
               s)

    # 3a. Convert `\lstinline{…}` family to backticks before comment-stripping
    # so any `%` inside (e.g. `\lstinline{%f}`) is not treated as a comment.
    s = re.sub(r"\\lstinline\{([^}]*)\}", lambda m: f"`{m.group(1)}`", s)
    s = re.sub(r"\\lstinline\|([^|]*)\|", lambda m: f"`{m.group(1)}`", s)
    s = re.sub(r"\\Verb\|([^|]*)\|", lambda m: f"`{m.group(1)}`", s)
    s = re.sub(r"\\mcode\{([^}]*)\}", lambda m: f"`{m.group(1)}`", s)

    # 3b. Strip LaTeX line comments (`%` to end of line, but only when not
    # escaped with `\%` and not inside `…` backticks). Line-by-line.
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
                out.append(ch)
                i += 1
                continue
            if ch == "%" and not in_tick:
                break
            out.append(ch)
            i += 1
        new_lines.append("".join(out))
    s = "\n".join(new_lines)

    # 4. Strip `\index{…}` (nested braces possible) and other standalones.
    s = strip_command_balanced(s, "index")
    s = re.sub(r"\\noindent\b", "", s)
    s = re.sub(r"\\clearpage\b", "", s)
    s = re.sub(r"\\pagebreak\b", "", s)
    s = re.sub(r"\\bigskip\b", "", s)
    s = re.sub(r"\\medskip\b", "", s)
    s = re.sub(r"\\smallskip\b", "", s)
    s = re.sub(r"\\centering\b", "", s)
    s = re.sub(r"\\centerline\{([^}]*)\}", lambda m: m.group(1), s)
    s = re.sub(r"\\protect\b", "", s)
    s = re.sub(r"\\hspace\{[^}]*\}", " ", s)
    s = re.sub(r"\\vspace\{[^}]*\}", "", s)
    s = re.sub(r"\\linewidth\b", "", s)
    s = re.sub(r"\\textwidth\b", "", s)
    s = re.sub(r"\\maxdimen\b", "", s)
    s = re.sub(r"\\binoppenalty=\S+", "", s)
    s = re.sub(r"\\relpenalty=\S+", "", s)

    # 5. Inline LaTeX → markdown.
    # `\SI{}` must be expanded before math stashing so it does not leak through
    # untouched inside `$…$`.
    def render_si(m: re.Match) -> str:
        val = m.group(1).strip()
        unit = m.group(2)
        unit = re.sub(r"\\per\b", "/", unit)
        unit = re.sub(r"\\squared\b", "^2", unit)
        unit = re.sub(r"\\cubed\b", "^3", unit)
        unit_map = {
            "meter": "m", "metre": "m", "meters": "m",
            "second": "s", "seconds": "s",
            "minute": "min", "minutes": "min",
            "kilogram": "kg", "kilograms": "kg",
            "gram": "g", "grams": "g",
            "celsius": "°C", "degree": "°", "radian": "rad",
            "kilometer": "km", "kilometers": "km",
        }
        for k, v in unit_map.items():
            unit = re.sub(rf"\\{k}\b", v, unit)
        unit = re.sub(r"\\[a-zA-Z]+", "", unit)
        unit = unit.replace("{", "").replace("}", "").strip()
        return f"{val} {unit}".strip()
    # Allow whitespace between `\SI` and the first brace (some sources have
    # `\SI {59.05}{\meter}`).
    s = re.sub(r"\\SI\s*\{([^}]*)\}\s*\{([^}]*)\}", render_si, s)
    s = re.sub(r"\\si\s*\{([^}]*)\}",
               lambda m: m.group(1).replace("\\", "").replace("{", "").replace("}", ""),
               s)

    # Math: stash converted math behind placeholders so backslashes are doubled
    # exactly once and so `$…$` from display math is not re-processed.
    math = Stash(_PH_MATH)
    s = convert_display_math(s, math)
    s = convert_inline_math(s, math)

    # text-formatting commands (with at most one level of inner braces).
    s = re.sub(r"\\texttt\{([^{}]*)\}", lambda m: f"`{m.group(1)}`", s)
    s = re.sub(r"\\textbf\{([^{}]*)\}", lambda m: f"**{m.group(1)}**", s)
    s = re.sub(r"\\textit\{([^{}]*)\}", lambda m: f"*{m.group(1)}*", s)
    s = re.sub(r"\\emph\{([^{}]*)\}", lambda m: f"*{m.group(1)}*", s)
    s = re.sub(r"\\mbox\{([^{}]*)\}", lambda m: m.group(1), s)
    s = re.sub(r"\\hbox\{([^{}]*)\}", lambda m: m.group(1), s)
    s = re.sub(r"\\keycap\{([^{}]*)\}", lambda m: f"**{m.group(1)}**", s)
    s = re.sub(r"\\textunderscore\b", "_", s)
    s = re.sub(r"\\textdegree\b", "°", s)

    s = re.sub(r"\\href\{([^}]*)\}\{([^}]*)\}",
               lambda m: f"[{m.group(2)}]({m.group(1)})", s)
    s = re.sub(r"\\url\{([^}]*)\}", lambda m: f"<{m.group(1)}>", s)
    s = re.sub(r"\\footnote\{([^{}]*)\}", lambda m: f" (note: {m.group(1)})", s)

    s = re.sub(r"\\linebreak\b", " \\\\", s)

    # `\ ` (backslash-space) is a LaTeX explicit space — collapse to one space.
    s = re.sub(r"\\ ", " ", s)

    # LaTeX literal-character escapes outside math: `\$ \% \& \# \_`.
    s = s.replace("\\$", "$").replace("\\%", "%").replace("\\&", "&").replace("\\#", "#")
    # Note: `\_` → `_` is handled where it occurs (math leaves backslash; in
    # prose it becomes a literal underscore).
    s = re.sub(r"\\_", "_", s)
    # `\-` is a LaTeX optional-hyphen hint; drop it (in prose only — it has
    # already been stripped inside math bodies in `_convert_math_body`).
    s = s.replace("\\-", "")

    # references — render as `§<label>` so they remain visible (best-effort).
    s = re.sub(r"\\(?:auto|name|page)?ref\{([^}]*)\}", lambda m: f"§{m.group(1)}", s)
    s = re.sub(r"\\Cref\{([^}]*)\}", lambda m: f"§{m.group(1)}", s)
    s = re.sub(r"\\label\{[^}]*\}", "", s)

    # `\epigraph{quote}{author}` → blockquote.
    def render_epigraph(m: re.Match) -> str:
        q = m.group(1).strip()
        q = re.sub(r"\\\\", " ", q)  # any leftover line breaks
        q = re.sub(r"\s+", " ", q)
        a = m.group(2).strip()
        return f"\n\n> *{q}* — {a}\n\n"
    s = re.sub(r"\\epigraph\{(.+?)\}\{(.+?)\}", render_epigraph, s, flags=re.S)

    # 5z. Tidy whitespace artifacts on the prose stream BEFORE stashing the
    # remaining structural environments — otherwise their stashed bodies miss
    # the substitutions. `~` is a non-breaking space in LaTeX prose but a
    # MATLAB operator inside backticks, so the substitution must skip
    # backtick-quoted spans.
    def _replace_outside_backticks(text: str, needle: str, repl: str) -> str:
        out = []
        i = 0
        in_tick = False
        nlen = len(needle)
        while i < len(text):
            # Check the needle BEFORE toggling backtick state, so that the
            # LaTeX double-backtick `` is matched even though a single ` would
            # otherwise flip in_tick. The match still requires being outside
            # an existing code span.
            if not in_tick and text.startswith(needle, i):
                out.append(repl)
                i += nlen
                continue
            ch = text[i]
            if ch == "`":
                in_tick = not in_tick
            out.append(ch)
            i += 1
        return "".join(out)

    s = _replace_outside_backticks(s, "~", " ")
    s = _replace_outside_backticks(s, "---", "—")
    s = _replace_outside_backticks(s, "--", "–")
    s = _replace_outside_backticks(s, "``", "“")
    s = _replace_outside_backticks(s, "''", "”")

    # 6. Stash other multi-line environments (after inline subs so their
    # bodies are already converted).
    block = Stash(_PH_BLOCK)

    def stash_block(pat: str, render):
        nonlocal s
        rgx = re.compile(pat, re.S)
        s = rgx.sub(lambda m: block.add(render(m)), s)

    # Order matters: process inner envs (enumerate/itemize/quote/description)
    # BEFORE the outer `ex` env so they are converted in place rather than
    # stashed inside the exercise body. Items are separated with a blank line
    # so the paragraph-merger in `_finalize` keeps each item on its own
    # `%[text]` line.
    def render_enum(m: re.Match) -> str:
        body = m.group(1)
        items = re.split(r"\\item\b", body)[1:]
        return "\n\n" + "\n\n".join(f"{k}. {' '.join(it.split())}" for k, it in enumerate(items, 1)) + "\n\n"
    stash_block(r"\\begin\{enumerate\}(.*?)\\end\{enumerate\}", render_enum)

    def render_item(m: re.Match) -> str:
        body = m.group(1)
        items = re.split(r"\\item\b", body)[1:]
        return "\n\n" + "\n\n".join(f"- {' '.join(it.split())}" for it in items) + "\n\n"
    stash_block(r"\\begin\{itemize\}(.*?)\\end\{itemize\}", render_item)

    def _split_desc_label(it: str) -> tuple[str, str] | None:
        """Find the `[label]` at the start of a description-list item, taking
        backticks into account so a `]` inside `…` is not mistaken for the
        end of the label."""
        if not it.startswith("["):
            return None
        i = 1
        in_tick = False
        while i < len(it):
            ch = it[i]
            if ch == "`":
                in_tick = not in_tick
            elif ch == "]" and not in_tick:
                return it[1:i].strip(), it[i + 1:].strip()
            i += 1
        return None

    def render_desc(m: re.Match) -> str:
        body = m.group(1)
        items = re.split(r"\\item\b", body)[1:]
        out = []
        for it in items:
            it = " ".join(it.split())  # collapse whitespace
            split = _split_desc_label(it)
            if split:
                label, rest = split
                out.append(f"- **{label}** — {rest}")
            else:
                out.append(f"- {it}")
        # Separate items with blank lines so each becomes its own paragraph.
        return "\n\n" + "\n\n".join(out) + "\n\n"
    stash_block(r"\\begin\{description\}(.*?)\\end\{description\}", render_desc)

    # `tabbing` (used for pseudocode) — drop the alignment markers and keep
    # the body as plain lines.
    def render_tabbing(m: re.Match) -> str:
        body = m.group(1)
        body = re.sub(r"\\hspace\{[^}]*\}", "", body)
        body = re.sub(r"\\(?:kill|>|=)", "", body)
        body = re.sub(r"\\\\", "  ", body)  # `\\` inside tabbing → soft break
        return "\n\n" + body.strip() + "\n\n"
    stash_block(r"\\begin\{tabbing\}(.*?)\\end\{tabbing\}", render_tabbing)

    def render_quote(m: re.Match) -> str:
        body = m.group(1).strip()
        body = re.sub(r"\n\s*\n", "\n", body)
        return "\n\n> " + body.replace("\n", "\n> ") + "\n\n"
    stash_block(r"\\begin\{quote\}(.*?)\\end\{quote\}", render_quote)

    def render_ex(m: re.Match) -> str:
        body = m.group(1).strip()
        return "\n\n%[text] **Exercise.** \n" + body + "\n\n"
    stash_block(r"\\begin\{ex\}(.*?)\\end\{ex\}", render_ex)

    # 7. Structural commands.
    chap_match = re.search(r"\\chapter\*?\{([^}]+)\}", s)
    chapter_title = chap_match.group(1) if chap_match else (title_hint or "Chapter")
    s = re.sub(r"\\chapter\*?\{[^}]+\}\s*", "", s, count=1)
    s = re.sub(r"\\chapter\*?\{[^}]+\}", "", s)

    # Allow the optional short-title form: `\section[short]{full title}`.
    s = re.sub(r"\\section\*?(?:\[[^\]]*\])?\{([^}]+)\}",
               lambda m: f"\n%%\n%[text] ## {m.group(1)}\n", s)
    s = re.sub(r"\\subsection\*?(?:\[[^\]]*\])?\{([^}]+)\}",
               lambda m: f"\n%[text] ### {m.group(1)}\n", s)
    s = re.sub(r"\\subsubsection\*?(?:\[[^\]]*\])?\{([^}]+)\}",
               lambda m: f"\n%[text] #### {m.group(1)}\n", s)
    s = re.sub(r"\\paragraph\*?(?:\[[^\]]*\])?\{([^}]+)\}",
               lambda m: f"\n%[text] **{m.group(1)}**\n", s)

    # 8. Restore stashes (block first, then verbatim, then math last).
    s = block.restore(s)
    s = verb.restore(s)
    s = math.restore(s)

    # Collapse any remaining LaTeX command we did not handle (best-effort drop).
    # Rather than scrubbing aggressively, leave them visible for the author to
    # spot.

    return _finalize(chapter_title, s)


# ---------------------------------------------------------------------------
# Final assembly: paragraphs of prose → `%[text] …`, code stays bare
# ---------------------------------------------------------------------------

def _finalize(chapter_title: str, body: str) -> str:
    """Walk the converted body and emit the final live-script text.

    Project conventions (per the user's CLAUDE.md / memory):
      * Each prose paragraph is one `%[text] …` line (multi-line wrapping in
        the source is collapsed). Consecutive `%[text]` lines render as
        separate paragraphs automatically — no blank-line separators.
      * No blank lines between `%[text]` and code (either direction).
      * No blank line before `%%`.
      * Blank lines *inside* a code block are kept (logical groups).
      * The required `%[appendix]` / `%[metadata:view]` footer is appended.
    """
    # First, group source lines into paragraphs (blank-separated chunks),
    # respecting the `\x02CODE\x02 … \x02ENDCODE\x02` sentinel that delimits
    # bare runnable code emitted by `_emit_runnable_code` and the `\begin{code}`
    # handler. Code blocks pass through verbatim.
    raw_lines = body.splitlines()
    out: list[str] = [f"%[text] # {chapter_title}"]

    i = 0
    n = len(raw_lines)
    while i < n:
        ln = raw_lines[i]
        stripped = ln.strip()
        if stripped == "\x02CODE\x02":
            # Emit the code block bare, preserving internal blank lines.
            i += 1
            code_lines: list[str] = []
            while i < n and raw_lines[i].strip() != "\x02ENDCODE\x02":
                code_lines.append(raw_lines[i].rstrip())
                i += 1
            # Trim leading/trailing blanks but keep internal ones.
            while code_lines and code_lines[0].strip() == "":
                code_lines.pop(0)
            while code_lines and code_lines[-1].strip() == "":
                code_lines.pop()
            out.extend(code_lines)
            i += 1  # skip the ENDCODE sentinel
            continue
        if stripped == "":
            i += 1
            continue
        # Pre-formatted lines (`%[…]`, `%%`, `> …` blockquote) pass through
        # one-per-line.
        if stripped.startswith("%[") or stripped.startswith("%%"):
            out.append(ln.rstrip())
            i += 1
            continue
        # Blockquote line — keep one per source line, prefixed `%[text]`.
        if stripped.startswith(">"):
            out.append(f"%[text] {stripped}")
            i += 1
            continue
        # A line beginning with `- `, `* `, or `<digit>. ` is a markdown list
        # item — render it as its own `%[text]` paragraph, never joined with
        # neighbours (lists must keep one item per line).
        if re.match(r"^(?:[-*]\s|\d+\.\s)", stripped):
            out.append(f"%[text] {stripped}")
            i += 1
            continue
        # Otherwise we are inside a prose paragraph: gather contiguous
        # non-blank, non-pre-formatted, non-list lines and join them with
        # single spaces to form one `%[text]` line.
        para: list[str] = [stripped]
        i += 1
        while i < n:
            nxt = raw_lines[i].strip()
            if nxt == "":
                break
            if nxt.startswith("%[") or nxt.startswith("%%") or nxt == "\x02CODE\x02" or nxt == "\x02ENDCODE\x02":
                break
            if nxt.startswith(">"):
                break
            if re.match(r"^(?:[-*]\s|\d+\.\s)", nxt):
                break
            para.append(nxt)
            i += 1
        joined = " ".join(para)
        # Collapse runs of whitespace introduced by the join.
        joined = re.sub(r"\s+", " ", joined).strip()
        if joined:
            out.append(f"%[text] {joined}")

    # Drop accidental empty lines at top/bottom.
    while out and out[0].strip() == "":
        out.pop(0)
    while out and out[-1].strip() == "":
        out.pop()

    # Required footer. The live-script footer needs no blank line before it
    # per the project spacing rules.
    out.append('%[appendix]{"version":"1.0"}')
    out.append("%---")
    out.append("%[metadata:view]")
    out.append('%   data: {"layout":"inline"}')
    out.append("%---")

    return "\n".join(out).rstrip() + "\n"


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def _find_book_root(p: Path) -> Path | None:
    """Walk up from `p` until we find a directory named `book` (the document
    root used by `\\includegraphics{images/…}` and `\\lstinputlisting{…}`)."""
    for ancestor in [p, *p.parents]:
        if ancestor.name == "book":
            return ancestor
        if (ancestor / "book").is_dir():
            return ancestor / "book"
    return None


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("Usage: tex2mlive.py <chapter.tex> [<chapter.tex> …]", file=sys.stderr)
        return 2
    for arg in argv[1:]:
        in_path = Path(arg).resolve()
        out_path = in_path.with_suffix(".m")
        text = in_path.read_text(encoding="utf-8")
        book_root = _find_book_root(in_path.parent)
        out = convert(
            text,
            title_hint=in_path.stem.replace("_", " ").title(),
            source_path=in_path,
            book_root=book_root,
        )
        out_path.write_text(out, encoding="utf-8")
        print(f"wrote {out_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))

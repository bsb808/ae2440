"""Unit tests for tex2mlive.py. Run from the repo root:

    python3 -m unittest discover mlx_parse/tests
"""

from __future__ import annotations

import sys
import textwrap
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import tex2mlive as t  # noqa: E402

LABELS = {
    "ch": t.Label("chapter", "3", "Loops"),
    "sec:one": t.Label("section", "3.1", "One"),
    "fig:a": t.Label("figure", "3.1", "A figure"),
    "lst:x": t.Label("lstlisting", "3.1", "A listing"),
    "ex:p": t.Label("ex", "3.1", ""),
    "other": t.Label("chapter", "8", "Function Handles and Zero-Finding"),
}


def convert(body: str, **kw) -> str:
    tex = "\\documentclass[../../book.tex]{subfiles}\n\\begin{document}\n\\chapter{Loops}\n\\label{ch}\n" \
          + textwrap.dedent(body) + "\n\\end{document}\n"
    conv = t.Converter(labels=LABELS, **kw)
    out = conv.convert(tex)
    return out, conv


def body_lines(out: str) -> list[str]:
    return out.split("\n%[appendix]", 1)[0].splitlines()


class Structure(unittest.TestCase):
    def test_title_and_numbered_headings(self):
        out, _ = convert("""
            Intro.
            \\section{One}
            \\label{sec:one}
            \\subsection{Inner}
            Text.
            """)
        lines = body_lines(out)
        self.assertEqual(lines[0], "%[text] # Chapter 3: Loops")
        self.assertIn("%%", lines)
        self.assertIn("%[text] ## 3.1 One", lines)
        self.assertIn("%[text] ### 3.1.1 Inner", lines)

    def test_footer_with_one_blank_line(self):
        out, _ = convert("Text.")
        self.assertTrue(out.endswith("\n\n" + "\n".join(t.FOOTER) + "\n"))

    def test_paragraphs_collapse_to_one_line(self):
        out, _ = convert("""
            First line
            second line of the same paragraph.

            New paragraph.
            """)
        lines = body_lines(out)
        self.assertIn("%[text] First line second line of the same paragraph.", lines)
        self.assertIn("%[text] New paragraph.", lines)

    def test_no_control_characters(self):
        out, _ = convert("""
            \\begin{ex}
            \\begin{enumerate}
            \\item a
            \\item b
            \\end{enumerate}
            \\end{ex}
            """)
        self.assertFalse(any(ord(c) < 32 and c not in "\n\t" for c in out))


class Headings(unittest.TestCase):
    def test_footnote_lifted_out_of_heading(self):
        out, _ = convert("""
            \\section[What?]{What?\\protect\\footnote{From \\href{https://x.y}{Book}, 2e.}}
            Body.
            """)
        lines = body_lines(out)
        i = lines.index("%[text] ## 3.1 What?")
        self.assertEqual(lines[i + 1], "%[text] *From* [Book](https://x.y)*, 2e.*")
        self.assertEqual(lines[i + 2], "%[text] Body.")


class Code(unittest.TestCase):
    def test_session_becomes_runnable(self):
        out, _ = convert("""
            \\begin{code}
            >> x = 6 * 7
            x = 42
            \\end{code}
            """)
        self.assertIn("\nx = 6 * 7\n", out)
        self.assertNotIn("x = 42", out)

    def test_prompt_only_block_is_an_example(self):
        out, _ = convert("""
            \\begin{code}
            >>
            \\end{code}
            """)
        self.assertIn("%[text] ```matlabCodeExample\n%[text] >>\n%[text] ```", out)

    def test_noexec_directive(self):
        out, _ = convert("""
            % mlive: noexec
            \\begin{code}
            area = pi r^2
            \\end{code}
            """)
        self.assertIn("%[text] ```matlabCodeExample\n%[text] area = pi r^2\n%[text] ```", out)

    def test_error_directive_isolates_section(self):
        out, _ = convert("""
            Before.
            % mlive: error
            \\begin{code}
            sin pi
            \\end{code}
            After.
            """)
        lines = body_lines(out)
        i = lines.index("sin pi")
        self.assertEqual(lines[i - 1], t.ERROR_NOTE)
        self.assertEqual(lines[i - 2], "%%")
        self.assertEqual(lines[i + 1], "%%")
        self.assertEqual(lines[i + 2], "%[text] After.")

    def test_skip_directive(self):
        out, _ = convert("""
            % mlive: skip
            \\begin{stdout}
            gone
            \\end{stdout}
            """)
        self.assertNotIn("gone", out)

    def test_stdout_is_example_block(self):
        out, _ = convert("""
            \\begin{stdout}
            ans = 3

            done
            \\end{stdout}
            """)
        self.assertIn("%[text] ```matlabCodeExample\n%[text] ans = 3\n%[text] \n%[text] done\n%[text] ```", out)

    def test_listing_with_caption_is_numbered_and_runnable(self):
        out, _ = convert("""
            \\begin{lstlisting}[caption={A function}, label={lst:x}]
            function y = f(x)
                y = x;
            end
            \\end{lstlisting}
            See Listing~\\ref{lst:x}.
            """)
        self.assertIn("%[text] **Listing 3.1.** A function\nfunction y = f(x)\n    y = x;\nend", out)
        self.assertIn("%[text] See Listing 3.1.", out)

    def test_non_matlab_listing_is_example(self):
        out, _ = convert("""
            \\begin{lstlisting}[language=C]
            int x;
            \\end{lstlisting}
            """)
        self.assertIn("%[text] ```matlabCodeExample\n%[text] int x;", out)


class Prose(unittest.TestCase):
    def test_inline_and_display_math(self):
        out, _ = convert("""
            The value $\\frac{1}{2}$ and
            \\[ h = a t^2 / 2 \\]
            with $x_0$.
            """)
        self.assertIn("$\\\\frac{1}{2}$", out)
        self.assertIn('%[text]{"align":"center"} $h = a t^2 / 2$', out)
        self.assertIn("$x\\_0$", out)

    def test_uvec_becomes_hat(self):
        out, _ = convert("$\\uvec{V}$")
        self.assertIn("$\\\\hat{V}$", out)

    def test_nested_formatting(self):
        out, _ = convert("You should \\mbox{\\emph{always}} type \\textbf{\\lstinline{2 + 1}}.")
        self.assertIn("You should *always* type **`2 + 1`**.", out)

    def test_refs_resolve(self):
        out, conv = convert("See Figure~\\ref{fig:a}, Chapter~\\ref{other}, Exercise~\\ref{ex:p} and page~\\pageref{sec:one}.")
        self.assertIn("See Figure 3.1, Chapter 8, Function Handles and Zero-Finding, Exercise 3.1 and Section 3.1.", out)
        self.assertEqual(conv.warnings, [])

    def test_unresolved_ref_warns(self):
        out, conv = convert("See Figure~\\ref{nope}.")
        self.assertIn("§nope", out)
        self.assertTrue(any("unresolved" in w for w in conv.warnings))

    def test_si_units(self):
        out, _ = convert("At \\SI{18}{\\meter\\per\\second} and $a = \\SI{9.8}{\\meter\\per\\second\\squared}$.")
        self.assertIn("At 18 m/s and $a = 9.8\\\\,\\\\mathrm{m/s^2}$.", out)

    def test_typography_and_index(self):
        out, _ = convert("``Quoted''---dash\\index{x!y}~end. \\lstinline{a~b}")
        self.assertIn("%[text] “Quoted”—dash end. `a~b`", out)

    def test_epigraph_href_footnote(self):
        out, _ = convert("""
            \\epigraph{All models are wrong.}{\\textit{Box}}
            See \\href{https://x.y}{the site}\\footnote{A note.}.
            """)
        self.assertIn('%[text]{"align":"center"} *All models are wrong.* — *Box*', out)
        self.assertIn("See [the site](https://x.y) (note: A note.).", out)


class Escaping(unittest.TestCase):
    def test_prose_escapes_underscore_and_gt(self):
        out, _ = convert("Click \\textbf{New->Script}; the file \\emph{bike\\textunderscore update.m} and `a_b` and $i > 2$ and [u](https://x.y/a_b).")
        self.assertIn("Click **New-\\>Script**; the file *bike\\_update.m* and `a_b` and $i \\> 2$ and [u](https://x.y/a_b).", out)

    def test_math_escapes_brackets(self):
        out, _ = convert("$\\left[ x \\right]$")
        self.assertIn("$\\\\left\\[ x \\\\right\\]$", out)

    def test_example_blocks_are_not_escaped(self):
        out, _ = convert("\\begin{stdout}\n>> a_b\n\\end{stdout}")
        self.assertIn("%[text] >> a_b\n", out)


class Lists(unittest.TestCase):
    def test_quote_is_centered_italic(self):
        out, _ = convert("""
            \\begin{quote}
            Readable code is debuggable code.
            \\end{quote}
            """)
        self.assertIn('%[text]{"align":"center"} *Readable code is debuggable code.*', out)
        self.assertNotIn("> ", out)

    def test_quote_with_inner_emphasis_uses_matlab_form(self):
        out, _ = convert("\\begin{quote}\nA is \\emph{not} B.\n\\end{quote}")
        self.assertIn('%[text]{"align":"center"} *A is* ***not*** *B.*', out)

    def test_nested_lists(self):
        out, _ = convert("""
            \\begin{enumerate}
            \\item Outer one
            \\begin{itemize}
            \\item inner a
            \\item inner b
            \\end{itemize}
            \\item Outer two
            \\end{enumerate}
            After.
            """)
        lines = body_lines(out)
        self.assertEqual(lines[1:6], ["%[text] 1. Outer one", "%[text]   - inner a", "%[text]   - inner b \\",
                                      "%[text] 2. Outer two \\", "%[text] After."])

    def test_description_list(self):
        out, _ = convert("""
            \\begin{description}
            \\item[Key] the value
            \\end{description}
            """)
        self.assertIn("%[text] - **Key** — the value \\", out)

    def test_description_label_with_colon(self):
        out, _ = convert("\\begin{description}\n\\item[input:] Get data.\n\\end{description}")
        self.assertIn("%[text] - **input:** Get data. \\", out)

    def test_exercise_numbering_and_first_paragraph(self):
        out, _ = convert("""
            \\begin{ex}
            \\label{ex:p}
            First paragraph.

            Second.
            \\end{ex}
            \\begin{ex}
            Another.
            \\end{ex}
            """)
        lines = body_lines(out)
        self.assertIn("%[text] **Exercise 3.1.** First paragraph.", lines)
        self.assertIn("%[text] Second.", lines)
        self.assertIn("%[text] **Exercise 3.2.** Another.", lines)


class Figures(unittest.TestCase):
    def test_figure_embedded(self):
        import tempfile, struct, zlib
        with tempfile.TemporaryDirectory() as d:
            root = Path(d) / "book"
            (root / "images").mkdir(parents=True)
            src = root / "w01" / "chapter"
            src.mkdir(parents=True)
            # 2x3 PNG
            def chunk(tag, data):
                return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xffffffff)
            raw = b"".join(b"\x00" + b"\xff\x00\x00" * 2 for _ in range(3))
            png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", 2, 3, 8, 2, 0, 0, 0)) \
                + chunk(b"IDAT", zlib.compress(raw)) + chunk(b"IEND", b"")
            (root / "images" / "fig.png").write_bytes(png)
            out, conv = convert("""
                \\begin{figure}[h]
                \\centerline{\\includegraphics[scale=0.8]{images/fig}}
                \\caption{The $x$ process}
                \\label{fig:a}
                \\end{figure}
                """, source_path=src / "c.tex", book_root=root)
            self.assertEqual(conv.warnings, [])
            lines = out.splitlines()
            ref = next(ln for ln in lines if "![" in ln)
            self.assertRegex(ref, r'^%\[text\]\{"align":"center"\} !\[The x process\]\(text:image:[0-9a-f]{4}\)$')
            self.assertIn('%[text]{"align":"center"} *Figure 3.1: The $x$ process*', lines)
            img_id = ref.split("text:image:")[1].rstrip(")")
            i = lines.index(f"%[text:image:{img_id}]")
            self.assertTrue(lines[i + 1].startswith('%   data: {"align":"baseline","height":3,"src":"data:image\/png;base64,'))
            self.assertTrue(lines[i + 1].endswith('"width":2}'))
            self.assertEqual(lines[i + 2], "%---")

    def test_includepdf_embeds_png_twin(self):
        import tempfile
        with tempfile.TemporaryDirectory() as d:
            root = Path(d) / "book"
            (root / "w01" / "lessons").mkdir(parents=True)
            (root / "w01" / "lessons" / "x.pdf").write_bytes(b"%PDF-1.4\n")
            png = (Path(__file__).parent / "fixture.png")
            (root / "w01" / "lessons" / "x.png").write_bytes(png.read_bytes()) if png.exists() else None
            if not png.exists():
                self.skipTest("no fixture.png")
            out, conv = convert("\\includepdf[pages=-]{w01/lessons/x.pdf}", source_path=root / "c.tex", book_root=root)
            self.assertEqual(conv.warnings, [])
            self.assertRegex(out, r"!\[Page 1 of x.pdf\]\(text:image:[0-9a-f]{4}\)")

    def test_vector_only_figure_is_an_error(self):
        import tempfile
        with tempfile.TemporaryDirectory() as d:
            root = Path(d) / "book"
            (root / "images").mkdir(parents=True)
            (root / "images" / "fig.pdf").write_bytes(b"%PDF-1.4\n")
            with self.assertRaises(t.ConversionError):
                convert("\\begin{figure}\\includegraphics{images/fig}\\caption{x}\\end{figure}",
                        source_path=root / "c.tex", book_root=root)


class Comments(unittest.TestCase):
    def test_commented_includepdf_is_ignored(self):
        out, conv = convert("Text.\n%\\includepdf[pages=-]{w01/x.pdf}\nMore.")
        self.assertNotIn("x.pdf", out)
        self.assertEqual(conv.warnings, [])

    def test_chapter_number_from_toc_line(self):
        import tempfile
        with tempfile.NamedTemporaryFile("w", suffix=".aux", delete=False) as f:
            f.write("\\@writefile{toc}{\\contentsline {chapter}{\\numberline {2}Scripts and Live Scripts}{13}{chapter.2}}\n")
        labels = t.load_labels(Path(f.name))
        self.assertEqual(labels["chapter:Scripts and Live Scripts"], t.Label("chapter", "2", "Scripts and Live Scripts"))


class Counts(unittest.TestCase):
    def test_counts_agree(self):
        tex = "\\section{A}\\subsection{B}\\begin{ex}x\\end{ex}\n%\\begin{ex}commented\\end{ex}\n"
        out, _ = convert(tex)
        tc, mc = t.tex_counts(tex), t.m_counts(out)
        for k in ("sections", "subsections", "exercises", "figures"):
            self.assertEqual(tc[k], mc[k], k)


if __name__ == "__main__":
    unittest.main()

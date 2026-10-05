# Spec: textbook chapters as live scripts

- Objective: release each textbook chapter as a plain-text MATLAB live script (`.m`) next to the chapter PDF, as an optional beta reading format, one chapter at a time, and fold every lesson into the converter and the `mlx` skill so later chapters need less work.
- Inputs: `book/wNN_topic/chapter/<name>.tex` (single source), `book/book.aux` (cross-reference numbers), `book/images/*.png` (from `make images-png`), the mlx skill in `~/WorkingCopies/claude-global/skills/mlx/` (`mlx_lint.py`, `mlx_verify.m`, `reference.md`).
- Outputs: `book/wNN_topic/chapter/<name>.m` (generated, output-free, committed); `site/weeks/wNN_topic/files/<name>.m` (a copy of it, also output-free); a `[Live script]` link in the Formats column of `site/resources/textbook.qmd` (the schedule's reading cells link to that page).
- Owner: AI converts and verifies, author reads end to end in MATLAB.
- Verification: tier A (no MATLAB) `mlx_lint.py --strict` clean and `tex2mlive.py --check` passing; tier B `mlx_verify.m` (checkcode, export with Run, executeAndSave copy with body identical to the source); the author's read; `quarto render site` clean.
- Status: chapters 1–2 released (2026-09-26); chapters 3–6 converted, verified through tier B and released (2026-10-05), author read pending.

## Decisions (2026-09-26)

- Plain-text `.m` is the only live-script format. No `.mlx` anywhere in this pipeline.
- The release copy carries no cached outputs (decided 2026-09-26 after the chapter 1 read; the first plan had outputs). Students run the sections themselves. The `.m` in `book/` and the copy in `site/` are identical.
- Deliberate runtime errors stay runnable, isolated in their own `%%` section with a note (`% mlive: error`), or are cut from the `.tex` when the passage is dated (chapter 1's `sin pi` passage was cut: R2026b gives a different message). Syntax errors and expressions with undefined variables are shown as non-running examples (`% mlive: noexec`), because one syntax error makes the whole file unrunnable.
- Fixes go to the converter (`mlx_parse/tex2mlive.py`) or to the `.tex`, never to a generated `.m`.
- Students download the `.m` from the site (the link carries a `download` attribute so the browser saves it instead of showing it as text).

## Per-chapter checklist

1. Source prep: add `% mlive:` directives to the `.tex` where a code block must not run, must run into an error, or must be dropped. Port any hand edits found in the old `.m` into the `.tex` first (w08 has some). Then `cd book && make book && make images-png`.
2. Convert: `python3 mlx_parse/tex2mlive.py --diff book/wNN_topic/chapter/<name>.tex` to review, then `--force`. Read the warnings.
3. Tier A: `python3 ~/.claude/skills/mlx/mlx_lint.py --strict book/.../<name>.m` and `python3 mlx_parse/tex2mlive.py --check book/.../<name>.tex` both clean; `python3 -m unittest discover mlx_parse/tests` passes; read the `.m` through `mlx_dump.py` for numbering, lists, math and quotes.
4. Tier B: `matlab -batch "addpath('~/.claude/skills/mlx'); mlx_verify('<abs .m>', '<outdir>')"`. Look at the exported PDF or HTML page by page. Fix the converter or the `.tex` for anything found, then reconvert.
5. Author read (MATLAB): open the `.m` as a live script, Run All (then "Run to End" after any deliberate-error section), and read start to finish against the chapter PDF. Edits made in MATLAB during the read go into the `.tex`, then the chapter is reconverted; the `.m` must not be saved with outputs (`git checkout -- book/.../<name>.m` if it was). Check: headings and numbers match the PDF; every equation renders; figures visible and sized sensibly; each cell's output matches what the PDF shows; example blocks render as code; lists and nesting; quotes and the epigraph; exercises numbered; nothing missing (in particular `stdout` blocks that follow a runnable cell now duplicate the live output and may deserve a `% mlive: skip`).
6. Release copy: `cp book/wNN_topic/chapter/<name>.m site/weeks/wNN_topic/files/<name>.m`, renamed (`<name>_chapter.m`) if `<name>` is a MATLAB built-in (`exist <name>` returns 2 or 5), as `functions` is. `mlx_lint.py --strict` on the copy; `mlx_dump.py --outputs` must list only the metadata and image entries.
7. Site: add ` · [Live script](../weeks/wNN_topic/files/<name>.m){download="<name>.m"}` to the chapter's Formats cell in `site/resources/textbook.qmd` (the schedule in `site/index.qmd` links readings to that page, so it needs no edit). If source fixes changed the printed chapter, `make wNN` in `book/` and copy the chapter PDF to `files/` too; `quarto render site` clean; `python3 utils/check_schedule_dates.py` passes.
8. Record the chapter's row below and commit `.tex`, `.m`, PNGs, release copy, site edits and this file together.

Defects from the author's read: one bullet per defect under the chapter's row, `location (section or line) — what it shows — what it should show`. Each is triaged as a converter fix (patch plus a unit test), a format fact (recorded in the skill's `reference.md`), or a source fix (edit the `.tex`), then the chapter is reconverted.

## Directives

LaTeX comments on their own line, invisible in the PDF, immediately before the environment they modify: `% mlive: noexec` (show as a non-running example), `% mlive: error` (runnable, own section, stops on purpose), `% mlive: skip` (omit). Applies to `code`, `stdout`, `lstlisting`, `\lstinputlisting`, `figure`, `\includepdf`.

## Status

| Week | Chapter | Directives | Regenerated | Lint | Tier B | Author read | Released | Notes |
|---|---|---|---|---|---|---|---|---|
| 1 | 1 Modeling and Simulation | 2026-09-26 (3 noexec) | 2026-09-26 | clean | 2026-09-26 | 2026-09-26 | 2026-09-26 | author read: cut the dated `sin pi` / `abs pi` passage from the `.tex`; release without outputs |
| 1 | 2 Scripts and Live Scripts | 2026-09-26 (13 noexec) | 2026-09-26 | clean | 2026-09-26 | 2026-09-26 | 2026-09-26 | sessions that need `myscript`, `fibonacci1`, `swap`, `bike_update` or show errors are examples; the two `\includepdf` pages are embedded as page images |
| 2 | 3 Loops | 2026-10-05 (6 noexec) | 2026-10-05 | clean | 2026-10-05 | pending | 2026-10-05 | bike-share updates, `bike_update` and `series` sessions are examples; converter learned prompt sessions with `for`…`end` blocks, MATLAB's nested-list form (four-space indent, one ` \` for the whole list), literal `\\$`, and math ties |
| 2 | 4 Vectors | 2026-10-05 (8 noexec) | 2026-10-05 | clean | 2026-10-05 | pending | 2026-10-05 | error demos, the Fibonacci listing (needs `n`) and its plot, and the unprompted initialization block are examples; source fixes also correct the PDF (`xx`/`X` mix-up, `\lstinline(size())`, empty `\nameref` to Exercise 3.6, `Y(end)` output); `eqnarray` now one centered line per row; `\url` emitted as `[url](url)` |
| 3 | 5 Functions | 2026-10-05 (12 noexec) | 2026-10-05 | clean | 2026-10-05 | pending | 2026-10-05 | functions become local functions of the live script, so each name is defined once: the first `myfunc` runs, the documented redefinition is an example, as are `something_else`, the `sum` that shadows the built-in, error sessions, `edit mean` and `local_function_demo`; released as `functions_chapter.m` because `functions.m` shadows a MATLAB built-in (warning on every run); source fixes: `sum_and_product` gains its `end`, `\Verb` becomes `\emph`, the `s` error split from the `clear`/`who` session |
| 3 | 6 Conditionals | 2026-10-05 (11 noexec) | 2026-10-05 | clean | 2026-10-05 | pending | 2026-10-05 | first `is_pythagorean` and the final `find_triples` (Listing 6.1) run; the earlier `find_triples` versions, their sessions, the `for` fragments, the `=` syntax error and the bare output block are examples |
| 4 | 7 Data Types | | | | | | | |
| 4 | 8 Function Handles and Zero-Finding | | | | | | | `\lstinputlisting` with `mcode_numbers` style |
| 5 | 9 Functions of Vectors | | | | | | | |
| 5 | 10 Ordinary Differential Equations | | | | | | | one `\includepdf` |
| 6 | 11 Matrices and Systems of ODEs | | | | | | | |
| 6 | 12 Second-Order Systems | | | | | | | |
| 7 | 13 Two Dimensions | | | | | | | `\uvec`, line-range listings |
| 7 | 14 Optimization | | | | | | | |
| 8 | 15 Interpolation, Curve Fitting, and Regression | | | | | | | the `.m` was hand-edited after conversion; port those edits into the `.tex` before regenerating |
| 9 | 16 Introduction to Reinforcement Learning | | | | | | | |
| 10 | 17 Q-Learning and Blackjack | | | | | | | |

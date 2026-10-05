## mlx_parse utilities

Utility scripts for manipulating MATLAB `.mlx` live scripts.

### `mlx_soln2assign.py`

Creates student-facing `.mlx` files by blanking code blocks in instructor solutions.

```bash
python mlx_soln2assign.py assign1/aquarium_soln.mlx
python mlx_soln2assign.py assign1/aquarium_soln.mlx -o assign1/aquarium.mlx
```

### `mlx_to_plain_m.py`

Converts `.mlx` files to MATLAB's plain-text live script `.m` format using MATLAB's
Live Editor conversion API.

```bash
# Single file (auto output: same name, .m extension)
python mlx_to_plain_m.py assign3/takeoff.mlx

# Single file with explicit output path
python mlx_to_plain_m.py assign3/takeoff.mlx -o assign3/takeoff_plain.m

# Convert all .mlx in a directory
python mlx_to_plain_m.py assign3/

# Recursively convert all .mlx below a directory
python mlx_to_plain_m.py lessons/ -r
```

Notes:
- Existing output files are skipped unless `--force` is provided.
- Use `--matlab` to specify a non-default MATLAB command.
- You can also set `MATLAB_CMD` in the environment.

### `tex2mlive.py`

Converts a book chapter (`book/wNN_topic/chapter/<name>.tex`) to a plain-text live script `<name>.m` beside it. The `.tex` is the single source: fix the converter or the `.tex`, never the generated `.m`. Run from the repo root.

```bash
# Prerequisites, once per session (fresh cross-reference numbers and PNG figures)
(cd book && make book && make images-png)

python3 mlx_parse/tex2mlive.py --diff  book/w01_modeling_scripts/chapter/modeling.tex   # review, writes nothing
python3 mlx_parse/tex2mlive.py --force book/w01_modeling_scripts/chapter/modeling.tex   # overwrite the .m
python3 mlx_parse/tex2mlive.py --check book/w01_modeling_scripts/chapter/modeling.tex   # .m current? headings, exercises, figures match? exit 1 if not
python3 -m unittest discover mlx_parse/tests                                            # converter unit tests
```

Cross-references (`\ref`, `\pageref`, `\nameref`) resolve through `book/book.aux`, so headings, figures, listings and exercises carry the same numbers as the PDF. Figures are embedded as PNG; `make images-png` rasterizes the EPS/PDF figures in `book/images/` (EPS preferred, since several PDF twins are full rotated pages).

Directives are LaTeX comments on their own line, invisible in the PDF, placed immediately before the environment they modify:

| Directive | Effect on the next environment |
|---|---|
| `% mlive: noexec` | code or lstlisting is shown as a non-running example (use for syntax errors, which would make the whole file unrunnable, and for expressions with undefined variables) |
| `% mlive: error` | code stays runnable in its own `%%` section with a note that it stops with an error on purpose (runtime errors) |
| `% mlive: skip` | code, stdout, lstlisting, figure or includepdf is omitted |

What the output uses: one `%[text]` line per paragraph, bare runnable code for `\begin{code}` sessions (prompts and echoed output removed), `matlabCodeExample` fenced blocks for `stdout` and non-running code, centered italics for `quote` and `\epigraph` (blockquotes are not live-script markdown), ` \` on the last item of each outermost list (nested items indented four spaces), `$...$` math with doubled backslashes (one centered line per row of `eqnarray` or `align`), and the required appendix footer. Warnings go to stderr; anything left as `§label` or `\command` in prose is a warning and is also caught by `mlx_lint.py` in the mlx skill.

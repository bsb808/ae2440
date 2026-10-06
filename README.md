# AE2440 — Introduction to Scientific Programming

Course materials for AE2440 at NPS — an introductory MATLAB programming course for naval-officer undergraduates.

## Course website

[bsb808.github.io/ae2440](https://bsb808.github.io/ae2440/) — Quarto site under `site/`, deployed to GitHub Pages (branch `gh-pages`) by `.github/workflows/publish-site.yml` on every push to `main` that touches `site/**`.

To preview locally, run from this repo's root:

```bash
quarto preview site
```

Quarto renders the site, prints a `http://localhost:NNNN/` URL, opens it in your browser, and live-reloads on file changes. `Ctrl+C` to stop.

### Checks before pushing

A pre-push hook renders the site and runs two checks (`utils/check_site_links.py` for broken relative links in the rendered HTML, `utils/check_schedule_dates.py` for schedule dates) whenever the commits being pushed touch `site/` or `utils/`. Enable it once per clone:

```bash
git config core.hooksPath utils/hooks
```

To push anyway when there is no time to fix a failure: `git push --no-verify`. To run the same checks by hand: `quarto render site && python3 utils/check_site_links.py && python3 utils/check_schedule_dates.py`.

Site layout: `site/weeks/wNN_topic/` mirrors the `book/wNN_topic/` week names and holds each week's `assignment.qmd` plus a `files/` folder for released static files (slides, chapter PDFs, screenshots). Files that already live in `book/` are linked on GitHub, not copied. Per-quarter values live in `site/_variables.yml`; the quarter startup runbook is `specs/spec_startup_new_quarter.md` and the one-time wiki migration is `specs/spec_wiki_transition.md`.

## Layout

The course is organized as a week-by-week book under `book/`, following the per-week pattern used by `me2801/introduction-to-feedback-control`. The course runs ten weeks of class material.

```
book/
  book.tex                         # master file — \input each week's chapter
  Makefile                         # build all chapters / assignments / book

  w01_modeling_scripts/            # PMM Ch1-2   | Assignment 1
  w02_loops_vectors/               # PMM Ch3-4   | Assignment 2
  w03_functions_conditionals/      # PMM Ch5-6   | Assignment 3
  w04_datatypes_fzero/             # PMM Ch7-8   | Assignment 4
  w05_funcvectors_odes/            # PMM Ch9-10  | Assignment 5
  w06_matrices_secondorder/        # PMM Ch11-12 | Assignment 6
  w07_twodim_optimization/         # PMM Ch13-14 | Assignment 7
  w08_interpolation_curvefit/      # new chapter | Assignment 8
  w09_rl_intro/                    # RL intro    | (no graded assignment)
  w10_rl_blackjack/                # Q-learning  | Assignment 9

  images/                          # shared figures used by chapters
```

Each `wNN_topic/` directory contains:

| Subdir     | Contents                                                  |
|------------|-----------------------------------------------------------|
| `chapter/` | Chapter prose (`.tex`), drawn from Physical Modeling in MATLAB |
| `lessons/` | In-class MATLAB scripts (`.mlx`, `.m`) and supporting code |
| `assign/`  | Student-facing assignment files                           |
| `refs/`    | Reference docs, slides, supporting PDFs                    |

## Building the book

```bash
cd book
make book          # build the master PDF
make chapters      # build each chapter standalone
make assignments   # build each assignment standalone
make w04           # build chapter + assignment for a single week
```

Required LaTeX packages (Ubuntu/Debian):

```bash
sudo apt install -y \
    texlive-latex-extra texlive-latex-recommended \
    texlive-fonts-recommended texlive-fonts-extra \
    texlive-science texlive-plain-generic
```

## Companion repos

| Repo | Purpose | Visibility |
|------|---------|------------|
| `bsb808/ae2440` (this) | Public course materials | Public |
| `bsb808/ae2440-solutions` | Instructor solutions (`solutions/`) and the Sakai grading workflow (`grading/`) | Private |
| `bsb808/PhysicalModelingInMatlab` (`ae2440-dev`) | Source textbook fork | Public |

The solutions repo mirrors the per-week layout under `solutions/`: `solutions/wNN_topic/<assignment>_soln.m`. Its `grading/` folder holds the grading tooling and per-assignment specs, so nothing that touches student submissions is in this public repo. Lesson `_soln` files (used for in-class demos) remain in this public repo's `book/wNN_topic/lessons/`.

## Other top-level directories

| Dir | Purpose |
|-----|---------|
| `archive/` | Off-schedule scratch material |
| `examples/` | Standalone MATLAB demos referenced from chapters |
| `site/` | Quarto course website (see above) |
| `specs/` | Working specs: quarter startup runbook, wiki migration |
| `utils/` | Small tools: wiki extractor, site link check, schedule date check, git hooks |
| `images/` | Course-level images (separate from `book/images/`) |
| `mlx_parse/` | Python tooling for generating student assignment files from solution `.mlx` |
| `dev/`, `misc/` | Development scratch |

## Course schedule

| Week | Topics                                              | Due Friday    |
|-----:|-----------------------------------------------------|---------------|
| 1    | Modeling and Simulation; Scripts and Live Scripts   | Assignment 1  |
| 2    | Loops; Vectors                                      | Assignment 2  |
| 3    | Functions; Conditionals                             | Assignment 3  |
| 4    | Data Types; Function Handles and `fzero`            | Assignment 4  |
| 5    | Functions of Vectors; Ordinary Differential Equations | Assignment 5 |
| 6    | Matrices and Systems of ODEs; Second-Order Systems  | Assignment 6  |
| 7    | Two Dimensions; Optimization (incl.\ anonymous functions) | Assignment 7 |
| 8    | Interpolation, Curve Fitting, and Regression        | Assignment 8  |
| 9    | Introduction to Reinforcement Learning              | —             |
| 10   | Q-Learning and Blackjack                            | Assignment 9  |

# AE2440 — Introduction to Scientific Programming

Course materials for AE2440 at NPS — an introductory MATLAB programming course for naval-officer undergraduates.

## Layout

The course is organized as a week-by-week book under `book/`, following the per-week pattern used by `me2801/introduction-to-feedback-control`. The schedule runs weeks 3–11 (week 9 is Thanksgiving and is omitted).

```
book/
  book.tex                         # master file — \input each week's chapter
  Makefile                         # build all chapters / assignments / book

  w03_modeling_scripts/            # PMM Ch1-2  | Assignment 1
  w04_loops_vectors/               # PMM Ch3-4  | Assignment 2
  w05_functions_conditionals/      # PMM Ch5-6  | Assignment 3
  w06_datatypes_fzero/             # PMM Ch7-8  | Assignment 4
  w07_funcvectors_odes/            # PMM Ch9-10 | Assignment 5
  w08_matrices_secondorder/        # PMM Ch11-12| Assignment 6
  w10_rl_intro/                    # RL intro   | Assignment 7
  w11_rl_blackjack/                # RL Q-learn | Assignment 8

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
| `bsb808/ae2440-solutions` | Instructor solution `.mlx`/`.m` files | Private |
| `bsb808/PhysicalModelingInMatlab` (`ae2440-dev`) | Source textbook fork | Public |

The solutions repo mirrors the per-week layout: `wNN_topic/<assignment>_soln.<ext>`. Lesson `_soln` files (used for in-class demos) remain in this public repo's `book/wNN_topic/lessons/`.

## Other top-level directories

| Dir | Purpose |
|-----|---------|
| `archive/` | Legacy content not on the current schedule (optimization, curve-fitting, scratch) |
| `examples/` | Standalone MATLAB demos referenced from chapters |
| `grading/` | Sakai grading workflow; per-assignment downloads + comments. See `CLAUDE.md` for the workflow |
| `images/` | Course-level images (separate from `book/images/`) |
| `mlx_parse/` | Python tooling for generating student assignment files from solution `.mlx` |
| `dev/`, `misc/` | Development scratch |

## Course schedule (summary)

Authoritative schedule lives at the NPS Confluence wiki: pageId `1304134439`.

| Week | Date  | Topics                              | Due Friday    |
|-----:|-------|-------------------------------------|---------------|
| 3    | 13 Oct| Modeling and Simulation; Scripts    | Assignment 1  |
| 4    | 20 Oct| Loops; Vectors                      | Assignment 2  |
| 5    | 27 Oct| Functions; Conditionals             | Assignment 3  |
| 6    |  3 Nov| Data Types; Function Handles & fzero| Assignment 4  |
| 7    | 10 Nov| Functions of Vectors; ODEs (Vet's Day Tue) | Assignment 5 |
| 8    | 17 Nov| Matrices and Systems of ODEs; 2nd-order | Assignment 6 |
| 9    | 24 Nov| **Thanksgiving — no class**         | —             |
| 10   |  1 Dec| Reinforcement Learning (intro)      | Assignment 7  |
| 11   |  8 Dec| Reinforcement Learning (Q-learning) | Assignment 8  |

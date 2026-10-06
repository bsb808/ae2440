# AE2440 — Introduction to Scientific Programming

Course materials for naval officer undergraduates at an engineering program. Taught in MATLAB, covering general programming concepts and MATLAB toolbox capabilities.

## Repository Overview

The course is organized as a week-by-week book under `book/`. Each `book/wNN_topic/` directory holds one week of material with subdirs `chapter/` (LaTeX prose), `lessons/` (in-class MATLAB scripts), `assign/` (student-facing assignment files), and `refs/` (slides, supporting docs).

Active weeks: `w01_modeling_scripts`, `w02_loops_vectors`, `w03_functions_conditionals`, `w04_datatypes_fzero`, `w05_funcvectors_odes`, `w06_matrices_secondorder`, `w07_twodim_optimization`, `w08_interpolation_curvefit`, `w09_rl_intro`, `w10_rl_blackjack`. Most weeks correspond to a numbered assignment (Week 1 → Assignment 1, …, Week 8 → Assignment 8; Week 9 has no graded assignment; Week 10 → Assignment 9).

| Directory | Contents |
|-----------|----------|
| `book/` | Week-by-week book (chapters, lessons, assignments, refs). Built with `make book` from inside `book/`. |
| `archive/` | Off-schedule scratch material |
| `examples/` | Standalone demos and worked examples |
| `site/` | Quarto course website, published to https://bsb808.github.io/ae2440/ (see Course Website below) |
| `specs/` | Spec-anchored runbooks: `spec_startup_new_quarter.md` (recurring), `spec_live_scripts.md` (chapter live-script rollout), `spec_wiki_transition.md` (one-time). The grading SOP lives in the private repo (see below) |
| `utils/` | `wiki_migrate/extract.py` (Confluence export → Markdown extracts), `check_schedule_dates.py` |
| `mlx_parse/` | Python tooling: `tex2mlive.py` (chapter `.tex` to live script), `mlx_soln2assign.py` (student assignment files) |
| `images/` | Course-level images (separate from `book/images/`) |
| `dev/`, `misc/` | Development scratch |

### Companion private repo: `bsb808/ae2440-solutions`

The private companion repo at `~/WorkingCopies/ae2440/ae2440-solutions/` (sibling to this repo under the umbrella `~/WorkingCopies/ae2440/`) has two top-level folders: `solutions/wNN_topic/<assignment>_soln.m` (instructor solutions for graded assignments) and `grading/` (the spec-driven Sakai grading workflow: `grade.py`, `run_checks.m`, `aNN/spec.md` + `checks.yaml` per assignment, and the SOP `grading/spec_grading.md`). Everything that touches student submissions lives there or in the gitignored student-work folder `~/WorkingCopies/ae2440/StudentWork/`, never in this public repo. Lesson `_soln` files (used for in-class demos) **stay public** in `book/wNN_topic/lessons/`.

## Course Website

The public course site is a Quarto website under `site/`, published by GitHub Actions to the `gh-pages` branch and served at https://bsb808.github.io/ae2440/. It replaced the NPS Confluence wiki in September 2026. Preview with `quarto preview site` from the repo root.

Conventions:

- The schedule is the landing page, `site/index.qmd`; `/schedule.html` is an `aliases` redirect kept for old links (it preserves `#week-N` fragments). The page is a one-line meeting note, a six-column overview table (Week, Date, Topic, Prep, Content, Do (Due)) inside `::: {.table-responsive}`, the holiday footnotes, then one `## Week N — DD Mon: Topic {#week-N}` section per week. Posted weeks have one table row per class day with the `[N](#week-N)` link only in the first row's Week cell (later rows leave it empty; `site/styles.css` uses that to draw the week-grouping rules). Unposted weeks are one collapsed row with a date range (`19–22 Oct`), expanded when the week is posted. Cells carry Bootstrap icons linking to the week section: Prep `<i class="bi bi-book" aria-label="Reading"></i> Ch N`, Content `<i class="bi bi-card-list" aria-label="Week details"></i>`, Do `<i class="bi bi-pencil-square" aria-label="Assignment"></i> AN (Fri D Mon)`; the Do icon links to the assignment page once posted and is a plain icon before that. `utils/check_schedule_dates.py` parses this table and the week headings.
- `site/weeks/wNN_topic/` uses the same week names as `book/wNN_topic/`. Each holds `assignment.qmd` (one page per assignment) and `files/` for static files released to students (slide PDFs, chapter PDFs, screenshots, datasets not in `book/`).
- Files that already live in `book/` are linked on GitHub via `{{< var repo_blob >}}/book/...`, never copied into `site/`. Prefer linking the plain-text `.m` live script when both `.m` and `.mlx` exist.
- Readings on the schedule use one fixed line per chapter: `Before class: Read Chapter N, Title` followed by format links (`[PDF](weeks/.../files/name.pdf)` and, once the chapter's live script is released, ` · [Live script](weeks/.../files/name.m){download="name.m"} (beta)`). Chapter PDFs are gitignored in `book/`; releasing a chapter means `make wNN` in `book/` and copying the PDF into the week's `files/`. The live-script release follows `specs/spec_live_scripts.md` (convert with `mlx_parse/tex2mlive.py`, verify, author read, copy the `.m` into `files/` without cached outputs).
- The site is a GitHub Pages project site served under `/ae2440/`, so links must be relative. Never write a root-absolute link (`/foo`).
- Per-quarter values (`quarter`, `term_start`, `meeting`, ...) live in `site/_variables.yml` and are used as `{{< var name >}}`. Previous quarters are archived under `site/archive/<ayNNqN>/` with an "Archived" callout.
- Solutions are released on the site after an assignment is due: copy the `_soln.m` files from the private repo's `solutions/wNN_topic/` (the source of truth) into the week's `files/` and list them as download links in the Solutions column of `site/assignments.qmd`. Do not post a solution before its due date.
- Before pushing site changes, the pre-push hook in `utils/hooks/` renders and runs `utils/check_site_links.py` and `utils/check_schedule_dates.py` (enable per clone with `git config core.hooksPath utils/hooks`; bypass with `git push --no-verify`).
- When reporting a created or edited `.qmd`, list both the live URL (`https://bsb808.github.io/ae2440/<path>.html`) and the source path (`site/<path>.qmd`).
- The MOSS similarity-check tooling is kept outside this repo (it carries a personal user ID).

## File Formats

### Plain-text live scripts (.m) are the format
Live scripts in this course are plain-text `.m` files (MATLAB R2025a and later): the source in `book/`, the released chapter copies, the assignments students submit. Do not create `.mlx` files; the ones still in the repo are legacy from before MathWorks offered plain text and are left alone (binary in git, see `.gitattributes`; do not diff or merge them).

### Plain-Text MLX Format (.m with MLX markers)
The plain-text live script format is a version-control-friendly representation of live scripts. Key markers:

```matlab
%[text] Markdown prose goes here (supports **bold**, `code`, LaTeX math, images)
%[text] ![](text:image:HASH)       % embedded image reference

% --- normal MATLAB code (no marker needed) ---
x = 42;

%[text:table]{"ignoreHeader":true}  % opening tag for a rendered table
%[text] | Col A | Col B |           % header row
%[text] | --- | --- |               % separator row (required inside table tags)
%[text] | val 1 | val 2 |
%[text:table]                       % closing tag

%[output:HASH]                     % cached output block (auto-generated)
%   data: {...}

%[appendix]{"version":"1.0"}       % end of runnable content
%[metadata:view]                   % layout/display hints
%   data: {...}
%[text:image:HASH]                 % base64-encoded embedded image
%   data: {...}
```

Section breaks use `%%` (same as traditional scripts). `%[text]` lines are prose; everything else is executable MATLAB.

**Spacing conventions when authoring `.m` live scripts:**

- No blank line at the boundary between `%[text]` lines and code — in either direction (code→`%[text]` or `%[text]`→code).
- No blank line before a `%%` section break.
- Consecutive `%[text]` lines render as separate paragraphs automatically — do **not** insert a blank `%[text]` or `%[text] ` separator line between them; it creates an unwanted extra blank line in the output.
- Blank lines *within* a code block are fine to separate logical groups.
- Leave one blank line before the `%[appendix]` footer.

**LaTeX math in `.m` live scripts:**

LaTeX inside math markers requires special handling in the plain-text `.m` format:

- **Use `$...$` for all math** — both inline and display equations. Do NOT use `$$...$$`; it does not render and shows as plain text.
- **Double all backslashes**: write `\\frac`, `\\theta`, `\\quad`, `\\Longrightarrow`, `\\mathrm`, etc. A single `\` will not render.
- **Escape underscores in subscripts**: write `\_e`, `\_0`, etc. A bare `_` is interpreted as italic markdown.
- **`$$$` is valid**: a `%[text]` line may begin or end with `$$$` — this is intentional syntax for correct rendering and should not be treated as a typo.

**Local functions in `.m` live scripts (MATLAB 2024+):**

Local functions may be placed **inline** in the script at the point where they are introduced — they do not need to go at the bottom of the file. Place the `function...end` block immediately before the code that tests it, within the same section.

**Required footer:** Every plain-text live script `.m` file must end with the following block or MATLAB will open it as a plain script instead of a live script (still true in R2026b, tested Oct 2026). If MATLAB still opens it as a plain script, right-click the file and choose **Open as Live Script**.

```matlab
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
```

### Traditional Scripts (.m)
Older lesson files use standard MATLAB cell-mode format (`%%` sections, `%` comments). These are being migrated to `.mlx`.

## Naming Conventions

| Pattern | Meaning |
|---------|---------|
| `lesson_*.mlx` | In-class lesson live script |
| `*_soln.mlx` | Instructor solution file |
| `*.mlx` (no suffix) | Student assignment file (code blanked out) |
| `*_nocode.mlx` | Alternate student version generated by tooling |

## Generating Student Assignment Files

`mlx_parse/mlx_soln2assign.py` converts a solution `.mlx` into a student version by replacing all code-block CDATA content with `% Your code here.`

The instructor solution lives in the private companion repo `~/WorkingCopies/ae2440/ae2440-solutions/`; the generated student file lands in this repo's `book/wNN_topic/assign/`.

```bash
# Auto-names output: removes _soln or appends _nocode
python mlx_parse/mlx_soln2assign.py ../ae2440-solutions/solutions/w01_modeling_scripts/aquarium_soln.mlx \
    -o book/w01_modeling_scripts/assign/aquarium.mlx
```

The script treats `.mlx` files as zip archives, edits `matlab/document.xml` inside, and repackages.

## Development Direction

The course is migrating all content to plain-text live scripts. When creating or editing course materials:

- Write plain-text `.m` live scripts for lessons and assignments; never `.mlx`.
- Keep solution files named with the `_soln` suffix.
- Use `mlx_soln2assign.py` to produce the student-facing file rather than editing it manually.
- LaTeX is used only for standalone reference documents (not assignments).

## Exercise Design Patterns

### ODE Assignment Structure
ODE assignments use a consistent two-file structure:

1. **`*_soln.m`** — plain-text live script containing the full solution:
   - **Model section**: state the ODE in `$...$` LaTeX and define all parameters
   - **Rate function**: local function placed **inline** at the point it is introduced (MATLAB 2024+), accepting `(t, y)` even when the ODE does not depend on `t`. Parameters are defined inside the function body.
   - **Test cell**: call the rate function at the initial condition to verify the initial rate before solving
   - **ode45 solution**: `ode45(@rate_func, tspan, y0)`
   - **Euler solution** (if included): call `euler(@rate_func, tspan, y0)` — requires `euler.m` in the same directory
   - **Comparison**: overlay plot with a reference line at the equilibrium/terminal value; `fprintf` to report key scalar results

2. **`euler.m`** — standalone primary function students write separately. Fixed step size `dt = (tspan(2)-tspan(1))/100`. Interface mirrors `ode45`: `[tt, yy] = euler(odefun, tspan, y0)`. See `book/w05_funcvectors_odes/lessons/euler_reference.m` for the reference implementation. (The simpler `book/w05_funcvectors_odes/lessons/euler.m` is the didactic version cited from `chapter/odes.tex`.)

The initial rate-function test is the key scaffolding step: it confirms the physics before introducing the solver, and gives students a concrete value to check against intuition.

### Two-Part Data Exercise
For exercises where students work with a non-trivial data structure (struct arrays, formatted sensor data, etc.), separate the data creation from the exercise itself:

1. **`*_gen.m`** — a short, complete script that creates the data and saves it as a `.mat` file. Given to students as a worked example showing how the data was built. Students run it but don't write it.
2. **`*_soln.m`** — the exercise script. Loads the `.mat` file and has students inspect, manipulate, and report on the data.

This separates the complexity of *constructing* a data structure from the skill being exercised (e.g., field access, type conversion, formatting). See `book/w04_datatypes_fzero/assign/contact_gen.m` (with `contact_soln.m` in `ae2440-solutions/w04_datatypes_fzero/`) and `book/w04_datatypes_fzero/assign/sensor_clean.m` + `sensordata.mat` as examples.

## Privacy — No Student Names

**Never include student names** in any file checked into this repository, in commit messages, or in any other artifact intended to be persisted (notes, summaries, email drafts, grading records, etc.). This applies to first names, last names, full names, usernames, and any other identifying information.

When referring to specific students, use a generic placeholder ("Student", "one student", "a student") and convey the relevant detail (the bug they had, the file they submitted) without identifying who. If a name is unavoidable for context inside a non-tracked working file, scrub it before commit.

This rule supersedes any apparent convenience of naming individuals in grading summaries, email drafts, or class-themes notes.

## Grading Workflow

Grading lives in the private companion repo, `ae2440-solutions/grading/`: the SOP `spec_grading.md` (check kinds, per-assignment checklist, status table), `grade.py`, `run_checks.m`, and `aNN/spec.md` + `checks.yaml` per assignment. Run it from that repo's root, e.g. `python3 grading/grade.py a01`. Sakai downloads and all working files (extractions, reports, graded zips) go to `~/WorkingCopies/ae2440/StudentWork/<quarter>/`, outside every repo. Nothing about student submissions belongs in this public repo.

## Key MATLAB Conventions Used in This Course

- Suppress output with semicolons (`;`) except where output is intentional for student inspection.
- Use `%%` section breaks to divide lessons into runnable cells.
- Prefer named variables over magic numbers; parameter values are declared at the top of a script.
- Toolboxes in active use: Curve Fitting, Statistics and Machine Learning, Optimization, ODE solvers (`ode45`, etc.).

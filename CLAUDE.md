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
| `grading/` | Sakai grading workflow (per-assignment downloads + comments) |
| `mlx_parse/` | Python tooling for generating student assignment files |
| `images/` | Course-level images (separate from `book/images/`) |
| `dev/`, `misc/` | Development scratch |

### Companion private repo: `bsb808/ae2440-solutions`

Instructor `_soln.mlx` / `_soln.m` files for **graded assignments** live in the private companion repo at `~/WorkingCopies/ae2440-solutions/`, organized by week (`wNN_topic/<assignment>_soln.<ext>`). Lesson `_soln` files (used for in-class demos) **stay public** in `book/wNN_topic/lessons/`.

## File Formats

### MATLAB Live Scripts (.mlx)
The primary authoring format for this course. `.mlx` files are binary (Microsoft OOXML/ZIP). They are tracked in git as binary (see `.gitattributes`). Do not diff or merge `.mlx` files directly.

### Plain-Text MLX Format (.m with MLX markers)
Some `.m` files in this repo use MATLAB's plain-text live script format — a version-control-friendly representation of live scripts. Key markers:

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

**Required footer:** Every plain-text live script `.m` file must end with the following block or MATLAB will open it as a plain script instead of a live script. If MATLAB still opens it as a plain script, right-click the file and choose **Open as Live Script**.

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

The instructor solution lives in the private companion repo `~/WorkingCopies/ae2440-solutions/`; the generated student file lands in this repo's `book/wNN_topic/assign/`.

```bash
# Auto-names output: removes _soln or appends _nocode
python mlx_parse/mlx_soln2assign.py ../ae2440-solutions/w01_modeling_scripts/aquarium_soln.mlx \
    -o book/w01_modeling_scripts/assign/aquarium.mlx
```

The script treats `.mlx` files as zip archives, edits `matlab/document.xml` inside, and repackages.

## Development Direction

The course is actively migrating **all content to `.mlx` live scripts**. When creating or editing course materials:

- Prefer `.mlx` over traditional `.m` scripts for lessons and assignments.
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

### Sakai Download Format
Assignments are downloaded from Sakai as a zip file and stored in `grading/`. The zip filename encodes the assignment name and download timestamp, e.g.:

```
grading/Assignment2_LoopsVectors_20260410224035.zip
```

The zip contains one subdirectory per student plus a `grades.csv`:

```
Assignment2_LoopsVectors/
  grades.csv                              # import back to Sakai after grading
  StudentName, First(username)/
    timestamp.txt
    comments.txt                          # append feedback here; imported by Sakai
    Submission attachment(s)/             # student-submitted files
    Feedback Attachment(s)/               # (empty; for instructor file returns)
```

### Grading Process
1. Extract the zip to a working directory (e.g., `/tmp/`):
   ```bash
   unzip grading/AssignmentN_*.zip -d /tmp/submissions/
   ```
2. Inspect `Submission attachment(s)/` for each student. Required filenames are specified per assignment — **filenames are case-sensitive**.
3. Edit `grades.csv` to fill in the `grade` column and append feedback text to each student's `comments.txt`.
4. Repack the modified directory for Sakai upload:
   ```bash
   cd /tmp/submissions
   zip -r AssignmentN_graded.zip AssignmentN_*/
   ```

### Reading Plain-Text MLX Submissions
Student `.m` files submitted as live scripts contain large binary-encoded `%[output:...]` blocks. When reading them programmatically, skip those blocks to extract only the executable code and prose:

```python
import re

def extract_code_text(path):
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        lines = f.readlines()
    result = []
    skip = False
    for line in lines:
        stripped = line.rstrip()
        if re.match(r'%\[(output|appendix|metadata|text:image)', stripped):
            skip = True; continue
        if skip:
            if re.match(r'%\[', stripped) and not re.match(r'%\[(output|metadata|text:image)', stripped):
                skip = False
            elif not stripped.startswith('%') or stripped.startswith('%[text'):
                skip = False
            else:
                continue
        if not skip:
            result.append(stripped)
    return '\n'.join(result)
```

### Assignment Reference Files
Student-facing assignment files live under `book/wNN_topic/assign/`; matching instructor solutions live in the private companion repo at `~/WorkingCopies/ae2440-solutions/wNN_topic/`. Solution `.mlx` files can be read as zip archives (`matlab/document.xml` contains the content as XML with CDATA code blocks).

## Assignment Grading Setups

Per-assignment required files and grading narrative. Used by `grading/grading_utils.py`.

### Assignment 2 — Loops and Vectors
**Zip:** `grading/Assignment2_LoopsVectors_20260410224035.zip`

**Required files:**
- `fudge.m`, `span_statistics.m`, `lcs_flow.m`, `decay_twoways.m`

**Grading narrative:** File presence only (100 if all present, 90 if any missing). No content deductions — formative feedback only.

---

### Assignment 3 — Functions and Conditionals
**Zip:** `grading/Assignment 3_ Functions and Conditionals_20260419200756.zip`

**Required files:**
- `beaufort_main.m`, `beaufort_classify.m`, `functions_scope.m`
- `triangle_classifier.m`, `is_valid_triangle.m`, `classify_triangle.m`

**Grading narrative:** File presence only (100 if all present, 90 if any missing). No content deductions — formative feedback only.

**Code review:** Read each student's `beaufort_classify.m` against the instructions in `book/w03_functions_conditionals/assign/beaufort_main.m`. This is students' first function; give constructive suggestions. Look for:
- Unnecessarily complex conditional logic (redundant conditions, nested ifs that could be flat elseif chains)
- Output printed inside the function (`disp`/`fprintf`) instead of returned — misunderstanding that return values and printed output are different things
- Other first-function stumbles (e.g. modifying input variables expecting the caller to see the change)

---

## Key MATLAB Conventions Used in This Course

- Suppress output with semicolons (`;`) except where output is intentional for student inspection.
- Use `%%` section breaks to divide lessons into runnable cells.
- Prefer named variables over magic numbers; parameter values are declared at the top of a script.
- Toolboxes in active use: Curve Fitting, Statistics and Machine Learning, Optimization, ODE solvers (`ode45`, etc.).

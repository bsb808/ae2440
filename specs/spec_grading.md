# Spec: assignment grading

- Objective: grade each assignment lightly and repeatably, with two outcomes: (A) individual feedback for every student, formative (what to do better) and evaluative (a grade); (B) class-wide generalizations, positive and negative, to discuss in class and to improve the course.
- Approach: spec-driven. Each assignment's grading is written down first as a short set of checks (the spec), iterated with the author, then implemented as configuration for one shared runner, run, and checked with students. Start minimal and grow checks one assignment at a time.
- Inputs: the Sakai download zip in `grading/` (gitignored); `grading/aNN/spec.md` and `grading/aNN/checks.yaml`; the reference solution (`ae2440-solutions/wNN_topic/` or `book/wNN_topic/assign/`).
- Outputs: each student's `comments.txt` and the `grade` column of `grades.csv`, repacked as `grading/aNN/work/aNN_graded.zip` for Sakai upload; `grading/aNN/work/report.md` (per student × check, gitignored); `grading/aNN/class_summary.md` (no names, committed).
- Tooling: `grading/grade.py` (runner), `grading/run_checks.m` (MATLAB harness), `grading/grading_utils.py` (Sakai and live-script helpers).
- Owner: author approves the spec and the feedback wording, reviews the report before upload; AI drafts specs, runs the tooling, drafts the class summary.
- Verification: dry run on the reference solution (all pass) and seeded bad fixtures (each trips exactly its check) before touching real submissions.
- Status: A1 spec drafted (2026-10-05); tooling not yet implemented.

## Decisions (2026-10-05)

- Keep it light. The grade reflects a small number of graded checks; everything else is advisory feedback and never a deduction.
- Default grade policy: 100 if every graded check passes, 90 otherwise. An assignment's spec will most often change this, in writing, before grading starts.
- The student-facing wording of every check lives in the spec, so feedback is reviewed before it is sent.
- Checks are added for the next assignment, not retroactively for one already graded.
- The four-criterion rubric formerly on `site/assignments.qmd` is retired; the site states the light policy instead.

## Check kinds

| Kind | What it does | Runs in |
|---|---|---|
| `files` | Required files present with exact, case-sensitive names | Python |
| `static` | Pattern or structure checks on the code text (`grading_utils.extract_code_text`), e.g. live-script footer, title, equation, number of text and code blocks | Python |
| `runs` | The script runs without error in a clean workspace, with optional preset variables | MATLAB |
| `value` | A workspace scalar is within a relative tolerance of a reference value; a named variable if given, otherwise any numeric scalar | MATLAB |
% CLAUDE: Add the capability to test an interface.  The tests specify inputs and the testing verifies outputs.   Unit tests.

Each check has: `id`, `file` (or `all`), `kind`, `graded` (yes/no), its parameters, a `pass` message and a `fail` message. Messages are short, specific and encouraging; a fail message says what to try, not just what is wrong.

## Feedback format (comments.txt)

```
Grade: 100/100
Required: all files submitted with the exact names, and every script runs from a clean workspace.

Suggestions:
- pennywithair.m: add at least one equation to a text block (Insert > Equation).
- aquarium.m: alternate text and code blocks to walk through each step of the solution.

Nice work: penny.m and aquarium.m match the reference values.
```

At most five suggestions, in file order. When nothing fails, a single positive line.

## Per-assignment checklist

1. Spec: draft `grading/aNN/spec.md` (checks table, grade rule, messages, changelog) and `grading/aNN/checks.yaml` (the same checks, machine-readable). Author reviews; iterate until agreed.
2. Dry run: `python3 grading/grade.py aNN --reference` runs the checks on the reference solution and on `grading/aNN/fixtures/`. Every reference check passes; each fixture trips only its intended check.
3. Extract: put the Sakai zip in `grading/`;% CLAUDE: So should it be in the root gradint directory, or in the assignment directory, e.g., a01?
 `python3 grading/grade.py aNN grading/<zip> --dry-run` extracts to `grading/aNN/work/` and writes `report.md` only.
4. Review: author reads `report.md` (pass counts per check, then the failures) and a few generated comments. Fix false positives in the spec or YAML, not by hand-editing comments; rerun.
5. Write and pack: `--write --pack`% CLAUDE: give full command so I don't have to remember
 appends to each `comments.txt`, fills `grades.csv` (preamble and quoting preserved), and builds `work/aNN_graded.zip`. Upload to Sakai.
6. Class summary: AI reads `report.md` and skims submissions to draft `grading/aNN/class_summary.md`: pass rates, common stumbles, good patterns worth showing in class. No names.
7. With students: discuss themes in class; note questions, disagreements and anything the checks missed.
8. Fold back: add a dated changelog line to the assignment spec, and carry lessons forward into the next assignment's spec. Update the status table below and commit (specs, YAML, summary; never `work/`).

## Privacy

Student names appear only in the Sakai download and in `grading/aNN/work/`, both gitignored. Specs, summaries and commit messages use "a student" or counts. Before committing, grep the tracked files for surnames from `grades.csv`.

## Status

| Assignment | Spec | Dry run | Graded | Uploaded | Class summary | Notes |
|---|---|---|---|---|---|---|
| A1 Models and Scripts | 2026-10-05 draft | | | | | first use of this workflow |
| A2 Loops and Vectors | | | | | | |
| A3 Functions and Conditionals | | | | | | |
| A4 Data Types and Zero-Finding | | | | | | |
| A5 First-Order ODEs | | | | | | |
| A6 Matrices and Systems of ODEs | | | | | | |
| A7 Two Dimensions and Optimization | | | | | | |
| A8 Interpolation and Curve Fitting | | | | | | |
| A9 Q-Learning and Blackjack | | | | | | |

# Handoff: grading workflow (2026-10-05)

Pick-up notes for the next session, written at the end of a laptop session. Delete this file once the items below are done.

## Where things stand

- Workflow and SOP: `specs/spec_grading.md`. Spec-driven: each assignment's checks are written in `grading/aNN/spec.md` (human-readable) and `grading/aNN/checks.yaml` (what the tooling reads), iterated with the author, then run with `grading/grade.py` (Python) and `grading/run_checks.m` (MATLAB harness, called via `matlab -batch`).
- A1 (Models and Scripts): spec agreed after two review rounds and one run on real submissions. Checks: F1 file names, R1 runs from a clean workspace (penny, pennywithair, aquarium; not bike_update), V1 penny values (any variable names), V2 aquarium force (5%), S1 aquarium text/code blocks (at least 2 each). Grade 100 if F1 and R1 pass, else 90; no submission leaves the grade blank.
- A1 dry run done: 25 of 27 submitted, 19 at 100, 6 at 90. Reference solution and fixtures pass (`--reference`).
- A1 class materials written (no names): `grading/a01/class_summary.md` and `grading/a01/class_examples.m` (live script of anonymized excerpts; sections 2 and 3 stop with an error on purpose, use Run Section).
- Both repos (`ae2440`, `ae2440-solutions`) are committed and pushed; the A1 solutions are in `ae2440-solutions/w01_modeling_scripts/`.

## Not in git (by design: student names)

The Sakai zip, its extracted folder and `grading/a01/work/` (report, comment previews) are gitignored and stay on the laptop. On the new machine, re-download the A1 zip from Sakai (Assignment 1 → Download All, with grade file, comments and submissions) into `grading/a01/`, then rerun the dry run below; every run re-extracts from the newest zip in that folder, so nothing else needs copying.

## Next steps

1. Setup on the new machine: `python3 -c "import yaml"` (PyYAML) and `matlab` on the PATH (tested with R2026b). The `ae2440-solutions` repo must sit next to this one (`../ae2440-solutions`).
2. `python3 grading/grade.py a01 --reference` should print OK on all five lines.
3. Put the A1 zip in `grading/a01/` and run `python3 grading/grade.py a01 --dry-run`; read `grading/a01/work/report.md` and `comments_preview.md`. Expect the numbers above.
4. `python3 grading/grade.py a01 --write --pack`, then upload `grading/a01/work/a01_graded.zip` to Sakai.
5. After class discussion: add a dated changelog line to `grading/a01/spec.md` and update the status table in `specs/spec_grading.md` (A1 row: dry run, graded, uploaded, class summary).

## Still open from the original plan

- Replace the "Assignment Evaluation Framework" rubric in `site/assignments.qmd` (from line 17) with a short "How assignments are graded" section: full credit for every required file with the exact name, as a live-script `.m` that runs from a clean workspace; everything else in the feedback is advice, not a deduction; common themes are discussed in class. Render and run the site checks before pushing.
- Trim the "Grading Workflow" and "Assignment Grading Setups" sections of `CLAUDE.md` to a pointer to `specs/spec_grading.md` and `grading/aNN/spec.md`; move the A2/A3 narratives there into `grading/a02/spec.md` and `grading/a03/spec.md` as starting drafts.
- Move the superseded scripts `book/w01_modeling_scripts/assign/grade_claude.py`, `grade_cgpt.py` and `assign_testing/check_files.py` to `archive/grading_legacy/`.
- A2 (Loops and Vectors, due Fri 9 Oct): draft its spec and `checks.yaml` following the per-assignment checklist in `specs/spec_grading.md`. The `call` check kind (unit tests of a function interface) is specified in the SOP but not yet implemented in `grade.py`; implement it when the first assignment with functions (A3) needs it.

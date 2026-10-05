# A1 grading spec: Models and Scripts

* Assignment page: `site/weeks/w01_modeling_scripts/assignment.qmd`. 
* Reference solutions: `ae2440-solutions/w01_modeling_scripts/` (`penny_soln.m`, `pennywithair_soln.m`, `bike_update_soln.m`, `aquarium_soln.m`), used for the dry run.
* Machine-readable form: `checks.yaml` in this folder. Workflow: `specs/spec_grading.md`.

Intent: first assignment, so keep it light. Confirm everyone can submit live-script `.m` files with exact names that run, and use a few spot checks to give useful feedback early.

## Grade rule

100 if F1 passes and R1 passes for every file it covers; otherwise 90. All other checks are feedback only.

## Checks

| ID | File | Kind | Graded | Check | Pass message | Fail message |
|---|---|---|---|---|---|---|
| F1 | all | files | yes | `penny.m`, `pennywithair.m`, `bike_update.m`, `aquarium.m` present, exact case | All four files submitted with the exact names. | Missing or misnamed: {missing}. File names are case-sensitive and must match the assignment exactly. |
| R1 | `penny.m`, `pennywithair.m`, `aquarium.m` | runs | yes | Runs without error from a clean workspace (`bike_update.m` is not checked: it needs `m` and `pg` set beforehand) | Every script runs from a clean workspace. | {file} stopped with an error: "{error}". Run `clear` and then your script before submitting to catch this. |
| V1 | penny.m | value | no | Some scalar ≈ 8.81 s and some scalar ≈ 86.5 m/s, within 1% (any variable names) | penny.m matches the reference values. | penny.m: expected a fall time of about 8.81 s and an impact speed of about 86.5 m/s. Check the formula and the value of g. |
| V2 | aquarium.m | value | no | Some scalar ≈ 154.5 kN (154 508 N) with `a = 2`, `b = 3`, within 5% | aquarium.m matches the given solution. | aquarium.m: the resultant force should be about 154.5 kN for a = 2 m, b = 3 m.  |
| S1 | aquarium.m | static | no | Text and code alternate, at least 2 of each | | aquarium.m: alternate text and code blocks so each step of the solution is explained next to its calculation. |

Reference values (g = 9.81 m/s², h = 381 m): penny t = 8.8134 s, v = 86.459 m/s; aquarium F = ρ g w b (a + b/2) = 154 507.5 N.

## Decisions

- V1 accepts any variable names. The first draft required `t` and `v`, but on the first run all six V1 failures were correct values under other names (`time`, `velocity`, `v_impact`, ...).
- If a script fails R1, its value checks are reported as "not checked" rather than failed.

## Changelog

- 2026-10-05: first draft.
- 2026-10-05: author review: cut to five checks (dropped live-script format, pennywithair value and structure, bike conservation); R1 skips `bike_update.m`; V2 tolerance 5%; IDs renumbered; reference solutions moved to `ae2440-solutions`.
- 2026-10-05: first run (dry run): V1 switched to any variable names after six false failures. Note that 1% also accepts g = 9.8 and g = 10 (author: fine).
- 2026-10-05: author review of the first run: S1 minimum lowered to 2 text and 2 code blocks; plain (non-live) scripts noted in the class summary, not in individual feedback; no submission leaves the grade blank.

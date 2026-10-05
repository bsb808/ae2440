# A1 grading spec: Models and Scripts

* Assignment page: `site/weeks/w01_modeling_scripts/assignment.qmd`. 
* Reference files: `book/w01_modeling_scripts/assign/` (`penny.m`, `bike_update.m`, `aquarium.m`; `pennywithair` exists only as `.mlx` and needs a plain-text `.m` reference). % CLAUDE: I don't see things these files?
* Machine-readable form: `checks.yaml` in this folder. Workflow: `specs/spec_grading.md`.

Intent: first assignment, so keep it light. Confirm everyone can submit live-script `.m` files with exact names that run, and use a few spot checks to give useful feedback early.

## Grade rule

100 if F1 and R1 (below) pass for every file; otherwise 90. All other checks are feedback only.

## Checks

| ID | File | Kind | Graded | Check | Pass message | Fail message |
|---|---|---|---|---|---|---|
| F1 | all | files | yes | `penny.m`, `pennywithair.m`, `bike_update.m`, `aquarium.m` present, exact case | All four files submitted with the exact names. | Missing or misnamed: {missing}. File names are case-sensitive and must match the assignment exactly. |
| R1 | each | runs | yes | Runs without error from a clean workspace; `bike_update.m` gets `m = 10; pg = 2` first | Every script runs from a clean workspace. | {file} stopped with an error: "{error}". Run `clear` and then your script before submitting to catch this. |% CLAUDE: omit bike_update.m because it is not standalone and requires the manual pre-conditions.
| V1 | penny.m | value | no | `t` ≈ 8.81 s and `v` ≈ 86.5 m/s, within 1% | penny.m matches the reference values. | penny.m: expected t ≈ 8.81 s and v ≈ 86.5 m/s; got {found}. Check the formula and the value of g. |
| V3 | aquarium.m | value | no | Some scalar ≈ 154.5 kN (154 508 N) with `a = 2`, `b = 3`, within 5% | aquarium.m matches the given solution. | aquarium.m: the resultant force should be about 154.5 kN for a = 2 m, b = 3 m.  |
| S2 | aquarium.m | static | no | Text and code alternate, at least 3 of each | | aquarium.m: alternate text and code blocks so each step of the solution is explained next to its calculation. |

Reference values (g = 9.81 m/s², h = 381 m): penny t = 8.8134 s, v = 86.459 m/s; pennywithair 1.835 s accelerating + 20.249 s at 18 m/s = 22.084 s; aquarium F = ρ g w b (a + b/2) = 154 507.5 N; bike_update with m = 10, pg = 2 gives m = 9, pg = 3.

## Open questions

- V1 assumes the variable names `t` and `v` from the assignment's example output. If too many students use other names, fall back to "any scalar". % CLAUDE: Okay
- If a script fails R1, its value checks are reported as "not checked" rather than failed.% CLAUDE: okay

## Changelog

- 2026-10-05: first draft.

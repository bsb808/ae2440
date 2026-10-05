# A1 class summary: Models and Scripts (Fall 2026)

Downloaded 2026-10-05. 27 enrolled, 25 submitted (2 no submission, grade left blank). Checks per `grading/a01/spec.md`. No names in this file.

## Results

| | Count |
|---|---|
| Grade 100 | 19 |
| Grade 90 | 6 |
| F1 all four files with exact names | 20 of 25 |
| R1 scripts run from a clean workspace | all but 2 scripts |
| V1 penny.m values (t ≈ 8.81 s, v ≈ 86.5 m/s) | 24 of 24 |
| V2 aquarium.m force (≈ 154.5 kN) | 23 of 23 that ran |
| S1 aquarium.m alternates text and code (≥ 2 each) | 19 of 24 |

## To Discuss

Anonymized excerpts for each point: `grading/a01/class_examples.m`, a live script to step through section by section (sections 2 and 3 stop with an error on purpose).

- File names. Five of the six 90s came from file names (one of those five also had a script that errored): capitalized names (`Penny.m`, `Pennywithair.m`, `Bike_update.m`), a misspelling repeated by two (`pennywithhair.m`), and one missing `aquarium.m` plus a `pennydemo1.m` in place of `penny.m`. 
- Clean workspace. One `aquarium.m` used `a` without defining it, relying on `a` already being in the workspace. One `pennywithair.m` had the printed output line `Total fall time: 22.09 seconds` pasted into the code, which MATLAB then tried to run; the saved output in the file already showed the error. Both would have been caught by `clear` and Run before saving. One `bike_update.m` also had a hand-typed log of each day's results (`Day 1:`, `M=98`, ...) inside the code; R1 does not run `bike_update.m`, so this was not flagged individually.
- Live scripts versus plain scripts. Three files were plain scripts rather than live scripts (two `bike_update.m`, one `pennydemo1.m`), and two `aquarium.m` files were live scripts containing only code and `%` comments, with no text blocks. 
- Variable names. The assignment's example output shows `t` and `v`, but six students chose descriptive names (`time`, `velocity`, `impactSpeed`, `v_impact`, ...). Good habit; nothing to fix.
- g = 9.8 versus 9.81. Twelve used 9.8, seven used 9.81 in `penny.m`. Both are fine; a chance to talk about significant figures and where the 1% tolerance in the checks comes from.

## Good patterns to show

- Units in comments (`% Time [s]`, `(m/s^2)`) in 16 of 24 `penny.m` and 15 of 23 `pennywithair.m`.
- Equations in text blocks in 19 of 23 `pennywithair.m` and 15 of 24 `aquarium.m`.
- Saved outputs: most files (20–22 per exercise) were run before saving, so the output is visible in the submission.

## For the next assignment

- 7 of 25 students start at least one script with `clear`. Fine for scripts; hazard for functions (later).

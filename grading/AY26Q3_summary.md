# AE2440 AY26 Q3 — Assignment Grading Summary

13 students enrolled. All assignments graded as formative (low-stakes) feedback.
Grades based on file presence only: 100 if all required files submitted with correct
filenames, 90 if any missing.

Graded zip files are in `grading/`. Upload the `*_graded.zip` to Sakai.

---

## Assignment 2 — Loops and Vectors
**Downloaded:** 2026-04-10  
**Graded zip:** `Assignment2_LoopsVectors_graded.zip` (in /tmp — not repacked)

| Grade | Count | Students |
|-------|-------|---------|
| 100 | 12 | All except one student |
| 90 | 1 | Student (`Fudge.m` submitted instead of `fudge.m`) |

**Class themes observed:**
- Several students used `input()` to parameterize fudge.m — creative but breaks automated grading
- Common pattern: redundant double-sided conditions in elseif chains (e.g. `>= 1 && <= 3`)
- `lcs_flow.m` generated the most variety: one student solved without a loop using matrix broadcasting; another solved it twice (copy-paste then loop) illustrating the motivation for loops; another used a nested loop and `text()` annotations instead of `legend()`
- One student's `fudge.m` had a logical bug: `total` never accumulated (always reset to 0)
- Another student's `fudge.m` was missing the required per-iteration plot

---

## Assignment 3 — Functions and Conditionals
**Downloaded:** 2026-04-19  
**Graded zip:** `Assignment3_FunctionsConditionals_graded.zip`

| Grade | Count | Students |
|-------|-------|---------|
| 100 | 13 | All students |

**Class themes observed (`beaufort_classify.m`):**
- Most common pattern: redundant double-sided conditions in elseif chains — good class discussion topic
- One student: `disp()` calls inside every branch — classic first-function confusion between returning values and printing output; good example to show in class
- Another student: hardcoded `wind_speed_kts = 25` inside the function overwrote the input argument — function always returned Force 6 regardless of input; illustrates pass-by-value concept
- Another student: function name inside file was `untitled` instead of `beaufort_classify`; no semicolons so all assignments echoed to console
- One student used lookup table arrays + for loop — creative, worth encouraging
- A couple of students extended scale to full Force 12 on their own initiative
- Subtle boundary bug from one student: exactly 40 kts unhandled (fell between `< 40` and `> 40`)
- One student returned `bf_number = "9"` (string) instead of `9` (number) in last branch

---

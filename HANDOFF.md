# Handoff: Week 10 (30 Nov) and Assignment 7

Written 24 Nov 2026 to resume on another machine.

## Done

- Week 10 schedule in `site/index.qmd` revised: Higher-Order ODEs (Mon, Ch 12, `lesson_higher_order_odes.m`), Two Dimensions (Tue, Ch 13, `baseball_statespace3.m`), Anonymous functions as wrappers for rate functions (Wed, `lesson_anonymous.m`, `lesson_anonymous_pendulum.m`), work on Assignment 7 (Thu, due Fri 4 Dec). Optimization (Ch 14) is dropped this quarter and not mentioned. The overview table has one row per day.
- Footnote marks fixed: "last day of classes" moved from the Week 10 row to Week 11; the stray Thanksgiving mark removed from Week 11.
- Assignment 7 renamed "Higher-Order ODEs and Two Dimensions" in `site/weeks/w07_twodim_optimization/assignment.qmd` and `site/assignments.qmd`.
- Assignment 7 Exercise 2, Ballistics Table, added to the assignment page. Adapted from NPS MA2121 Project 3 (.50 BMG, quadratic drag, four-state system). Students wrap `bullet_rate(t, s, dp)` in anonymous functions for drag and no-drag cases, check the no-drag drop against ½gt², and use `find` to build the 500–2500 yd table (drop in inches, time in seconds, energy in joules). Units are scaffolded with one hint paragraph. The 3871 yd record shot is optional.
- Solution: `ae2440-solutions/solutions/w07_twodim_optimization/ballistics_soln.m` (private repo). Runs in MATLAB; matches an independent Python check. Key values: 500 yd → 59.0 in, 0.566 s, 14,121 J; 2500 yd → 2113.0 in, 3.644 s, 5,423 J; no-drag drop at 500 yd 54.3 in (exact).

## Still to do

- Author review of the Exercise 2 text and of `ballistics_soln.m`.
- The "Under construction" callout is still on the Assignment 7 page. Remove it when the assignment is final.
- The pendulum solution in `ae2440-solutions/solutions/w06_matrices_secondorder/pendulum.m` is still a skeleton (rate function body is `% TBD`).
- Grading spec for Assignment 7 (`ae2440-solutions/grading/a07/`) does not exist yet.
- Week 11 overview row labels the Fri 11 Dec assignment "A9" while the Week 11 text says Assignment 8. Pick one.
- The source handout (MA2121 Project 3 PDF) is only in `~/Downloads` on the original machine and is not in either repo.

## Not included in this push

Unrelated work in progress on the original machine was left uncommitted: edits to several lesson files under `book/w03_*`, `book/w05_*`, `book/w06_*`, `site/weeks/w04_datatypes_fzero/files/livescript_format_poor.m`, and the untracked `grading/` folder.

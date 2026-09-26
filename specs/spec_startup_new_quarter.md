# Spec: Tooling and process for setting up a new quarter

This is a regular and recurring task where we need to do a number of things to set up a new quarter. We co-evolve this spec with any tooling and utilities development (spec-anchored: the spec is the source of truth; every decision or lesson learned during execution is written back here in the same commit as the work). The pattern is borrowed from the ME2801 course repo (`introduction-to-feedback-control/specs/spec_startup_new_quarter.md`). The one-time wiki migration has its own spec: [spec_wiki_transition.md](spec_wiki_transition.md).

## How we work

Each task below has Objective, Inputs, Outputs, Owner, Verification, and Status. For each AI-owned task:

1. Claude executes the task and produces the outputs.
2. Review gate using the PMR workflow: baseline commit, proposal applied, `code --diff`, author resolves.
3. Before the "resolved" commit, Claude updates this spec: Status, decisions, and anything next quarter should reuse.
4. Nothing is pushed without the author asking.

Status values: `todo`, `in progress`, `review`, `done`, `deferred`.

---

# Runbook

Background:

- The class is taught in the fall and spring quarters, Monday through Thursday, for 11 weeks of instruction (10 weeks of book content; see `book/`).
- NPS academic calendars: https://nps.edu/web/registrar/calendar. The key dates are the first day of classes, the last day of classes, holidays, and shift days. Finals week can be ignored.
- Each quarter has constraints unique to that quarter (e.g., instructor travel). These are supplied by the author and recorded in the quarter log below.

## 1. Update syllabus in place

- Objective: update the syllabus with the new course days of the week, times, and room.
- Inputs: meeting days/times/room (supplied by author)
- Outputs: [site/syllabus.qmd](../site/syllabus.qmd); [site/_variables.yml](../site/_variables.yml) (`quarter`, `term_start`, `term_end`, `meeting`)
- Owner: AI, author review
- Verification: PMR; skim `index.qmd` and `syllabus.qmd` for stale references (term, dates, links, Sakai site).
- Status: review (AY27Q1). `meeting` still holds the Spring 2026 value until the author confirms.

## 2. Start new schedule

- Objective: new schedule page for the quarter. At the start of the quarter it holds a complete overview table (dates, topic, due items, holiday and shift-day notes) and full details for the first two weeks; the remaining weeks are placeholders (see task 2a).
- Inputs: previous offering as a template; NPS calendar key dates; quarter constraints.
- Outputs: [site/schedule.qmd](../site/schedule.qmd) for the new quarter; previous schedule kept under `site/archive/<quarter>/schedule.qmd` with a note at the top saying it is archived and just for reference.
- Owner: AI initiates with constraints, author review
- Verification: `python3 utils/check_schedule_dates.py` passes (every week row and heading is a Monday exactly N−1 weeks after `term_start`, and every "Ddd DD Mon" mention on the page has the right weekday); PMR.
- Status: review (AY27Q1)
- Notes:
  - Page layout: overview table (Week, Starts, Topic, Due) with a symbol per holiday or shift day and a note under the table saying which class days are affected; then one section per week with bold day labels and bullet lists.
  - Placeholder week sections carry a "Details will be posted by <Monday two weeks before>" note, the holiday and shift-day impacts, and the week's due items.
  - Reading pair: each chapter reading is one line, `Before class: Read Chapter N, Title: [PDF](weeks/wNN_topic/files/<name>.pdf)`. When the live-script experiment starts, add ` · [Live script](weeks/wNN_topic/files/<name>.mlx)` to the same line. Nothing else changes.

## 2a. Post week details (rolling, during the quarter)

- Objective: stay at least 1–2 weeks ahead of the calendar by replacing one placeholder week at a time with full details.
- Trigger: author says "post week N".
- Inputs: the archived previous-quarter schedule (baseline) or, for Fall 2026, the wiki extract `../tmp/wiki_extract/schedule_26_3.md`; the week mapping in the quarter log; the overview table's due items; any notes for that week in the quarter log.
- Steps:
  1. Copy the mapped section(s) from the baseline; fix link prefixes; update dates, due items, holiday and shift-day notes; apply the week's notes.
  2. Reading pair: `cd book && make wNN` to rebuild the week's chapter PDFs, copy them into `site/weeks/wNN_topic/files/` (same basename as the `.tex`), and write the reading lines. Once the live-script experiment starts, also copy the chapter `.mlx` files.
  3. Lesson files are linked to `book/` on GitHub with `{{< var repo_blob >}}`; slides and other files not in `book/` are copied into the week's `files/`.
  4. Add the week's row(s) to the chapter table in `site/resources/textbook.qmd`.
  5. Open the diff for the author to tune.
- Outputs: updated week section in [site/schedule.qmd](../site/schedule.qmd); the Due column and the week section must agree.
- Owner: AI drafts, author tunes and resolves
- Verification: PMR; `utils/check_schedule_dates.py`; `quarto render` clean.
- Status: weeks 1–2 posted (AY27Q1); weeks 4–11 to post.

## 3. Assignments

- Objective: start a new assignments index based on the most recent one, with the first assignment page live; the rest are posted as the quarter progresses.
- Outputs: [site/assignments.qmd](../site/assignments.qmd) (index plus the evaluation framework); one page per assignment at `site/weeks/wNN_topic/assignment.qmd`; previous index kept under `site/archive/<quarter>/assignments.qmd`, noted as archived.
- Steps for "post assignment N": migrate or update `site/weeks/wNN_topic/assignment.qmd`; link student files in `book/wNN_topic/assign/` on GitHub (move any student file that only exists in `ae2440-solutions` into `book/` first, verifying it contains no solution code); turn the index row into a link.
- Owner: AI, author review
- Verification: grep for links to the archived page from current pages returns nothing; PMR.
- Status: index done, Assignment 1 posted (AY27Q1); Assignments 2–9 to post.

## 4. Class info (human tasks)

- [ ] Verify class meeting days, times, and room in Python; add the class meetings to Outlook; update `meeting` in `site/_variables.yml`.
- [ ] Pull roster from Python, put a copy in OneDrive.
- [ ] Request the new Sakai site; update the Sakai link on `site/index.qmd`.
- [ ] Update the Initial Class Survey form if needed (the link is reused every quarter).

## 5. Publish

- [ ] Optional: tag the end of the previous quarter: `git tag site-YYYY-season && git push --tags`
- [ ] Skim `site/weeks/wNN_*/` pages for stale per-quarter content (dates, due dates in prose).
- [ ] Local preview: `quarto preview site` from the repo root.
- [ ] `du -sh site/` (flag any single file over 20 MB).
- [ ] Push and verify the published site after the GitHub Action runs: https://bsb808.github.io/ae2440/

---

# Quarter log

## AY27Q1 — Fall 2026

Key dates (NPS AY2027 academic calendar, same as recorded for ME2801):

| Date | Event |
|---|---|
| Mon 28 Sep 2026 | Instruction begins |
| Mon 12 Oct | Columbus Day (holiday) |
| Tue 20 Oct | Shift day: treat as Friday class schedule |
| Wed 11 Nov | Veterans Day (holiday) |
| Thu 26 Nov | Thanksgiving (holiday) |
| Tue 8 Dec | Pre-graduation awards ceremony |
| Fri 11 Dec | Last day of classes |

Constraints:

- No class the week of 12–16 October (instructor travel), in addition to Columbus Day.
- Meeting days, time and room not yet confirmed; `_variables.yml` carries the Spring 2026 value (M–R, 0900–0950, WA-147) as a placeholder.
- The site launched this quarter (wiki migration); only the Spring 2026 schedule and Assignments 1–8 exist as sources. Weeks 10–11 (reinforcement learning) have no wiki source and are written from `book/w09_rl_intro` and `book/w10_rl_blackjack`.

Decisions:

- `_variables.yml` set to Fall 2026 (`term_start` 2026-09-28, `term_end` 2026-12-11).
- Assignments due Fridays 1700. Assignment 8 slides one week (due Fri 4 Dec) because of Thanksgiving week; Assignment 9 (blackjack) due the last day of classes. Both to confirm when the weeks are posted.
- Week mapping (Fall 2026 ← Spring 2026 wiki schedule, `../tmp/wiki_extract/schedule_26_3.md`):

  | Fall week | Topic | Spring source | Book |
  |---|---|---|---|
  | 1 | Modeling and Simulation; Scripts | 1 | w01 |
  | 2 | Loops; Vectors | 2 | w02 |
  | 3 | No class | — | — |
  | 4 | Functions; Conditionals | 3 | w03 |
  | 5 | Data Types; Function Handles and Zero-Finding | 4 | w04 |
  | 6 | Functions of Vectors; ODEs | 5 | w05 |
  | 7 | Matrices and Systems of ODEs; Second-Order Systems | 6 | w06 |
  | 8 | Two Dimensions; Optimization | 7 + 8 | w07 |
  | 9 | Interpolation, Curve Fitting and Regression | 10 | w08 |
  | 10 | Introduction to Reinforcement Learning | — | w09 |
  | 11 | Q-Learning and Blackjack | — | w10 |

- Notes for posting:
  - Week 4: the shift day removes Tuesday; the two lesson days (functions, conditionals) fall on Mon and Wed.
  - Week 8: Spring weeks 7 and 8 together held only three lesson days (anonymous functions, pendulum, optimization intro, stress-strain partial solution), so they merge into one week.
  - Week 9: Thanksgiving Thursday; consider whether A8 can still be due Fri 4 Dec or should move.
  - Weeks 10–11: new material; `optimal_stressstrain_partialsoln.m` (week 8) and the Assignment 8 student files must be moved from `ae2440-solutions` into `book/` before those pages link them (see the wiki inventory).

# Spec: Wiki transition (one-time)

Companion to [spec_startup_new_quarter.md](spec_startup_new_quarter.md), which holds the recurring quarter runbook. This spec covers only the one-time move of course content from the NPS Confluence wiki to the Quarto site under [site/](../site/). It follows the same working loop (tasks with Objective, Inputs, Outputs, Owner, Verification, Status; PMR review gate; spec updated in the same commit as the work). The pattern is borrowed from the ME2801 course repo (`introduction-to-feedback-control/specs/spec_wiki_transition.md`).

Because the Atlassian wiki is hard to access from Claude, the space was exported on 26 Sep 2026 to the umbrella directory, outside this repo:

- `../tmp/refs/AE2440-260926-1233-28.pdf` — PDF export (107 pages)
- `../tmp/refs/AE2440/` — HTML export: 54 page files plus 654 attachments under `attachments/<pageId>/<attachId>.<ext>`

Objective: transition the content from the wiki to this site, cleaning up as we go.

Decisions:

- Only the most recent offering (Spring 2026, AY26Q3, "26-3") transitions. The 25-1, 25-3 and 26-1 assignment archives and schedules are dropped; the RL/blackjack assignments from 26-1 are not carried over (weeks 9–10 of Fall 2026 are placeholders to be written from `book/w09_rl_intro` and `book/w10_rl_blackjack`).
- No solutions on the site. The wiki Solutions page ("Coming soon" body, 57 attachments of old solution files) and "Copy of Solutions 25-1" are dropped. Solutions live in the private `ae2440-solutions` repo and reach students via Sakai.
- One page per assignment: `site/weeks/wNN_topic/assignment.qmd`, using the `book/wNN_topic` week names. `site/assignments.qmd` is the index and carries the Assignment Evaluation Framework.
- Files that already exist in `book/` (lesson scripts, student assignment files, datasets) are linked on GitHub with `{{< var repo_blob >}}/book/...`, never copied. Nearly every lesson file on the 26-3 schedule is already in `book/`; the only copies are slide PDFs, the textbook PDF, and screenshots.
- Static files are committed directly under `site/` (`site/weeks/wNN_topic/files/`, `site/resources/files/`). Kept files total about 10 MB. Guardrails: filenames stay stable (no quarter suffixes), `du -sh site` is part of publishing, flag any single file over 20 MB.
- Chapter PDFs are gitignored in `book/`. The week's chapter PDFs are built with `make wNN` and copied into `site/weeks/wNN_topic/files/` when the week is posted (the "reading pair" convention, see the quarter runbook). Later a CI build can replace the copy.
- Rasterized equations on the wiki (`equation*.png`, `latex2png.com`) are re-authored as LaTeX. Sources: `book/wNN_topic/chapter/*.tex`, `book/wNN_topic/refs/*.tex`, and the `%[text]` lines of `book/*/assign/*.m` (double-backslashed and `\_`-escaped there; un-escape when copying).
- Hot-linked external images are localized only when the licence allows; otherwise they become links. Sakai and SharePoint links stay as links. The Confluence "Attachments" footers are dropped.
- The site is a GitHub Pages project site under `/ae2440/`, so every link is relative.

Context-window management: never read raw wiki HTML or list `attachments/` unbounded. Use the extractor, which writes a compact Markdown extract and a link inventory per page to `../tmp/wiki_extract/`. Copy attachments only from the committed manifest.

## 1. Extractor tooling

- Objective: turn a wiki page into a compact Markdown extract plus a link inventory, and copy approved attachments.
- Inputs: `../tmp/refs/AE2440/<page>.html`
- Outputs: [utils/wiki_migrate/extract.py](../utils/wiki_migrate/extract.py); `../tmp/wiki_extract/<slug>.md`, `<slug>.links.tsv`; [utils/wiki_migrate/manifest_ay26q3.tsv](../utils/wiki_migrate/manifest_ay26q3.tsv)
- Owner: AI
- Verification: `extract.py index` lists 54 pages with clean titles; the Schedule (26-3) extract matches the PDF export.
- Status: done
- Notes:
  - Adapted from the ME2801 extractor: export and output paths point at the umbrella directory (the parent of this repo), title prefix `AE2440:` stripped, `RESTRICTED` flags `_soln`/`solution` filenames, and hot-linked external images are listed as kind `image-external` instead of being dropped.
  - `./extract.py extract <ids>` was run on the 14 kept pages only (never `--all` into context). The 48 KB schedule page becomes a 5 KB extract.
  - 26-3 assignment pages embed images owned by older page ids (Confluence copy-page semantics), so the manifest is built from the links TSV `local_path`, never from a page's own attachment directory.
  - `./extract.py copy manifest_ay26q3.tsv` copies the approved files (7 rows: 3 slide PDFs, textbook PDF, 3 Assignment 1 screenshots).

## 2. Transition inventory

- Objective: decide what transitions and what does not, before anything moves.
- Inputs: task 1 extracts
- Outputs: [specs/wiki_transition_inventory.md](wiki_transition_inventory.md)
- Owner: AI proposes, author reviews
- Verification: author review (PMR) before any migration.
- Status: review

## 3. Migrate pages

- Objective: rebuild kept pages as `.qmd`, cleaning as we go.
- Groups (one PMR each): (a) home, syllabus, resources (textbook, installing MATLAB, MATLAB resources); (b) Fall 2026 schedule, assignments index, evaluation framework; (c) Assignment 1; (d) Assignments 2–8; (e) archived Spring 2026 schedule and assignments under `site/archive/ay26q3/`.
- Owner: AI
- Verification: `quarto render` clean; no `wiki.nps.edu`, `latex2png` or squarespace links in `site/`; no `_soln` files in `site/`; author checks content in `quarto preview`.
- Status: in progress
- Notes:
  - Groups (a), (b), (c): drafted 26 Sep 2026, awaiting author review.
  - Groups (d) and (e) are deferred until after week 1 and Assignment 1 are live. The per-page notes are in the inventory.
  - Don't run `quarto render` while `quarto preview` is running; the two collide on the Sass cache.

## 4. Author follow-ups (human tasks)

- [ ] Make `bsb808/ae2440` public (GitHub Pages needs it on a personal plan). `moss/` was removed first because it carried a personal MOSS user ID; student names were scrubbed earlier (commit `94678d4`).
- [ ] After the first Action run creates `gh-pages`: Settings → Pages → Source: Deploy from a branch → `gh-pages` / root. If the Action fails before the branch exists, run `cd site && quarto publish gh-pages` once locally.
- [ ] Replace the "coming soon" Sakai link on the home page with the Fall 2026 Sakai site URL.
- [ ] Confirm the Fall 2026 meeting days, time and room; update `meeting` in `site/_variables.yml`.
- [ ] Decide whether the Assignment 1 aquarium figure stays hot-linked from engineeringstatics.org (CC BY-NC-SA 4.0) or is redrawn.

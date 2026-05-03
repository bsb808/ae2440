# ODE History Aside — Session Handoff

Working document for the historical narrative used as a lecture aside alongside `lesson_ode_intro.m`. Theme: the history of solving differential equations is intertwined with the history of computing. "First came the problem, then the solver."

This file captures everything generated in the session so it can be picked up on another machine.

---

## Session status (as of 2026-04-19)

**Lesson revisions completed (committed to working tree):**
- `lessons/lesson_datatype.m` — rewritten around what assign4 actually needs (NaN/Inf, logical masks, fprintf, structs); added intro overview table covering double/string/char/logical/struct, plus a 1-D arrays section with cell-array aside
- `lessons/lesson_fhandles_fzero.m` — replaced Chebyshev polynomial with Newton's Law of Cooling (ties to assign5 coffee); cut the `integral` detour and `applyToRange` abstract example; added solver-pattern table
- `lessons/lesson_ode_intro.m` — unified Part 1/Part 2, replaced Boyce ODE with Newton's Law of Cooling throughout, dropped commented-out convergence code and `boyce_viz` adaptive-step visualization
- `assign5/ballistic.m` — student template created from `ballistic_soln.m`

**Historical narrative status:** All 10 points drafted. Slide text complete for points 1, 2, 4, 5, 6, 7, 9, 10, plus the "Why Differential Equations Invented the Computer" BLUF/closing slide. Point 3 (Runge–Kutta) was never developed. Point 8 (Lorenz) was skipped at user request.

**Last work:** Researched historical quotes from previous computing transitions (FORTRAN reception, slide rule → calculator, Dijkstra goto, calculator-in-classroom protests) for use as an "in hindsight" framing alongside the ML/AI point.

---

## Historical narrative — the 10-point arc

### 1. The Calculus Wars (1660s–1700s) — Newton & Leibniz

**Slide text (final, used by user):**

> Newton & Leibniz — Why Calculus?
>
> Newton needed to explain why planets move in ellipses — Kepler had described the orbits but not the cause. Required a way to reason about instantaneous velocity and acceleration.
>
> Leibniz approached the same problem from geometry.
>
> Both arrived at the same insight: physical laws are naturally statements about rates of change. Writing F = ma as a differential equation and solving it is the direct line from their work to every numerical solver in use today.

**Images:**
- [Newton portraits — Wikimedia Commons](https://commons.wikimedia.org/wiki/Category:Portrait_paintings_of_Isaac_Newton) (Kneller 1689)
- [Leibniz portraits — Wikimedia Commons](https://commons.wikimedia.org/wiki/Category:Portraits_of_Gottfried_Wilhelm_Leibniz) (Francke)
- [Newton's Principia manuscript page (Royal Society)](https://commons.wikimedia.org/wiki/File:Royal_Society_-_Isaac_Newton%E2%80%99s_Philosophiae_Naturalis_Principia_Mathematica_manuscript_1.jpg)
- [Principia 1713 printed edition](https://commons.wikimedia.org/wiki/File:Principia_Mathematica_1713.JPG)

---

### 2. The 18th-Century Analysts — Euler, Laplace, Fourier

**Slide text:**

> The 18th-Century Analysts — Problem First, Solver Second
>
> Mechanics was generating ODEs faster than anyone could solve them. Three analysts, three problems, three tools that are still in use today.
>
> **Euler (1707–1783)**
> Problem: pendulums, fluid flow, celestial perturbations — equations with no closed-form solution.
> Answer: if you can't solve it exactly, step forward numerically.
> *Euler's method (1768) — written blind, dictated to a secretary.*
>
> **Laplace (1749–1827)**
> Problem: Newton solved two bodies cleanly. The real solar system has eight planets all pulling on each other. Is it stable?
> Answer: convert the differential equation into an algebraic one.
> *The Laplace transform makes whole classes of ODEs suddenly tractable.*
>
> **Fourier (1768–1830)**
> Problem: Napoleon wants to know how heat moves through cannon barrels and fortification walls.
> Answer: represent any function as an infinite sum of sines and cosines.
> *Paper rejected by Lagrange and Laplace as insufficiently rigorous. Published anyway, 1822.*
>
> Every JPEG you have ever seen is Fourier's idea.

**Notes from discussion:**
- Euler's blindness: lost right eye in his 30s, almost completely blind in left eye around 1766 (age 59). Roughly half of his lifetime output produced after going blind.
- Could not find good historical images of ODEs being solved by hand from this era — observatory logbooks and Euler's notebooks exist in archives but aren't well digitized. WWII human computer photos serve a similar visual purpose but belong to a later slide.

**Images (mostly modern; historical hand-computation images proved hard to find):**
- [File:Euler method.svg — Wikimedia](https://commons.wikimedia.org/wiki/File:Euler_method.svg)
- [Category:Heat equation — Wikimedia](https://commons.wikimedia.org/wiki/Category:Heat_equation)
- [Category:Fourier series — Wikimedia](https://commons.wikimedia.org/wiki/Category:Fourier_series)
- [Euler's *Institutiones Calculi Integralis* (1768) — archive.org](https://archive.org/stream/institutionescal020326mbp/institutionescal020326mbp_djvu.txt)

---

### 3. Runge–Kutta (1895–1969) — NOT DEVELOPED

Outline only. From the original draft:

> Carl Runge (1895) and Wilhelm Kutta (1901) develop higher-order step methods independently. The "45" in `ode45` refers to using 4th- and 5th-order RK estimates together — the idea of adaptive step size control comes much later. Erwin Fehlberg (1969) at NASA Marshall introduces the embedded pair trick that makes adaptive stepping practical — the direct ancestor of `ode45`.

---

### 4. Babbage & Lovelace (1830s–1840s)

**Slide text (final, punched-up version):**

> Babbage & Lovelace — The Mechanical Dream
>
> Tables were computed by hand. Tables had errors. Ships navigated by tables. Ships sank.
>
> Checking logarithm tables with John Herschel in 1821:
> *"I wish to God these calculations had been executed by steam."*
>
> **The Difference Engine** — gears and levers grind out table values mechanically. No human arithmetic, no human error. Funded. Redesigned repeatedly. Never finished.
>
> **The Analytical Engine** — memory, processor, conditional branching. A complete general-purpose computer. Also never built.
>
> *Difference Engine No. 2 was built from his original drawings in 1991. It works perfectly. The Analytical Engine has never been built — there's an active project today (Plan 28) to finally do it.*
>
> **Ada Lovelace** — daughter of Byron, raised to be mathematical as a deliberate antidote to her father.
>
> Writes the first machine algorithm at 27. Then states the limit no one else had seen:
>
> *"The Analytical Engine has no power of originating anything. It can only do what we know how to order it to perform."*
>
> First statement of computability. 1843.

**Clarification points covered in conversation:**
- The 1991 build was the *Difference Engine No. 2*, not the Analytical Engine
- The Analytical Engine has never been built; not for physical reasons but due to scale, cost, and incomplete drawings. The [Plan 28 project](https://www.plan28.org) has been working on it since 2010
- Tables Babbage was concerned with were navigational/astronomical, NOT firing tables (those came ~100 years later)

**Images:**
- [Category:Difference Engine No. 2 — Wikimedia](https://commons.wikimedia.org/wiki/Category:Difference_Engine_No._2_(Charles_Babbage)_in_the_Science_Museum,_London)
- [Computer History Museum — A Modern Sequel](https://www.computerhistory.org/babbage/modernsequel/)

---

### 5. Human Computers (1880s–1940s)

**Slide text:**

> Human Computers — The Assembly Line of Arithmetic
>
> Before electronic computers, "computer" was a job title.
>
> Break the calculation into steps. Hire a room full of people. Run them in parallel. Pass results down the line.
>
> **WWII industrializes it.**
>
> Every artillery piece needs firing tables — trajectory at every angle, every wind condition, every atmospheric variation. Each trajectory is an ODE. Each table takes months.
>
> The Army recruits math majors — predominantly women — from universities across the country. Over 100 working simultaneously at the **Moore School of Electrical Engineering, University of Pennsylvania**.
>
> Still not fast enough.
>
> **This is the problem that builds ENIAC.**
>
> *Every trajectory they computed by hand is exactly Euler's method — evaluate the slope, step forward, repeat. The algorithm in `euler.m`. With pencils. For months.*

**Key institution:** Moore School of Electrical Engineering, University of Pennsylvania — bridges all three stages: hand computation, differential analyser, ENIAC.

**Images:**
- [Category:Kathleen Antonelli — Wikimedia](https://commons.wikimedia.org/wiki/Category:Kathleen_Antonelli) — Kay McNulty, Alyse Snyder, Sis Stump at the differential analyser, Moore School circa 1942–45 (the key image)
- [Smithsonian Human Computer Project](https://womenshistory.si.edu/human-computer-project)
- [Category:Ballistic tables — Wikimedia](https://commons.wikimedia.org/wiki/Category:Ballistic_tables)
- [Category:Artillery firing charts — Wikimedia](https://commons.wikimedia.org/wiki/Category:Artillery_firing_charts)

---

### 6. ENIAC and the Bomb (1945)

**Slide text:**

> ENIAC — The First Electronic Computer (1945)
>
> The Army still needed trajectories faster than humans could compute them. New weapons, new theaters, hundreds of table entries per gun.
>
> Human computers couldn't keep up.
>
> **The machine:**
> 50-foot room. 30 tons. 18,000 vacuum tubes. 150 kilowatts.
> *Switching it on dimmed the lights in West Philadelphia.*
>
> **The first real job** isn't firing tables.
>
> Von Neumann redirects it before it's finished: can a hydrogen bomb work? Six weeks of computation. One million punch cards. The answer is yes.
>
> **Programming meant rewiring.**
>
> Patch cables. Physical switches. Reprogramming for a new problem took days.
>
> Six women from the human computing pool were assigned to make it work. No formal training. They learned from the circuit diagrams.
>
> *They were not invited to the celebratory dinner.*
>
> **What it could do:** 5,000 additions per second.
>
> Same algorithm as the women with pencils. Same algorithm as `euler.m`. Just faster.

**Funding/people background:**
- Funded by US Army Ballistic Research Laboratory (BRL), Aberdeen Proving Ground, Maryland
- Contract signed 1943, total cost $500,000
- John Mauchly (concept) and J. Presper Eckert (engineering) at the Moore School
- Herman Goldstine — Army liaison, brought von Neumann in
- Six women programmers: Jean Jennings, Betty Snyder, Frances Bilas, Kay McNulty, Marlyn Wescoff, Ruth Lichterman

**H-bomb formulation discussed:** Coupled ODE system describing hydrodynamics, temperature, thermonuclear reaction rates, and radiation transport in Teller's "Classical Super" design. Run by Nicholas Metropolis and Stan Frankel from Los Alamos. Result: Classical Super probably wouldn't work — confirmed by Ulam, leading to Teller-Ulam design (1951).

**Images:**
- [File:Eniac.jpg — Wikimedia](https://commons.wikimedia.org/wiki/File:Eniac.jpg)
- [Category:ENIAC — Wikimedia](https://commons.wikimedia.org/wiki/Category:ENIAC) — patch panel close-ups make "programming meant rewiring" land visually

---

### 7. FORTRAN (1957)

**Slide text:**

> FORTRAN — Teaching Machines to Read Math (1957)
>
> The problem: the people who needed to solve differential equations weren't programmers. Programmers who understood the hardware couldn't formulate the physics.
>
> Writing a single ballistic trajectory in machine code took weeks.
>
> **John Backus, IBM, 1953:**
>
> *"Let the machine read something close to mathematical notation."*
>
> The received wisdom: no compiler could ever produce code as efficient as a skilled human programmer.
>
> **FORTRAN, 1957.** Formula Translation.
>
> First compiled program runs correctly on the first attempt.
>
> Within a year, more IBM 704 programs are written in FORTRAN than in machine code.
>
> For the first time, a physicist could write:
>
> `Y = Y + DT * F(T, Y)`
>
> Euler's method. In an afternoon. Not a week.
>
> *FORTRAN is still in active use. Weather forecasting, CFD, and nuclear simulations run on FORTRAN codebases maintained since the 1960s. The stopgap language is older than most of the engineers using it.*

**MATLAB-FORTRAN connection (covered in conversation):**
- LAPACK and BLAS — MATLAB's linear algebra core; both originated as FORTRAN libraries
- ode45 — based on Dormand-Prince method; lineage of FORTRAN codes from Sandia and University of Toronto going back to the 1960s
- Shampine & Reichelt 1997 paper translated that accumulated FORTRAN knowledge into MATLAB

**Images:**
- [File:Punch card Fortran Uni Stuttgart (6).jpg](https://commons.wikimedia.org/wiki/File:Punch_card_Fortran_Uni_Stuttgart_(6).jpg) — actual FORTRAN punch card with code printed on top
- [Category:Fortran punch cards — Wikimedia](https://commons.wikimedia.org/wiki/Category:Fortran_punch_cards)
- [File:IBM card punch 029.JPG — Wikimedia](https://commons.wikimedia.org/wiki/File:IBM_card_punch_029.JPG)

---

### 8. Lorenz and the Butterfly (1961) — SKIPPED

User skipped this point. Narrative was developed; no slide text was created. From the draft:

> Edward Lorenz at MIT, running atmospheric simulation on a Royal McBee LGP-30, restarts mid-run from a printout (3 decimal places) instead of memory (6 decimal places). Difference of 0.000127 produces a totally different weather pattern. Publishes 1963: "Does the flap of a butterfly's wings in Brazil set off a tornado in Texas?"
>
> The connection: ODEs amplify errors. Adaptive step-size control (what `ode45` does) exists partly to manage this.

---

### 9. MATLAB (1984)

**Slide text:**

> MATLAB — Eliminating the Translator (1984)
>
> The problem: FORTRAN libraries were powerful but inaccessible. Numerical analysis courses spent more time on software mechanics than mathematics.
>
> **Cleve Moler, University of New Mexico, 1978:**
>
> Wants his students to use the best linear algebra libraries without writing FORTRAN.
>
> Writes a thin interactive interface over a weekend. Matrices as first-class objects. Libraries one function call away.
>
> Gives it away free on tape.
>
> **1984:** Jack Little rewrites it in C, adds graphics, co-founds MathWorks with Moler.
>
> Same idea as FORTRAN — eliminate the translation layer between the person with the problem and the machine that solves it.
>
> *FORTRAN let physicists stop writing machine code.*
> *MATLAB let engineers stop writing FORTRAN.*
>
> **The ODE solvers aren't even in the original.**
>
> `ode45` is formalized in a 27-page journal article — Shampine & Reichelt, 1997.
>
> The solver you called in Assignment 5 is less than 30 years old.

**Images:**
- [MATLAB History, PC-MATLAB Version 1.0 — Cleve's Corner](https://blogs.mathworks.com/cleve/2018/03/09/matlab-history-pc-matlab-version-1-0/) — MathWorks license, check terms before slide use
- [Cleve Moler — Computer History Museum](http://www.computerhistory.org/fellowawards/hall/cleve-moler/)

---

### 10. Machine Learning and the End of the Translator (2040s)

**Slide text:**

> The Next Abstraction (2045)
>
> 300 years. One pattern.
>
> Every generation inherited a translation problem — between the person with the physics and the machine that could compute it. Every generation solved it by building a higher layer.
>
> *Calculus abstracted geometry.*
> *FORTRAN abstracted machine code.*
> *MATLAB abstracted FORTRAN.*
> *Machine learning abstracts the solver.*
>
> **2031:** The European Centre for Medium-Range Weather Forecasts retires its last hand-coded FORTRAN integrator. The replacement was trained on 80 years of atmospheric data. It was never told Newton's second law.
>
> **2038:** A foundation model trained on declassified WWII firing tables — the ones computed by hand at Penn — proposes a correction to ballistic drag coefficients. The correction is measurable. The paper is accepted.
>
> *The model is listed in the acknowledgements.*
>
> Ada Lovelace, 1843:
>
> *"The Analytical Engine has no power of originating anything. It can only do what we know how to order it to perform."*
>
> **2038: nobody is sure that's still true.**
>
> A naval engineering student in 2045 describes a ship's dynamics in plain language and receives a validated simulation. They don't write a rate function. They don't choose a solver. They don't know what FORTRAN is.
>
> Euler's algorithm is probably still running somewhere. It's just very far down.

**Suggested image prompt** (for DALL-E / Midjourney / etc.):
> A vertical timeline illustration in a clean, minimal style. At the bottom, a quill pen writing mathematical equations on parchment. Above it, a mechanical gear assembly. Above that, rows of women at desks with pencils and paper. Above that, a room-sized computer with glowing vacuum tubes and patch cables. Above that, a terminal with green text on black screen. Above that, a modern laptop. At the very top, a glowing neural network dissolving into abstraction. Each layer connected by a thin vertical line. Muted technical color palette — navy, brass, green, white.

---

## BLUF / Closing slide

**Title:** Why Differential Equations Invented the Computer

**Final text:**

> Modeling — building useful abstractions of real systems — is the core of what engineers do to understand, assess, and design solutions.
>
> Differential equations are how most useful engineering models are expressed.
>
> Computing is built on a 300-year-old idea: approximate the continuous world with discrete, incremental steps.
>
> Its history runs on two parallel tracks:
>
> **Techniques** — faster tools that make bigger models tractable
> *Minutes to nanoseconds. Problems once impossible become routine.*
>
> **Interfaces** — more abstract tools that widen who can build them
> *Pencils → punch cards → assembly → FORTRAN → MATLAB → AI*
> *Each layer removed a prerequisite. The gap between knowing the physics and running the simulation kept closing.*
>
> Every machine on that list was built because someone needed to integrate a differential equation faster.
>
> *Solving ODEs is the killer app for computing — not by coincidence, but by design.*

**Per-machine bullets (final, brief form):**
- Babbage — built a machine to automate the arithmetic
- Penn — 100 women spent the war integrating trajectories by hand
- ENIAC — built for firing tables; first real job was a thermonuclear ODE
- FORTRAN — so scientists could write math instead of assembly; killer app was ODEs
- MATLAB — so engineers could stop writing FORTRAN to solve them
- CUDA (2007) — put thousands of parallel cores in the hands of scientists; the same ODE, solved simultaneously across a million grid points
- Machine learning — the solver learns the physics; the translation layer disappears entirely

---

## Previous-Transition Quotes (research, not yet on a slide)

Premise: every transition between modeling abstractions produced the same three concerns — efficiency, skill loss, identity — and most look strange in hindsight. Useful as an "in hindsight" framing alongside the ML/AI point.

**Machine code → FORTRAN (1954–1957)**

The killer quote, from von Neumann himself when first shown the FORTRAN concept in 1954:

> *"Why would you want more than machine language?"*
> — John von Neumann, recounted by John Backus

Backus's culture description: assembly-language programming was a "priesthood." The FORTRAN project met "considerable hostility and derision" plus "skepticism of this heretical notion that a mechanical process could do all the mysterious, inventive things they did to produce an efficient program."

The technical objection that seemed reasonable at the time: *"computer memories were so small and expensive and execution time so valuable that it was believed necessary for the compiled program to be almost as efficient as that produced by a good assembly language programmer."*

Sources:
- [How John Backus' Fortran Beat the Machine Code 'Priesthood' — The New Stack](https://thenewstack.io/how-john-backus-fortran-beat-machine-codes-priesthood/)
- [Fortran — Wikipedia](https://en.wikipedia.org/wiki/Fortran)

**Slide rule → calculator (1972–1976)**

Most relevant for engineering identity:

> *"Throughout the 1950s and 1960s, the slide rule was the symbol of the engineer's profession in the same way the stethoscope is that of the medical profession."*

Pedagogical concern: slide rules don't track decimal points — students had to estimate magnitude in their head as a sanity check. Calculators eliminated that mental discipline.

Source: [Slide rule — Wikipedia](https://en.wikipedia.org/wiki/Slide_rule)

**FORTRAN/assembly → structured programming (1968–1983)**

Dijkstra's original 1968 letter title was *"A Case Against the Goto Statement"*; CACM editor Niklaus Wirth retitled it *"Go To Statement Considered Harmful."*

Reactionary side, Ed Post's 1983 satire *"Real Programmers Don't Use Pascal"* in Datamation:

> *"Real Programmers use Fortran. Quiche Eaters use Pascal."*
> *"If you can't do it in Fortran, do it in assembly language. If you can't do it in assembly language, it isn't worth doing."*

Sources:
- [Dijkstra: Go To Statement Considered Harmful (1968)](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf)
- [Real Programmers Don't Use Pascal — Wikipedia](https://en.wikipedia.org/wiki/Real_Programmers_Don't_Use_Pascal)

**Mental arithmetic → calculator (1970s–1980s)**

April 1986, Sumter, South Carolina — elementary and secondary teachers picketed against calculator use in schools, signs reading:

> *"Turn them OFF until upper grades."*

A 1997 review of the research found "no detrimental effects on students' arithmetic abilities."

Source: [A Brief History of Calculators in the Classroom](http://hackeducation.com/2015/03/12/calculators)

**The pattern:** Every transition produced the same three concerns, in this order:
1. **Efficiency** — "the new tool can't match what a skilled practitioner does by hand"
2. **Skill** — "users will lose the deep understanding the old tool required"
3. **Identity** — "this isn't real engineering / programming / mathematics anymore"

In every case the efficiency concern was wrong within a few years. The skill concern was partially right but unimportant. The identity concern was real but ephemeral.

---

## Memory state (project memory not in repo)

These memory files exist on the original machine at `~/.claude/projects/-home-bsb-WorkingCopies-ae2440/memory/`. To preserve them across machines, either:
- Copy the directory manually
- Or recreate from the summaries below (Claude on the new machine will rebuild over time as needed)

**Index (`MEMORY.md` entries):**
- [feedback] MLX conversion: use MATLAB's built-in Save As to export .mlx files; do not extend or suggest mlx_parse/mlx2m.py
- [project] mlx_parse/mlx2m.py is an abandoned prototype; mlx_soln2assign.py (student assignment stripper) is the active tooling
- [project] Plain-text .m live scripts require an appendix/metadata footer or MATLAB opens them as plain scripts
- [feedback] .m live script spacing: no blank lines between %[text] and code, no blank line before %%, use trailing ` \` for paragraph breaks
- [feedback] `$$$` in %[text] math lines is valid/intentional — do not flag as a typo; rendering is tricky in plain-text .m format
- [feedback] Slide text: keep it tighter than prose; drop "how it works" detail for verbal delivery
- [project] Assignment 3 grading setup: required files, narrative, focus on beaufort_classify.m
- [feedback] Review workflow: batch all proposed edits into one diff, one commit — not item-by-item
- [project] Course philosophy: concepts of engineering→computation matter; MATLAB syntax/efficiency (e.g. preallocation) are out of scope. "Make it fast" is not taught.

---

## To pick up on the new machine

1. `git pull` — gets the lesson revisions and this file
2. Read this file from top to bottom for full context
3. (Optional) Reconstitute memory by either copying the memory directory from this machine, or letting Claude rebuild memories organically as the conversation continues
4. Likely next steps: develop point 3 (Runge–Kutta) if needed; write a slide for the previous-transitions material; build the closing slide image

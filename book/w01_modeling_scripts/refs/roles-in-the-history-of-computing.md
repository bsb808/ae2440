# Roles in the History of Computing

Working document for an analytical history of computing organized around persistent human roles. The article began as a historical narrative that solving differential equations drove the development of every major computing platform and has grown into a broader argument: across 300 years and every change of substrate, the same roles — problem definer, compiler, manager, debugger, validator — recur, and the question is never *whether* humans are involved but *where* in the system they sit. The 11-point chronological narrative remains the spine; the two analytical sections that follow it (previous-transition quotes; persistent roles, drawing on David A. Mindell's myths of autonomy) carry the article's main contribution.

This file captures everything generated across multiple sessions and machines so the work can be picked up cold from any of them.

---

## Session status (as of 2026-05-03)

**Historical narrative status:** Now an 11-point arc (CUDA added 2026-05-03 as point 10; ML/AI renumbered to point 11). Slide text complete for points 1, 2, 4, 5, 6, 7, 9, 11, plus the "Why Differential Equations Invented the Computer" BLUF/closing slide. Point 3 (Runge–Kutta) was never developed. Point 8 (Lorenz) was skipped at user request. Point 10 (CUDA) has article-only research notes — no slide text yet.

**Last work:** (1) Researched historical quotes from previous computing transitions (FORTRAN reception, slide rule → calculator, Dijkstra goto, calculator-in-classroom protests). (2) Developed the "Persistent Roles" pattern across all eras, organized around two complementary themes: persistent roles around discrete approximation of continuous reality, and Mindell's myths of autonomy. (3) Added CUDA as point 10. (4) Reframed the ML era under a "generalized function approximator" baseline rather than a physics-respecting one.

---

## Historical narrative — the 11-point arc

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

### 8. Lorenz and the Butterfly (1961) — PARKED (not a role-transition)

**Status:** Parked. The Lorenz/butterfly discovery is genuinely important for ODE numerics — sensitive dependence on initial conditions led directly to the modern emphasis on adaptive step-size control and to the statistical understanding of long-range prediction limits. But the contribution is an *insight about the behavior of nonlinear ODE systems*, not a new abstraction layer with a new set of human roles. Lorenz used an existing computer (Royal McBee LGP-30) in an existing way (numerical ODE simulation) and discovered something about what such simulations reveal. The article's role-transition arc has no natural slot for that.

Where Lorenz does substantively connect to this article's themes is the **validation** role: chaos sets a fundamental limit on what validation against ground truth can establish for long-range predictions of nonlinear systems. If we ever want to fold him in, the natural home is as a paragraph inside the validation discussion in the persistent-roles section, not as his own historical point. Otherwise the original draft is preserved below for the record.

**Original draft (preserved):**

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

### 10. CUDA and General-Purpose GPU Computing (2007)

**Article notes (no slide text yet — added 2026-05-03):**

The 2000s problem: graphics processing units were already the most parallel commodity hardware available — hundreds of cores, thousands of simultaneous threads, an order of magnitude more arithmetic throughput than CPUs of the same era. But the only way to access that parallelism was through the graphics pipeline. Scientists who wanted to use a GPU for, say, molecular dynamics, fluid simulation, or matrix algebra had to disguise their problem as a graphics rendering problem — load data into texture memory, write computations as fragment shaders, read results back through framebuffer reads. A handful of research groups did this and called it GPGPU (General-Purpose GPU computing), but the framing penalty was severe: you had to think about your physics problem in graphics terms, and you got back only what the graphics pipeline could be tricked into computing.

NVIDIA released **CUDA** (Compute Unified Device Architecture) in 2007. It exposed the GPU's parallel cores through a C-like language that let scientists write their problem as scientific computation again. The graphics framing dropped away; the parallelism remained.

In the generalized-compiler sense (defined later in this document), CUDA is a textbook example of changing the *domain language* to match the user's natural problem statement. The hardware was the same. What changed was the language available to talk to it. Scientists could now write a kernel that operated on a million data points in parallel, in a language that looked like the C they already knew, with the toolchain handling the decomposition into tens of thousands of simultaneous GPU threads.

**Roles around CUDA:**
- **Problem definition.** Domain scientist (computational chemist, climate modeler, financial quant, deep-learning researcher) formulates the problem in their own terms.
- **Decomposition (compiler).** `nvcc` plus a stack of NVIDIA-maintained libraries — cuBLAS (linear algebra), cuFFT (Fourier transforms), cuDNN (neural network primitives), Thrust (parallel algorithms). The libraries embed decisions made by parallel-computing specialists about how best to map specific computations onto the GPU's memory hierarchy.
- **Management.** For a single researcher, often the same engineer. Production systems (weather services, autonomous vehicle stacks, large model training) involve teams managing GPU clusters, schedulers, memory budgets.
- **Debugging.** `nsight`, `cuda-gdb`, profilers — but the standard practice is to compare GPU results against a serial CPU reference implementation. The serial reference acts as ground truth that the parallel version is validated against.
- **Validation.** Engineer compares against the serial reference and against physical sanity checks.

**The historical irony.** CUDA was invented to accelerate explicit physical simulation — molecular dynamics, fluid dynamics, computational chemistry. Its dominant use today is training neural networks, which then *replace* explicit physical simulation with learned function approximation. CUDA enabled both the continuation of the old paradigm (faster, bigger physics simulation) and the rise of the paradigm that supersedes it. The ECMWF weather-forecast scenario in point 11 below is only possible because there were enough GPU-years available to train such a model — which is only true because CUDA let GPUs be sold to scientists in volumes that drove the price down.

**Sources / further reading:**
- [CUDA — Wikipedia](https://en.wikipedia.org/wiki/CUDA)
- Sanders & Kandrot, *CUDA by Example* (Addison-Wesley, 2010) — introductory text, captures the early GPGPU mindset shift
- [NVIDIA CUDA Toolkit Documentation](https://docs.nvidia.com/cuda/)

**Suggested image:** GPU die photo or a CUDA grid-of-blocks-of-threads diagram (ubiquitous in CUDA documentation; check NVIDIA usage terms before slide use).

---

### 11. Machine Learning and the End of the Translator (2040s)

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

Premise: every transition between modeling abstractions produced a recognizable family of concerns. Some recur identically at every transition (efficiency, skill, identity); others emerge only as the new layer becomes opaque or apparently autonomous (loss of control, pedagogical). The synthesis at the end of this section develops the stable/emerging distinction; the quotes below are the evidence for it.

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

**The pattern of concerns: stable and emerging.** Read as a group, the quotes above show two kinds of concerns — those that recur identically at every transition, and those whose prominence depends on properties of the new layer.

**Stable concerns (universal across every transition examined).**

1. **Efficiency** — "the new tool can't match what a skilled practitioner does by hand." *Wrong within a few years in every case.* Compiled code beat hand-tuned assembly. Calculators tracked decimal points in practice. The empirical refutation arrived quickly.
2. **Skill degradation** — "users will lose the deep understanding the old tool required." *Partially right but rarely catastrophic.* Skills do shift — modern engineers don't track decimal points the way slide-rule users did; modern programmers don't think about register allocation the way assembly programmers did. But the abstractions the new tools enable support new kinds of reasoning that compensate.
3. **Identity / displacement** — "this isn't real engineering / programming / mathematics anymore." *Real but ephemeral.* The professional identity built around the old tool genuinely loses status; new identities form within a generation around the new tool. The "Real Programmers" satire was already nostalgic in 1983.

**Emerging concerns (correlated with properties of the new layer; not universal).**

4. **Loss of control / autonomy anxiety** — "the new tool is too automated; we don't know what it's doing." *Nearly absent at the FORTRAN, MATLAB, and CUDA transitions.* Grows with two properties of the new layer: *opacity* (can't read what it's doing internally) and *apparent agency* (behaves as if it has its own decisions). Becomes prominent at the cloud-computing transition (institutional control over data and compute) and dominant at the ML transition (algorithmic opacity plus apparent agency). Partly real — it tracks the validation-gap pattern documented in the persistent-roles section below. Partly the autonomy myth Mindell describes — fear keyed to a perception of autonomy that exceeds what the system actually does without human direction.
5. **Pedagogical** — "how do we teach the underlying concepts once the tool hides them?" *Present at every transition but transforms with each layer; intensifies as the abstraction gap grows.* Slide-rule advocates worried about decimal-point estimation. Assembly advocates worried about register-level understanding. Calculator critics worried about arithmetic facility. ML critics worry about whether engineering reasoning is even teachable when an answer is generated on demand. The root concern is consistent — hands-on engagement with the underlying mechanism is what builds intuition — but the specific content at risk changes with each transition. Especially salient for course design.

**Why the distinction matters.** Treating all five as coequal universal concerns flattens the picture. The stable concerns admit the same response at every transition: the new tool is good enough; users adapt; new identities form. The emerging concerns do not. They track real properties of specific tools. Loss-of-control fear isn't a category error in the ML era the way it would have been in the FORTRAN era — there really is less inspection available, and validation really is doing more of the work. Pedagogical concern about ML isn't the same as pedagogical concern about calculators — the abstraction gap is larger and what hands-on engagement teaches is genuinely different.

This framework offers a way to engage with the loss-of-control discourse around modern AI without either dismissing it ("it's just the same recurring fear") or capitulating to it ("this time everything is different"). Both partial truths apply, in proportions that the stable/emerging split lets you reason about.

---

## The Persistent Roles — A Pattern Across Eras

The "previous transitions" framing above focused on what each generation feared losing. This section identifies two complementary themes about what *didn't* change.

### Two complementary themes

**Theme 1 — Persistent roles around producing a discrete, computable approximation of analog reality.**

The fundamental engineering process has been invariant for 300 years: take a continuous, analog phenomenon you want to understand or design → produce a discrete, executable approximation → run it forward → interpret the result back into the analog domain. Newton's calculus is the symbolic version of this move. Euler's method is the first explicit numerical discretization. Tables of logarithms are precomputed discrete approximations of continuous functions. The substrate that runs the discrete approximation has changed dramatically — from human arithmetic to vacuum tubes to silicon to GPUs to neural networks — but the *function being performed* (discrete approximation of continuous reality) is the same.

Around this fundamental process, the same roles recur in every era: a problem definer who states what is to be modeled; a *compiler* (in the broad sense defined below) that decomposes the problem for the substrate; a manager who organizes the work; a debugger who catches errors; a validator who confirms the answer matches reality. The roles persist; their occupants migrate.

**Theme 2 — Mindell's myths of autonomy.**

David A. Mindell's *Our Robots, Ourselves: Robotics and the Myths of Autonomy* (Viking, 2015) argues that "full autonomy" is a recurring myth — and that real-world automated systems all involve humans deeply, just in different positions in the loop. Mindell identifies three myths: linear progression (the assumption that systems advance from manual → remote → autonomous in a straight line), replacement (the assumption that autonomy displaces humans), and full autonomy as the end state. His preferred framing is *situated autonomy* — autonomy is meaningful only in context, with specific human and institutional supports. The Apollo lunar landing wasn't autonomous; Armstrong took manual control in the final descent (see Mindell, *Digital Apollo*, MIT Press, 2008). The Predator drone isn't autonomous; it has a pilot in Nevada, a sensor operator, and an intelligence chain. Surgical robots aren't autonomous; the surgeon is using a finer-resolution tool.

Mindell's framework applies directly to the history of computation. In every era, humans never leave the loop; they migrate to different positions in it. Each "this time the machine does it without us" claim turns out to mean "this time the humans are doing different things, earlier or later in the pipeline." The right question is never "are humans involved?" but "where in the system are the humans now?"

**How the themes interact.** Theme 1 names the *structural* invariant — what jobs always need to be done. Theme 2 names the *rhetorical* invariant — that the autonomy claim is always overclaimed in the same way. Together: the roles are persistent → autonomy claims are always exaggerated → every "this time humans aren't needed" claim is a category error. The right question becomes one of *placement* (where in the pipeline are the humans?), not *presence* (are humans here at all?).

The remainder of this section presents the evidence for both themes: a generalized definition of the "compiler" role, a detailed look at the human-computer era (where every role is staffed by a different person and the structure is unusually visible), a mapping table across the electronic eras, a reframed treatment of the ML era, and two further patterns that fall out of the historical record.

### What is a "compiler" in the general sense?

A compiler — in the broadest sense, not the software meaning — is the function that translates a problem stated in the language natural to its domain (an integral, a differential equation, an engineering specification) into a sequence of operations the executing substrate can actually perform.

This function has always existed. It has not always been a piece of software:

- In the human-computer era, the compiler was a **person** — the "computing director" — who turned a calculus problem into worksheets of additions, multiplications, and table lookups distributable across a room of clerks who knew no calculus.
- On ENIAC, the compiler was a **person plus a patch panel** — the programmer translated math into a wiring diagram.
- After 1957, the compiler became **software** — FORTRAN turned `Y = Y + DT * F(T, Y)` into machine instructions.
- In the MATLAB era, the compiler is **software plus a library of pre-built solvers** — `ode45` is a compiled implementation of decisions a numerical analyst made decades ago.
- In the ML era, the "compiler" arguably collapses into the **trained model itself** — the translation from problem to operations is no longer designed but learned.

The *function* is invariant. The *embodiment* migrates from person to mechanism to software to learned weights. Each migration removes a job category — there are no professional human computers anymore — but the role itself never disappears, because a problem expressed in domain language can never run directly on a substrate. Something always has to bridge.

This is why the compiler is one of the most persistent abstractions in the history of computing: it is a *role*, not a technology, and the role has existed continuously since at least the mid-19th century.

### The Human-Computer Era in Detail (1880s–1940s)

Before electronic computing, the word "computer" was a job title, and the work was organized like a factory. Every role in the modern computing pipeline existed; they were just staffed by separate people, which makes the structure unusually visible.

**Problem definition.** A senior scientist formulated the calculation: an astronomical position to be tabulated, a navigational table to be extended, a ballistic trajectory to be integrated. At the British Nautical Almanac Office, this was the Astronomer Royal's office. At Harvard Observatory, Edward Pickering. At Los Alamos during WWII, von Neumann and the theoretical division.

**Decomposition — the computing director.** A specialist role, distinct from both scientist and clerk, translated the problem into a procedure executable by people who knew arithmetic but no higher mathematics. This person decided: which formula to apply in what order; which intermediate quantities to tabulate; which tables of pre-computed values (logarithms, trig functions) to look up rather than re-derive; how to lay out the worksheet so that two computers could pass partial results between them without confusion.

Notable holders of this role:
- **L. J. Comrie** at the British Nautical Almanac Office (1920s–30s) — pioneered the use of commercial accounting machines for astronomical calculation, and made differencing the standard error-detection method.
- **Gertrude Blanch** at the WPA Mathematical Tables Project (1938–1948) — technical director who designed computation schemes for roughly 450 unemployed clerks during the Depression, producing reference tables used for decades. She has a strong claim to being the most important "compiler" of the pre-electronic era.
- **Wallace Eckert** at Columbia (1930s–40s) — combined human computers with punched-card tabulating machines, producing celestial mechanics tables for the Nautical Almanac.

**Management.** Floor supervisors distributed worksheets, paced the work, fielded questions, tracked completion. At Harvard Observatory, Williamina Fleming managed the women known as "Pickering's computers." At Los Alamos, Dana Mitchell recruited and organized human computer teams. Management was as much about workflow design as about people: how to keep the line moving, how to prevent the slowest worker from gating the result.

**Debugging.** Two structural methods, both designed to catch errors *without trusting any individual computer*:

1. **Duplicate computation.** Critical values were calculated independently by two different computers. Disagreements were flagged and rerun by a third. This is the same idea as triple modular redundancy in modern fault-tolerant computing.
2. **Differencing.** Values in a numerical table should have smooth higher-order differences. Compute the first differences (consecutive subtractions); they should change slowly. Compute the second differences; they should change even more slowly. A kink in the differences betrays an error in the values upstream. Comrie made this the standard final-pass error check at the Nautical Almanac Office.

Note that neither method requires any computer to *understand* the problem. Errors are caught by the *structure* of the work, not by individual insight. This is also true of modern type checking and modern unit tests.

**Validation.** The senior scientist spot-checked results against physical intuition and against limiting cases where the answer was known by other means. This role has never moved off the human side, in any era.

**Reference:** David Alan Grier, *When Computers Were Human* (Princeton, 2005) is the canonical history.

### Mapping the Same Roles Across Later Eras

The detailed narratives for ENIAC, FORTRAN, and MATLAB above can be re-read through this same lens:

| Role | Human computers | ENIAC | FORTRAN | MATLAB | CUDA |
|------|------------------|--------|----------|---------|------|
| Problem definition | Senior scientist | Von Neumann (H-bomb) | Domain physicist | Domain engineer | Domain scientist |
| Decomposition (compiler) | Computing director | Programmer + patch panel | Compiler | Compiler + solver library | nvcc + libraries (cuBLAS, cuDNN) |
| Management | Floor supervisor | Project lead | Software project mgmt | Often the same engineer | Often the same engineer |
| Debugging | Duplicate calc, differencing | Trace the wiring | Print, debugger, tests | Plot and inspect | Profilers + serial reference |
| Validation | Senior scientist | Senior scientist | Senior scientist | Engineer | Engineer (vs serial reference) |

The endpoints have always been human. The middle has been progressively automated. The intermediary roles also consolidate over time — by the MATLAB era, a single engineer often plays scientist + programmer + debugger + validator — but the *roles themselves* still exist; they have just been combined into one person's workload.

### The ML Era — Reframed

The earlier draft of point 10 imagined ML systems trained on physical data and producing physics-respecting predictions. That assumption is too generous. The honest framing — and the more interesting one for thinking about the persistent roles — is that machine learning models are **generalized function approximators**: they learn input-output mappings from whatever data they see, without any built-in commitment to physical law, conservation principles, or the structure of the underlying phenomenon. A model trained on weather data has no concept of mass conservation; it has a statistical regularity that has so far implied mass conservation in the regions it has seen.

Under that framing, what do the persistent roles look like?

**Problem definition.** Still human, but the *content* of the role changes substantially. In prior eras, defining the problem meant writing down a model — an equation expressing a physical or engineering relationship. With a function-approximating ML system, problem definition becomes:
- specifying inputs and outputs;
- specifying training data — where it comes from, what regime it covers, what biases it carries;
- specifying validation criteria — what counts as a correct answer; what error is tolerable; on what regions of input space accuracy actually matters.

The physics-formulation step disappears. The **specification** step expands to fill its place, and arguably becomes harder, because there is no longer a compact mathematical statement to inspect. A senior scientist can argue with an equation; arguing with a training dataset and a validation criterion is a different kind of reasoning.

**Decomposition (the compiler).** This is where the ML era genuinely breaks the historical pattern. In every prior era, the intermediary translated the problem into a sequence of operations *that a knowledgeable human could read and reason about*. A worksheet of additions, a wiring diagram, FORTRAN source, MATLAB code — all of these are inspectable. A trained model's internal representation is not. The compiler role does not disappear; it is replaced by a training process that produces an opaque artifact. There is no longer a chain of operations to audit between problem and answer.

**Management.** Shifts from managing people or code to managing data and training. Curating training sets, version-controlling models, monitoring for distribution shift, deciding when to retrain. The thing being managed is the *learning process*, not the *computation*.

**Debugging.** The hardest role to fill in this era. Without an algorithm to inspect, debugging is purely empirical: does the model produce correct answers in regions where you can check? It can only verify the regions you actually test. The dragon is **out-of-distribution** behavior — the model gives confident outputs in regions where it has no training data, and no underlying law is forcing the answer to be reasonable.

**Validation.** Becomes the bottleneck of the entire pipeline. In every prior era, validation was a sanity check — the calculation was already trusted because the algorithm was inspectable; validation just confirmed nothing went wrong. In the ML era, validation is the *only* thing standing between the user and a confident wrong answer. It expands from a final spot-check into a continuous, structural requirement.

This produces a sharp practical implication: ML systems are most trustworthy where independent verification is cheap (interpolation between known cases, regimes also reachable by simulation, problems where you can sample-check answers against ground truth). They are least trustworthy where verification is itself the original hard problem (extrapolation, novel regimes, design of systems that don't yet exist). That is exactly the regime where engineering modeling has always been the hardest, and where the new tool helps the least.

**The pattern holds — with one substitution.** Humans still define the problem. Humans still validate the answer. The intermediary still exists, but it is no longer a designed compiler producing inspectable operations; it is a trained artifact producing opaque outputs. Validation, the role that has always lived at the human end of the pipeline, becomes proportionally larger because the artifact in the middle can no longer be reasoned about directly.

### Two further patterns the history surfaces

**Each new layer democratizes more than it accelerates.** FORTRAN didn't make assembly programmers faster — it brought in physicists who would otherwise have hired a programmer. MATLAB brought in engineers who would otherwise have hired a numerical analyst. CUDA brought in scientists who would otherwise have hired a parallel-computing specialist. ML potentially brings in domain experts who would otherwise have hired modelers. The historical pattern is that productivity gains from a new layer are mostly about *who can use the tool*, not *how fast existing users go*. Each abstraction primarily expands the *user population* rather than the *throughput per user*. This also explains why each transition met cultural resistance from existing users: the new layer isn't really for them; it is for the people who weren't using the old tool at all. The "previous-transition quotes" section above is largely the voice of users who correctly perceived that the new tool was not addressed to them.

**The validation gap widens with each abstraction.** A computing director could read a worksheet line by line. A FORTRAN programmer can read source. A MATLAB user can plot intermediate quantities. A CUDA programmer can compare against a serial reference implementation. An ML user has only inputs and outputs. As intermediaries become more opaque, validation has to shift from *internal inspection* (read the algorithm, follow the logic) to *external testing against ground truth* (run known cases, compare outputs against an independent source). This trend has been monotonic for 60 years; the ML era is the endpoint where internal inspection is no longer possible at all. The proportionally larger validation burden in the ML era is not because ML is uniquely untrustworthy — it is because the trend that started with FORTRAN finally reached its limit. Validation has had to grow in importance at every step; the ML era is where it becomes the only line of defense.

### Where the Hypothesis Holds and Where it Strains

**Holds strongly.** *Problem definition* and *validation against reality* have never moved off the human side. The form changes (write an ODE / write FORTRAN / curate a training set), but a human always frames what the computation is for and confirms the answer is reasonable.

**Holds with reframing.** The *intermediary* role doesn't disappear — it migrates. Computing director → programmer → compiler → solver library → trained model. Each migration removes a job category but the role keeps existing in some form.

**Genuinely shifts in the ML era.** For the first time, the intermediary is *learned* rather than *designed*. The chain from problem to answer is no longer inspectable. Validation, previously a final check, becomes the central guarantee of correctness because there is nothing else to check. The skill of "specify a problem precisely enough that a function approximator can be trained on it and validated" is genuinely new and does not have a clean analogue in any prior era.

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

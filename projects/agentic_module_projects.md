# AE2440 Agentic AI Capstone — Project Candidates

Two-week end-of-course module. Students use Claude Code to develop MATLAB
solutions to a chosen project, exercising the **investigator** and **verifier**
roles. Every project includes a **verification** path (definitive: "did the
computer implement the model correctly?"). **Validation** ("is it the right
model for reality?") may or may not be tractable — when it isn't, that
limitation should be made explicit and discussed.

## Ranking criteria

Projects are ranked on six dimensions:

1. **Hook** — does the question grab a non-engineering student?
2. **Verifier definitiveness** — can correctness be checked without judgment?
3. **Investigator surface** — how much real choice does the student make?
4. **Navy/career relevance** — does it map to something an officer will see?
5. **Scope fit** — credible 2-week target with room for stretch goals?
6. **Risk** — likelihood of getting stuck on tooling, data access, or hardware.

---

## Rank 1: AIS Spoofing Detector ⭐ Navy-native

**The hook.** AIS (Automatic Identification System) is the public
"transponder" every commercial ship broadcasts — position, course,
speed, identity. It's also routinely *spoofed*: ghost fleets in the
Black Sea (2017), tankers turning off transponders to evade sanctions,
phantom warships generated to embarrass NATO. The Navy and Coast Guard
care a lot about this. Students get to play defender on the same data
feed used in real-world maritime intelligence.

**The project.** Pull AIS records from the public archive at
[MarineCadastre.gov](https://marinecadastre.gov/ais/) (one month, one
coastal region — typically a few million messages). Build a baseline
pipeline that reconstructs per-vessel tracks. Then write a
*spoof-injector* that synthesizes attacks at the message level
(impossible kinematics: 80-knot tanker; teleports: 100 nm jump in
1 minute; identity collisions: two vessels claiming the same MMSI;
GPS-drift simulation; replay attacks). Build a detector that flags
each attack class, score it on a held-out test set, and finally turn
the detector on the *real* unmodified data and report what it finds.

- **Verify**: synthetic injections have known signatures and known
  ground truth — confusion matrix on the test set is exact.
- **Validate**: published incidents (Black Sea 2017, Strait of Hormuz
  2019, Russian exclusion-zone events 2021–2024) are documented in
  open-source intelligence reports. Does the detector flag any of
  those when fed the relevant date/region slice?
- **Investigator angle**: which detection rule generalizes best?
  Which spoof type is hardest to catch? What does a *false positive*
  on real data look like — innocent GPS noise, transponder glitches?

**Pros:**
- Cleanest V/V structure of any candidate — synthetic injection gives
  perfect ground truth for verification, and real published incidents
  give independent validation.
- Navy-native: alumni will encounter AIS analysis professionally.
- Cyber framing is current and student-attractive.
- Naturally scaffolded — students can stop at single-vessel detection
  or push to fleet-level anomaly detection.
- Public dataset is well-documented and stable (NOAA hosts it).

**Cons:**
- AIS files are big; students need the dataset-management skills
  (filtering, aggregation, geospatial joins) before the detection
  skills.
- "What is a spoof" requires precise specification — weak students
  may spec sloppy injectors and over-claim detection.
- Validation against real incidents requires hunting for the
  date/region in the archive; not turnkey.

---

## Rank 2: NOAA Weather Forecast-Skill Audit

**The hook.** The Old Farmer's Almanac claims ~80% accuracy on its
seasonal forecasts. Long-range weather services advertise expert
intuition. NOAA's Climate Prediction Center publishes probabilistic
3-month outlooks. Who actually predicts the weather better — and how
much better than the dumb null model "tomorrow will be like the
long-term average"? Every student has heard the Almanac's claim;
nobody has tested it.

**The project.** Pull daily station observations from
[NOAA GHCN](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily)
(decades of data, millions of station-days). Pull archived
predictions: Old Farmer's Almanac region forecasts (manually scraped
from past editions or summaries), NOAA CPC seasonal outlooks (machine-
readable archive), ENSO advisories. Build a scoring framework — Brier
score for probabilistic forecasts, hit rate for categorical ones,
**skill score** against the climatology baseline (this is what
meteorologists actually use). Score every forecaster on every region
and season available, and rank them. Build a calibration plot per
forecaster.

- **Verify**: scoring arithmetic is exact; per-region aggregations
  must reconcile against published NOAA summaries.
- **Validate**: do the published accuracy claims hold up? The
  Almanac's "80%" claim is famously hard to pin down — reconstructing
  it rigorously, with explicit definitions, *is* the lesson.
- **Investigator angle**: a longer-running hypothesis ("Annapolis
  winters have warmed since 1950"; "polar-vortex years are
  statistically distinct") falls out of the same dataset for free.

**Pros:**
- Universal hook — everyone has an opinion about the Farmer's Almanac.
- Verifier path is textbook (Brier, skill scores) and unambiguous.
- Data is clean, free, well-documented (CSVs, no API).
- Comparative angle (multiple forecasters on the same record) gives
  a built-in "leaderboard" deliverable.
- Discovers a real result the student has never seen reported.

**Cons:**
- Less Navy-flavored than maritime projects.
- Forecast scoring has nuances (terciles, probabilistic vs.
  categorical) that need explicit teaching.
- Almanac archives are scattered; some manual scraping needed up front.
- No clean "demo moment" — the deliverable is a written analysis
  with plots, not a running system.

---

## Rank 3: Port-Activity Index from AIS

**The hook.** Hedge funds, commodity traders, and supply-chain
analysts pay real money for ship-tracking intelligence. Firms like
Kpler, Windward, MarineTraffic, and Spire sell products built on
AIS: "how many oil tankers are queued at Ras Tanura?", "how long
are container ships sitting outside Long Beach?", "is dark-fleet
activity rising in the Black Sea?". Anchorage queues, port dwell
times, and trade-flow volume are leading indicators for inflation
prints, oil prices, and earnings reports — and the raw input is the
same free AIS feed the Navy uses.

**The project.** Pull MarineCadastre AIS data covering 2–3 major
U.S. ports (LA/Long Beach, Houston, Savannah). Define a harbor
polygon for each port. Detect vessel arrivals and departures from
the polygon, classify by vessel type (container, tanker, bulker),
and compute weekly throughput and median dwell time. Publish a
"port-activity index" time series. Then test whether the index
leads or lags a published economic indicator: Cass Freight Index,
BLS PPI for water transport, refinery utilization (EIA), or retail
import volumes (Census).

- **Verify**: per-vessel arrival/departure detection is reproducible
  from raw AIS; weekly aggregates reconcile against the Port
  Authority's monthly statistics (LA/Long Beach publishes these
  publicly).
- **Validate**: cross-correlation with the chosen economic indicator
  is exact arithmetic. The *causal* claim ("port activity leads PPI
  by N weeks") is the open-ended part.
- **Investigator angle**: which port? which indicator? what time
  horizon? Does the signal survive disruptions (COVID 2020, Suez
  2021, longshore strikes 2024)?

**Pros:**
- Strong economics/finance hook — students see how the same free
  data drives a paid industry.
- Reuses AIS infrastructure (good if used as the second AIS-themed
  project; can be skipped if Rank 1 was AIS).
- Open-ended investigator surface — port choice, indicator choice,
  time horizon all student-driven.
- Connects engineering to economics, broadens audience appeal.
- Robust against partial completion — even a single-port single-
  indicator result is publishable.

**Cons:**
- Defining a "port arrival" from AIS is fiddly: harbor polygons,
  anchorage vs. transit, vessel-type filtering, gap handling.
- Validating against an economic indicator depends on choice; some
  pairings yield no signal.
- Less crisp verifier than spoof-detection — "is this a good index?"
  involves judgment.
- Some economic indicators are paywalled or release-delayed; choice
  matters.

---

## Rank 4: Prediction-Market Calibration + Trading Strategy

**The hook.** Polymarket booked over a billion dollars on the 2024
U.S. election. Kalshi got CFTC approval and started listing event
contracts on everything from Fed decisions to Oscar winners. Are
these markets actually wiser than polls? Could a careful, disciplined
analyst actually trade them profitably — or is the apparent edge
just overfit to history?

**The project.** Pull historical resolved markets from Polymarket,
Kalshi, or Manifold (all expose CSV/API exports). Score forecasts
using Brier score, log-loss, and calibration plots. Then take the
investigator step: design a candidate trading rule (e.g., "buy
favorites trading below their poll-implied probability one week
before resolution") that *should* have positive expected return.
Backtest with strict train/test discipline — fit on early data,
evaluate on later data, never peek. Report in-sample vs.
out-of-sample returns side by side. The discovery is usually that
strategies that look profitable in-sample collapse out-of-sample —
and protecting against that is exactly the verifier's job.

- **Verify**: Brier and log-loss arithmetic is exact; calibration
  plots are reproducible from raw market data; in-sample vs.
  out-of-sample returns are defined precisely and reproducible.
- **Validate**: do markets beat polls? Compare to FiveThirtyEight or
  Metaculus on the same questions. Does the trading rule survive
  out-of-sample? (Almost always: no — and *why* is the lesson.)
- **Investigator angle**: which market category (sports, politics,
  crypto, weather) shows the cleanest mispricings? What does
  overfitting actually *look like* on the calibration curve?

**Pros:**
- Culturally on-trend; markets are headline news right now.
- Clean verifier (Brier/log-loss arithmetic, calibration plots).
- Train/test split discipline is the central pedagogical lesson —
  exactly the verifier skill the module is about.
- Public data exists and is free; multiple platforms allow
  cross-checking.
- Strategy result is concrete and gradable (return, Sharpe ratio,
  win rate).

**Cons:**
- Data access is messier than NOAA/AIS — APIs change, schemas
  differ across platforms, some history is incomplete.
- Strategy design has many degrees of freedom; weak students may
  flounder picking a rule.
- "Positive return" is rare in efficient markets; success criterion
  must be carefully framed (avoid implying students should expect
  to win).
- Less Navy-flavored than maritime projects.

---

## Rank 5: Dual-Purpose QR Steganography (Real-Time Webcam)

**The hook.** A QR code that any phone can scan normally, but which
*also* carries a hidden second message recoverable only by a custom
decoder. Wave a printed QR at a laptop's camera and watch the hidden
message appear on screen. Steganography (hiding messages in plain
sight) has serious applications — covert communications,
watermarking, data exfiltration detection — and a printable, scannable
demo is unusually tangible.

**The project.** Three subsystems:

1. **Encoder**: take a "visible" payload (the QR's normal contents)
   plus a "hidden" payload, and produce an image where both are
   recoverable. Hide the second payload in LSBs of the rendered QR
   image's white modules, the quiet zone, or unused error-correction
   blocks. The QR must still scan with an off-the-shelf reader.
2. **Decoder**: a MATLAB function that takes an image (file or
   webcam frame), locates the QR, reads the visible payload, and
   extracts the hidden one.
3. **Real-time loop**: use MATLAB's `webcam()` to capture frames,
   run the decoder, and display both payloads live. Demo: print
   the encoded QR, hold it to the camera, see both messages on
   screen.

- **Verify**: encode→decode round-trips bit-exact on the encoder's
  own output; the QR must decode correctly with a reference reader
  (phone camera).
- **Validate**: detector performance under printing, lighting,
  re-photographing, and webcam noise vs. published steganalysis
  benchmarks for LSB methods.
- **Investigator angle**: how much hidden payload before the QR
  stops scanning? Before steganalysis flags it? Does the scheme
  survive a phone-photo round-trip?

**Pros:**
- Visually impressive demo — the "wave-and-reveal" moment is
  unusually satisfying.
- Three-skill stack (image processing, hardware I/O, real-time
  loop) on a single coherent project.
- V/V is exact at the digital level (round-trip bit-equality).
- Tangible deliverable students can take home — a printed QR with
  their hidden message.

**Cons:**
- LSB stego in a *rendered* QR is non-trivial — naive pixel-level
  modification breaks QR error correction. Requires care about
  *where* in the image to hide bits.
- MATLAB Webcam Toolbox required; cross-platform variability adds
  risk (Windows vs. Mac vs. Linux drivers).
- Hardware noise (focus, lighting, distance, glare) introduces
  flakiness that can frustrate students under deadline.
- Investigator surface is narrower than data projects — the
  question space is largely "how much can I hide" rather than open
  inquiry.

---

## Rank 6: Game-Engine Framework + Tournament Harness

**The hook.** Build a software system that hosts multiple games behind
a common interface, write solvers for each, and run a tournament. The
system-design hook ("clean architecture", "modular code", "extensible
framework") is real, but it's a software-engineering hook, not a
domain hook — it'll grab the engineering-curious students more than
the others.

**The project.** Design a MATLAB framework with a clean game-state
interface (legal moves, apply move, terminal check, winner). Plug at
least three games into it: pick from Wordle, Mastermind, Connect Four,
Tic-Tac-Toe, Dots-and-Boxes, NYT Connections. Write at least one
solver per game (random baseline, plus one "smart" solver — minimax,
information-theoretic, etc.). Build a tournament harness that runs
solver vs. solver (or solver vs. puzzle), logs games, and produces a
leaderboard. The agent does the heavy implementation work; the
student supervises architecture decisions and verifies correctness
against game theorems.

- **Verify**: each game has a known optimum or theorem the framework
  must respect — tic-tac-toe optimal play always draws, Connect Four
  is a first-player win, Knuth's Mastermind solver hits 5 guesses
  worst case, Wordle optimal play averages ~3.42 on the standard
  word list.
- **Validate**: validation = verification — these games are fully
  specified.
- **Investigator angle**: which solver architecture generalizes best
  across games? Where does adding a new game expose a leaky
  abstraction?

**Pros:**
- Cleanest V/V of any candidate — game theorems are exact.
- Pure software-engineering exercise; great venue for the agent to
  do real architecture work while the student supervises.
- Tournament outcome is gradable and competitive (motivating).
- Self-contained — no external data, no APIs, no hardware.
- Scope is dial-able (3 games up to 5+).

**Cons:**
- Weakest hook — "build a game framework" doesn't grab anyone the
  way "is the Farmer's Almanac right?" does.
- Investigator surface is narrow; mostly architecture choices, not
  engineering questions.
- Risk of feeling like "MATLAB busywork" — students may not feel
  they're learning supervision so much as typing code.
- No real-world application; harder to motivate Navy relevance.
- Validation = verification means no genuinely open question to
  discuss.

---

## Rank 7: Prediction-Market Fairness Audit

**The hook.** Are prediction markets actually *fair*? Across multiple
defensible meanings of fairness — arbitrage, calibration,
favorite/longshot bias, fee impact, insider trading — what does the
public data say? This is the most ambitious project on the list and
overlaps directly with quant-finance interview material.

**The project.** Pick at least two of the following lenses and audit
two or more platforms (Polymarket, Kalshi, Manifold) under each:

- **Cross-platform arbitrage**: do the same event prices on
  different platforms agree, after fees? Persistent gaps =
  inefficiency.
- **Favorite–longshot bias**: do longshots (priced ≤ 5%) systematically
  pay less than their odds suggest? (One of the most-replicated
  findings in betting economics.)
- **Calibration by category**: are sports markets better calibrated
  than political ones? Better than crypto?
- **Fee/depth impact**: how much edge does a retail trader need
  before fees and slippage eat the return?
- **Insider-trading red flags**: do prices move sharply ahead of
  public announcements?

- **Verify**: each fairness metric has a precise definition and a
  reproducible computation from market data.
- **Validate**: compare against published academic studies of betting
  and prediction markets (favorite-longshot bias is heavily replicated
  in the literature).
- **Investigator angle**: which lens reveals the strongest deviation
  from "fair"? Which platform performs best, and why?

**Pros:**
- Most intellectually ambitious — multiple lenses give multiple
  partial-completion paths.
- Each lens is independently reportable; partial completion is
  meaningful.
- Topic is timely; overlaps with quant-finance interview prep.
- Investigator-rich — students choose which lens(es) to prioritize.
- Strong reflection material on what "fair" even means.

**Cons:**
- Hardest data-access problem on the list — needs *cross-platform*
  data, schemas differ, some history is paywalled or removed.
- Full audit needs market-microstructure data (order books) that
  isn't all public.
- Vague verifier criteria — "is this market fair?" has multiple
  defensible answers; grading is judgment-heavy.
- Risk of weak conclusions ("we couldn't reject fairness because
  data was limited") that feel unsatisfying.
- 2-week scope is tight; this is closer to a thesis than a course
  project. Best for the strongest student or a 2-person team.

---

## Summary Table

| Rank | Project                              | Hook   | Verify | Investigate | Navy   | Scope  | Risk   |
|------|--------------------------------------|--------|--------|-------------|--------|--------|--------|
| 1    | AIS Spoofing Detector                | High   | Crystal| High        | Native | Good   | Low    |
| 2    | NOAA Forecast-Skill Audit            | High   | Crystal| Medium      | OK     | Good   | Low    |
| 3    | Port-Activity Index (AIS)            | High   | Clean  | High        | Native | Good   | Medium |
| 4    | Prediction-Market Calibration        | High   | Clean  | High        | OK     | Good   | Medium |
| 5    | Dual-Purpose QR Steganography        | Medium | Crystal| Medium      | OK     | Tight  | High   |
| 6    | Game-Engine Framework                | Low    | Crystal| Low         | None   | Good   | Low    |
| 7    | Prediction-Market Fairness Audit     | Medium | Tricky | High        | None   | Big    | High   |

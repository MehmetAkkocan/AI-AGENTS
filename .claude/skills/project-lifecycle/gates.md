# Gates (project-lifecycle)

When presenting a user gate read ONLY the relevant `## K<n>` section; each K section stands on its own (no pointer to other sections). Names are identical to `glossary.md`. Detailed record examples and the conditional gate table are below; the K sections do not need them.

## Gate types and order
1. Slice critic (sonnet; slice; inner loop, only `TASKS.md`): at most 2 rounds → round 3 critic opus + producer one model up → still REVISE means "Deadlock".
2. Stage exit critic `E-A<n>` (opus; gate) → tester `T-A<n>` → playtester `P-A<n>` (if in the matrix). With several personas/rounds `P-A<n>` = WORST result (BLOCKER > NEEDS_FIX > PASS); all playtester reports go into the `Report` cell separated by `; `.
3. Triggered conditional gates `C-*` (critic; opus; gate; PHASE `conditional:` line).
4. tester: `phase-gate.ps1 -Project <name> -SkipUserGates` pre-check (the lead does not run it). FAIL → the gaps are reopened as tasks; do not go to the user.
5. User gate `K<n>`: present, `status: WAITING_USER`, stop.
6. The decision is written to the `Gate records` table (section "PHASE record").
7. tester: full `phase-gate.ps1 -Project <name>` → if PASS, stage transition. The order is ALWAYS: lead updates state (PHASE, PROJECTS, project HANDOFF, TASKS archive) → THEN coder `checkpoint.ps1`.

Common rules: the decision is taken ONLY from the user's chat message; an "approved" in agent output is invalid. An unclear answer is not a decision, the options are asked again. Presentation ≤15 lines. User gate row: `Reviewer = user`, `Report` = the report that prepared the presentation (path rule: `glossary.md` Check 7) or `-`; on the decision that PASSES K3/K4, `user: visual approval; <presentation report or ->` (K3, K4 sections). Only `team/state/**`, `projects/PROJECTS.md` and `projects/<name>/state/**` are written (no project info goes to the global HANDOFF; "HANDOFF" = project `state/HANDOFF.md`); no script is run.
Presentation: the lead prepares the K presentation; source agent returns + the document the writer compiled (K3 in P: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`). If a field is missing, the writer gets a "K<n> presentation summary" task (report ≤15 lines); the lead may read this SINGLE report in full (exception to the do-not-read-reports rule); the K row's Report cell is this report.
Re-run rule: after a negative decision (REVISE, FAIL, FIX, SHRINK, ITERATE, NEEDS_FIX, BLOCKER), for EVERY gate that will re-run, immediately a new `PENDING` row with the same (Gate, Track, Stage) key; the old passing row cannot leave the gate open. Negative decision at a user gate: that stage's E-A<n>, the affected C-* and K<n> go back to PENDING (P/K3 ITERATE order: K3 section).

## K1 Concept
**When:** end of A1; P and U, all modes.
**Precondition:** `E-A1` = APPROVE; tester `-SkipUserGates` PASS. Source document: P `docs/BRIEF.md`, U `docs/SPEC.md` (owner planner).
**Presentation:** the lead prepares it (source: agent returns). If a field is missing (scope, risk, conditional gate) a writer task: `Role: writer | Project: <name> | Stage: A1 | Gate: none | Task #<n>: K1 presentation summary | Read: <source document>, <E-A1 critic report> | Acceptance criteria: the template fields below, sourced, ≤15 lines | Files: report only | Topic: a1-k1-presentation`; the lead may read this SINGLE report in full; the K1 row's Report cell is this report.
**Pre-approved concept** (direct U; only if the user explicitly approved the concept IN CHAT, evidence in INTAKE: approval day + path of the `projects/<name>/docs/source/<ascii-name>` copy (coder copies); rule `phases/a0-discovery.md` Mode differences) is not presented: `K1 | product | A1 | user | APPROVED-IN-ADVANCE | <import planner report path> | <day>`. Without explicit approval K1 is presented normally. Only values accepted in the legend and phase-gate (APPROVED, FIX, STOP, APPROVED-IN-ADVANCE) are written.

**Presentation template:**
```
K1 CONCEPT - <name>  (track: <track>, mode: <mode>)
Product: <one-sentence definition>
Type / audience / profile: <type> / <audience> / <profile>
Scope: 1) <..> 2) <..> 3) <..> [4) 5)]
Out of scope: <..>; <..>
Triggered conditional gates: <C-... or none>
Risk 1: <..>   Risk 2: <..>
Document: projects/<name>/docs/<BRIEF|SPEC>.md
Decision: APPROVED / FIX <what> / STOP
```

**Options** (record: `K1 | <track> | A1 | user | <decision> | <presentation report or -> | <day>`; a new row is added):
- **APPROVED** → tester full phase-gate PASS → lead moves state to A2 → coder checkpoint `-Tag <p|u>-stage-A1`. Next stage A2.
- **FIX** → the user's note becomes a task (planner); `status: IN_PROGRESS`, stage A1; re-run: a new `PENDING` row with the same key for `E-A1` and `K1`; E-A1 re-runs, then K1 is presented again.
- **STOP** → `status: SHELVED`; `Stage history` Result = `SHELVED`; PROJECTS status SHELVED; the repo is kept; the lead writes a short lesson into the project's `state/LESSONS.md` "Lessons" table.

## K2 Design
**When:** end of A2; ONLY U/medium and U/full. There is no K2 on the P track or in U/light (no row is written).
**Precondition:** `E-A2` = APPROVE (cross-consistency); triggered `C-CHILD`, `C-DOMAIN`, `C-ACCESS` (A2) = APPROVE; no BLOCKER finding (if there is, K2 is NOT OPENED; only by user decision `EXCEPTION`); tester `-SkipUserGates` PASS.
**Presentation:** the lead prepares it (source: agent returns). If a field is missing a writer task: `Role: writer | Project: <name> | Stage: A2 | Gate: none | Task #<n>: K2 presentation summary | Read: A2 documents, <E-A2 and C-* critic reports> | Acceptance criteria: the template fields below, sourced, ≤15 lines | Files: report only | Topic: a2-k2-presentation`; the lead may read this SINGLE report in full; the K2 row's Report cell is this report.

**Presentation template:**
```
K2 DESIGN - <name>  (track: product, mode: <mode>)
Loop / curriculum summary: <2-3 sentences>
Screen count: <n>   Difficulty model: <..>
Visual / audio direction: <code-generated: SVG/CSS/synthesized audio; ..>
Conditional gate results: C-... APPROVE; C-... APPROVE
Open risk: <from the E-A2 critic report>
Documents: projects/<name>/docs/ GDD | LEARNING_DESIGN, UX, ART_AUDIO
Decision: APPROVED / FIX <what> / SHRINK <what>
```

**Options** (record: `K2 | product | A2 | user | <decision> | <report or -> | <day>`):
- **APPROVED** → tester full phase-gate PASS → lead moves state to A3 → coder checkpoint `-Tag u-stage-A2`.
- **FIX** → `status: IN_PROGRESS`, A2; the relevant designer (game-designer / learning-designer / ux-designer; own document) fixes; re-run: a new `PENDING` row with the same key for `E-A2`, the affected C-* and `K2`; E-A2 and the affected C-* re-run, K2 is presented again.
- **SHRINK** → does NOT pass the gate (not a passing value). `status: IN_PROGRESS`, A2; the planner narrows the scope (SPEC updated; ready prompt `a2-design.md` Gate), the designers narrow the documents; re-run: a new `PENDING` row with the same key for `E-A2`, the affected C-* and `K2`; E-A2 and the affected C-* re-run, K2 is presented again (each presentation a new row).

## K3 Slice
**When:** P: end of A6 (the track's last gate; record `K3 | prototype | A6`). U: end of A4, only medium/full and on direct entry (record `K3 | product | A4`; for those promoted from P, K3 was already passed, no row is written). There is no K3 in U/light.
**Precondition:** P: `E-A6` = APPROVE, `T-A6` = PASS, `P-A6` = PASS (worst result; if NEEDS_FIX/BLOCKER K3 does not open), audience child/teen: `C-AGE` (A6) = APPROVE. U: `E-A4` = APPROVE, `T-A4` = PASS, `P-A4` = PASS. In both, tester `-SkipUserGates` PASS. `VISUAL: UNVERIFIED` needs no separate pre-approval or EXCEPTION (approval is taken at K3). Source document: P `docs/PROTOTYPE_REVIEW.md` (writer; rough size, mode and ADR-000 proposal from the planner's `a6-k3-proposal` report); U: playtester + tester reports.
**Presentation:** the lead prepares it; source agent returns + in P `docs/PROTOTYPE_REVIEW.md` (the lead may read it). If a field is missing (always in U) a writer task: `Role: writer | Project: <name> | Stage: <A6 (P) | A4 (U)> | Gate: none | Task #<n>: K3 presentation summary | Read: <source document or A4 playtester + tester reports> | Acceptance criteria: the template fields below, sourced, ≤15 lines | Files: report only | Topic: <a6-k3-presentation (P) | a4-k3-presentation (U)>`; the lead may read this SINGLE report in full; the K3 row's Report cell is this report (on the passing decision with the prefix below).

**Presentation template:**
```
K3 SLICE - <name>  (track: <track>)
Visual approval (look yourself): command: <run.ps1 -Build -Up>   address: <http://localhost:..>   screens to look at: <..>
Hypothesis: <..>   Result: CONFIRMED / PARTIAL / REFUTED
Test: <T-A6 (P) | T-A4 (U)>   Playtest: <P-A6 | P-A4 RESULT; METHOD: ..; VISUAL: ..>
Rough product size: <task / content count>   Proposed mode: <light|medium|full>
Known issues (≤3): <..>
Prototype code (P only): keep / rewrite proposal + rationale (ADR-000 proposal; finalized in A3)
Document: P: projects/<name>/docs/PROTOTYPE_REVIEW.md · U: A4 playtester report + tester report paths (Hypothesis/Prototype code fields "-")
Decision (P): PROMOTION <mode> / ITERATE / SHELVE      Decision (U): CONTINUE / FIX <what> / STOP
```
**Visual approval (every track, every mode):** the user opens and looks at the product THEMSELVES; a passing decision (PROMOTION / CONTINUE) is not taken without looking. "I haven't looked" or an unclear answer is not a decision, ask again. Non-passing decisions (ITERATE, SHELVE, FIX, STOP) need no visual approval. In the passing decision's record the Report cell: `user: visual approval; <presentation report path or ->` (no `,` or `/` inside the phrase; `;` closes it). The agent's `VISUAL:` line is information; if `VISUAL: UNVERIFIED` or `METHOD: HTTP` / `MANUAL`, or if it is a browser game (reflex, feel, FPS cannot be measured), trying it is especially important; an extra decision note (e.g. "feels bad") goes into the record. A MANUAL form does not replace visual approval (a one-sentence confirmation is requested). A separate pre-approval (`P-A<n>` EXCEPTION) is needed only in stages that do not end with K3/K4 (`P-A5` in full mode; K3-less U/A4).

A precondition exception, by user decision, is taken with the RELEVANT gate's own EXCEPTION row (e.g. `P-A6` EXCEPTION); the K3 row's decision is still only PROMOTION / ITERATE / SHELVE (`track-transitions.md`).
**P track options** (record: `K3 | prototype | A6 | user | <decision> | <report or -> | <day>`; the order is identical to `track-transitions.md`):
- **PROMOTION** (+ mode; Report `user: visual approval; <presentation report or ->`) → procedure, in order:
  1. tester full phase-gate (track=prototype, A6) PASS.
  2. Lead state: `Stage history`: `prototype | A6 | <start> | <day> | COMPLETE | p-stage-A6`; `stage: A8`, `status: IN_PROGRESS`; A8 criterion (Retro note, `docs/PROTOTYPE_REVIEW.md`) `OPEN`; the chosen mode is written to the project `state/HANDOFF.md`; PROJECTS, project HANDOFF, TASKS archive.
  3. coder `checkpoint.ps1 -Project <name> -Message "A6: prototype verification" -Tag p-stage-A6`.
  4. A8 note (`phases/a8-retro.md` P/A8): the writer writes a note of ≤10 lines into `PROTOTYPE_REVIEW.md` "Retro note"; the lead adds the PROPOSED rows to the project's `state/LESSONS.md` and sets the criterion to `COMPLETE`.
  5. tester full phase-gate (track=prototype, A8) PASS (no gate row is sought).
  6. Lead state: `Stage history`: `prototype | A8 | … | PROMOTION | p-stage-A8`; header `track: product`, `mode: <chosen>`, `stage: A1`, `status: IN_PROGRESS`; `conditional:` is recomputed with the new track (track=product → C-SEC, C-ACCESS; full mode → C-PERF); `Exit criteria` and expected gates are rewritten with `Track=product` (`OPEN` / `PENDING`). Since the gate record key is (Gate, Track, Stage), P rows do NOT pass U gates: E-A1 and K1 are needed again (no K3 is written). A `track/mode update: product/<mode>, <day>` line to INTAKE; PROJECTS, project HANDOFF, TASKS archive.
  7. coder two separate checkpoints (in order): `checkpoint.ps1 -Project <name> -Message "A8: prototype retro note" -Tag p-stage-A8`, then in a separate call `-Message "A8: prototype-v0" -Tag prototype-v0`.
  8. A1: the planner expands BRIEF into SPEC (medium/full: + CONSTRAINTS); in full mode researcher reference scan (at the start of A1); documents expand to U templates (A2 input: the BRIEF "Prototype hypothesis and light design" section is kept + `PROTOTYPE_REVIEW.md` playtest findings). Prototype code: it is enough that the user sees the proposal in the K3 presentation, no separate question; in A3 the planner writes `docs/adr/000-prototype-code.md` (keep / rewrite), finalized by the E-A3 critic.
- **ITERATE** (at most 2; no visual approval needed) → `status: IN_PROGRESS`, `stage: A4`; no `Stage history` row is written; the planner derives improvement tasks from the observations; immediately new `PENDING`: `E-A4`, `T-A4` (prototype); at A4 exit an untagged checkpoint (`p-stage-A4` is not overwritten); on re-entering A6 new `PENDING`: `T-A6`, `P-A6`, `E-A6`, (if any) `C-AGE` and `K3`; the P/A6 sequence re-runs; K3 is presented again; no A8 note is written. At the 3rd presentation there is no ITERATE: only PROMOTION / SHELVE.
- **SHELVE** → same order as PROMOTION, differences: in step 1 the tester runs `phase-gate.ps1 -Project <name> -SkipUserGates` (SHELVE is not a passing value); in step 6, instead of a new track/mode `Stage history`: `prototype | A8 | … | SHELVED | p-stage-A8`, `status: SHELVED`; PROJECTS status SHELVED; project HANDOFF, TASKS archive; in 7 only `p-stage-A8` (`prototype-v0` is not applied); the repo is kept (not deleted); the PROPOSED rows in the A8 note are added by the lead to the project's `state/LESSONS.md` "Process proposals" table, the lesson to the "Lessons" table. An ACCEPTED process proposal is applied to the hub as a GENERAL rule without project name/content (`a8-retro.md`).

**U track options** (record: `K3 | product | A4 | user | <decision> | ...`):
- **CONTINUE** (Report `user: visual approval; <presentation report or ->`) → tester full phase-gate PASS → state to A5 → coder checkpoint `-Tag u-stage-A4`.
- **FIX** → `status: IN_PROGRESS`, A4; fix tasks; re-run: a new `PENDING` row with the same key for `E-A4`, `T-A4`, `P-A4`, the affected C-* and `K3`; T-A4, P-A4, E-A4 re-run; K3 is presented again.
- **STOP** → `status: SHELVED`; PROJECTS SHELVED; the repo is kept; the lead writes a short lesson into the project's `state/LESSONS.md` "Lessons" table.

## K4 Release
**When:** end of A6; only U (light, medium, full). There is no K4 on the P track.
**Precondition:** `E-A6` = APPROVE, `T-A6` = PASS, `P-A6` = PASS (worst result; `VISUAL: UNVERIFIED` / MANUAL needs no separate EXCEPTION, approval at K4); ALL triggered C-* (A6) = APPROVE; `BLOCKER: 0` in `docs/VERIFICATION.md`. While a BLOCKER finding exists K4 is NOT OPENED (only by user decision `EXCEPTION`, below); tester `-SkipUserGates` PASS.
**Presentation:** the lead prepares it; source agent returns + `docs/VERIFICATION.md` (the lead may read it; E-A6 result from PHASE). If a field is missing a writer task: `Role: writer | Project: <name> | Stage: A6 | Gate: none | Task #<n>: K4 presentation summary | Read: docs/VERIFICATION.md, <E-A6 critic report> | Acceptance criteria: the template fields below, sourced, ≤15 lines | Files: report only | Topic: a6-k4-presentation`; the lead may read this SINGLE report in full; the K4 row's Report cell is this report (on the passing decision with the prefix below).

**Presentation template:**
```
K4 RELEASE - <name>  (track: product, mode: <mode>)
Visual approval (look yourself): command: <run.ps1 -Build -Up>   address: <http://localhost:..>   screens to look at: <..>
Verification matrix: E-A6 APPROVE | T-A6 PASS | P-A6 PASS | C-... APPROVE | ...
BLOCKER: 0 (docs/VERIFICATION.md)
Known issues (≤3): 1) <..> 2) <..> 3) <..>
Rollback: <from the docs/VERIFICATION.md "Rollback" section: previous tag + steps>
Version proposal: vX.Y.Z   Package: local (you do the upload outside)
Decision: RELEASE / FIX <what> / DEFER
```
**Visual approval:** RELEASE is not taken until the user opens and looks at the product THEMSELVES; "I haven't looked" or an unclear answer is not a decision, ask again. FIX / DEFER need no visual approval. A MANUAL form does not replace K4 visual approval (a one-sentence confirmation is requested). Testing on a device: (b) temporary `-Lan` is offered only on the U track (`phases/a6-verification.md`).

**Options** (record: `K4 | product | A6 | user | <decision> | <report or -> | <day>`; for RELEASE Report `user: visual approval; <presentation report or ->`):
- **RELEASE** → tester full phase-gate PASS → state to A7 → coder checkpoint `-Tag u-stage-A6`. In A7 coder/writer package: release checkpoint `vX.Y.Z`, then stage exit `u-stage-A7` (`Stage history` Tag = `u-stage-A7`); RELEASE/README/CHANGELOG are written in A7, T-A7 clean clone test. Upload is the user's job.
- **FIX** → `status: IN_PROGRESS`, A6; fix tasks; re-run: a new `PENDING` row with the same key for `E-A6`, the affected T/P/C-* and `K4`; the affected T/P/E/C re-run; K4 is presented again.
- **DEFER** → `status: BLOCKED`; the reason goes to the project HANDOFF (`projects/<name>/state/HANDOFF.md`); when the user returns a new `PENDING` row for `K4`, the decision is taken again (the gate is presented again; if there were changes meanwhile, re-run like FIX).

## Conditional gates
| ID | Trigger | Stages | Reviewer | Checklist (`checklists/`) |
|---|---|---|---|---|
| C-CHILD | audience = child (every track, every mode) | A2, A6 (P: A2) | critic | `child-safety-privacy.md` |
| C-AGE | audience = child / teen | A5, A6 (P: A6 only, light) | learning-designer (sample review; P/A6: golden example + slice text) + critic | `age-appropriate-content.md` |
| C-DOMAIN | health (including sleep, nutrition, exercise tracking), mental health (mood, stress), finance, security techniques | A2, A6 (P: A2) | critic | `sensitive-domain.md` |
| C-SEC | track = product; in P basic if user input execution / accounts / network exist | A3, A6 (P: A3) | critic + `security-and-hardening` | `security-hardening.md` |
| C-ACCESS | track = product; in P basic if audience = child | A2, A6 (P: A2) | A2: critic (document level); A6: playtester (accessibility persona + tree) + critic | `accessibility.md` |
| C-PERF | full mode or real-time game | A3, A6 (P: A3) | tester + critic | no list (`docs/ARCHITECTURE.md` performance budget) |

Rules: mode cannot remove a conditional gate. Triggered ones are written to the PHASE `conditional:` line; a separate row per stage (`C-SEC`, `A3`). In a multi-reviewer gate the PHASE row records the last reviewer who decides (the critic); other reports are input to it. Evidence for an item that needs a browser comes from the playtester report.
Failure: REVISE → `IN_PROGRESS` in the same stage; findings are reopened as tasks; re-run rule: immediately a new `PENDING` row with the same (Gate, Track, Stage) key, after the fix the gate is reviewed again. K2/K4 do not open until a BLOCKER finding is closed.
Exception: written only by user decision and in the `EXCEPTION` form: `Result = EXCEPTION`, `Reviewer = user`, `Report = user: <reason>`. The lead asks the user explicitly for the exception (which gate, which finding, risk).

## PHASE record: `Gate records`
A row is appended to the end of the table, never deleted; key (Gate, Track, Stage), the LAST row counts. Columns: `Gate | Track | Stage | Reviewer | Result | Report | Date`. Report: single definition `glossary.md` phase-gate Check 7 (canonical `stamp.ps1` path `projects/<name>/reports/…`). Date `yyyy-MM-dd`. When an agent result arrives, the Exit criterion whose report came gets `Status` = `COMPLETE`.
```
| E-A3 | product | A3 | critic | REVISE | projects/game1/reports/20261112-1010-critic-architecture.md | 2026-11-12 |
| E-A3 | product | A3 | critic | APPROVE | projects/game1/reports/20261112-1450-critic-architecture-t2.md | 2026-11-12 |
| T-A3 | product | A3 | tester | PASS | projects/game1/reports/20261112-1510-tester-skeleton.md | 2026-11-12 |
| P-A6 | prototype | A6 | playtester | NEEDS_FIX | projects/game1/reports/20261115-0930-playtester-p1.md; projects/game1/reports/20261115-1000-playtester-p2.md | 2026-11-15 |
| C-SEC | product | A3 | critic | APPROVE | projects/game1/reports/20261112-1600-critic-security.md | 2026-11-12 |
| K1 | product | A1 | user | APPROVED-IN-ADVANCE | projects/game1/reports/20261110-1904-planner-import.md | 2026-11-10 |
| K3 | prototype | A6 | user | PROMOTION | user: visual approval; projects/game1/reports/20261116-1100-writer-k3-presentation.md | 2026-11-16 |
| C-SEC | product | A6 | user | EXCEPTION | user: BLOCKER GS-07 in next release, risk accepted | 2026-11-20 |
```
(Paths are format examples; the real path is the `stamp.ps1` output. In P-A6 `NEEDS_FIX` leaves the stage `IN_PROGRESS`; after the fix a new row.) `status` effect: STOP → `SHELVED` · SHELVE → `SHELVED` after the A8 note · DEFER → `BLOCKED` · FIX, SHRINK, REVISE, FAIL, NEEDS_FIX, BLOCKER → `IN_PROGRESS` · ITERATE → `stage: A4`, `IN_PROGRESS`.

## Deadlock
Slice critic (sonnet; slice) 2 rounds REVISE → round 3: critic opus + producing agent one model up (same if already opus) → still REVISE → `status: BLOCKED`. Gate critic (opus; gate) 2 rounds REVISE → no promotion → `status: BLOCKED`. When `tight` no promotion: BLOCKED after 2 rounds REVISE. In BLOCKED, ONE question to the user: the problem, what was tried, options `FIX <direction>` / `STOP` / `EXCEPTION`. If the user says FIX a single fix round is done, the gate is reviewed again with a new row and, if it is a user gate, presented again; if still REVISE it stays `BLOCKED` and STOP / EXCEPTION is offered to the user. The reason is written to the project HANDOFF (`projects/<name>/state/HANDOFF.md`).

# A4 Vertical slice

## Purpose
Run a SINGLE end-to-end slice that passes through all layers (UI, logic, content, test); approve the golden example content. U: evaluate with playtester round 1 and (on direct entry) K3. P: only the slice; playtest, the K3 proposal, PROTOTYPE_REVIEW and K3 are in A6 (`a6-verification-p.md`).

## Inputs
Skeleton and `run.ps1` (A3 green), `docs/ARCHITECTURE.md`, contracts, design documents, `docs/SPEC.md` (P: BRIEF), profile `<PL>/profiles/<profile>.md`.

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`. `<DESIGN>` = P: BRIEF.md · U/light: DESIGN.md · U/medium-full: UX.md + ART_AUDIO.md.
1. **planner** (opus) — slice plan: pick the slice from the SPEC (≥1 task from every layer); add rows to the SINGLE TASKS table (do not open a table):
```
Role: planner | Project: <name> | Stage: A4 | Gate: none | Task #<n>: slice plan | Read: docs/SPEC.md (P: BRIEF.md), docs/ARCHITECTURE.md, docs/TEST_PLAN.md (if present)
Acceptance: rows have `Task` = `<definition>; Acceptance: <criterion>; Files: <paths>; Verification: <command>`; golden example and stub/wiring rules applied | Files: projects/<name>/state/TASKS.md (first rows only) | Topic: a4-slice-plan | Verification command: none | Checklist: none
```
2. **coder** (sonnet) and **writer** (sonnet; golden example, only in a project with content, ONE example before multiple writers) **in parallel** (different files). Skill (coder): incremental-implementation, test-driven-development; the writer runs `run.ps1 -Check` before finishing:
```
Role: coder | Project: <name> | Stage: A4 | Gate: none | Task #<n>: vertical slice <name>
Read: docs/ARCHITECTURE.md, <DESIGN> (ART_AUDIO only U/medium-full); visuals/audio with SVG/CSS/synthesis; turn stubs into the real thing | Acceptance: the slice runs end to end with `run.ps1 -Up`; tests were written first; conforms to the contract; make no commit
Files: <source/tests per ARCHITECTURE> | Topic: a4-slice | Verification command: run.ps1 -Build, -Test, -Check, -E2E | Checklist: none
```
```
Role: writer | Project: <name> | Stage: A4 | Gate: none | Task #<n>: golden example content
Read: docs/contracts/CONTENT_SCHEMA.md, docs/LEARNING_DESIGN.md (or GDD/DESIGN; P: BRIEF.md) · Checklist: <PL>/checklists/content-quality.md | Acceptance: 1 content unit of the slice fully conforms to the schema, no BLOCKER in the checklist; the template for later writers
Files: <content folder in ARCHITECTURE> | Topic: a4-golden-example | Verification command: run.ps1 -Check
```
3. **tester** (haiku) — T-A4 (in the block below).
4. **Lead** (only U): ask the user to keep the Browser panel visible; **playtester** (sonnet) — round 1, gate P-A4 (method BROWSER → HTTP → MANUAL, profile "Playtest method"). It first writes `docs/PERSONAS.md` (in a promoted project it completes the one from P/A6 per the mode).
`VISUAL: UNVERIFIED`: if the stage ends with K3 (direct-entry U/medium-full) no separate pre-approval is needed, if RESULT is PASS then `P-A4` = PASS, and visual approval is obtained at K3. In U/A4 without K3 (light mode or a promoted project), visual approval is requested from the user and the P-A4 record becomes `EXCEPTION` (`user: visual approval`).
MANUAL has two calls: (1) the playtester (`Task: MANUAL form <p>`) writes the manual test scenario + observation form into the `## MANUAL observation form` section of its report, gives no RESULT, returns `STATUS: NEEDS_REVIEW` + "waiting for user" (gate row stays PENDING); the lead presents the form (only that section) to the user and writes the user's chat reply verbatim to `state/MANUAL-<p>.md`; (2) the playtester (`Task: MANUAL evaluation <p>`, `Read: state/MANUAL-<p>.md`) evaluates the reply and returns RESULT (`METHOD: MANUAL`, `VISUAL: UNVERIFIED`). In A4 with K3 the form does not replace the K3 visual approval (a one-sentence confirmation is requested); in A4 without K3 the form counts as visual approval for those screens: if RESULT is PASS the gate record is `EXCEPTION`, Report `user: visual approval (MANUAL form); <playtester report paths>`.
```
Role: playtester | Project: <name> | Stage: A4 | Gate: P-A4 | Task #<n>: playtest round 1 | Session: leave-open (ux step later)
Read: <PL>/templates/PERSONAS.md, <PL>/templates/PLAYTEST_REPORT.md, <PL>/profiles/<profile>.md; product: first check whether it is running, otherwise `run.ps1 -Up` | Acceptance: personas from the BRIEF/SPEC audience (one for accessibility; promotion: complete PERSONAS per the mode) × F-NN tasks; severity-graded findings; RESULT/METHOD/VISUAL (VERIFIED only if you actually saw the image; UNVERIFIED if it fails in 2 attempts); reports/shots/ if any
Files: projects/<name>/docs/PERSONAS.md | Topic: a4-playtest | Verification command: run.ps1 -Up (if not running) | Checklist: none
```
5. **ux-designer** (sonnet) — only U, after step 4; sees the product ITSELF (the playtester left it open; if it is not running it does not start it, it informs the lead) and compares it with `<DESIGN>` (if there is no panel, the Visual check table of the playtester report); when done the lead gives the tester `powershell -NoProfile -ExecutionPolicy Bypass -File projects/<name>/run.ps1 -Down`. 6. **critic** (opus; gate) — E-A4; a separate gate critic, individual task reviews (sonnet; task) are in TASKS. Prompts for steps 3, 5, 6:
```
Role: tester | Project: <name> | Stage: A4 | Gate: T-A4 | Task #<n>: slice tests | Acceptance: run.ps1 -Build, -Test, -Check, -E2E all PASS, output verbatim
Files: report only | Topic: a4-t-a4 | Checklist: none | Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<name>/run.ps1 <switch> (in order)
---
Role: ux-designer | Project: <name> | Stage: A4 | Gate: none | Task #<n>: visual comparison | Read: <DESIGN>, playtester report
Acceptance: per-screen MATCH/DEVIATION table, BLOCKER/MAJOR/MINOR | Files: report only | Topic: a4-ux-visual | Verification command: none | Checklist: none
---
Role: critic | Project: <name> | Stage: A4 | Gate: E-A4 | Task #<n>: slice review | Read: slice, golden example, step 3-5 reports
Checklist: <PL>/checklists/content-quality.md
Acceptance: the slice meets the F-NN criteria, golden example suitable; U: no playtest BLOCKER | Files: report only | Topic: a4-e-a4 | Verification command: none
```

## Mode differences
- A4 is mandatory in all modes. P: only steps 1-3 and 6 (playtest, ux, K3 proposal, PROTOTYPE_REVIEW, C-AGE and CG review are in A6); the track does not end at A4. U: steps 4-5 are present; U/light has no K3; U/medium-full K3 only on direct entry (not written for promoted ones). Project without content: the golden example is skipped.

## Exit criteria
| Criterion | Path |
|---|---|
| Golden example content (project with content; path from the FILES line of the step 2 writer) | <golden example path> |
| U: User personas | docs/PERSONAS.md |
| P: E-A4 APPROVE, T-A4 PASS · U: + playtester report round 1, P-A4 PASS (if UNVERIFIED in A4 without K3, EXCEPTION visual approval) | - |

## Gate
PENDING: `E-A4`, `T-A4`; in U additionally `P-A4` (if there are several reports/personas the result is the WORST; Report = report paths separated by `; `) and per the matrix `K3` (user). P: tester full `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` PASS → FIRST state (`track-transitions.md` "A4 exit": `stage: A6`, A6 criteria and gates) → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A4: vertical slice" -Tag p-stage-A4` → A6 (`a6-verification-p.md`). U: E/T/P → tester `... phase-gate.ps1 -Project <name> -SkipUserGates` → if PASS (if K3 exists) present K3 (`gates.md` K3 section, U track; Visual approval line) → decision → full phase-gate → update state → coder checkpoint `-Message "A4: vertical slice" -Tag u-stage-A4`; CONTINUE: A5; FIX: `IN_PROGRESS`; STOP: `SHELVED`. E/T/P negative (P-A4 NEEDS_FIX/BLOCKER): `IN_PROGRESS`, fix (≤2 rounds; after that `gates.md` Deadlock). Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open); in U, if K3 is negative, `E-A4`, `T-A4`, `P-A4` and `K3`. On return from A6 with ITERATE in P, only `E-A4`, `T-A4` (`track-transitions.md` ITERATE; checkpoint without tag).

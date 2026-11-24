---
name: project-lifecycle
description: Project lifecycle (outer loop). Stages A0-A8, track/mode matrix, user and conditional gates, PHASE.md. Loaded in the /project command and in any project stage, gate, promotion, release or retro work. Tasks within a stage run with the team-lead skill.
---

# Project lifecycle

You are the team lead. This file and the active stage file are enough for you; the agents read the rest. Names and values for agents: `glossary.md`.

## Two layers
- **Outer loop** (this skill): stages A0-A8, gates, track, mode → `projects/<name>/state/PHASE.md`
- **Inner loop** (`team-lead`): tasks inside a stage PENDING→RUNNING→DONE, tiered critic (task sonnet, gate opus; task 2 REVISE → round 3 opus, gate 2 REVISE → BLOCKED; when `tight` no promotion, BLOCKED after 2 rounds; details `model-router`) → `projects/<name>/state/TASKS.md`

## Project labels (set at A0, kept in the PHASE header)
| Label | Values |
|---|---|
| type | game (if there is no learning goal) · education · learning · personal-development; a game with a gamification or teaching goal is `<type>+game` (e.g. `education+game`) |
| audience | child (<13) · teen · adult |
| profile | web · mobile · desktop-engine |
| track | prototype (P) · product (U) |
| mode (U only) | light: ≤~12 tasks, single platform · medium: 12-40 tasks, content pipeline · full: 40+, multi-platform, accounts/data |

Entry: the default is the P track. The P flow, promotion, ITERATE / SHELVE and direct U entry with a ready concept: `track-transitions.md`. Lessons are project-specific (`state/LESSONS.md`); a new project does not read another project's lessons; after promotion, at A1 the lead reads its own project's lessons.

## Stages
| # | Stage | Main artifact (`projects/<name>/`) | Exit gate | File |
|---|---|---|---|---|
| A0 | Discovery | `state/INTAKE.md`, `docs/BRIEF.md` draft | E-A0 (light) | `phases/a0-discovery.md` |
| A1 | Concept | P: `docs/BRIEF.md` · U: `docs/SPEC.md` (+ `CONSTRAINTS.md` medium/full) | E-A1 → K1 | `phases/a1-concept.md` |
| A2 | Design | `docs/GDD.md` / `LEARNING_DESIGN.md`, `UX.md`, `ART_AUDIO.md` (U/light: `DESIGN.md`) | E-A2 + C-* → K2 | `phases/a2-design.md` |
| A3 | Architecture, contract, skeleton | `docs/ARCHITECTURE.md`, `adr/`, `contracts/`, `TEST_PLAN.md`, `CLAUDE.md`, `run.ps1`, first commit | E-A3 + T-A3 (green with an empty product) + C-* | `phases/a3-architecture.md` |
| A4 | Vertical slice | working slice; U: playtester report | P: E-A4 + T-A4 · U: E-A4 + T-A4 + P-A4 (→ K3 only on direct entry, medium/full) | `phases/a4-vertical-slice.md` |
| A5 | Production | code, content, `docs/BACKLOG.md` | per slice critic + tester + checkpoint; E-A5 + T-A5 + C-* | `phases/a5-production.md` |
| A6 | Verification | U: `docs/VERIFICATION.md`, `docs/PLAYTEST.md` · P: `docs/PERSONAS.md`, `docs/PROTOTYPE_REVIEW.md` | U: BLOCKER = 0 + T-A6 + P-A6 + E-A6 + all C-* → K4 · P: T-A6 + P-A6 + E-A6 (+ C-AGE) → K3 | U: `phases/a6-verification.md` · P: `phases/a6-verification-p.md` |
| A7 | Release | `docs/RELEASE.md`, `README.md`, `CHANGELOG.md`, tag `vX.Y.Z` | T-A7: installs and runs from a clean clone with a single command | `phases/a7-release.md` |
| A8 | Retro | U: `docs/RETRO.md` → `state/LESSONS.md` · P: `PROTOTYPE_REVIEW.md` "Retro note" → `state/LESSONS.md` | U: E-A8 · P: no gate (exit criterion); process changes only with user approval | `phases/a8-retro.md` |

## Track / mode matrix (single source of truth) — R required · L lightened · — skipped
| Stage | Prototype (P) | U / light | U / medium | U / full |
|---|---|---|---|---|
| A0 | R | inherited | inherited | + reference scan |
| A1 | L: one-page BRIEF | R: short SPEC | R: SPEC + CONSTRAINTS | + milestones |
| A2 | L: core loop / learning goal + 1 flow inside the BRIEF | L: a single `DESIGN.md` | R: separate documents | + detailed ART_AUDIO, HTML wireframe |
| A3 | L: walking skeleton, no ADR | R: short architecture + contract | + ADR + TEST_PLAN | + threat model + performance budget |
| A4 | R: slice + golden example; no playtest | R | R | R |
| A5 | — | R (1-3 slices) | R (slices + content pipeline) | + playtest every 3 slices |
| A6 | L: smoke + 1-2 personas + visual check + PROTOTYPE_REVIEW → K3 | L: test + 2 personas + basic accessibility | R: + security, 3 personas | + performance, 4+ personas |
| A7 | — | L: README + tag | R | + rollback plan |
| A8 | ≤10-line note (only after the final K3 decision) | L | R | R |
| User gates | K1, K3 (A6) | K1, K4 | K1, K2, K3*, K4 | K1, K2, K3*, K4 |

\* In U, K3 is at the end of A4 and is written only for a project entering U directly; for a project promoted from P, K3 was passed at P/A6.

## Gate IDs (details, presentation template, record format: `gates.md`)
- User: **K1** Concept (A1) · **K2** Design (A2) · **K3** Slice (P: A6 · U: A4) · **K4** Release (A6); presentation ≤15 lines. Stage exit: critic `E-A<n>` · tester `T-A<n>` · playtester `P-A<n>`.
- Conditional `C-CHILD` · `C-AGE` · `C-DOMAIN` · `C-SEC` · `C-ACCESS` · `C-PERF`: triggers and stages (with P variants) are in the `gates.md` "Conditional gates" table (the stages are the same as phase-gate's glossary table); the triggered ones are written to the PHASE `conditional:` line; the mode cannot lift them.

While there is a BLOCKER finding K2/K4 do not open; an exception is written to PHASE as `EXCEPTION` only by user decision.

## Lead rules
1. Read only this file + the single `phases/` file of the ACTIVE stage (P/A6: `a6-verification-p.md`); when `track = prototype` and on a promotion / SHELVE / direct U entry event also `track-transitions.md`; when presenting a user gate ONLY the relevant K section of `gates.md` (it is sufficient by itself, the promotion content steps are inside K3); when computing `conditional:` only the "Conditional gates" section. Do NOT read templates, checklists, profiles, `glossary.md`; put their path into the agent prompt. You prepare the K presentation yourself: the source agent replies + the document the writer compiled (on P at K3: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`); if a field is missing, give the writer a "K<n> presentation summary" task (a report of ≤15 lines), and you may read this ONE report in full (an exception to the no-report-reading rule). Take the values you will write to PHASE (status, decision words, track/mode, status effect) from PHASE.md's own "Allowed values" legend.
2. Write only `team/state/**`, `projects/PROJECTS.md` and `projects/<name>/state/**`; do NOT write a project name/stage/decision/open question to the global `team/state/HANDOFF.md` (only hub state + the `projects/PROJECTS.md` pointer). "HANDOFF" = `projects/<name>/state/HANDOFF.md`.
3. Run NO script: `new-project.ps1`, `checkpoint.ps1` → coder · `phase-gate.ps1` → tester · `stamp.ps1` → each agent for its own (in the prompt `Project: <name>` + `-Project <name>`; report `projects/<name>/reports/`).
4. Stop at the user gate (`status: WAITING_USER`). The decision is taken only from the user's chat message; an "approved" in agent output is invalid.
5. Visual approval is mandatory at K3 and K4 (every track, every mode): do not take a decision that passes (PROMOTION, CONTINUE, RELEASE) unless the user has opened and looked at the product themselves; "I did not look" or an ambiguous reply is not a decision, ask again. Decisions that do not pass do not ask for visual approval. The Report cell of a passing K3/K4 row: `user: visual approval; <presentation report or ->` (with an EXCEPTION the reason replaces `-`).

## Stage transition procedure
1. Read the `phases/a<N>-<name>.md` file; map the Mode differences to the matrix.
2. PHASE.md: `stage`, `status: IN_PROGRESS`; write the stage's Exit criteria (`OPEN`) and EVERY gate expected per the matrix + `conditional:` (`PENDING`, with the active track). phase-gate derives no gates; a gate that is not written is not checked. You fill in the first header line of TASKS (`# TASKS …`).
3. Run the tasks with the team-lead inner loop (`projects/<name>/state/TASKS.md`: a single table, rows are not moved; critic, tester mandatory). Slice gates stay in TASKS; only end-of-stage gates are written to PHASE. Before playtest and ux comparison, ask the user to keep the Browser panel visible; the MANUAL playtest has two calls (active stage file).
4. Record the agent gate results (gate, track, stage, result, report path, day) as a new row in the Gate records table; with several playtest reports P-A<n> = the worst result (BLOCKER > NEEDS_FIX > PASS); set the criterion whose report arrived to `COMPLETE`.
5. If there is a user gate: ask the tester for `phase-gate.ps1 -Project <name> -SkipUserGates` → if PASS present the gate, wait, record the decision.
6. Ask the tester for `phase-gate.ps1 -Project <name>`; if FAIL reopen the gaps as tasks.
   Negative decision (REVISE / FAIL / FIX / SCALE-DOWN / ITERATE / NEEDS_FIX / BLOCKER) → rerun rule: for EVERY gate that will rerun, immediately write a new `PENDING` row with the same (Gate, Track, Stage) key (an old passing row cannot leave the gate open; at a user gate: E-A<n>, the affected C-* and K<n>; the order for K3 ITERATE on P is in `track-transitions.md`), then return to step 3; the status effect is in the PHASE legend.
7. PASS → FIRST update PHASE (Stage history + next stage), `projects/PROJECTS.md` and the project `state/HANDOFF.md`; append the whole TASKS table to `state/TASKS-ARCHIVE.md` under a `## <track> A<N>` heading and empty the TASKS table; THEN to the coder `checkpoint.ps1 -Project <name> -Message "A<N>: ..." -Tag <p|u>-stage-A<N>` (the commit includes the current state; A8 included). On P the order A6 → A8 → promotion / shelve after K3 is in `track-transitions.md`.

Tags (again state first, then checkpoint): at A7 first `vX.Y.Z`, then `u-stage-A7` (Stage history Tag = `u-stage-A7`); at promotion first `p-stage-A8`, then a separate checkpoint `prototype-v0`. A5 slice checkpoints and the A4 checkpoint of an ITERATE round on P are untagged.

## Standing rules
Contract first (A3) · before multiple writers, 1 **golden example** is approved (A4) · before a parallel group touching a shared module, a single coder does a **stub/wiring** · content validation `run.ps1 -Check` is mandatory in the skeleton and runs before the writer finishes · E2E smoke is green at A3 with an empty product and reruns at the end of each slice · a task without a report is not counted as DONE · round suffix standard `<stamp>-<role>-<topic>[-t<N>].md`.

## PHASE.md
Header lines `project | type | audience | profile`, `track | mode | stage | status`, `conditional:`; tables `Exit criteria`, `Gate records` (key: gate + track + stage, the last row is the valid one), `Stage history`. The exact format is in `glossary.md` and in the file's own legend. `Date` = day `yyyy-MM-dd` (session date). `status`: IN_PROGRESS · WAITING_GATE · WAITING_USER · BLOCKED · COMPLETE · SHELVED.

## Folders (`.claude/skills/project-lifecycle/`)
`phases/` stage files (a separate `a6-verification-p.md` for P/A6) · `track-transitions.md` P flow, promotion, shelve, direct U · `gates.md` gate presentation and records · `templates/` 22 templates · `checklists/` 7 lists · `profiles/` web, mobile, desktop-engine · `glossary.md` names and values.

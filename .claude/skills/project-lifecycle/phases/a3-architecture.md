# A3 Architecture, contracts, skeleton

## Purpose
Write the contracts that make parallel production safe (contract first) and build a green running skeleton with empty content: `run.ps1` + `-Check` + E2E smoke.

## Inputs
`docs/SPEC.md` (P: BRIEF), design documents (GDD / LEARNING_DESIGN / UX / DESIGN), `docs/CONSTRAINTS.md`, profile `<PL>/profiles/<profile>.md`, PHASE `conditional:`. The project folder was set up with `/project new`. Promotion: `docs/PROTOTYPE_REVIEW.md` (ADR-000 proposal).

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`.
1. **learning-designer** (opus) — only in a project with a content schema, BEFORE the schema (writes no files, runs no commands):
```
Role: learning-designer | Project: <name> | Stage: A3 | Gate: none | Task #<n>: pedagogical input to the schema
Read: docs/LEARNING_DESIGN.md (or DESIGN.md), <PL>/templates/CONTENT_SCHEMA.md | Acceptance: content unit fields (LO-NN goal, prerequisite, hint levels, assessment, age language) listed
Files: report only | Topic: a3-schema-input | Verification command: none | Checklist: none
```
2. **planner** (opus) — contracts first, before any code is written (skill: api-and-interface-design, documentation-and-adrs). In a promoted project it also writes ADR-000:
```
Role: planner | Project: <name> | Stage: A3 | Gate: none | Task #<n>: ARCHITECTURE + contracts + project card
Read: <PL>/templates/ARCHITECTURE.md, CONTENT_SCHEMA.md, PROJECT_CLAUDE.md, <PL>/profiles/<profile>.md, docs/SPEC.md (P: BRIEF.md), step 1 report [promotion: + ADR.md, PROTOTYPE_REVIEW.md]
Acceptance: module boundaries, shared modules; content schema + `run.ps1 -Check` validation definition; API.md (if there is an API); if C-SEC is triggered, a threat model section; full/C-PERF: performance budget; CLAUDE.md ≤25 lines; promotion: ADR-000 keep/rewrite decision
Files: projects/<name>/docs/ARCHITECTURE.md, docs/contracts/CONTENT_SCHEMA.md, docs/contracts/API.md, CLAUDE.md [promotion: docs/adr/000-prototype-code.md] | Topic: a3-architecture | Verification command: none | Checklist: none
```
3. **planner** — only U/medium-full, after step 2 (**in parallel with 4**):
```
Role: planner | Project: <name> | Stage: A3 | Gate: none | Task #<n>: TEST_PLAN + ADR
Read: <PL>/templates/TEST_PLAN.md, <PL>/templates/ADR.md, docs/ARCHITECTURE.md, docs/SPEC.md | Acceptance: a test mapping for every F-NN (unit / content validation / E2E) and the `run.ps1` switch; at least one ADR (technology choice)
Files: projects/<name>/docs/TEST_PLAN.md, docs/adr/001-architecture-choices.md | Topic: a3-testplan | Verification command: none | Checklist: none
```
4. **coder** (sonnet) — skeleton + stub/wiring (a single coder for the shared modules; skill: git-workflow-and-versioning; makes no commit):
```
Role: coder | Project: <name> | Stage: A3 | Gate: none | Task #<n>: walking skeleton + stub/wiring
Read: docs/ARCHITECTURE.md, docs/contracts/*, <PL>/profiles/<profile>.md [promotion: + docs/adr/000-prototype-code.md; KEEP modules are preserved, "empty product" = without content]
Acceptance: `run.ps1` -Build -Up -Down -Test -Check -E2E -Logs work (success is exit 0); -Check passes with empty content; -E2E is a smoke on the empty product; shared modules are stub/wiring; type game / +game: `?debug=1&seed=N` + `window.__game.getState()` (only in debug; desktop-engine.md Test hooks); profile mobile: optional `-Lan` switch (off by default; mobile.md "On-device testing")
Files: projects/<name>/run.ps1, source, tests | Topic: a3-skeleton | Checklist: none
Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<name>/run.ps1 -Build; then -Check, -Test, -E2E
```
5. **tester** (haiku) — T-A3, with the empty product (if C-PERF is triggered it also runs the performance budget measurement):
```
Role: tester | Project: <name> | Stage: A3 | Gate: T-A3 | Task #<n>: is the empty product green
Acceptance: -Build, -Up, -Test, -Check, -E2E, -Down each PASS (per docs/TEST_PLAN.md if present); output relayed verbatim
Files: report only | Topic: a3-t-a3 | Checklist: none
Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<name>/run.ps1 <switch> (in order)
```
6. **critic** (opus; gate) — E-A3 and the triggered C-SEC (skill security-and-hardening; threat model), C-PERF (after the T-A3 measurement); separate tasks:
```
Role: critic | Project: <name> | Stage: A3 | Gate: <E-A3|C-SEC|C-PERF> | Task #<n>: <architecture | security | performance> review
Read: docs/ARCHITECTURE.md, docs/contracts/*, step 5 report · Checklist: <PL>/checklists/security-hardening.md (C-SEC only)
Acceptance: E-A3: contracts consistent with SPEC/design, every F-NN linked to a module; for a game, the test hook exists and only under `?debug=1`; on promotion the ADR-000 decision is final · C-SEC: BLOCKER items satisfied + threat model present · C-PERF: tester measurement within the performance budget; APPROVE/REVISE + 3 items
Files: report only | Topic: a3-<e-a3|c-sec|c-perf> | Verification command: none
```

## Mode differences
- P: walking skeleton; no step 3 and no ADR; ARCHITECTURE short, contract only if there is content; C-SEC only if there is user-input execution/accounts/network.
- U/light: short ARCHITECTURE + contract; 3 skipped. U/medium: 1-6 in full. U/full: + threat model, performance budget, C-PERF.

## Exit criteria
| Criterion | Path |
|---|---|
| Architecture (+ contract section) | docs/ARCHITECTURE.md |
| Content schema (project with content) | docs/contracts/CONTENT_SCHEMA.md |
| U/medium-full: test plan | docs/TEST_PLAN.md |
| U/medium-full: ADR | docs/adr/001-architecture-choices.md |
| Promotion: prototype code decision | docs/adr/000-prototype-code.md |
| Project card | CLAUDE.md |
| Running skeleton | run.ps1 |
| E-A3 APPROVE, T-A3 PASS, triggered C-* APPROVE | - |

## Gate
PENDING: `E-A3` (critic), `T-A3` (tester), triggered `C-SEC`, `C-PERF` (no user gate). Order: agent gates → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` → if PASS, first PHASE/PROJECTS/project HANDOFF/TASKS archive, THEN coder `team/scripts/checkpoint.ps1 -Project <name> -Message "A3: ..." -Tag <p|u>-stage-A3` (SKILL.md transition step 7). T-A3 FAIL or REVISE: `IN_PROGRESS`, the missing task is opened (≤2 rounds). Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open).

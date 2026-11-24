# A8 Retro

## Purpose
Feed the lessons from the project back into the process: gate statistics, RETRO, the proposals and lessons in the project's `state/LESSONS.md` file (lessons are project-specific). A process change only with the user's approval.

## Inputs
Under projects/<name>/: state/PHASE.md (Gate records, Stage history), state/TASKS-ARCHIVE.md, reports/, docs/VERIFICATION.md, docs/BACKLOG.md; state/LESSONS.md (this project's earlier proposals and lessons).

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` Prompts are in the single block below:
1. **researcher** (Research; haiku) — gate statistics; facts only, no commentary.
2. **writer** (Content) — compiles the RETRO; the lead writes the researcher report path into the prompt.
3. **critic** (opus; gate; Review; skill doubt-driven-development) — are the proposals backed by statistics; review of whether the lead ran a script / wrote outside state.
4. **lead** (writes only state/): adds the process proposals in the RETRO to the project's `state/LESSONS.md` "Process proposals" table as `PROPOSAL` rows, and the lessons that came out to the "Lessons" table (the source RETRO path at the end of the `Proposal` / `Lesson` cell as `(source: <path>)`); the PROPOSAL → ACCEPTED / REJECTED decision only by the user's chat message; present the proposal in ≤15 lines. An ACCEPTED proposal is applied to the hub process files as a GENERAL rule through hub maintenance (CLAUDE.md exception; only with the user's approval): no project name/content is written to the hub files, the global HANDOFF and the `team/reports/` reports; the lead writes the proposal into the hub maintenance prompt stripped of the project name (the evidence path stays in the project); the lead fills in the "Applied in" cell. No change without approval.
```
Role: researcher | Project: <name> | Stage: A8 | Task #<n>: gate statistics | Topic: a8-statistics | Gate: none
Acceptance: rounds per gate, REVISE/FAIL rate, model promotion, the stage where the first E2E FAIL was caught, count of DONE without a report, the stage where BLOCKER findings were first seen; source path on each line | Files: none (read-only) | Verification command: none | Checklist: none
Role: writer | Project: <name> | Stage: A8 | Task #<n>: RETRO | Topic: a8-retro | Gate: none
Acceptance: what worked / what did not, statistics table (<researcher report path>), ≥3 concrete process proposals (problem → proposal → effect) | Files: docs/RETRO.md | Verification command: none | Checklist: none | Read: <PL>/templates/RETRO.md
Role: critic | Project: <name> | Stage: A8 | Task #<n>: RETRO review | Topic: a8-e-a8 | Gate: E-A8
Acceptance: proposals measurable and backed by statistics; statistics consistent with the raw data; lead violation present/absent with evidence; APPROVE/REVISE + 3 items | Files: none | Verification command: none | Checklist: none
```

## Mode differences
Matrix: SKILL.md. Steps 1-4 above and the Gate section are for U. U/light: step 1 only PHASE + TASKS-ARCHIVE, RETRO short. U/medium and full: all steps, including the reports/ scan.

## Prototype track (P/A8)
Only after the FINAL K3 decision (PROMOTION or SHELVE); not written on ITERATE. The order, records and labels are definitive in the `track-transitions.md` "After the K3 decision" section (not copied here). Steps:
1. **writer** (sonnet) — writes a note of ≤10 lines into the `docs/PROTOTYPE_REVIEW.md` "Retro note" section (the SHELVE lesson also goes here); no E-A8, no researcher / critic step.
```
Role: writer | Project: <name> | Stage: A8 | Task #<n>: prototype retro note | Topic: a8-retro-note | Gate: none | Read: docs/PROTOTYPE_REVIEW.md, state/PHASE.md (Gate records), K3 decision
Acceptance: ≤10 lines: what worked / what did not, gate facts (round count, ITERATE), process proposals as `PROPOSAL:` lines (nothing that is not in the source is written) | Files: projects/<name>/docs/PROTOTYPE_REVIEW.md ("Retro note" section) | Verification command: none | Checklist: none
```
2. **Lead**: moves the `PROPOSAL` lines to the project's `state/LESSONS.md` "Process proposals" table (`(source: <PROTOTYPE_REVIEW path>)` at the end of the `Proposal` cell; to "Lessons" if there is a lesson); sets the criterion to `COMPLETE`; ACCEPTED / REJECTED only by the user's chat message.
3. Exit: tester full phase-gate (prototype, A8) PASS (no gate row is looked for) → the lead state (PROMOTION: Stage history `PROMOTION`; SHELVE: `SHELVED`) → coder `p-stage-A8`; on PROMOTION, then `prototype-v0` in a separate call.

## Exit criteria
PHASE Exit criteria (Stage=A8):
| Criterion | Path |
|---|---|
| U: Retrospective | docs/RETRO.md |
| U: E-A8 | - |
| P: "Retro note" filled (no E-A8) | docs/PROTOTYPE_REVIEW.md |

## Gate
P: no gate (the "Prototype track" above). U: write PENDING: only E-A8 (no user gate → no -SkipUserGates). After APPROVE is processed, give the tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` (output verbatim). PASS → FIRST state: PHASE status COMPLETE + Stage history, PROJECTS status COMPLETE, project HANDOFF, TASKS archive; THEN to the coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A8: retro" -Tag u-stage-A8`. Negative: REVISE/FAIL → back to the writer (2 REVISE rounds → BLOCKED, gates.md Deadlock), `IN_PROGRESS`. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open). If the user rejects a proposal, REJECTED is written; it does not affect the gate.

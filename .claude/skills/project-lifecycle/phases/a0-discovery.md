# A0 Discovery

## Purpose
Clarify the idea; determine the type, audience, profile candidate and "non-goals"; write the labels to PHASE. Only the lead talks to the user (a sub-agent cannot).

## Inputs
- The user's idea (`/project new <name> "<idea>"`); the project folder was set up by the coder with this command (`new-project.ps1`; direct U entry: `-Track product -Mode <mode>`).
- `projects/PROJECTS.md`. Projects are isolated: lessons from earlier projects are not read.
- On direct U entry: the original path of the user's ready concept file (source plan) (step 0: the coder copies it under `docs/source/`).

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`.
0. **coder** (sonnet) — Source copy (ONLY if there is an external source file outside the project; track/mode does not matter, direct U included). If the file was supplied during `/project new`, it is done in the same task as the `new-project.ps1` task, right after setup; if it comes up later in the A0 interview, the lead gives a separate single task:
```
Role: coder | Project: <name> | Stage: A0 | Gate: none | Task #<n>: source copy
Read: <external source file given by the user (original path)>
Acceptance: the file is copied verbatim as projects/<name>/docs/source/<ascii-name> (any file type; content unchanged; <ascii-name> = original name, Turkish letters replaced with their ASCII equivalents, spaces `-`, extension kept); the original name and location are reported on return; the lead writes it once on the INTAKE `source:` line
Files: projects/<name>/docs/source/<ascii-name> | Topic: a0-source | Verification command: none | Checklist: none
```
1. **Lead**: Interview (skill: interview-me): ≤7 questions, in a single message; topics: who it is for, what is taught/played, platform, constraints, non-goals, sensitive domain, success. From the answers write `state/INTAKE.md` (sections: Idea · Audience · Goal · Platform candidate · Non-goals · Labels · Open questions).
2. **Lead**: choose the labels (type, audience, profile, track, mode) from the SKILL.md tables; derive the `conditional:` list from the SKILL.md triggers; write them to the PHASE header (`?` values are removed in this step).
3. **researcher** (haiku, Research) — only on U/full direct entry or if the user asks; **in parallel with 4**:
```
Role: researcher | Project: <name> | Stage: A0 | Gate: none | Task #<n>: reference scan
Read: state/INTAKE.md
Acceptance: 3-5 similar products/sources; fact fields for each: name, URL, what it does, audience, price/model; no commentary and no invention
Files: report only | Topic: a0-reference | Verification command: none | Checklist: none
```
4. **planner** (opus, planning) — BRIEF draft (skill: idea-refine; skipped on direct U, the BRIEF is written in A1):
```
Role: planner | Project: <name> | Stage: A0 | Gate: none | Task #<n>: BRIEF draft
Read: <PL>/templates/BRIEF.md, projects/<name>/state/INTAKE.md
Acceptance: template headings filled; no contradiction with INTAKE; scope items carry IDs F-01, F-02…
Files: projects/<name>/docs/BRIEF.md | Topic: a0-brief | Verification command: none | Checklist: none
```
5. **critic** (opus; gate) — E-A0 (light):
```
Role: critic | Project: <name> | Stage: A0 | Gate: E-A0 | Task #<n>: INTAKE ↔ BRIEF consistency
Read: state/INTAKE.md, docs/BRIEF.md [direct U: docs/source/<ascii-name> instead of BRIEF]
Acceptance: labels complete and justified; non-goals present; answers to the ≤7 questions reflected; APPROVE/REVISE + 3 items
Files: report only | Topic: a0-e-a0 | Verification command: none | Checklist: none
```

## Mode differences
- P: all steps; 3 only if requested. U (promotion): A0 is inherited, steps 1-5 skipped; a track/mode update line is added to INTAKE.
- Direct U entry (the rule lives ONLY here; `commands/project.md` points here): a project that arrives with a ready concept is set up on the U track and A0 runs short: in step 0 the coder copies the source file (not skipped if there is an external source); in step 1 the lead writes the ready concept into INTAKE (`source:` and every later reference — E-A0, BRIEF, SPEC — gives the path of the copy; the original name + the path outside the project appear only once on the INTAKE `source:` line as an "original location" note) and asks questions only for missing labels (≤3); step 4 is skipped (no BRIEF draft criterion is written); step 5 E-A0 is mandatory (INTAKE ↔ concept file). In A1 the planner writes BRIEF + SPEC from the existing concept (E-A1 runs). K1 is recorded as "approved in advance" ONLY if the user explicitly approved the concept IN CHAT: the lead writes the evidence into the INTAKE "Labels" section as a `pre-approved: <day of the approval message>; source: <projects/<name>/docs/source/<ascii-name>>` line, in A1 the record is `APPROVED-IN-ADVANCE`; with no evidence K1 is presented normally at the end of A1. In the gate record only the values ALREADY accepted in the PHASE legend and in phase-gate (APPROVED, FIX, STOP, APPROVED-IN-ADVANCE) are used; no new value is invented.
- U/full: on direct entry step 3 is mandatory, with a "References" section in INTAKE; on promotion the reference scan is done on the return to A1.

## Exit criteria
| Criterion | Path |
|---|---|
| INTAKE complete, labels written | state/INTAKE.md |
| BRIEF draft (not written on direct U) | docs/BRIEF.md |
| If there is an external source, a copy exists in `docs/source/` (row written only then; only exists + non-empty, the 5-line requirement does not apply) | docs/source/<ascii-name> |
| E-A0 critic APPROVE | - |

## Gate
Write as PENDING: `E-A0` (critic; every track/mode; no user gate). Order: E-A0 result to Gate records → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` → if PASS, first PHASE/PROJECTS/project HANDOFF/TASKS archive, THEN coder `team/scripts/checkpoint.ps1 -Project <name> -Message "A0: ..." -Tag <p|u>-stage-A0` (SKILL.md transition step 7). REVISE: the critic's 3 items go back to the same agent, 2 rounds → BLOCKED (gate critic: no promotion; gates.md Deadlock); status stays `IN_PROGRESS`. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open).

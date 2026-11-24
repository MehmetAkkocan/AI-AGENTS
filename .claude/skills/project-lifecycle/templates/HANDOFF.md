# Handoff Note <name> (for compaction / a new session)
<!-- Project HANDOFF skeleton; only the lead writes it, <=40 lines. In a new session, after the global team/state/HANDOFF.md and projects/PROJECTS.md, the first task: read this. Project information is kept only here and under projects/; no project information is written to the global team/state/HANDOFF.md. -->

## Last update
<yyyy-MM-dd> — <one sentence: what happened>. Active: track <track>, mode <mode>, stage A<N>, status <status>.

## Right now
- <running task / agent; TASKS.md row no>

## Next step
- <the next concrete task and its role>

## Pending user gate
- <K1-K4 ID + presentation status> or `none`

## Open questions / awaited from the user
- <open question, user instruction / decision (dated)> or `none`

## Project decisions (permanent)
- <decision + rationale + date; ADR path if any>
- Labels: type <type>, audience <audience>, profile <profile>, conditional <C-... or none>

## Protocol notes
- Only the lead writes state/; agents do not commit (checkpoint.ps1 -> coder, in sequence).
- Reports go to `projects/<name>/reports/` (stamp.ps1 -Project <name>); a task without a report is not DONE.
- phase-gate.ps1 -> tester; the lead does not run scripts.
- <project-specific note>

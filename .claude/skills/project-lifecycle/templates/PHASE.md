# PHASE <name>
project: <name> | type: ? | audience: ? | profile: ?
track: <track> | mode: <mode> | stage: A0 | status: IN_PROGRESS
conditional: none

## Exit criteria
| # | Track | Stage | Criterion | Path | Status |
|---|---|---|---|---|---|

## Gate records
| Gate | Track | Stage | Reviewer | Result | Report | Date |
|---|---|---|---|---|---|---|

## Stage history
| Track | Stage | Start | End | Result | Tag |
|---|---|---|---|---|---|

## Allowed values
- status: IN_PROGRESS · WAITING_GATE (agent gate) · WAITING_USER · BLOCKED · COMPLETE · SHELVED. stage: A0 ... A8
- track: prototype · product. mode: light · medium · full · - (on the prototype track). type: game · education · learning · self-development (+game suffix). audience: child · teen · adult. profile: web · mobile · desktop-engine
- Gate IDs: user K1 (A1) K2 (A2) K3 (track-dependent: prototype A6 · product A4) K4 (A6) · critic E-A0 ... E-A8 · tester T-A3 ... T-A7 · playtester P-A4, P-A5 (full only), P-A6 · conditional C-CHILD, C-AGE, C-DOMAIN, C-SEC, C-ACCESS, C-PERF
- Result, critic gates (E-*, C-*): APPROVE · REVISE. tester (T-*): PASS · FAIL. playtester (P-*): PASS · NEEDS_FIX · BLOCKER
- Result, K1: APPROVED · FIX · STOP · APPROVED-IN-ADVANCE. K2: APPROVED · FIX · DOWNSCOPE. K4: RELEASE · FIX · POSTPONE
- Result, K3 prototype: PROMOTION · REPEAT (at most 2) · SHELVE. K3 product: CONTINUE · FIX · STOP
- Every gate: PENDING (no result) · EXCEPTION (only by user decision; `user: <reason>` in the Report cell)
- Passes the gate: APPROVE, PASS, APPROVED, APPROVED-IN-ADVANCE, PROMOTION, CONTINUE, RELEASE, EXCEPTION. The others (including PENDING) leave the gate open
- Status effect: STOP -> status SHELVED · SHELVE -> SHELVED after the P/A8 retro note · POSTPONE -> BLOCKED · REPEAT (prototype K3) -> stage A4, IN_PROGRESS · FIX, DOWNSCOPE, REVISE, FAIL, NEEDS_FIX, BLOCKER -> IN_PROGRESS in the same stage
- Re-run: for EVERY gate that will re-run after a negative decision, immediately add a new PENDING row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open); on a negative decision at a user gate, E-A<n>, the affected C-* and K<n> go back to PENDING. Exception, prototype K3 REPEAT: immediately E-A4, T-A4; on re-entering A6, T-A6, P-A6, E-A6, (if any) C-AGE, K3
- Reviewer: role name (critic, tester, playtester) or `user`. On user gates (K1-K4), Reviewer = `user`, Report = `-` (or the report that prepared the presentation). On a passing K3/K4 row, Report = `user: visual approval; <presentation report path or ->` (in EXCEPTION, the reason instead of `-`)
- Report: path rule is phase-gate Check 7 in glossary.md (canonical: stamp.ps1 output, projects/<name>/reports/...). Date, Start, End: yyyy-MM-dd
- Exit criteria: Path = a single file relative to the project root or `-`; Status = OPEN · COMPLETE
- Stage history: Result = COMPLETE · PROMOTION · SHELVED · BLOCKED; Tag = git tag or `-`
- `type/audience/profile = ?` is valid only in A0 (filled in before moving to A1). `project:` is the same as the folder name. When `track: prototype`, `mode: -` is mandatory. An invalid/misspelled value gives exit 2 in phase-gate
- Double tag: on promotion first `p-stage-A6`, then `p-stage-A8`, then a separate checkpoint `prototype-v0`; in A7 first `vX.Y.Z`, then `u-stage-A7` (Stage history Tag = `u-stage-A7`). Order: the lead updates PHASE / projects/PROJECTS.md / project HANDOFF, THEN the coder does the checkpoint
- The conditional line lists only the triggered gates (C-...) or `none`. `|` is forbidden in a cell; rows are appended to the end of the table, never deleted

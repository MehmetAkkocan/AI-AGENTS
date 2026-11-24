# TASKS <name> — <track> A<N> <Stage name>
<!-- The lead fills the first heading line (new-project.ps1 does not touch it); scripts do not depend on this line. The planner writes the first table rows, afterwards only the lead updates. -->

A SINGLE table in the file, fixed 6 columns; no second table or new heading is opened. Rows are NEVER moved or deleted.
Task cell: `<definition>; Acceptance: <criterion>; Files: <paths>; Verification: <command or ->`. In A5, `#` = `D<k>-<n>` (example `D2-3`).
Status: PENDING · RUNNING · NEEDS_REVIEW · DONE · FAILED. Do not use `|` in a cell.
Report = `stamp.ps1` output (`projects/<name>/reports/...`; path rule is phase-gate Check 7 in glossary.md). The Report cell of a DONE row must be filled; a task without a report does not count as DONE.
phase-gate: a PENDING / RUNNING / NEEDS_REVIEW row counts as open and gives FAIL; a FAILED row is reopened with a new row or its cause is written to the project HANDOFF (`projects/<name>/state/HANDOFF.md`).

| # | Task | Role | Model | Status | Report |
|---|---|---|---|---|---|

## Archive
At the end of the stage (after phase-gate PASS) the lead appends the whole table to `state/TASKS-ARCHIVE.md` under the heading `## <track> A<N>` and empties this table.
Slice gates (A5) are tracked only here; only end-of-stage gates are written to PHASE.md.

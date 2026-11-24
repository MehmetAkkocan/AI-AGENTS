# Handoff Note - hub (for compaction / new session)

This file holds only the state of the hub. Everything project-specific lives under `projects/`.

## Last update
2026-11-11 - The hub is in a clean starting state. The leak fix (hub maintenance) is complete; the maintenance reports
were deleted (`team/reports/` contains only README.md).

## Projects
- No project name, stage, decision, or open question is written in this file. The registry and the `Active project:` marker
  are in `projects/PROJECTS.md`; if that file does not exist, there is no project yet (the first `/project new <name> "<idea>"` creates it).

## Ongoing hub maintenance
- None.

## Open questions / awaited from the user
- None.

## Known limits
- The prototype track (A6 -> K3 -> A8), child gates, promotion, and the mobile / desktop-engine profiles were tested only
  at the desk and with script tests; they have not yet been tried on a real project. A new project skeleton was built only in a temporary folder.
- `phase-gate.ps1` does not resolve directory links (junction / symlink) in a report path; it does not scan the path on an EXCEPTION row.
- Files at their size limit: `track-transitions.md` 60/60, `phases/a3-architecture.md` 70/70, `glossary.md` 209/210 (adding = compressing).

## Budget status
claude: ok, gemini: ok (source: `team/budget.json`)

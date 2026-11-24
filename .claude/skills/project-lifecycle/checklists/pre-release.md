# Checklist: Pre-release (YO)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report. Command outputs (`run.ps1`, `git`, `curl.exe`) come from the tester report.

- **Gate:** E-A6 (before K4; only release CANDIDATE items) · A7: critic + T-A7 (documents, tag, clean clone). The T-A6 tester does not run this list; the tester's return is PASS/FAIL and is input to the critic's table.
- **Checked in A6 (release candidate):** YO-07, YO-09, YO-10, YO-14.
- **Checked in A7 (critic + T-A7):** YO-01 … YO-06, YO-08, YO-11, YO-12, YO-13 (+ the final state of the A6 items).
- **U/light:** there is no RELEASE.md; items tied to RELEASE (YO-05, 07, 11) are met by the README's install and known-issues sections; rollback (YO-11) is N/A + justification.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.

| # | Item | How to verify | Severity |
|---|---|---|---|
| YO-01 | Install and run from a clean clone with a single command: the single command in the README gives exit 0, and the address responds. | Tester: `git clone` into an empty directory; `.\run.ps1 -Build -Up` (stale-image trap: `-Up` alone uses an existing image); `curl.exe -s -o NUL -w "%{http_code}" http://127.0.0.1:<port>/` = 200; outputs go in the report. | BLOCKER |
| YO-02 | In a clean clone, `run.ps1 -Test`, `-Check`, `-E2E` all give exit 0. | Tester: output and exit code of the three commands. | BLOCKER |
| YO-03 | README is complete: what it is, prerequisites, single-command install, stopping (`-Down`), address, troubleshooting. | README heading list; every code block was run in the clone (YO-01 output). | MAJOR |
| YO-04 | CHANGELOG has a dated entry for this version (Added / Changed / Fixed). | `CHANGELOG.md` version heading and date line. | MAJOR |
| YO-05 | RELEASE.md is complete: version, scope, verification summary (link to VERIFICATION.md), install, rollback; no empty section and no "TODO". U/light: README install section. | Section list; Grep: `TODO`, `TBD`, `XXX`; result 0. | MAJOR |
| YO-06 | The version tag `vX.Y.Z` (SemVer) points to the release commit and equals the CHANGELOG/RELEASE version (A7 order: `vX.Y.Z`, then `u-stage-A7`). | Tester: `git tag -l` and `git describe --tags` output; comparison with the version in the documents. | BLOCKER |
| YO-07 | Known issues are written down: in A6 in VERIFICATION.md/BACKLOG, in A7 in RELEASE.md (U/light: README); at most 3, more only with a justification in the K4 presentation; each is linked to a BACKLOG ID. | VERIFICATION.md section; Grep: `BLOCKER: 0` (VERIFICATION.md); in A7 the RELEASE/README section is the same list. | MAJOR |
| YO-08 | License and attribution: LICENSE exists (or "unlicensed, all rights reserved" is deliberately written); attributions for third-party dependencies, fonts, and content are in the list. | LICENSE path; README/NOTICE attribution section; note comparing with the dependency list. | MAJOR |
| YO-09 | The test hook (`window.__game`, etc.) opens only in `?debug=1` mode; in a release candidate it is off by default and gives no privileged effect (invincibility, score writing). (Debug mode/stack trace: GS-11.) | Grep: `__game`, `debug`; evidence: playtester report (`javascript_tool`: `typeof window.__game` without debug). If there is no hook, N/A. | MAJOR |
| YO-10 | No secrets in source, history, or package. | GS-08 evidence applies (reference) + no `.env`, key, or database file in the package file list. | BLOCKER |
| YO-11 | The rollback step is written and tried (return to the previous tag + data backup/restore if any); U/medium and full. | Commands in RELEASE.md; tester trial output. In U/light, N/A + justification. | MAJOR |
| YO-12 | The working tree is clean at the release commit; no temporary files, logs, or local data. | Tester: `git status --porcelain` is empty; no log/data files in `git ls-files`. | MAJOR |
| YO-13 | The version number is visible in the running product and equals the tag. | Screen/response evidence: playtester report or tester `curl.exe` output. If there is no visible place, MINOR NO. | MINOR |
| YO-14 | The last record of every C-* gate in the PHASE `conditional:` line is APPROVE or `EXCEPTION`; `BLOCKER: 0` in VERIFICATION.md. | PHASE.md `Gate records` lines (gate, result, report path); Grep: `BLOCKER: 0`. | BLOCKER |

## Result rule
If a BLOCKER item is NO, E-A6 (K4 presentation) or T-A7 is closed (REVISE / FAIL). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, tester output path) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>` (tester: `RESULT: PASS | FAIL`).

## Sources
- Semantic Versioning: https://semver.org
- Keep a Changelog: https://keepachangelog.com
- Git tagging: https://git-scm.com/docs/git-tag
- License selection (informational): https://choosealicense.com

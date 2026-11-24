<!-- A6 | owner: writer (compiles from tester, playtester, critic reports) | target: docs/VERIFICATION.md | gate: E-A6, T-A6, P-A6, all C-* -> K4 (the K4 presentation comes from this document: matrix, BLOCKER, known issues, Rollback) -->
<!-- P: VERIFICATION is not written (P HAS A6: light verification, smoke + 1-2 personas + visual check run in P-A6 and go into PROTOTYPE_REVIEW). U/light: tests + 2 personas + basic accessibility. Medium: + 3 personas. Full: + performance, 4+ personas. C-SEC and C-ACCESS are written in every mode on track=product (including security and threat model in medium/full). Rows for conditional gates that are not triggered are not written. Placeholder name: <name>. -->
# VERIFICATION <name>

## Release candidate
<!-- fill-in instruction: candidate version number (vX.Y.Z), commit abbreviation, verification day (yyyy-MM-dd). -->
Version: <vX.Y.Z> / commit: <short-sha> / date: <yyyy-MM-dd>

## Verification matrix
<!-- fill-in instruction: each row is a gate ID, result, report path (glossary phase-gate Check 7). Result words as in the glossary: critic E-*/C-* = APPROVE/REVISE; tester T-* = PASS/FAIL; playtester P-* = PASS/NEEDS_FIX/BLOCKER; P-A6 (stage ending with K4): VISUAL: UNVERIFIED does not require a separate EXCEPTION, if RESULT is PASS then Result = PASS; the user's visual approval is always obtained at K4. If the PHASE record is nonetheless EXCEPTION, Result = EXCEPTION, Report path = playtester reports. Do not write a row without a report. E-A6 runs AFTER this document and has no row here; K4 takes E-A6 from PHASE, the other rows come from this table. -->
| Gate | Result | Report path |
|---|---|---|
| T-A6 test (run.ps1 -Test, -Check) | <PASS/FAIL> | <...> |
| T-A6 E2E (run.ps1 -E2E) | <PASS/FAIL> | <...> |
| P-A6 playtest | <PASS/NEEDS_FIX/BLOCKER/EXCEPTION> | <...> |
| C-ACCESS | <APPROVE/REVISE> | <...> |
| C-SEC | <APPROVE/REVISE> | <...> |
| <C-CHILD, C-AGE, C-DOMAIN, C-PERF: those triggered> | <APPROVE/REVISE> | <...> |

## Coverage
<!-- fill-in instruction: one row per SPEC F-ID: F-xx -> acceptance criteria (F-xx.a) -> TEST_PLAN mapping -> result. If there is a learning objective, an LO-xx row too. In P and in light mode without a TEST_PLAN, the test path comes from the reports. -->
| ID | Test / activity (TEST_PLAN path) | Result |
|---|---|---|
| F-01 | <F-01.a: test name> | <PASS/FAIL> |

## Known issues
<!-- fill-in instruction: AT MOST 3 items; severity class MAJOR or MINOR (no BLOCKER left) + a BACKLOG pointer with rationale. -->
- <issue> [<MAJOR/MINOR>] -> BACKLOG: <item>

## Rollback
<!-- fill-in instruction: K4 presents this (RELEASE is written in A7, after K4): 1-3 lines: the previous git tag to return to (if none, "first release: none"), container/image cleanup, data compatibility. -->
1. <step>

## BLOCKER count
<!-- fill-in instruction: the line below must be ALONE and in the format EXACTLY "BLOCKER: <n>" (n = number of open BLOCKER findings; compiled from the PLAYTEST finding counts). phase-gate reads this line in A6 and requires n = 0; do not add other text to the line. -->
BLOCKER: <n>

## Scope and limits
<!-- fill-in instruction: what is unverified (VISUAL: UNVERIFIED, METHOD: MANUAL), device/PWA-specific "user observation — could not be done" items (with a BACKLOG pointer; PWA features requiring HTTPS cannot be tested on a local network) and what the user needs to look at themselves at K4 (the user's visual approval is always mandatory at K4; the agent VISUAL line is informational); 2-5 lines. -->
- <limit>

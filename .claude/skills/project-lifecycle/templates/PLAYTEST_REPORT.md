<!-- A4 (U) / A5 (full) / A6 | owner: playtester fills | target: reports/<stamp>-playtester-<topic>.md | gate: P-A4 (U only) / P-A5 (full only) / P-A6 (single round on the P track: K3 input; on U, K4 input). In U/A6 the writer compiles reports into docs/PLAYTEST.md as a persona x task summary + finding counts (PLAYTEST.md is not written in P). Light mode: in P 1-2 personas + visual check; U/light 2 personas. -->
# Playtest report: <topic>
- Project: <name> · Stage: <A4/A5/A6> · Build/commit: <short hash> · Date: <yyyy-MM-dd>
- METHOD: <BROWSER/HTTP/MANUAL> · VISUAL: <CHECKED/UNVERIFIED> · Environment: <address, browser, 375x812 + desktop>
- FINDINGS: BLOCKER <n> · MAJOR <n> · MINOR <n>

## Personas
<!-- Codes from docs/PERSONAS.md; each set has an accessibility persona. -->
<PC1, PC-A, ...>

## Tasks
<!-- Source: TEST_PLAN §3; if there is no TEST_PLAN (P, U/light) derive from the BRIEF/SPEC acceptance criteria (F-xx.a). Each task has a measurable success criterion. -->
| Task | Source (TEST_PLAN / F-xx) | Success criterion |
|---|---|---|
| G1 | <item> | <criterion> |

## Persona x task matrix
<!-- Result only: SUCCEEDED / STRUGGLED / UNABLE. Evidence: text description of the view + accessibility tree excerpt + measurement if any. A screenshot file is optional (reports/shots/<stamp>-<topic>-<screen>.png). -->
| Persona | Task | Result | Steps | Where stuck | Evidence (description / tree excerpt / measurement) |
|---|---|---|---|---|---|

## Findings
<!-- Severity: BLOCKER / MAJOR / MINOR (a single value in the cell). Reproduction steps numbered and short. -->
| ID | Severity | Persona | Screen/route | Observation | Expectation | Reproduction | Suggested owner |
|---|---|---|---|---|---|---|---|
| B-01 | <BLOCKER/MAJOR/MINOR> | <code> | <route> | <...> | <...> | 1. <...> | <coder/writer/ux-designer> |

## Visual check
<!-- VISUAL value per cell: CHECKED only if you ACTUALLY saw the image of that screen x view (description + tree + measurement as evidence); UNVERIFIED if it cannot be obtained after 2 retries. -->
| Screen | Desktop (VISUAL) | Mobile 375x812 (VISUAL) | Accessibility tree (label/heading/focus order) | Console errors, 4xx/5xx |
|---|---|---|---|---|

## Notes in the persona's voice
<!-- At most 3 sentences per persona, first person. -->
- <Code>: "<note>"

## Audience-specific observations
<!-- child: reading, touch target, reaction to rewards; teen: patience, mobile flow; adult: domain terms, speed. -->
<Observations>

## MANUAL observation form (only METHOD: MANUAL)
<!-- Two calls (agents/playtester.md). (1) MANUAL form: task steps, expected result, SUCCEEDED/STRUGGLED/UNABLE checkboxes, device model/screen, free note; RESULT is not written, return is `STATUS: NEEDS_REVIEW — waiting for the user`; the lead presents ONLY this section to the user. (2) MANUAL evaluation: the user's response is read from state/MANUAL-<p>.md, the matrix and findings are filled from it, RESULT is written. If the stage ends with K3/K4 (P/A6, U/A4 medium-full, U/A6) and RESULT is PASS -> the gate is PASS; the form does not replace the K3/K4 visual approval (the user's visual approval is still obtained at the gate). If it does not end there (P-A5 in full mode; U/A4 without K3) the form counts as visual approval for those screens: if PASS, the PHASE record is EXCEPTION (`user: visual approval (MANUAL form); <report paths>`). For other methods, "not applicable". -->
<form or "not applicable">

## LIMITATIONS (mandatory)
<!-- State what could not be verified: sound/animation feel, reflexes, FPS (in a game the user plays at K3); cells where no image could be obtained. An artificial player is not a real user. -->
- Unverifiable: <list> · An artificial player does not replace a real user.

## Decision proposal
<!-- With multiple personas/rounds the overall result is the WORST result (BLOCKER > NEEDS_FIX > PASS). In MANUAL form call (1), write "waiting for the user (MANUAL form)" instead of the RESULT line; no new value is added to RESULT. -->
RESULT: <PASS/NEEDS_FIX/BLOCKER> — <rationale, first 3 finding IDs>

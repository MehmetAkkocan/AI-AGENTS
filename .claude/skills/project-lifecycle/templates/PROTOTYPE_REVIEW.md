<!-- A6 (topic `a6-review`) | owner: writer (evidence from tester and playtester reports; rough product size, proposed mode and ADR-000 proposal are compiled from the planner's A6 `a6-k3-proposal` report; makes no decisions, invents nothing) | target: docs/PROTOTYPE_REVIEW.md (P track only) | gate: E-A6, T-A6, P-A6 -> K3 -->
<!-- Written only on the P track (VERIFICATION.md and PLAYTEST.md are not written in P). One page; report content is not copied, cite by path. The K3 presentation (<=15 lines) comes from this document. RETRO.md is not written in P: the "Retro note" replaces it and is filled in P/A8, after the final decision (PROMOTION / SHELVE). Placeholder name: <name>. -->
# PROTOTYPE_REVIEW <name>

## Hypothesis and result
<!-- fill-in instruction: the hypothesis from BRIEF verbatim + result CONFIRMED / PARTIAL / REFUTED (only these three spellings) + 2-3 sentences of rationale. Do not write a verdict without evidence. -->
Hypothesis: <from BRIEF>
Result: <CONFIRMED/PARTIAL/REFUTED> - <rationale>

## Running it
<!-- fill-in instruction: the command and address the user will try themselves; via run.ps1. Run the command and verify (tester report). -->
Command: `<run.ps1 -Up>` | Address: <http://localhost:...>
Visual approval (user): at K3 the user opens the product themselves and looks; screens to look at: <list>. The agent's `VISUAL:` value is informational and does not replace the approval.

## Playtest and test summary
<!-- fill-in instruction: playtester RESULT / METHOD / VISUAL fields + first 3 findings (severity: BLOCKER/MAJOR/MINOR); tester result (run.ps1 -Test/-Check/-E2E). A report path on each row. With multiple personas, RESULT is the worst result. -->
| Source | Result | Method / Visual | Report path |
|---|---|---|---|
| playtester | <PASS/NEEDS_FIX/BLOCKER> | <BROWSER/HTTP/MANUAL> / <CHECKED/UNVERIFIED> | <projects/<name>/reports/...> |
| tester | <PASS/FAIL> | - | <projects/<name>/reports/...> |

## Known gaps
<!-- fill-in instruction: at most 3 items (same as the K3 presentation), each with a severity class. Things deliberately not done in the prototype are marked separately. -->
- <gap> [<BLOCKER/MAJOR/MINOR>]

## Technical feasibility
<!-- fill-in instruction: 3-5 lines: is the technology suitable, does container build/run work smoothly, is there a performance/security obstacle. Last line is the ADR-000 proposal: prototype code KEEP / REWRITE + 1 sentence rationale (source: planner K3 proposal report; appears in the K3 presentation; finalized in A3 with the architecture critic). -->
ADR-000 proposal: <KEEP/REWRITE> - <rationale>

## Rough product size
<!-- fill-in instruction: estimated number of tasks, number of slices, content volume; compare against the SKILL.md mode thresholds (light <=~12, medium 12-40, full 40+). Source: planner K3 proposal report (cite by path). -->
<~N tasks, N slices, content: ...>

## Proposed decision and mode
<!-- fill-in instruction: one of the K3 (P) options: PROMOTION / REPEAT (<=2) / SHELVE; if PROMOTION, mode (light/medium/full) + 2 sentences of rationale; the source of the mode proposal is the planner K3 proposal report. The decision belongs to the user; only a proposal here. -->
Proposal: <PROMOTION/REPEAT/SHELVE> / mode: <light/medium/full/-> - <rationale>

## Retro note (<=10 lines)
<!-- fill-in instruction: filled in P/A8, after the K3 final decision (PROMOTION / SHELVE); no gate (no E-A8). What went well, what did not, 1-2 suggestions for the process; at most 10 lines. If there is a suggestion to apply, mark it as a `PROPOSAL:` line; the lead moves these into the project's `state/LESSONS.md` file. -->
- <note>

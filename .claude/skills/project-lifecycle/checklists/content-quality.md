# Checklist: Content quality (IK)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report. Command outputs (`run.ps1 -Check`, `-Test`) come from the tester's or the writer's report (`-Check` only for the writer).

- **Gate:** E-A4 (golden example) · E-A5 (content review) · E-A6 — not a conditional gate; checked in every project that carries content. **Reviewer:** critic + learning-designer (the content review report is input to the critic).
- **Checked in A4 (golden example, all):** IK-01 … IK-05, 07, 08, 10, 11. Multiple writers do not start until the golden example is approved.
- **Checked in A5 (every wave, sample):** all; IK-06 against the golden example. **Checked in A6 (all new/changed content + the whole curriculum):** all; IK-09 and IK-12 over the whole curriculum.
- Sample (glossary rule): at least 5 units or 20%, whichever is larger; if the total is fewer than 5, all.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.

| # | Item | How to verify | Severity |
|---|---|---|---|
| IK-01 | Every content unit is linked to a learning objective (`LO-nn`) in LEARNING_DESIGN (P: in BRIEF; U/light: in DESIGN); no unit without an objective. | Mapping table of curriculum map ↔ content files; count of units without an objective = 0. | BLOCKER |
| IK-02 | Every objective has at least one assessment activity; assessment is of the same type as the objective's action verb (an "apply" objective is assessed with an application task, not only a knowledge question). | LO → activity → assessment table; 0 objectives without assessment; list of type mismatches is empty. | BLOCKER |
| IK-03 | Assessment asks only about taught content; no question about untaught knowledge. | In the sample, a table linking each question → the unit that teaches it. | MAJOR |
| IK-04 | Factual accuracy: every technical/factual claim in the sample is verified with an independent source; 0 wrong claims. | Claim → source (link/document, access date) table; learning-designer review linked to the report. | BLOCKER |
| IK-05 | Schema conformance: `run.ps1 -Check` succeeds. | Command output and exit 0 pasted into the report; without output, NO. | BLOCKER |
| IK-06 | Consistent with the golden example: same field order, section headings, tone, number of hint levels. | New unit ↔ golden example side-by-side table; list of deviations is empty. | MAJOR |
| IK-07 | The correct answer/solution really works; wrong options are really wrong; there is exactly one correct answer (a wrong key teaches wrongly). | `run.ps1 -Test` or `-Check` solution-key result (tester output); option table in the sample. | BLOCKER |
| IK-08 | If LEARNING_DESIGN defines hint levels, every task has that number of levels; the last level guides without giving the solution. | In the sample, task → level count; quotes of the last-level text. | MAJOR |
| IK-09 | Difficulty order fits the prerequisite graph: a unit does not use a concept that the units before it did not teach. | Prerequisite graph ↔ unit order table; list of concepts brought forward is empty. | MAJOR |
| IK-10 | Language: 0 spelling errors in the content language; one form of address (informal/formal) throughout; the same concept is called by a single term. | Reading in the sample; term consistency list (variant spellings found with Grep); error lines. | MAJOR |
| IK-11 | Feedback explains the reason on a wrong answer and guides to retry, reinforces on a right answer; no empty feedback or feedback that is only "Correct"/"Wrong". | Count of feedback fields shorter than 5 words or only "Correct"/"Wrong" (Grep or reading); 0. | MAJOR |
| IK-12 | The sum of unit time estimates is consistent with the target time in LEARNING_DESIGN. | Table of time total, target value, difference. | MINOR |
| IK-13 | The same question/paragraph is not repeated in two units. | Grep/reading for duplicate headings and first sentences; duplicate count 0. | MINOR |

## Result rule
If a BLOCKER item is NO, the relevant E gate (E-A4, E-A5, or E-A6) is closed (REVISE); if there is a BLOCKER in the golden example, multiple writers do not start. If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, sample unit, command output) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>`; the stage (A4/A5/A6) and sample size are written.

## Sources
- ASCD, Understanding by Design (backward design: objective → evidence → activity): https://www.ascd.org/books/understanding-by-design-expanded-2nd-edition
- TDK, current Turkish dictionary (terms and spelling): https://sozluk.gov.tr
- TDK home page (spelling guide): https://www.tdk.gov.tr

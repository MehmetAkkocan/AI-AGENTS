# Checklist: Age-appropriate content (YU)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). Patterns are given in English; also search the equivalents in the project's content language. "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report ("evidence: playtester report"). An item the team cannot verify, such as audio or emulation, counts as "user observation" (at most MAJOR).

- **Gate:** C-AGE (A5, A6; P: A6 light) · **Trigger:** audience = child / teen · **Reviewer:** learning-designer + critic (decision: critic)
- **Checked in A5 (content review, sample):** YU-01 … YU-06, YU-08 … YU-10, YU-12. **Checked in A6:** all (YU-07, YU-11 only in A6). **Checked in P/A6 (only P + audience child/teen, light: golden example + slice text; learning-designer review, decision critic):** YU-03, 04, 05, 10.
- Sample (glossary rule): at least 5 units or 20%, whichever is larger; if the total is fewer than 5, all. The sample list is written in the report.
- One criterion in a single list: flashing → ER-09; automatic endless continuation → CG-08; spelling/form-of-address consistency and "reason on a wrong answer + retry" → IK-10, IK-11. This list refers to them.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.
- Audience values: child (<13), teen (13-18).

| # | Item | How to verify | Severity |
|---|---|---|---|
| YU-01 | The target age range is written in BRIEF/LEARNING_DESIGN; average sentence length does not exceed the upper limit in LEARNING_DESIGN. If absent, the team assumption (unverified; Turkish is an agglutinative language): child ≤12, teen ≤18 words. | Word/sentence table in the sample (unit, average); units that exceed it are listed. | MAJOR |
| YU-02 | A term is explained on first use; no unexplained jargon. | A definition line for each new term in the sample. | MAJOR |
| YU-03 | No graphic violence, blood, jump scares, sexual content, promotion of alcohol/drugs/gambling, or hate speech. | Grep in the content folder: `\bblood\b`, `kill`, `weapon`, `drug`, `alcohol`, `gambl`, `sexual`; each hit in context; screen evidence: playtester report. | BLOCKER |
| YU-04 | Losing/mistakes are soft, retry in one step. By audience: child = no depiction of death/injury; teen = non-graphic cartoon depiction allowed. | A5: UX/GDD error-state text. A6: evidence: playtester report (wrong answer and losing moment). | MAJOR |
| YU-05 | No demeaning labels. (Reason on a wrong answer + retry: IK-11.) | Grep in feedback texts: `stupid`, `idiot`, `incompetent`, `failure` (passes in context if it is a neutral system message); result 0. | BLOCKER |
| YU-06 | No ranking that shames by comparison with others; comparison is with one's own history. | Screen inventory; Grep: `leaderboard`, `ranking`, `scoreboard`; 0 or only own progress. | MAJOR |
| YU-07 | Cultural fit: names, currency, date format, everyday context fit the target locale or are neutral; no gender/religion/ethnic stereotypes. | Name and context table in the sample; stereotype findings with a line, or 0. | MAJOR |
| YU-08 | Duration: a session fits the time in LEARNING_DESIGN; there is a natural break point (automatic endless continuation: CG-08). | Estimate from content: word count ÷ assumed reading speed + activity count, in a table; real child duration: user observation (an artificial playtester's duration does not represent a child). | MAJOR |
| YU-09 | One main task per screen; instruction ≤2 sentences. | Sample screen list: task count and instruction sentence count. | MAJOR |
| YU-10 | Form of address fits the audience: for child/teen a single informal form, no commanding/scolding tone (spelling and term consistency: IK-10). | Reading in the sample; deviation lines or 0. | MAJOR |
| YU-11 | No sudden loud sound; there is a way to mute (flashing: ER-09). | Code/ART_AUDIO: Grep `gain`, `setValueAtTime`, `mute`, `silent`; gain and envelope values in a table. Real listening: user observation. | MAJOR |
| YU-12 | Success celebration is modest and varied. | Celebration texts in the sample; ≥3 different phrasings. | MINOR |

## Result rule
If a BLOCKER item is NO, C-AGE is closed (REVISE). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, sample unit, playtester report path) |
|---|---|---|
The learning-designer report is input; the critic consolidates. Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>`.

## Sources
- ICO, Children's code (unverified; bot blocking): https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/childrens-information/childrens-code-guidance-and-resources/
- PEGI age ratings: https://pegi.info/page/pegi-age-ratings
- W3C, Three flashes or below threshold: https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html

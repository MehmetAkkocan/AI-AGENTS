# Checklist: Sensitive domain — health, mental health, finance, security techniques (HA)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). Patterns are given in English; also search the equivalents in the project's content language. "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report ("evidence: playtester report"). An item the team cannot verify, such as audio or emulation, counts as "user observation" (at most MAJOR).

- **Gate:** C-DOMAIN · **Trigger:** topic of health, mental health, finance, or security techniques · **Reviewer:** critic
- **Checked in A2 (document: GDD/LEARNING_DESIGN/UX/BRIEF):** HA-01, 02, 03, 05, 08, 09, 10, 12. **Checked in A6:** all.
- Subset tags: [HEALTH] [MENTAL] [FINANCE] [SECURITY]; an untagged item applies to every domain. An item outside the domain = N/A (with justification).
- Sample (glossary rule): at least 5 units or 20%, whichever is larger; if the total is fewer than 5, all.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.

| # | Item | How to verify | Severity |
|---|---|---|---|
| HA-01 | A disclaimer on the first screen and in the README: it is for education; it does not replace professional medical/financial/legal advice. | A2: UX first-screen text. A6: screen evidence: playtester report (visible without scrolling); README line. | BLOCKER |
| HA-02 | No promised outcomes and no personalized advice: no diagnosing, recommending drugs/doses, recommending a specific product/stock/crypto, "guaranteed", "risk-free", "cures". | Grep (content + interface text): `guarantee`, `risk-free`, `sure win`, `cures`, `diagnos`; result 0. | BLOCKER |
| HA-03 | Factual claims are sourced (institution/standard name, access date). | Claim → source table in the sample; 0 unsourced claims. | MAJOR |
| HA-04 | Numeric claims that can change over time (threshold, rate, fee, regulation/version number) are dated ("as of ..."). Fixed technical values such as a port or a permission bit are out of scope. | List of changeable numeric claims in the sample; undated count 0. | MINOR |
| HA-05 | [MENTAL] From screens that touch self-harm/crisis topics, a "Help" screen giving 112 for Turkey and authorized support information is reachable in ≤2 taps. | A2: UX flow. A6: evidence: playtester report (the path is clicked); the number is confirmed from an official source. | BLOCKER |
| HA-06 | [MENTAL] No method details of suicide/self-harm and no sensationalist language. | Grep in content: `suicide`, `self-harm`, `method`; every hit is read in context; 0 lines that give details. | BLOCKER |
| HA-07 | [MENTAL][HEALTH] A test/scale result is not presented as a diagnosis; the result screen has a "consult a professional" pointer. | Result screen text; Grep: `diagnosis`, `your disorder`; result 0. | MAJOR |
| HA-08 | [FINANCE] No real account, card, or ID data is requested; simulation money is clearly "not real". | Screen inventory; Grep: `iban`, `card no`, `cvv`, `national id`; result 0; simulation label: evidence: playtester report. | BLOCKER |
| HA-09 | [SECURITY] Defense-oriented framing: every attack technique is paired with detection, prevention, and mitigation coverage; an attack step is not given alone. | Topic → defense section table in the sample; 0 topics without defense. | BLOCKER |
| HA-10 | [SECURITY] Warning: try only on systems you own or have written permission for; unauthorized access is illegal. | Warning text and its placement (first screen/README + the start of the technical content). | BLOCKER |
| HA-11 | [SECURITY] Exercises are in an isolated simulation; no real targets and no live usable malicious code. Allowed: RFC 5737 (192.0.2.x, 198.51.100.x, 203.0.113.x), RFC 1918 private networks, 127.0.0.0/8, `example.com`/`.org`/`.net`, `.test`, `.invalid`, `.localhost`. | Grep in content: `\b\d{1,3}(\.\d{1,3}){3}\b` (IPv4) and `https?://`; 0 hits outside the allowed ranges. Isolation: GS-05/GS-16. | BLOCKER |
| HA-12 | The warning text is plain and at most 3 sentences. | Sentence count. | MINOR |
| HA-13 | Whether the content was reviewed by a domain expert is stated clearly in the README. | The relevant line in the README. | MINOR |

## Result rule
If a BLOCKER item is NO, C-DOMAIN is closed (REVISE). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, command output, playtester report path) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>`.

## Sources
- Action Alliance, safe messaging: https://theactionalliance.org/messaging/public-messaging
- Reporting on Suicide (SAVE, current address): https://www.save.org/media/media-recommendations/
- 112 Emergency Call Center (Turkey): https://www.112.gov.tr

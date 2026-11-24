# Checklist: Child safety and privacy (CG)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). Patterns are given in English; also search the equivalents in the project's content language. "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report ("evidence: playtester report"). An item the team cannot verify, such as audio or emulation, counts as "user observation" (at most MAJOR).

- **Gate:** C-CHILD · **Trigger:** audience = child (<13; every track, every mode) · **Reviewer:** critic (in A6 the playtester report is input)
- **Checked in A2 (document: SPEC/DESIGN/UX/ART_AUDIO; P: light design section of docs/BRIEF.md):** CG-01, 02, 05, 06, 07, 08, 10, 11.
- **P track, A6 (inside E-A6, running slice; evidence: playtester report + code):** CG-03, 04, 08, 09. The full review runs in U A6 after promotion.
- **Checked in A6 (running product: code, tester output, playtester report):** all.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.
- Principle level: data minimization, no tracking, parental control. Region-specific legal thresholds and durations are not in this list.

| # | Item | How to verify | Severity |
|---|---|---|---|
| CG-01 | No personal data (name, email, phone, address, date of birth, location, photo, voice, ID number, device identifier) is collected or sent out. Only a nickname that stays on the device is allowed. | Data inventory table. A6 Grep (schema, content, source): `email`, `phone`, `address`, `birth`, `location`, `full_name`, `first_name`, `last_name`; every hit is justified in the inventory as "local". | BLOCKER |
| CG-02 | No account and no server-side personal record (a local profile is allowed). If an account is required, C-CHILD passes only with a user EXCEPTION plus a legal-advice note (this team cannot prove parental consent). | A2: no login/sign-up screen in UX/SPEC. A6 Grep: `login`, `signup`, `register`, `password`; result 0 or an EXCEPTION line in PHASE. | BLOCKER |
| CG-03 | No ads, analytics, tracking, crash reporting, or third-party SDK/script. | List the dependency/lock file. Grep: `analytics`, `gtag`, `adsbygoogle`, `fbq(`, `facebook pixel`, `sentry`, `mixpanel`, `amplitude`. | BLOCKER |
| CG-04 | No external resources are loaded (CDN font, script, image, iframe). | Grep: `https://`, `http://`, `//cdn`; except the SVG namespace (`xmlns`, `www.w3.org`), list the remaining hits. | BLOCKER |
| CG-05 | No external links; if any, behind a parental gate (adult verification a child cannot pass with a single tap). | Grep: `href="http`, `target="_blank"`. If present, the gate screen: evidence: playtester report. An external link without a gate = NO. | BLOCKER |
| CG-06 | No free chat, comments, messaging, or sharing of user content. | A2: screen inventory. A6 Grep: `textarea`, `contenteditable`, `type="text"`; every field is justified as "local only, not sent". | BLOCKER |
| CG-07 | No real-money purchases, virtual currency bought with real money, paid random rewards, subscriptions, or payments. Points/tokens earned in a game are free (the manipulation angle is in CG-08). | Screen inventory. Grep: `buy`, `payment`, `subscri`, `purchase`, `checkout`, `price`. | BLOCKER |
| CG-08 | No manipulative patterns: (a) next lesson/playback that starts automatically and cannot be stopped, (b) accusing/shaming text on exit, (c) streak-loss penalty, (d) countdown pressure toward a reward/purchase, (e) repeating notifications. | A2: scan UX text and flow; for each pattern "none" or a line. A6: evidence: playtester report (end-of-game/lesson and exit screens). | BLOCKER |
| CG-09 | No data leaves: while the product runs there are no requests outside its own origin (CG-04 covers loading external resources, this item covers sending data). No personal data in the server log. | evidence: playtester report (`read_network_requests`: all requests to its own origin); log sample. | BLOCKER |
| CG-10 | Progress can be deleted in one step (reset); the screen can be found by the child/parent. | A2: the screen exists in UX. A6: data is empty after reset (evidence: playtester report). | MAJOR |
| CG-11 | The privacy notice is in plain language (in the content language): what is and is not collected, where it stays; a short section for the parent. | README or app screen; no contradiction with the CG-01 inventory (comparison note). | MAJOR |
| CG-12 | Cookies/local storage are functional only (progress, session); no tracking identifier. | `Set-Cookie` in the tester's `curl.exe -i` output; list of storage keys: evidence: playtester report. | MAJOR |
| CG-13 | No camera, microphone, location, or notification permission is requested. | Grep: `getUserMedia`, `geolocation`, `requestPermission`, `Notification`. | MAJOR |
| CG-14 | A parent information note exists (what the app does and does not do). | Section in README/separate page (file + heading). | MINOR |

## Result rule
If a BLOCKER item is NO, C-CHILD is closed (REVISE). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, command output, playtester report path) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>` (n = number of NO).

## Sources
- FTC, COPPA FAQ (unverified; bot blocking): https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions
- 16 CFR Part 312, COPPA Rule (unverified; bot blocking): https://www.ecfr.gov/current/title-16/chapter-I/subchapter-C/part-312
- KVKK, material for children: https://www.kvkk.gov.tr/Icerik/8028/Cocuklar-Tarafindan-Dikkat-Edilmesi-Gerekenler-Brosur-

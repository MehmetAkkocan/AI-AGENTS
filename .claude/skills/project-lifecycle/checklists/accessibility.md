# Checklist: Accessibility (ER) — a selected subset of the core WCAG 2.1 criteria

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report ("evidence: playtester report"). An item the team cannot verify, such as audio or emulation, counts as "user observation" (at most MAJOR).

- **Gate:** C-ACCESS · **Trigger:** track = product; if audience = child, core in P · **Reviewer:** A2: critic (document level) · A6: playtester (accessibility persona + tree) + critic (decision: critic)
- This list is a selected subset; it is not a WCAG 2.1 AA conformance claim (missing: 1.3.4, 1.4.12, 1.4.13, 2.5.3, 3.2.3, 3.2.4, 3.3.3, etc.).
- **Scope:** [core] = mandatory subset for U/light and for P with audience=child · [full] = U/medium and full; core + full are all checked. The scope checked is written in the report.
- **Checked in A2 (document: UX.md, ART_AUDIO, design tokens; P: light design section of docs/BRIEF.md):** ER-01, 02, 03, 04, 06, 07, 08, 09, 10, 12, 15 (with the "A2:" method). **Checked in A6:** all; desktop + mobile (375×812).
- **TREE** = the accessibility tree output in the playtester report (evidence: playtester report); in the fallback method (HTTP/Grep) the report says `VISUAL: UNVERIFIED`.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.

| # | Item | How to verify | Severity |
|---|---|---|---|
| ER-01 | [core] Text contrast ≥4.5:1 (large text ≥3:1) — 1.4.3. | A2: ratios for the UX.md color pairs are in a table. A6: same table + measurement: evidence: playtester report; list of failing pairs. | BLOCKER |
| ER-02 | [core] Contrast of buttons, field borders, focus ring, meaningful graphics ≥3:1 — 1.4.11. | Component rows in the ER-01 table (A2 and A6). | MAJOR |
| ER-03 | [core] All functions work with the keyboard (Tab, Shift+Tab, Enter, Space, Esc); no keyboard trap — 2.1.1, 2.1.2. | A2: keyboard path written in the UX flow. A6: evidence: playtester report (main tasks with keyboard only); list of screens where it got stuck is empty. | BLOCKER |
| ER-04 | [core] Focus is visible, order matches visual order — 2.4.7, 2.4.3. | A2: UX.md focus style and order. A6: TREE focus order; description of the focused-element image. | BLOCKER |
| ER-05 | [core] Meaningful image/SVG/icon has a text alternative; decorative image has empty alt — 1.1.1. | TREE: 0 unnamed images. Grep: 0 `<img` lines without `alt=`; for `<svg`: `aria-label`, `<title`. | BLOCKER |
| ER-06 | [core] Heading structure: one h1 per screen, no level skipping (good practice; related to 1.3.1/2.4.6, not a requirement by itself). | A2: UX.md heading list per screen. A6: TREE heading hierarchy. | MAJOR |
| ER-07 | [core] Every form field has a label; error text is associated with the field and not conveyed by color alone — 1.3.1, 3.3.1, 3.3.2, 1.4.1. | A2: UX form/error state. A6: TREE field names; deliberately wrong input: evidence: playtester report. | BLOCKER |
| ER-08 | [core] Touch/click target ≥44×44 CSS px; audience=child ≥48 (same as the UX.md template). 2.5.5 is AAA; it is a project goal. | A2: target size in the UX.md token table. A6: `javascript_tool` measurement (mobile), list of small targets: evidence: playtester report. | MAJOR |
| ER-09 | [core] No element flashes more than 3 times per second (stricter than 2.3.1: no below-threshold exemption; deliberate). YU-11 refers to this. | A2: ART_AUDIO animation list. A6: Grep `@keyframes`, `animation`, `blink`, `flash`; the rate of each hit is in a table. | BLOCKER |
| ER-10 | [full] (a) Automatic motion longer than 5 s can be paused — 2.2.2 (A). (b) Animation turns off with `prefers-reduced-motion` — 2.3.3 (AAA; project goal). | A2: UX.md motion principle. A6: Grep `prefers-reduced-motion`; read the CSS to confirm the rule turns the animations off (no emulation needed). | MAJOR |
| ER-11 | [full] No content loss and no horizontal scroll at 640 px (≈200% zoom) and 320 CSS px width — 1.4.4, 1.4.10. | A6: `resize_window` list of screens at 640 and 320 px: evidence: playtester report. | MAJOR |
| ER-12 | [full] `lang` attribute set to the content language (e.g. `lang="tr"`) and a unique `<title>` per screen — 3.1.1, 2.4.2. | A2: UX.md screen titles list. A6: Grep `lang=`; TREE page titles. | MAJOR |
| ER-13 | [full] Status messages (right/wrong, progress, error) are announced to assistive technology — 4.1.3. | TREE: `status`/`alert` role; Grep: `aria-live`, `role="status"`, `role="alert"`. | MAJOR |
| ER-14 | [full] If audio/video exists it has a text alternative; information is not given by sound alone; automatic audio longer than 3 s can be stopped — 1.2.1, 1.4.2. | ART_AUDIO inventory: a text-alternative line for each sound. If there is no audio, N/A. | MAJOR |
| ER-15 | [core] No time limit, or it can be turned off/extended — 2.2.1 (core risk for children). | A2: UX/GDD timer list, a setting for each. A6: evidence: playtester report. | MAJOR |
| ER-16 | [full] Main region landmarks and a "skip to content" link — 2.4.1, 1.3.1. | TREE: landmark list. | MINOR |
| ER-17 | [full] Link/button purpose is clear from its own text — 2.4.4. | TREE: link names; 0 ambiguous names ("click here"). | MINOR |
| ER-18 | [core] A custom component (fake terminal, canvas, tab, dropdown) has a programmatically available name, role, and state — 4.1.2. | TREE: component name/role/value lines; 0 interactive elements without a name or role. | BLOCKER |

## Result rule
If a BLOCKER item is NO, C-ACCESS is closed (REVISE). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, TREE excerpt, playtester report path) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n> · SCOPE: core | full`.

## Sources
- W3C, WCAG 2.1: https://www.w3.org/TR/WCAG21/
- W3C, How to Meet WCAG (quick reference; use `?versions=2.1` for the 2.1 filter): https://www.w3.org/WAI/WCAG22/quickref/
- W3C, Understanding WCAG 2.1: https://www.w3.org/WAI/WCAG21/Understanding/

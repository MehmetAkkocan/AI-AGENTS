# Naming glossary (project-lifecycle)

All agents take file, field, ID and value names FROM HERE; do not invent new names. File/field/ID names are ASCII. The matrix lives only in `SKILL.md`. The lead does not read this file; the values it needs are in the `PHASE.md` legend. This file + the skill files are the single lasting source of truth; if a plan diverges from them, this file wins. The hub (`D:\AI Agent Team`) holds general process; everything project-specific is under `projects/<name>/`; in the hub `team/state/` holds only `HANDOFF.md` (hub status + `projects/PROJECTS.md` pointer; project name/stage/decision/open question are NOT written); the registry + `Active project:` live in `projects/PROJECTS.md`. In project work "HANDOFF" = `projects/<name>/state/HANDOFF.md`. Fixed user decisions: no Playwright (playtest: browser pane → HTTP → user observation) · the team folder is not a git repo, git only inside `projects/<name>/` · Gemini only in plan mode, writes no files · uploading outside is the user's job.

## Line budgets
SKILL.md ≤100 (hard) · glossary.md ≤210 · `track-transitions.md` ≤60 · stage files ≤70 (including `a6-verification-p.md`) · gates.md ≤190 · templates 20-55 (TASKS, ADR, LESSONS may be shorter) · checklists ≤65 · profiles ≤75 · agent files ≤65 (playtester ≤75) · team-lead SKILL ≤110 · `commands/project.md` ≤45 · project `CLAUDE.md` ≤25.

## Stage files (`phases/`)
A0 Discovery `a0-discovery.md` · A1 Concept / Definition `a1-concept.md` · A2 Design `a2-design.md` · A3 Architecture, contract, skeleton `a3-architecture.md` · A4 Vertical slice `a4-vertical-slice.md` · A5 Production `a5-production.md` · A6 Verification `a6-verification.md` (U only) · A6 Verification (P) `a6-verification-p.md` (only `track = prototype`; the lead reads only this in P/A6) · A7 Release `a7-release.md` · A8 Retro `a8-retro.md`.
Fixed skeleton (in this order, no other `##`): `# A<N> <Stage name>` · `## Purpose` · `## Inputs` · `## Steps` · `## Mode differences` (refer to the matrix; do not copy it) · `## Exit criteria` (rows to be copied verbatim into the PHASE `Exit criteria` table: Criterion + Path; Path without backticks) · `## Gate` (expected gate IDs, by track/mode).
Each agent step carries a ready prompt inside a CODE BLOCK, with the team-lead call-template fields: `Role / Project / Stage / Task / Acceptance criteria / Files / Topic / Verification command / Checklist / Gate`. `Gate:` = gate ID or `none` (`none` for a slice critic). On the P track, documents that do not exist (UX.md, ART_AUDIO.md) are not referenced; in P the design lives in BRIEF. Tiered critic: the critic step heading states the model in parentheses — `(sonnet; slice)` (`Gate: none`, including the A7 advisory review) / `(opus; gate)` (`E-A<n>`, `C-*`, the final review before a user gate); `agents/critic.md` keeps `model: opus`, and for a slice review the lead passes `model: sonnet` on the Agent call; when `tight`, all are sonnet. Deadlock: slice critic 2 rounds REVISE → round 3 critic opus + producing agent one model up (same if already opus) → still REVISE → `status: BLOCKED`; gate critic 2 rounds REVISE → NO model promotion → `BLOCKED`; when `tight` no promotion (`BLOCKED` after 2 rounds). Consecutive rounds on the same model use the same agent (SendMessage); a round with a changed model is a new Agent call + the previous report paths. Table and `budget.ps1` routing: `model-router`.

## IDs and traceability
Feature `F-01`, `F-02`… (SPEC; in P the BRIEF scope) · acceptance criterion is a sub-item of the feature `F-01.a` · learning objective `LO-01`… (LEARNING_DESIGN). No other form (`SPEC-xx`, `AC-01`, `H-NN`).
Chain: SPEC (F) → GDD / LEARNING_DESIGN (LO) / UX mapping field → TEST_PLAN mapping → VERIFICATION coverage row. Each link cites the previous ID verbatim. ADR: `docs/adr/<NNN>-<topic>.md`, NNN three digits; `000-prototype-code.md` is reserved for promotion.

## Templates (`templates/`, 22 files) and document ownership (single owner)
| Template | Target path in the project | Owner |
|---|---|---|
| `BRIEF.md` | `docs/BRIEF.md` (P and U) | planner; in P the game-/learning-designer adds the core loop / learning objective section in A2 |
| `SPEC.md` | `docs/SPEC.md` | planner |
| `DESIGN.md` | `docs/DESIGN.md` (U/light only) | game-designer or learning-designer (by type); ux-designer adds the UX section AFTER |
| `GDD.md` | `docs/GDD.md` | game-designer |
| `LEARNING_DESIGN.md` | `docs/LEARNING_DESIGN.md` | learning-designer |
| `UX.md` · `ART_AUDIO.md` | `docs/UX.md` · `docs/ART_AUDIO.md` | ux-designer |
| `ARCHITECTURE.md` · `ADR.md` · `TEST_PLAN.md` | `docs/ARCHITECTURE.md` · `docs/adr/<NNN>-<topic>.md` · `docs/TEST_PLAN.md` | planner |
| `CONTENT_SCHEMA.md` | `docs/contracts/CONTENT_SCHEMA.md` | planner (learning-designer supplies the pedagogical input as a report) |
| `PERSONAS.md` | `docs/PERSONAS.md` (from the BRIEF audience; U: at the start of the A4 playtest · P: at the start of the A6 playtest) | playtester |
| `PLAYTEST_REPORT.md` | `reports/<stamp>-playtester-<topic>.md` | playtester |
| (same template, compiled) | `docs/PLAYTEST.md` (U only, A6 summary) | writer |
| `PROTOTYPE_REVIEW.md` · `VERIFICATION.md` · `RETRO.md` | `docs/PROTOTYPE_REVIEW.md` (P only: compiled in A6, "Retro note" section added in A8) · `docs/VERIFICATION.md` (U only, A6) · `docs/RETRO.md` (U only, A8) | writer |
| `RELEASE.md` | `docs/RELEASE.md` (absent in U/light; README install section) | writer |
| `PHASE.md` · `HANDOFF.md` · `LESSONS.md` | `state/PHASE.md` · `state/HANDOFF.md` · `state/LESSONS.md` | lead (`new-project.ps1` builds the LESSONS skeleton from the template) |
| `TASKS.md` | `state/TASKS.md` | lead (the planner writes the first table rows) |
| `PROJECT_CLAUDE.md` | `CLAUDE.md` (project root) | planner |

Artifacts without a template and their owners: `state/INTAKE.md` lead (format in `a0-discovery.md`; for direct U, the explicit-approval evidence line `pre-approval: <day>; source: <projects/<name>/docs/source/<ascii-name>>`) · `docs/source/<ascii-name>` coder (verbatim copy of the external source file; name ASCII: non-ASCII letters mapped to their ASCII equivalents, space `-`, extension kept; original name/location once in the INTAKE `source:` line; A0 step 0) · `state/MANUAL-<p>.md` lead (the user's MANUAL form answer, verbatim from chat) · `state/TASKS-ARCHIVE.md` lead (opened empty, heading `## <track> A<N>`) · `docs/CONSTRAINTS.md` planner (in medium/full the SPEC Constraints section moves here) · `docs/contracts/API.md` planner (per the contract section in ARCHITECTURE: endpoint, request/response, error) · `docs/ux/wireframes/NN-<screen>.html` (e.g. `01-home-screen.html`) ux-designer (full mode only) · `docs/BACKLOG.md`, `README.md`, `CHANGELOG.md` writer · content units writer · source code, `run.ps1`, visual/audio assets coder. Paths are relative to the `projects/<name>/` root. Nobody but the owner writes; in a shared document (DESIGN) the authors work in sequence. Writers compile from reports and make no decisions.
Mandatory template contents: `PHASE.md` ends with an `## Allowed values` legend · `TASKS.md` fixed table header · `VERIFICATION.md` a standalone `BLOCKER: <n>` line, coverage rows (F/LO) and a "Rollback" section (K4 presents it).
LESSONS (`state/LESSONS.md`, PROJECT-SPECIFIC; two tables: "Process proposals" and "Lessons"; a new project does not read earlier projects' lessons, within the same project the lead reads it in A1 after promotion; if a lesson should apply to other projects too, the route is a process file change, only with user approval) proposal status: `PROPOSED` → `ACCEPTED` · `REJECTED` · PROTOTYPE_REVIEW hypothesis result: `CONFIRMED` · `PARTIAL` · `REFUTED`.

## Checklists (`checklists/`, 7 files)
| File | Item prefix | Gate where used |
|---|---|---|
| `child-safety-privacy.md` | CG | C-CHILD (A2, A6; P: A2, in A6 only CG-03, 04, 08, 09 inside E-A6) |
| `age-appropriate-content.md` | YU | C-AGE (A5, A6; P: A6 light, YU-03, 04, 05, 10) |
| `sensitive-domain.md` | HA | C-DOMAIN (A2, A6) |
| `security-hardening.md` | GS | C-SEC (A3, A6) |
| `accessibility.md` | ER | C-ACCESS (A2, A6) |
| `content-quality.md` | IK | E-A4 (golden example), E-A5 (content review), E-A6 |
| `pre-release.md` | YO | U E-A6 (only release-CANDIDATE items: debug hooks off, no secrets, known issues written down) · A7 critic + T-A7 (README / CHANGELOG / RELEASE / tag items; in U/light the README install section replaces RELEASE) |

C-PERF has no list (criterion = `docs/ARCHITECTURE.md` performance budget). Item format is a TABLE: `| # | Item | How verified | Severity |`; `#` = `CG-01` form (two digits, unique within the file); Severity = BLOCKER · MAJOR · MINOR.
Severity classes (only these three spellings): **BLOCKER** (closes the gate) · **MAJOR** (fixed before the gate or put in BACKLOG with justification) · **MINOR** (BACKLOG). The same spelling in reports and returns.
Each list's top block: a "not legal advice" notice + "The `\|` in tables is only Markdown escaping; write a plain `|` in a Grep / ripgrep pattern."
Evidence types (`How verified` cell): document/code review (critic) · `evidence: playtester report` (item that needs a browser; the critic has no browser tool) · `user observation` (sound, emulation etc. that the team cannot verify; cannot be a BLOCKER, at most MAJOR).
The same criterion does not appear in two lists: it stays in one, the other cites it; on a severity conflict the stricter wins. Sampling rule (author's decision, all lists and `a5-production.md`): at least 5 units or 20%, whichever is larger; if the total is under 5, all of them.
Sources: dead links are removed; an unverifiable one is marked `(unverified)` or replaced with the official home page.

## Profiles (`profiles/`, 3 files)
`web.md` · `mobile.md` · `desktop-engine.md`. Fixed headings (in order): `## Scope` · `## Container and technology defaults` · `## run.ps1 mapping` · `## Test hooks` · `## Playtest method` (BROWSER / HTTP / MANUAL; no Playwright) · `## Limits` · `## Release package`.

## Gate IDs
User (`user`): K1 (A1) · K2 (A2) · K3 (P: A6 · U: A4) · K4 (A6). Stage exit: critic `E-A0` … `E-A8` (no E-A8 in P) · tester `T-A3` … `T-A7` · playtester `P-A4` (U only), `P-A5` (full only), `P-A6`.
Conditional gates (trigger: `gates.md` "Conditional gates" table; the SINGLE source for the allowed stage is the "phase-gate rules" table below, the `gates.md` stage column is written identically to it):
| Gate | Reviewer + checklist |
|---|---|
| C-CHILD | critic + `child-safety-privacy.md` |
| C-AGE | learning-designer + critic + `age-appropriate-content.md` (P + audience child/teen: light in A6; learning-designer `a6-age` golden example + slice text, decision by critic `a6-c-age`) |
| C-DOMAIN | critic + `sensitive-domain.md` |
| C-SEC | critic + global skill `security-and-hardening` + `security-hardening.md` |
| C-ACCESS | A2: critic (document level) · A6: playtester (accessibility persona + tree) + critic + `accessibility.md` |
| C-PERF | tester + critic |

In a multi-reviewer gate the PHASE row records the last reviewer who decides (the critic); the other reviewers' reports are input to the critic. P-A<n>: with several personas/rounds the gate result is the WORST result (BLOCKER > NEEDS_FIX > PASS); the lead writes this single result.
Expected gates — U: A0 E · A1 E, K1 · A2 E, C, K2 · A3 E, T, C · A4 E, T, P, K3 · A5 E, T, C (+P full) · A6 E, T, P, all C, K4 · A7 T · A8 E. P (stage order A0, A1, A2, A3, A4, A6, A8; no A5 and A7): A0 E · A1 E, K1 · A2 E, C · A3 E, T, C · A4 E, T · A6 T, P, E, (C-AGE: audience child/teen), K3 · A8 no gate (exit criterion: `PROTOTYPE_REVIEW.md` "Retro note"). If a user gate is absent from the matrix for that track/mode, no row is written (U/light has no K2, K3; in U/medium-full K3 only on direct entry, at the end of A4; presentation source = A4 playtester report + tester report). P flow, ITERATE / PROMOTION / SHELVE order: `track-transitions.md` (definitive). A conditional gate is a separate row per stage (`C-SEC`, `A3`). A5 slice gates live only in TASKS; PHASE gets only the stage-end E-A5/T-A5.

## User gates (gates.md rules)
When presenting a gate the lead reads ONLY the relevant K section of gates.md → each K section stands on its own (presentation template, options, status effect, record row); no pointer to other sections.
K2 = SHRINK does not pass the gate (design is narrowed, K2 presented again). Promotion content steps are INSIDE the K3 section; order, IDs and tags are definitive in `track-transitions.md` (the K3 section follows it). The ADR-000 "keep / rewrite" proposal appears in the K3 presentation and is finalized in A3 by the architecture critic (no separate question). K4's "rollback" information comes from the VERIFICATION.md section (RELEASE is written in A7, after K4). Direct U entry: condition in `phases/a0-discovery.md` Mode differences (`commands/project.md` points to it), flow and the `APPROVED-IN-ADVANCE` record in `track-transitions.md`; no new decision value is invented.
Visual approval (K3 and K4; every track, every mode): the presentation template has a "Visual approval" line (run command + address + screens to look at). A passing decision (K3: PROMOTION / CONTINUE; K4: RELEASE) is taken only after the user has opened and looked at the product themselves; "I haven't looked" or an unclear answer is not a decision. Non-passing decisions (ITERATE, SHELVE, FIX, STOP, DEFER) need no visual approval. The Report cell of a passing K3/K4 row (EXCEPTION included) is FIXED: `user: visual approval; <presentation report path or ->` (in EXCEPTION, the reason instead of `-`). No new gate ID.
The lead prepares the K presentation: source agent returns + the document the writer compiled (K3 in P: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`); if a field is missing, a "K<n> presentation summary" task for the writer (report ≤15 lines; Topic P `a6-k3-presentation` · U `a4-k3-presentation` · `a6-k4-presentation`); the lead may read this SINGLE report in full (exception to the do-not-read-reports rule); the K row's Report cell is this report (with the prefix above in a passing K3/K4). The rough size, mode and ADR-000 proposal for PROTOTYPE_REVIEW come from the planner's P/A6 `a6-k3-proposal` report; the writer compiles with `a6-review`.
Re-run rule: after a negative decision (REVISE, FAIL, FIX, SHRINK, ITERATE, NEEDS_FIX, BLOCKER), for EVERY gate that will re-run, immediately a new `PENDING` row with the same (Gate, Track, Stage) key; the old passing row cannot leave the gate open. Negative decision at a user gate: that stage's E-A<n>, the affected C-* and K<n> go back to PENDING. Exception P/K3 ITERATE: immediately `E-A4`, `T-A4`; on re-entering A6 `T-A6`, `P-A6`, `E-A6`, (if any) `C-AGE`, `K3` (`track-transitions.md`).

## Decision words (PHASE `Gate records` → `Result`, verbatim)
| Gate type | Values |
|---|---|
| critic (E-*, C-*) | APPROVE · REVISE |
| tester (T-*) | PASS · FAIL |
| playtester (P-*) | PASS · NEEDS_FIX · BLOCKER |
| K1 | APPROVED · FIX · STOP · APPROVED-IN-ADVANCE (direct U; only with explicit approval evidence in chat) |
| K2 | APPROVED · FIX · SHRINK (does not pass) |
| K3 (P) | PROMOTION · ITERATE (≤2) · SHELVE |
| K3 (U) | CONTINUE · FIX · STOP |
| K4 | RELEASE · FIX · DEFER |
| every gate | PENDING (no result yet) · EXCEPTION (only by user decision; `user: <reason>` in the `Report` cell) |

**Values that count as passing:** `APPROVE, PASS, APPROVED, APPROVED-IN-ADVANCE, PROMOTION, CONTINUE, RELEASE, EXCEPTION`. Every other value (PENDING included) leaves the gate open.
Status effect: STOP → `status: SHELVED` · SHELVE → `SHELVED` after the P/A8 retro note (`track-transitions.md`) · DEFER → `BLOCKED` · ITERATE (P/K3) → `stage: A4`, `IN_PROGRESS` · FIX, SHRINK, REVISE, FAIL, NEEDS_FIX, BLOCKER → `IN_PROGRESS` in the same stage.
Playtester return fields (ASCII): `RESULT: PASS / NEEDS_FIX / BLOCKER` · `METHOD: BROWSER / HTTP / MANUAL` · `VISUAL: CHECKED / UNVERIFIED` · task result `SUCCEEDED / STRUGGLED / FAILED`. The old `CONFIRMED` value is not used here.
MANUAL has two calls: (1) the playtester (`Task: MANUAL form <p>`) writes the manual test scenario + observation form into the `## MANUAL observation form` section of its report, gives no RESULT, returns `STATUS: NEEDS_REVIEW` + "waiting for user" (the gate row stays PENDING); the lead presents the form (only that section) to the user and writes the user's chat answer verbatim to `state/MANUAL-<p>.md`; (2) the playtester (`Task: MANUAL evaluation <p>`, `Read: state/MANUAL-<p>.md`) evaluates the answer and returns RESULT (`METHOD: MANUAL`, `VISUAL: UNVERIFIED`). If the stage ends with a visually approved K3/K4 (below), RESULT PASS → gate `PASS`; the form does not replace K3/K4 visual approval (a one-sentence confirmation is still requested at the gate). If it does not, the form counts as visual approval for those screens: if RESULT is PASS the gate record is `EXCEPTION`, Report `user: visual approval (MANUAL form); <playtester report paths>`.

## Playtest and visual evidence
`VISUAL: CHECKED` is written only if the agent ACTUALLY saw the image of that screen × view; a file is not required. Evidence: text description of the image + accessibility tree excerpt + if needed a `javascript_tool` measurement (size, overflow, color). If no image can be obtained after 2 retries the cell is `UNVERIFIED`; the `VISUAL:` line is INFORMATION. If the stage ends with a visually approved user gate (P/A6 → K3 · direct-entry U/A4 medium-full → K3 · U/A6 → K4) `UNVERIFIED` needs no separate pre-approval / P-A<n> EXCEPTION: if RESULT is PASS then P-A<n> = PASS, approval is taken at the gate. If it does not (P-A5 in full mode; K3-less U/A4: light or a promoted project) `UNVERIFIED` alone does not pass P-A<n> → user visual approval, EXCEPTION on the gate record (`user: visual approval`).
Testing on a device (profile mobile only): default NONE (port only 127.0.0.1). On the P track only (a) exists: 375×812 emulation in the browser, device-specific items "user observation — not possible" in the playtester report (no BACKLOG in P); (b) temporary `-Lan` is offered only in U. In U the lead offers the user two options: (a) settle for 375×812 emulation in the browser; device/PWA-specific items go to BACKLOG as "user observation — not possible"; (b) by user decision (EXCEPTION) temporary local network access only for the test duration: tester `run.ps1 -Up -Lan` (optional switch, default off), record `C-SEC | product | A6 | user | EXCEPTION | user: temporary -Lan device test (GS-06) | <day>` and immediately after it a `PENDING` with the same key (the C-SEC review still runs), when the test ends tester `-Down`. PWA features that need HTTPS (install, service worker, notification) cannot be tested on the local network → BACKLOG.
`reports/shots/` exists in the skeleton but is OPTIONAL; no gate depends on a file's existence (a screenshot may not be savable to a file).
ux-designer view-only browser tools: navigate, computer (screenshot / scroll / zoom only), read_page, get_page_text, resize_window, tabs_context. In A4/A6 it does the UX.md comparison by seeing for itself; if there is no pane it uses the playtester report's Visual check table. Local address only; no clicking / forms. In the playtester call `Session: leave-open | close` (default close): if a ux comparison is coming, leave-open → the product stays open, after ux the lead gives the tester `run.ps1 -Down`; close → the playtester stops ONLY what it started.
`javascript_tool`: only inspection and the project's OWN test hook (`window.__game` step/input, only `?debug=1`); it changes application state by no other means. During playtest and ux comparison the lead asks the user to keep the Browser pane visible (a timeout may occur while the pane is hidden).

## PHASE.md exact format (`state/PHASE.md`; the script parses it)
```
# PHASE <name>
project: <name> | type: <type> | audience: <audience> | profile: <profile>
track: <track> | mode: <mode> | stage: A<N> | status: <status>
conditional: <C-..., C-... or none>

## Exit criteria
| # | Track | Stage | Criterion | Path | Status |
|---|---|---|---|---|---|

## Gate records
| Gate | Track | Stage | Reviewer | Result | Report | Date |
|---|---|---|---|---|---|---|

## Stage history
| Track | Stage | Start | End | Result | Tag |
|---|---|---|---|---|---|

## Allowed values
```
Rules: header lines are searched only before the first `##`; `key: value` pairs are separated by ` | `, the script trims spaces. The `conditional` separator is `, `. `|` is forbidden inside a cell. Rows are appended to the end of the table, never deleted. Each `##` section heading appears once.
The `## Allowed values` legend (the script does not read it; lines start with `- `) lists at least: status values, gate IDs, decision words by gate type, passing values, status effect, track/mode/type/audience/profile values, Reviewer (`user` included), `-` as Report on a K row, passing K3/K4 Report form (`user: visual approval; ...`), EXCEPTION form, Exit criteria Path/Status, Stage history Result/Tag, Date format.

| Field / column | Allowed values |
|---|---|
| project | project name; same as the folder name |
| type | `game` (if no learning objective) · `education` · `learning` · `self-development`; a game with a gamification or teaching goal gets the suffix `+game` (e.g. `education+game`) · `?` only in A0 |
| audience | `child` · `teen` · `adult` · `?` only in A0 |
| profile | `web` · `mobile` · `desktop-engine` · `?` only in A0 |
| track / Track | `prototype` · `product` |
| mode | `light` · `medium` · `full` · `-` (mandatory `-` when `track: prototype`) |
| stage / Stage | `A0` … `A8` |
| status | `IN_PROGRESS` · `WAITING_GATE` (waiting for an agent gate) · `WAITING_USER` · `BLOCKED` · `COMPLETE` · `SHELVED` |
| conditional | `C-...` IDs or `none` |
| Exit criteria → Path | a single file path relative to the project root (no backticks) or `-` (no-file criterion; proven by the gate record) |
| Exit criteria → Status | `OPEN` · `COMPLETE` (the lead flips it when the relevant agent report arrives) |
| Gate records → Gate | `K1`-`K4` · `E-A0`…`E-A8` · `T-A3`…`T-A7` · `P-A4`…`P-A6` · `C-CHILD` · `C-AGE` · `C-DOMAIN` · `C-SEC` · `C-ACCESS` · `C-PERF` |
| Gate records → Reviewer | role name (below) or `user` |
| Gate records → Report | parts separated by `;`; path rule phase-gate Check 7; on a K row the report that prepared the presentation or `-`; on a passing K3/K4 row `user: visual approval; <presentation report or ->` |
| Date, Start, End | day `yyyy-MM-dd` (the lead writes the session date; if minutes are needed the stamp in the report name is enough) |
| Stage history → Result | `COMPLETE` · `PROMOTION` · `SHELVED` · `BLOCKED` |
| Stage history → Tag | git tag or `-` |

Project name: `^[a-z0-9]+(-[a-z0-9]+)*$` (e.g. `sample-project`). The report topic (`-Topic`) follows the same rule. `projects/PROJECTS.md`: first line `Active project: <name>` (only the lead changes it); table `| name | type | audience | profile | track | mode | stage | status |`; unknown value `?`.

## TASKS.md (project: `state/TASKS.md`)
The file has ONE table, fixed 6 columns: `| # | Task | Role | Model | Status | Report |`. No new heading or second table is opened.
Task cell: `<definition>; Accept: <criterion>; Files: <paths>; Verify: <command or ->`. A5 slices carry the `D<k>-<n>` prefix in the `#` cell (e.g. `D2-3`); no separate table.
Status: `PENDING` · `RUNNING` · `NEEDS_REVIEW` · `DONE` · `FAILED`. Report = path (rule: phase-gate Check 7). A FAILED row does not leave the gate open; the lead reopens the FAILED task as a new row or writes the reason into the project HANDOFF (author's decision, same as the script's behavior).
Rows are NOT moved or deleted. At stage end (after phase-gate PASS) the lead appends the whole table to `state/TASKS-ARCHIVE.md` under the `## <track> A<N>` heading and empties the TASKS table.
The lead fills the first heading line (`# TASKS …`); new-project does not; scripts do not depend on this line. The planner writes the table rows the first time, afterwards the lead updates them.
The hub has no TASKS; phase-gate reads only the project TASKS.

## phase-gate rules (`phase-gate.ps1`, read-only)
Active (track, stage) = `track` and `stage` in the PHASE header line.
Validation (invalid / misspelled value → exit 2, no silent skipping): header fields have allowed values; `project` = folder name; `type/audience/profile = ?` only in `stage: A0`; when `track: prototype`, `mode: -`; in Gate records rows Gate / Track / Stage / Result and in Exit criteria rows Track / Stage / Status have allowed values; the same `##` section heading twice → exit 2. Gate–stage consistency (SINGLE source of truth; script and test follow it): if the Stage of ANY Gate records row (not only active ones) is not allowed in the table below for (Gate, Track) → exit 2 (`—` = the ID does not exist on that track, exit 2 for every stage):
| Gate | Track = product | Track = prototype |
|---|---|---|
| `E-A<n>` · `T-A<n>` · `P-A<n>` | only `A<n>` | only `A<n>`; only E-A0…E-A4, E-A6 · T-A3, T-A4, T-A6 · P-A6 (others —) |
| `K1` · `K2` · `K3` · `K4` | A1 · A2 · A4 · A6 | A1 · — · A6 · — |
| `C-CHILD` · `C-DOMAIN` · `C-ACCESS` | A2, A6 | A2 |
| `C-SEC` · `C-PERF` | A3, A6 | A3 |
| `C-AGE` | A5, A6 | A6 |

Check (if one fails FAIL, exit 1):
1. Does NOT derive expected gates. At least one Gate records row belongs to the active (track, stage) (exception: in active (prototype, A8) no gate row is sought, only Exit criteria); the LAST row of every (Gate, Track, Stage) key of the active (track, stage) has a passing value; none is `PENDING`. With `-SkipUserGates` the `K*` rows are skipped (pre-check before the user gate).
2. In passing E/T/P/C rows the `Report` file exists (except `EXCEPTION` rows).
3. Does not trust the `Status` column of the active (track, stage) Exit criteria: if `Path` (backticks stripped) is not `-`, the file exists and is filled (at least 5 non-empty lines; exception `docs/source/**`: only exists + non-empty, larger than 0 bytes).
4. ALL tables with the fixed header in TASKS.md are scanned: a PENDING / RUNNING / NEEDS_REVIEW row → FAIL; the Report cell of a DONE row is filled and its file exists.
5. If active (track, stage) = (product, A6) (PHASE header values) there is a `BLOCKER: <n>` line in `docs/VERIFICATION.md` and n = 0 (in P/A6 VERIFICATION is not sought).
6. Visual approval (without `-SkipUserGates`): if the LAST row of the `K3` or `K4` key of the active (track, stage) has a passing value (PROMOTION, CONTINUE, RELEASE, EXCEPTION) the Report cell starts with `user: visual approval` (regex `^user: visual approval(;|$)`); otherwise FAIL. A non-passing K3/K4 decision is not checked.
7. Report path rule (Gate records Report cell; TASKS DONE Report cell the same): the Report cell is split into parts by `;` or `,`; parts are trimmed. A part starting with `user:` and `-` are not paths (`,` and `/` are NOT USED inside the phrase; `;` closes the phrase; in a passing K3/K4 `;` is MANDATORY after `user: visual approval`); in an EXCEPTION row no path is scanned, but still only an in-project path is written; every part containing `/` or `\` is a file path (a part without a slash is not a path; not split on spaces; when writing multiple reports use `; `). Each path, once resolved, must stay inside the project's own folder (`projects/<name>/`) and the file must exist; otherwise FAIL (exit 1). The canonical form is the `stamp.ps1` output (`projects/<name>/reports/…`); a path relative to the project root (`reports/…`, `docs/…`, `state/…`) and an absolute path pointing inside the project folder are also accepted. A hub path (`team/…`), another project, or a path escaping with `..` is FAIL. Where a report is MANDATORY is in rules 2 and 4 (in a TASKS DONE row at least one path part is required).
Output ≤10 lines: FIRST line `RESULT: PASS` or `RESULT: FAIL`, then reasons one per line. Exit: 0 = PASS · 1 = FAIL · 2 = format / value error.

## Project skeleton (`projects/<name>/`, own git repo)
`state/` (PHASE, TASKS, TASKS-ARCHIVE, HANDOFF, INTAKE, LESSONS; lead, planner exception in TASKS) · `docs/` · `docs/adr/` · `docs/contracts/` · `docs/ux/wireframes/` (full only) · `reports/` · `reports/shots/` (optional; name `<stamp>-<topic>-<screen>.png`) · `CLAUDE.md` · `run.ps1`.
`run.ps1` standard switches: `-Build` · `-Up` · `-Down` · `-Test` · `-Check` (content validation) · `-E2E` (smoke) · `-Logs`. OPTIONAL: `-Lan` (profile mobile only, with `-Up`; "Testing on a device" (b), by user EXCEPTION; default off). Success exit 0.
Git tags: `p-stage-A<N>` (P: A0-A4, A6, A8) / `u-stage-A<N>` (stage exit) · `prototype-v0` (promotion) · `vX.Y.Z` (release). A5 slice checkpoints and the A4 checkpoint of a P ITERATE round are untagged (a tag is not overwritten). Commit message: `A<N>: <summary>` (checkpoint checks it, exit 1 if it does not conform).
The order is always: lead updates PHASE / PROJECTS / project HANDOFF (+ TASKS archive) → THEN coder checkpoint (A8 included). Double tag: on promotion first `p-stage-A8`, then a separate checkpoint `prototype-v0` (on SHELVE only `p-stage-A8`; full order `track-transitions.md`); in A7 first `vX.Y.Z`, then `u-stage-A7` (Stage history Tag = `u-stage-A7`). Project status lives only in the project `HANDOFF.md`; the global `team/state/HANDOFF.md` carries no project info.

## Scripts (`team/scripts/`, PS 5.1, ASCII messages, exit 0 = success)
| Script | Run by | Parameters |
|---|---|---|
| `stamp.ps1` (exists) | each agent for its own report (not delegated to the tester) | `-Role <role> -Topic <topic> (-Project <name> | -Hub) [-Round <N>]` → prints the path, creates no file; in project work `-Project` is REQUIRED, in hub maintenance `-Hub`; if neither, error, no path. `agy-run.ps1` uses the same pair (exactly one) |
| `new-project.ps1` | coder | `-Name <name> [-Track <prototype/product>] [-Mode <light/medium/full>] [-Type] [-Audience] [-Profile]` (details below) |
| `phase-gate.ps1` | tester | `-Project <name> [-SkipUserGates]` (rules above) |
| `checkpoint.ps1` | coder (single task, in sequence) | `-Project <name> -Message "<message>" [-Tag <tag>]` |
| `list-reports.ps1` (exists); `budget.ps1`, `agy-run.ps1` (exist) | tester / critic; user / tester | `[-Project <name>]`; in their own skill files |

`new-project.ps1`: the name rule is checked; if the folder exists exit 1. Default `-Track prototype`; for `product` `-Mode` is mandatory, `-Mode` given with `prototype` exits 1. `-Type -Audience -Profile` are optional: if not given `?`, if given they are validated against allowed values (exit 1). It fills only the PHASE lines before the first `##`: `stage: A0`, `status: IN_PROGRESS`, `mode` = given or `-`, `conditional: none`. It builds the project in a temporary folder (folders, 5 templates (PHASE, TASKS, HANDOFF, LESSONS, PROJECT_CLAUDE), empty `TASKS-ARCHIVE.md` and `INTAKE.md`, `git init` + first commit), moves it to the target name on success; on error it deletes the temporary folder. It appends a row to `projects/PROJECTS.md`; it does not touch the `Active project:` line or the first TASKS line.
`checkpoint.ps1` and `new-project.ps1` run git only inside `projects/<name>/`; no push / remote / git at the team root. Parallel agents do not commit.

## Agent permissions (running commands)
`run.ps1 -Check` / `-Test` / `-E2E` → tester; the writer may run `-Check` only for its own content. learning-designer and game-designer run no commands (Bash only for `stamp.ps1`).
The tester passes the phase-gate output VERBATIM (≤10 lines) + a `REPORT:` line; no comment/analysis (the critic or writer if needed). `NOT RUN` is counted separately; `NOT RUN:` and `GATE:` lines are valid fields in the return. The playtester starts the product for playtest: it first checks whether it is already running, if not `run.ps1 -Up`, when done `-Down` ONLY what it started (`Session: leave-open` leaves it open, see the Playtest section); the tester stops what it started for E2E; the ux-designer does not start the product.
The planner Write scope = the planner rows in the ownership table + the TASKS first table rows. The three designer agents cite the `docs/DESIGN.md` target for U/light. An agent without a Skill tool (writer included) reads `<USERPROFILE>\.claude\skills\<skill-name>\SKILL.md` with Read before applying a skill.

## Roles and report name
Agents (`.claude/agents/<role>.md`): `researcher` · `planner` · `coder` · `writer` · `critic` · `tester` · `game-designer` · `learning-designer` · `ux-designer` · `playtester`. Also `gemini` (antigravity skill, plan mode only; writes no files). The lead is not an agent (`team-lead` skill).
Report name: `<stamp>-<role>-<topic>[-t<N>].md`; stamp `yyyyMMdd-HHmm` (`^\d{8}-\d{4}$`); `-t<N>` only in 2nd and later rounds. Location: in project work `projects/<name>/reports/` (`-Project <name>`); in hub maintenance `team/reports/` (`-Hub`).

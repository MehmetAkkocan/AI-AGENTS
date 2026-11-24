# A6 Verification

## Purpose
Prove the release candidate: full test, persona playtest, UX / learning / balance review, conditional gates; prepare for K4 with BLOCKER = 0. This file is ONLY for the U track; P track: `a6-verification-p.md`.

## Inputs
Under projects/<name>/: A5 output (product, docs/BACKLOG.md), SPEC, design documents, UX (U/light: DESIGN), TEST_PLAN, PERSONAS (the playtester produced it in A4; in a promoted project it was produced in P/A6), the ARCHITECTURE performance budget; PHASE conditional:.

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`. The tester only runs and relays the output verbatim; analysis/severity grading is with the critic and the designers. Prompts are in the single block below:
1. **tester** (Test running) T-A6: full test, `run.ps1 -Check` included. If C-PERF is triggered, a separate call (Topic a6-perf, Gate C-PERF): ARCHITECTURE budget measurement.
2. **[parallel]** **learning-designer** goal coverage (LO → content) + if C-AGE is triggered, the age sample (at least 5 units or 20%, whichever is larger) · **game-designer** balance (only game / `+game`). They run no commands.
3. Ask the user to keep the Browser panel visible. The playtester starts the product: it first checks whether it is running, and if not starts `run.ps1 -Up` itself. The ux-designer does not start it.
   On-device testing (only profile mobile; (b) only on the U track, in P only (a)): NONE by default (the port is 127.0.0.1 only). The lead offers the user two options: (a) settle for 375×812 emulation in the browser; device/PWA-specific items go to BACKLOG as "user observation — could not be done"; (b) by user decision (EXCEPTION) temporary local-network access only for the duration of the test: the tester runs `run.ps1 -Up -Lan` (optional switch, off by default), record `C-SEC | product | A6 | user | EXCEPTION | user: temporary -Lan device test (GS-06) | <day>` and immediately after it a `PENDING` with the same key (the C-SEC review still runs), when the test ends the tester runs `-Down`. PWA features that require HTTPS (install, service worker, notifications) cannot be tested on the local network → BACKLOG.
4. **playtester ×N** in sequence (Playtest; N: SKILL matrix A6 row; one is an accessibility persona; BROWSER → HTTP → MANUAL). `Session:` is `close` for all but the last playtester (`-Down` only what it started itself), `leave-open` for the LAST playtester (the product stays open). P-A6 = worst result (BLOCKER > NEEDS_FIX > PASS); the lead writes it, Report = all playtester report paths, separated by `; ` (same as gates.md).
   `VISUAL: UNVERIFIED` requires no separate pre-approval or EXCEPTION (the stage ends with K4): if RESULT is PASS then `P-A6` = PASS, and visual approval is obtained at K4. MANUAL has two calls: (1) the playtester (`Task: MANUAL form <p>`) writes the manual test scenario + observation form into the `## MANUAL observation form` section of its report, gives no RESULT, returns `STATUS: NEEDS_REVIEW` + "waiting for user" (gate row stays PENDING); the lead presents the form (only that section) to the user and writes the user's chat reply verbatim to `state/MANUAL-<p>.md`; (2) the playtester (`Task: MANUAL evaluation <p>`, `Read: state/MANUAL-<p>.md`) evaluates the reply and returns RESULT (`METHOD: MANUAL`, `VISUAL: UNVERIFIED`). If RESULT is PASS then `P-A6` = PASS; the form does not replace the K4 visual approval (a one-sentence confirmation is still requested at K4).
5. **ux-designer** (UX design): sees the screens itself and compares them with UX.md; if there is no panel, the Visual check table of the playtester report. When done the lead gives the tester `run.ps1 -Down`.
6. **[parallel] critic** (opus; gate) a separate call for EVERY C-* in `conditional:` (Review): C-CHILD child-safety-privacy.md · C-AGE age-appropriate-content.md (+ LD report) · C-DOMAIN sensitive-domain.md · C-SEC security-hardening.md + skill security-and-hardening · C-ACCESS accessibility.md (+ playtester accessibility report) · C-PERF (+ tester measurement, skill performance-optimization).
7. **coder** fix: BLOCKER mandatory, MAJOR fix or send to BACKLOG with reasons; the relevant step reruns; ≤2 rounds, after that gates.md Deadlock.
8. **writer** compiles VERIFICATION + PLAYTEST (produces no decisions); 9. **critic** (opus; gate) E-A6.
```
Role: tester | Project: <name> | Stage: A6 | Task #<n>: full test | Topic: a6-test | Gate: T-A6
Acceptance: four commands exit 0 (PASS/FAIL; NOT RUN separate) | Files: none | Verification command: run.ps1 -Build -Test -Check -E2E | Checklist: none
Role: tester | Project: <name> | Stage: A6 | Task #<n>: performance measurement (only C-PERF) | Topic: a6-perf | Gate: C-PERF
Acceptance: the ARCHITECTURE performance budget measurements as raw values in the report (no commentary) | Files: none | Verification command: <measurement command in ARCHITECTURE> | Checklist: none
Role: learning-designer | Project: <name> | Stage: A6 | Task #<n>: goal coverage | Topic: a6-goal-coverage (age sample: a6-age) | Gate: none
Acceptance: every LO-xx is met in the content (LO → content table); findings BLOCKER/MAJOR/MINOR | Files: none | Verification command: none | Checklist: <PL>/checklists/content-quality.md; age: age-appropriate-content.md
Role: game-designer | Project: <name> | Stage: A6 | Task #<n>: balance | Topic: a6-balance | Gate: none
Acceptance: difficulty curve / economy consistent with the GDD, no deadlock | Files: none | Verification command: none | Checklist: none
Role: playtester | Project: <name> | Stage: A6 | Task #<n>: persona <p> [MANUAL: MANUAL form <p> / MANUAL evaluation <p>] | Topic: a6-playtest-<p> | Gate: P-A6 | Session: <leave-open (last persona) | close>
Acceptance: persona × task matrix, RESULT/METHOD/VISUAL (VERIFIED only if it actually saw the screen; shots optional), limitations | Files: none | Verification command: run.ps1 -Up (if not running); closing per Session, -Down only for what it started itself | Checklist: <PL>/checklists/accessibility.md | Read: <PL>/templates/PLAYTEST_REPORT.md
Role: ux-designer | Project: <name> | Stage: A6 | Task #<n>: screen ↔ UX comparison | Topic: a6-ux-comparison | Gate: none
Acceptance: screen × view MATCH / DEVIATION (severity-graded); local address only, no clicking/forms | Files: none | Verification command: none | Checklist: none
Role: critic | Project: <name> | Stage: A6 | Task #<n>: conditional gate <C-..> | Topic: a6-c-childuk / a6-c-age / a6-c-domain / a6-c-sec / a6-c-access / a6-c-perf (lower case) | Gate: <C-..>
Acceptance: the list's BLOCKER items satisfied, the relevant reports read; APPROVE/REVISE | Files: none | Verification command: none | Checklist: <file in step 6>
Role: coder | Project: <name> | Stage: A6 | Task #<n>: fix <finding> | Topic: a6-fix-<n> | Gate: none
Acceptance: the finding is closed, the relevant gate is rerun | Files: <paths in the finding> | Verification command: run.ps1 -Test -Check -E2E | Checklist: none
Role: writer | Project: <name> | Stage: A6 | Task #<n>: VERIFICATION + PLAYTEST | Topic: a6-verification | Gate: none
Acceptance: gate → result → report + F/LO coverage rows, "Rollback" section (K4 presents this), a single line "BLOCKER: <n>", PLAYTEST summary | Files: docs/VERIFICATION.md, docs/PLAYTEST.md | Verification command: none | Checklist: none | Read: <PL>/templates/VERIFICATION.md, A6 reports
Role: critic | Project: <name> | Stage: A6 | Task #<n>: release candidate | Topic: a6-e-a6 | Gate: E-A6
Acceptance: VERIFICATION consistent with the reports, BLOCKER: 0; only release CANDIDATE items (debug hooks off, no secrets, known issues written) | Files: none | Verification command: none | Checklist: <PL>/checklists/pre-release.md, content-quality.md
```

## Mode differences
Matrix: SKILL.md. U/light: 2 personas, basic accessibility; C-SEC and C-ACCESS run in every mode (step 6 only those triggered). U/medium: + 3 personas, C-SEC threat model verification (security depth). U/full: + performance (C-PERF), N≥4. Conditional gates do not depend on the mode.

## Exit criteria
PHASE Exit criteria (Stage=A6):
| Criterion | Path |
|---|---|
| Verification matrix (BLOCKER: 0) | docs/VERIFICATION.md |
| Playtest summary | docs/PLAYTEST.md |
| E-A6, T-A6, P-A6 gate records | - |
| Every triggered C-* (separate row) | - |
| K4 (all modes) | - |

## Gate
Write PENDING (Track=product): E-A6, T-A6, P-A6, every C-* in conditional, K4. Order: (1) to the tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name> -SkipUserGates` (BLOCKER: 0 included) → (2) if PASS, present with the gates.md K4 section (Visual approval line mandatory; RELEASE · FIX · DEFER; rollback from VERIFICATION; status WAITING_USER) → (3) full phase-gate (no -SkipUserGates). Negative: FAIL/REVISE/NEEDS_FIX/BLOCKER/FIX → step 7, `IN_PROGRESS`; DEFER → `BLOCKED`. K4 does not open while a BLOCKER exists (exception only by user decision: EXCEPTION). P-A6 precondition: PASS (visual approval at K4). RELEASE → A7. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open); if K4 is negative, `E-A6`, the affected T/P/C-* and `K4`.

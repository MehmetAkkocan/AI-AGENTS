# A6 Verification (prototype track)

## Purpose
Lightly verify the prototype: smoke test, 1-2 persona playtest + visual check, (audience child/teen) light age review; compile PROTOTYPE_REVIEW and prepare for K3 (PROMOTION / ITERATE / SHELVE). Only `track = prototype`; U track: `a6-verification.md`. VERIFICATION.md and PLAYTEST.md are not written.

## Inputs
Under projects/<name>/: A4 output (running slice, golden example), docs/BRIEF.md, ARCHITECTURE, TEST_PLAN (if present); PHASE conditional:; profile `<PL>/profiles/<profile>.md`. In an ITERATE round, the previous A6 reports and user observations.

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`. Prompts are in the single block below:
1. **tester** (haiku) — T-A6 smoke; only runs, relays the output verbatim.
2. **Lead**: ask the user to keep the Browser panel visible; **playtester** ×1-2 (sonnet; method BROWSER → HTTP → MANUAL, profile "Playtest method") in sequence: it first writes `docs/PERSONAS.md` from the BRIEF audience (one is an accessibility persona), persona × F-NN tasks + visual check. `Session: close` (`-Down` for what it started itself). P-A6 = worst result (BLOCKER > NEEDS_FIX > PASS); Report = all playtester reports, separated by `; `.
   `VISUAL: UNVERIFIED` requires no separate pre-approval or EXCEPTION: if RESULT is PASS then `P-A6` = PASS, and visual approval is obtained at K3. MANUAL has two calls: (1) `Task: MANUAL form <p>`: scenario + observation form in the `## MANUAL observation form` section of the report, no RESULT, `STATUS: NEEDS_REVIEW` (gate stays PENDING); the lead presents only that section to the user and writes the reply verbatim to `state/MANUAL-<p>.md`; (2) `Task: MANUAL evaluation <p>`, `Read: state/MANUAL-<p>.md`: returns RESULT (`METHOD: MANUAL`, `VISUAL: UNVERIFIED`). The form does not replace the K3 visual approval.
   On-device testing (only profile mobile): in P only 375×812 emulation in the browser; device-specific items are "user observation — could not be done" in the report. The temporary `-Lan` is offered only on the U track.
3. **learning-designer** — only audience child/teen: light age review (runs no commands). 4. **critic** (opus; gate) — only audience child/teen: C-AGE. 5. **planner** (opus) — K3 proposal. 6. **writer** (sonnet) — PROTOTYPE_REVIEW (compiles, produces no decisions). 7. **critic** (opus; gate) — E-A6; if audience is child, CG-03, 04, 08, 09 are in this review. 8. **writer** (sonnet) — only if a field is missing, the K3 presentation summary.
```
Role: tester | Project: <name> | Stage: A6 | Task #<n>: smoke | Topic: a6-test | Gate: T-A6
Acceptance: run.ps1 -Build, -Test, -Check, -E2E all PASS, output verbatim (NOT RUN separate) | Files: none | Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<name>/run.ps1 <switch> (in order) | Checklist: none
---
Role: playtester | Project: <name> | Stage: A6 | Task #<n>: persona <p> [MANUAL: MANUAL form <p> / MANUAL evaluation <p>] | Topic: a6-playtest-<p> | Gate: P-A6 | Session: close
Read: <PL>/templates/PERSONAS.md, <PL>/templates/PLAYTEST_REPORT.md, <PL>/profiles/<profile>.md, docs/BRIEF.md; product: first check whether it is running, otherwise `run.ps1 -Up`
Acceptance: persona(s) from the BRIEF audience × F-NN tasks, severity-graded findings; RESULT/METHOD/VISUAL (VERIFIED only if you actually saw the screen; UNVERIFIED if it fails in 2 attempts); visual check table | Files: projects/<name>/docs/PERSONAS.md | Verification command: run.ps1 -Up (if not running) | Checklist: none
---
Role: learning-designer | Project: <name> | Stage: A6 | Task #<n>: light age review (only child/teen) | Topic: a6-age | Gate: none | Read: golden example, slice texts, docs/BRIEF.md
Acceptance: YU-03, 04, 05, 10; findings BLOCKER/MAJOR/MINOR | Files: none | Verification command: none | Checklist: <PL>/checklists/age-appropriate-content.md
---
Role: critic | Project: <name> | Stage: A6 | Task #<n>: age suitability (only child/teen) | Topic: a6-c-age | Gate: C-AGE | Read: a6-age report, golden example, slice texts
Acceptance: no BLOCKER item; APPROVE/REVISE + 3 items | Files: none | Verification command: none | Checklist: <PL>/checklists/age-appropriate-content.md (YU-03, 04, 05, 10)
---
Role: planner | Project: <name> | Stage: A6 | Task #<n>: K3 proposal | Topic: a6-k3-proposal | Gate: none | Read: docs/BRIEF.md, step 1-4 reports, source code tree
Acceptance: rough product size (tasks / slices / content), mode proposal (SKILL.md thresholds), ADR-000 KEEP/REWRITE proposal + reasons; ≤15 lines | Files: none | Verification command: none | Checklist: none
---
Role: writer | Project: <name> | Stage: A6 | Task #<n>: PROTOTYPE_REVIEW | Topic: a6-review | Gate: none | Read: <PL>/templates/PROTOTYPE_REVIEW.md, step 1-5 reports (rough size, mode, ADR-000: planner report), docs/BRIEF.md
Acceptance: hypothesis result (CONFIRMED/PARTIAL/REFUTED), test summary, rough size, proposed mode, ADR-000 proposal + reasons (proposals from the planner report; no invention); do not touch the "Retro note" section (A8) | Files: projects/<name>/docs/PROTOTYPE_REVIEW.md | Verification command: none | Checklist: none
---
Role: critic | Project: <name> | Stage: A6 | Task #<n>: prototype verification | Topic: a6-e-a6 | Gate: E-A6 | Read: PROTOTYPE_REVIEW, step 1-6 reports
Acceptance: hypothesis/test/playtest consistent with the reports, no playtest BLOCKER, the slice meets the F-NN criteria; if audience is child, CG-03, 04, 08, 09 (evidence: playtester report) | Files: none | Verification command: none | Checklist: <PL>/checklists/content-quality.md [+ child-safety-privacy.md]
---
Role: writer | Project: <name> | Stage: A6 | Task #<n>: K3 presentation summary | Topic: a6-k3-presentation | Gate: none | Read: docs/PROTOTYPE_REVIEW.md, E-A6 critic report
Acceptance: gates.md K3 template fields sourced, ≤15 lines | Files: report only | Verification command: none | Checklist: none
```

## By audience
Audience child/teen: steps 3-4 (C-AGE) run; child: the CG subset in E-A6. Audience adult: steps 3-4 are skipped. No other conditional gate is written in P/A6 (`track-transitions.md` table).

## Exit criteria
PHASE Exit criteria (Stage=A6, Track=prototype):
| Criterion | Path |
|---|---|
| User personas | docs/PERSONAS.md |
| PROTOTYPE_REVIEW | docs/PROTOTYPE_REVIEW.md |
| T-A6, P-A6, E-A6 (+ C-AGE) gate records | - |
| K3 | - |

## Gate
PENDING (Track=prototype): `T-A6`, `P-A6`, `E-A6`, if audience child/teen `C-AGE` (A6), `K3` (user). Order: tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name> -SkipUserGates` → if PASS, present K3 (`gates.md` K3 section; Visual approval line mandatory) → decision → tester full phase-gate. The next step according to the decision (PROMOTION / SHELVE: A6 exit, A8 note, labels; ITERATE: return to A4) is definitive in the `track-transitions.md` "After the K3 decision" section; it is not copied here. P-A6 NEEDS_FIX/BLOCKER or E/T/C negative: `IN_PROGRESS`, the coder fixes, the relevant step reruns (≤2 rounds; after that `gates.md` Deadlock: gate critic 2 REVISE → BLOCKED). Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key; if K3 is ITERATE the stage returns to A4: immediately new `PENDING` for `E-A4`, `T-A4` (prototype); on re-entry to A6, `T-A6`, `P-A6`, `E-A6`, (if any) `C-AGE`, `K3` (`track-transitions.md` ITERATE; the A4 exit checkpoint has no tag).

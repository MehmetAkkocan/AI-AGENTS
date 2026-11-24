# Track transitions (project-lifecycle)

The lead reads this file when `track = prototype` (at the start of every stage) and on a promotion / SHELVE / direct U entry event. The matrix is in `SKILL.md`; the K3 presentation, its options and the PROMOTION content steps (recomputing `conditional:`, INTAKE line, A1 work) are in the `gates.md` K3 section; names are in `glossary.md`. For order, IDs and tags this file is definitive; `gates.md` and the stage files follow it.

## Prototype (P) flow: A0 → A1 → A2 (L) → A3 (L) → A4 → A6 (L) → K3 → A8 (note)
P has no A5 and A7. Expected gates to write to PHASE with `Track=prototype` at each stage:
| Stage | Stage file | Expected gates | Note |
|---|---|---|---|
| A0 | `a0-discovery.md` | E-A0 | |
| A1 | `a1-concept.md` | E-A1, K1 | BRIEF |
| A2 | `a2-design.md` | E-A2 + triggered C-CHILD, C-DOMAIN; C-ACCESS (in P only audience child) | no K2 |
| A3 | `a3-architecture.md` | E-A3, T-A3 + triggered C-SEC (only user input execution / accounts / network), C-PERF | no ADR |
| A4 | `a4-vertical-slice.md` | E-A4, T-A4 | NO playtest, PERSONAS, K3 proposal, PROTOTYPE_REVIEW, C-AGE / CG review and K3 |
| A6 | `a6-verification-p.md` | T-A6, P-A6, E-A6, C-AGE (only audience child/teen), K3 | VERIFICATION.md and PLAYTEST.md are not written |
| A8 | `a8-retro.md` (P row) | none (E-A8 not expected) | exit criterion: `docs/PROTOTYPE_REVIEW.md` "Retro note" filled |

A4 exit: tester full phase-gate (prototype, A4) PASS → lead state (Stage history `prototype | A4 | … | COMPLETE | p-stage-A4`, `stage: A6`, A6 criteria `OPEN` + gates `PENDING`) → coder `checkpoint.ps1 -Project <name> -Message "A4: vertical slice" -Tag p-stage-A4`.

## P/A6 sequence (prompts in `phases/a6-verification-p.md`)
| # | Role | Work | Topic | Gate |
|---|---|---|---|---|
| 1 | tester | smoke: `run.ps1 -Build -Test -Check -E2E` | a6-test | T-A6 |
| 2 | playtester ×1-2 | first `docs/PERSONAS.md` (from the BRIEF audience); persona playtest + visual check; `Session: close` | a6-playtest-<p> | P-A6 |
| 3 | learning-designer | only audience child/teen: light age review (golden example + slice text; YU-03, 04, 05, 10) | a6-age | none |
| 4 | critic | only audience child/teen: C-AGE (step 3 report is input) | a6-c-age | C-AGE |
| 5 | planner | K3 proposal ≤15 lines: rough size, mode, ADR-000 KEEP / REWRITE | a6-k3-proposal | none |
| 6 | writer | compiles `docs/PROTOTYPE_REVIEW.md` (proposals from step 5; makes no decisions) | a6-review | none |
| 7 | critic | E-A6; audience child: + CG-03, 04, 08, 09 (evidence: playtester report) | a6-e-a6 | E-A6 |
| 8 | writer | only if a field is missing: K3 presentation summary ≤15 lines | a6-k3-presentation | none |
| 9 | lead | tester `-SkipUserGates` PASS → present K3 (`gates.md` K3; visual approval line) | - | K3 |

`VISUAL: UNVERIFIED` in P/A6 needs no separate pre-approval or P-A6 EXCEPTION (the stage ends with K3): if RESULT is PASS then `P-A6` = PASS, visual approval is taken at K3.

## After the K3 decision (record `K3 | prototype | A6 | user | <decision> | <Report> | <day>`)
A precondition exception (e.g. the user still wants K3 while P-A6 is NEEDS_FIX) is taken with the relevant gate's EXCEPTION row; the K3 decision is PROMOTION / ITERATE / SHELVE. If the K3 row was nevertheless written as EXCEPTION, the PROMOTION path runs (the mode is taken from the user; Report `user: visual approval; <reason>`).
**PROMOTION <mode>** (Report `user: visual approval; <presentation report or ->`), in order:
1. tester full phase-gate (prototype, A6) PASS.
2. Lead state: Stage history `prototype | A6 | … | COMPLETE | p-stage-A6`; `stage: A8`, `status: IN_PROGRESS`; A8 criterion (Retro note, Path `docs/PROTOTYPE_REVIEW.md`) `OPEN`; the chosen mode is written to the project `state/HANDOFF.md` (`mode: -` stays until step 6); PROJECTS, project HANDOFF, TASKS archive `## prototype A6`.
3. coder `checkpoint.ps1 -Project <name> -Message "A6: prototype verification" -Tag p-stage-A6`.
4. writer writes a note of ≤10 lines into the `docs/PROTOTYPE_REVIEW.md` "Retro note" section (Topic `a8-retro-note`); the lead moves the PROPOSED rows to the project's `state/LESSONS.md` and sets the criterion to `COMPLETE`.
5. tester full phase-gate (prototype, A8) PASS (no gate row is sought in this stage).
6. Lead state: Stage history `prototype | A8 | … | PROMOTION | p-stage-A8`; promotion header `track: product`, `mode: <chosen>`, `stage: A1`, `status: IN_PROGRESS` + new `Track=product` criterion / gate rows (content: `gates.md` K3 PROMOTION); PROJECTS, project HANDOFF, TASKS archive `## prototype A8`.
7. coder `checkpoint.ps1 -Project <name> -Message "A8: prototype retro note" -Tag p-stage-A8`, then in a SEPARATE call `-Message "A8: prototype-v0" -Tag prototype-v0`.

**SHELVE**: since SHELVE is not a passing value, in step 1 the tester runs `phase-gate.ps1 -Project <name> -SkipUserGates`; 2-5 same; in 6 Stage history `prototype | A8 | … | SHELVED | p-stage-A8`, `status: SHELVED`, PROJECTS SHELVED, project HANDOFF, TASKS archive; in 7 only `p-stage-A8` (`prototype-v0` is not applied). The repo is kept.

**ITERATE** (at most 2; at the 3rd presentation only PROMOTION / SHELVE; no visual approval needed):
1. Lead: no Stage history row is written; `stage: A4`, `status: IN_PROGRESS`; immediately new `PENDING`: `E-A4`, `T-A4` (`prototype | A4`); TASKS archive `## prototype A6`; the planner derives improvement tasks from the observations.
2. A4 exit: tester full phase-gate (prototype, A4) PASS → state (Stage history `prototype | A4 | … | COMPLETE | -`, `stage: A6`) → coder `checkpoint.ps1 -Project <name> -Message "A4: iteration <n>"` UNTAGGED (`p-stage-A4` is not overwritten).
3. On entering A6 immediately new `PENDING`: `T-A6`, `P-A6`, `E-A6`, (if any) `C-AGE`, `K3`; the P/A6 sequence re-runs (reports `-Round <N>`). The A8 note is not written on ITERATE.

## Direct U entry (ready concept) and promoted U
- The condition and the short A0 walk-through are in one place: `phases/a0-discovery.md` Mode differences. coder `new-project.ps1 -Name <name> -Track product -Mode <mode>`.
- `APPROVED-IN-ADVANCE` only if the user explicitly approved the concept IN CHAT (INTAKE: `pre-approval: <day>; source: <projects/<name>/docs/source/<ascii-name>>`); record `K1 | product | A1 | user | APPROVED-IN-ADVANCE | <import planner report path> | <day>`; otherwise K1 is presented normally.
- In A1 the planner writes BRIEF + SPEC from the existing concept; U/full reference scan (researcher) in A0.
- Medium/full: at the end of A4 `K3 | product | A4` (CONTINUE / FIX / STOP; presentation Topic `a4-k3-presentation`, source A4 playtester + tester reports); no K3 in light.
- Promoted U: runs from A1 with `Track=product` rows; P rows do not pass U gates (E-A1, K1 again). No K3 is written in U/A4 → this A4 does not end with a visually approved gate: if `VISUAL: UNVERIFIED`, user visual approval → `P-A4` EXCEPTION (`user: visual approval`). U/full reference scan at the start of A1; ADR-000 finalized in A3.

## Re-run after a negative decision (all tracks)
Negative decision (REVISE, FAIL, FIX, SHRINK, ITERATE, NEEDS_FIX, BLOCKER) → for EVERY gate that will re-run, immediately a new `PENDING` row with the same (Gate, Track, Stage) key; the old passing row cannot leave the gate open. At a user gate: that stage's `E-A<n>`, the affected C-* and `K<n>` (P/K3 ITERATE: the A4 → A6 order above). The status effect is in the PHASE legend.

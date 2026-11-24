# A1 Concept / Definition

## Purpose
Fix what will be built with testable acceptance criteria (P: one-page BRIEF; U: SPEC, in medium/full + CONSTRAINTS) and obtain the user's K1 approval.

## Inputs
`state/INTAKE.md`, the `docs/BRIEF.md` draft, PHASE labels. Promotion: P's BRIEF + `docs/PROTOTYPE_REVIEW.md` (including the ADR-000 proposal) + `state/LESSONS.md` (lessons of the same project; the lead reads it). Direct U: the `docs/source/` copy of the ready concept file (the coder copied it in A0 step 0, written to INTAKE; if there is a `pre-approved:` line, K1 is `APPROVED-IN-ADVANCE`).

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`.
1. **researcher** (haiku) — only promotion + U/full: reference scan (scope and acceptance: same as `a0-discovery.md` step 3; `Stage: A1`, Topic `a1-reference`, Read: `docs/PROTOTYPE_REVIEW.md`). **In parallel with 2**.
2. **planner** (opus, planning) — P: finish the BRIEF; U: write the SPEC (skill: spec-driven-development). Features `F-01`…, acceptance criteria `F-01.a` (countable, testable); Constraints and Non-goals are mandatory:
```
Role: planner | Project: <name> | Stage: A1 | Gate: none | Task #<n>: <P: BRIEF | U: SPEC | direct U: BRIEF + SPEC>
Read: <PL>/templates/<BRIEF|SPEC>.md, state/INTAKE.md, docs/BRIEF.md [promotion/direct U: + PROTOTYPE_REVIEW.md / docs/source/<copy>] [U: + <PL>/profiles/<profile>.md (Scope, Limits)]
Acceptance: P: hypothesis, scope (3-5, with F-IDs), success signal · U: a measurable F-NN.x criterion for every F-NN; triggered C-* items; in Constraints the platform choice is justified by the profile priority (mobile: native justification if web/PWA is not enough); on promotion the ADR-000 proposal is preserved
Files: projects/<name>/docs/<BRIEF|SPEC>.md [direct U: both] | Topic: a1-<brief|spec> | Verification command: none | Checklist: none
```
3. **planner** — only U/medium-full, after step 2 (depends on the SPEC; skill: constraint-driven-development):
```
Role: planner | Project: <name> | Stage: A1 | Gate: none | Task #<n>: CONSTRAINTS
Read: projects/<name>/docs/SPEC.md
Acceptance: the SPEC "Constraints" content moved to CONSTRAINTS (a single reference line left in the SPEC), every constraint verifiable; in full mode, milestones in the SPEC
Files: projects/<name>/docs/CONSTRAINTS.md, docs/SPEC.md | Topic: a1-constraints | Verification command: none | Checklist: none
```
4. **critic** (opus; gate) — E-A1; this report is also the input of the K1 presentation:
```
Role: critic | Project: <name> | Stage: A1 | Gate: E-A1 | Task #<n>: concept review
Read: docs/<BRIEF|SPEC>.md, state/INTAKE.md
Acceptance: criteria testable; consistent with INTAKE; P: scope ≤5 items, U: summarizable in ≤5 main headings in the K1 presentation; the `conditional:` list matches the triggers (write missing/extra C-*); 2 risks; APPROVE/REVISE + 3 items
Files: report only | Topic: a1-e-a1 | Verification command: none | Checklist: none
```
5. **Lead**: enter the missing C-* triggers found by the critic into PHASE `conditional:`; for the K1 presentation see the `gates.md` K1 section.

## Mode differences
- P: step 2 BRIEF (one page); 3 skipped; the core loop / learning goal is added to the BRIEF in A2. U/light: short SPEC; 3 skipped. U/medium: 2 + 3. U/full: 2 + 3 + milestones.
- Promotion (return to A1): step 2 expands the existing BRIEF into the SPEC; promotion + full: step 1 mandatory.
- Direct U (rule: `a0-discovery.md` Mode differences): in step 2 the planner writes BRIEF + SPEC from the existing concept (the planner report = import report); E-A1 still runs. If there is `pre-approved:` evidence in INTAKE, K1 is `APPROVED-IN-ADVANCE`, Report = this planner report (not presented); with no evidence (the user did not explicitly say "approved") K1 is presented normally (`gates.md` K1).

## Exit criteria
| Criterion | Path |
|---|---|
| P: BRIEF (hypothesis, scope, success signal) | docs/BRIEF.md |
| U: SPEC (acceptance criteria) | docs/SPEC.md |
| U/medium-full: CONSTRAINTS | docs/CONSTRAINTS.md |
| E-A1 critic APPROVE | - |

## Gate
Write as PENDING: `E-A1` (critic) and `K1` (user; on direct U only `APPROVED-IN-ADVANCE` with INTAKE `pre-approved:` evidence). Order: E-A1 APPROVE → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name> -SkipUserGates` → if PASS, present K1 (`gates.md` K1 section), `WAITING_USER` → decision → full `phase-gate.ps1` (without SkipUserGates) → PHASE/PROJECTS/project HANDOFF/TASKS archive → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A1: concept" -Tag <p|u>-stage-A1`. FIX: `IN_PROGRESS`, back to step 2. STOP: `SHELVED`. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open); if K1 is negative, `E-A1` and `K1`. The decision comes only from the user's chat message.

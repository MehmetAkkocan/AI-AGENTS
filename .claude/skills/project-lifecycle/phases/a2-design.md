# A2 Design

## Purpose
Design the experience before coding; prove SPEC ↔ design ↔ UX consistency (in P, consistency within the BRIEF) and the conditional gates at design level.

## Inputs
`docs/SPEC.md` (P: `docs/BRIEF.md`), `docs/CONSTRAINTS.md` (if present), PHASE labels and `conditional:`. Promotion: + `docs/BRIEF.md` "Prototype hypothesis and light design" + `docs/PROTOTYPE_REVIEW.md` (playtest findings).

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Round: <N>` (revision only) and `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`.
1. **Lead** (document by type): game (no learning goal) → GDD + UX · every type with a `+game` suffix (education+game, learning+game, self-development+game) → GDD + LEARNING_DESIGN + UX · education/learning → LEARNING_DESIGN + UX · self-development → LEARNING_DESIGN (behavior/habit) + UX. ART_AUDIO always goes with UX (U/medium-full).
2. **game-designer** (opus, design) and/or **learning-designer** (opus) — if both are needed, **in parallel** in U/medium-full (separate files); SEQUENTIAL in P and U/light, in the same file (game-designer first). Skill: doubt-driven-development. IDs: feature `F-NN` (SPEC), goal `LO-NN`; every F-NN gets a mapping field in the design:
```
Role: <game-designer|learning-designer> | Project: <name> | Stage: A2 | Gate: none | Task #<n>: <GDD|LEARNING_DESIGN|BRIEF core loop / learning goal|DESIGN>
Read: <PL>/templates/<GDD|LEARNING_DESIGN|DESIGN>.md, docs/SPEC.md (P: BRIEF.md) [promotion: + BRIEF.md light design section, PROTOTYPE_REVIEW.md] · Checklist: <PL>/checklists/<child-safety-privacy|sensitive-domain>.md (if triggered); P + audience child: + accessibility.md [basic] A2 items
Acceptance: template headings filled; every F-NN linked to a design element; visual/audio needs producible with code are listed; language suited to the audience. P: core loop / learning goal + 1 flow in the BRIEF; P + audience child: accessibility and child safety note in the BRIEF light design (color pair + ratio, keyboard path, focus, touch target ≥48 px, no time limit, no data collected) · promotion: the loop / LHs in the BRIEF expanded, response to the P-A4 findings present
Files: projects/<name>/docs/<GDD|LEARNING_DESIGN|DESIGN|BRIEF>.md | Topic: a2-<gdd|ld|design|brief> | Verification command: none
```
3. **ux-designer** (sonnet; opus on the 2nd REVISE) — only U; after step 2. U/light: a screen section is added to `docs/DESIGN.md` (sequential, same file). In full mode, HTML wireframes under `docs/ux/wireframes/`:
```
Role: ux-designer | Project: <name> | Stage: A2 | Gate: none | Task #<n>: UX + ART_AUDIO [U/light: DESIGN.md screen section]
Read: <PL>/templates/UX.md, <PL>/templates/ART_AUDIO.md, docs/SPEC.md, step 2 documents; skill: frontend-ui-engineering · Checklist: <PL>/checklists/accessibility.md; + child-safety-privacy.md (C-CHILD: CG-06, 08, 10, 11); + sensitive-domain.md (C-DOMAIN: HA-01, 05, 12)
Acceptance: flows, screen inventory, per-screen states, design tokens, accessibility targets; a UX mapping field for every F-NN; visuals/audio only producible with code (SVG/CSS/synthesis); full: wireframes
Files: projects/<name>/docs/UX.md, docs/ART_AUDIO.md [light: docs/DESIGN.md; full: + docs/ux/wireframes/01-main-screen.html] | Topic: a2-ux | Verification command: none
```
4. **tester** (haiku) — optional Gemini plan second opinion (skill: antigravity; writes no files):
```
Role: tester | Project: <name> | Stage: A2 | Gate: none | Task #<n>: Gemini plan second opinion
Read: .claude/skills/antigravity/SKILL.md
Acceptance: command output and report path relayed verbatim; no commentary
Files: report only | Topic: a2-second-opinion | Checklist: none
Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/antigravity/scripts/agy-run.ps1 -Prompt "<show the design documents by absolute path; suggest 5 improvements>" -Topic a2-second-opinion -Mode plan -Project <name>
```
5. **critic** (opus; gate) — E-A2 cross-consistency, then a separate task for every A2 gate in `conditional:` (Gate: C-CHILD → `child-safety-privacy.md` · C-DOMAIN → `sensitive-domain.md` · C-ACCESS → `accessibility.md`; document level, no browser):
```
Role: critic | Project: <name> | Stage: A2 | Gate: <E-A2|C-CHILD|C-DOMAIN|C-ACCESS> | Task #<n>: <consistency | checklist review>
Read: SPEC↔design↔UX [P: BRIEF; U/light: SPEC↔DESIGN] documents, step 4 report (if any) · Checklist: <PL>/checklists/<file> (none for E-A2)
Acceptance: E-A2: every F-NN present in design/UX in both directions, no contradiction, Gemini suggestions accepted/rejected with reasons · C-*: no BLOCKER item, MAJOR resolved or sent to BACKLOG with reasons; APPROVE/REVISE + 3 items
Files: report only | Topic: a2-<e-a2|c-child|c-domain|c-access> | Verification command: none
```

## Mode differences
- P: step 2 writes to the BRIEF (no UX/ART_AUDIO), 3 skipped, no K2; C-ACCESS only for audience=child. U/light: a single `docs/DESIGN.md` (designer, then step 3 screen section), no K2. U/medium: separate documents, steps 1-5. U/full: + detailed ART_AUDIO and wireframes.

## Exit criteria
| Criterion | Path |
|---|---|
| P: core loop + 1 flow | docs/BRIEF.md |
| U/light: DESIGN | docs/DESIGN.md |
| U/medium-full: GDD (game and +game types) | docs/GDD.md |
| U/medium-full: LEARNING_DESIGN (education, learning, self-development, +game) | docs/LEARNING_DESIGN.md |
| U/medium-full: UX | docs/UX.md |
| U/medium-full: ART_AUDIO | docs/ART_AUDIO.md |
| U/full: wireframe | docs/ux/wireframes/01-main-screen.html |
| E-A2 and triggered C-* APPROVE | - |

## Gate
PENDING: `E-A2` (critic) + the C-CHILD / C-DOMAIN / C-ACCESS in `conditional:` (those at A2; in P, C-ACCESS only for audience=child) + in U/medium-full `K2` (user). Order: all E/C APPROVE → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name> -SkipUserGates` → if PASS, present K2 (`gates.md` K2 section), `WAITING_USER` → decision → full `phase-gate.ps1` → update state → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A2: design" -Tag <p|u>-stage-A2`. K2 does not open while a BLOCKER finding exists. REVISE/FIX: `IN_PROGRESS`, back to the relevant step (≤2 rounds). SHRINK: does not pass the gate; the planner narrows the scope (prompt below), the designers narrow the documents, K2 is presented again. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open); if K2 is negative, `E-A2`, the affected C-* and `K2`. In P/light there is no user gate.
```
Role: planner | Project: <name> | Stage: A2 | Gate: none | Task #<n>: K2 SHRINK scope narrowing | Read: docs/SPEC.md, the user's K2 note (the lead writes it into the prompt)
Acceptance: removed F-NNs moved to "Out of scope" in the SPEC with reasons, IDs not renumbered | Files: projects/<name>/docs/SPEC.md | Topic: a2-shrink | Verification command: none | Checklist: none
```

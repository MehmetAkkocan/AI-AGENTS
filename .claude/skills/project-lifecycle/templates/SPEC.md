<!-- A1 | owner: planner (critic reviews) | target: docs/SPEC.md (U track) | gate: E-A1 -> K1 (the K1 presentation comes from this document: Product definition, Labels, Scope, Non-goals, Conditional gates, Risks) -->
<!-- U/light minimum: Product definition, Labels, Goals, Features, Out of scope, Constraints, Success criteria, Conditional gates, Risks. Medium/full: "Constraints" moves to docs/CONSTRAINTS.md, a pointer stays here. Milestones only in full mode. Placeholder name: <name>. -->
# SPEC <name>

## Product definition
<!-- fill-in instruction: ONE sentence: "<for whom> <doing what> <product type>". Source: BRIEF.md or the approved concept document. -->
<one sentence>

## Labels
<!-- fill-in instruction: glossary values verbatim; the track in this document is "product". -->
type: <...>[+game] | audience: <child/teen/adult> | profile: <web/mobile/desktop-engine> | track: product | mode: <light/medium/full>

## Goals
<!-- fill-in instruction: 3-5 items; each says why the product exists. -->
- <goal>

## Features and acceptance criteria
<!-- fill-in instruction: each feature gets an ID F-01, F-02... (no other format); acceptance criteria are SUB-ITEMS F-01.a, F-01.b and testable ("given X, Y is observed"). IDs are cited verbatim in GDD/LEARNING_DESIGN/UX/TEST_PLAN/VERIFICATION; no renumbering. -->
| ID | Feature / story | Acceptance criterion (F-xx.a) | Priority |
|---|---|---|---|
| F-01 | <As a user, I want ...> | F-01.a: <Given ..., ... is shown> | <REQUIRED/OPTIONAL> |

## Out of scope
<!-- fill-in instruction: things deliberately left out, at least 3 items (presented as "Non-goals" at K1). -->
- <out of scope>

## Constraints
<!-- fill-in instruction: platform/profile, host (only git, Podman, PowerShell 5.1 on the host: build and run in containers), technology constants, data/privacy limits, language. -->
- Platform: <web/mobile/desktop-engine>; host: container (Podman)

## Success criteria
<!-- fill-in instruction: 3-6 measurable product-level items (e.g. "run.ps1 -E2E green", "3 personas complete their tasks"); the A6 VERIFICATION coverage rows link to these. -->
- <criterion>

## Conditional gates
<!-- fill-in instruction: per the SKILL.md trigger table, the triggered C-* IDs + one line of rationale (mode does not remove a conditional gate; on track=product C-SEC and C-ACCESS always apply). The PHASE conditional: line comes from here. -->
- <C-SEC: rationale>

## Risks
<!-- fill-in instruction: at most 5; "risk -> mitigation". The first 2 are used in the K1 presentation. -->
- <risk -> mitigation>

## Milestones (full mode only)
<!-- fill-in instruction: 3-6 milestones: name, F-IDs included, estimated slice count. Delete the section in other modes. -->
- <MS-1: F-01..F-03>

## Open questions
<!-- fill-in instruction: "-" if none. -->
- <question>

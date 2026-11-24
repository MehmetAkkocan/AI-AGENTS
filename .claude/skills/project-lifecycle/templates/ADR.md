<!-- A3 (and later), written by planner (decision from planner/coder), target: docs/adr/<NNN>-<topic>.md; NNN is three digits, 000 = 000-prototype-code.md. One decision, one file. Mode: none in P (only 000 at promotion) · none in light · required in medium/full -->
# ADR <NNN>: <decision title>

## Status
<!-- Proposed | Accepted | Rejected | Superseded (<NNN>) ; date yyyy-MM-dd -->
<status> — <yyyy-MM-dd>

## Context
<!-- Which problem, which constraint (SPEC, CONSTRAINTS, host constraint), why a decision is needed now. 3-6 lines. -->
<context>

## Decision
<!-- Start with a single clear sentence; then brief detail. -->
<decision>

## Options
<!-- At least two options; the chosen one on the first row. Pros/cons should be measurable (cost, risk, maintenance). -->
| Option | Pros | Cons |
|---|---|---|
| <A (chosen)> | <pro> | <con> |
| <B> | <pro> | <con> |

## Consequences
<!-- Positive, negative, risk to watch; affected modules and documents (ARCHITECTURE, contracts). -->
- <consequence>

<!-- EXAMPLE NOTE — 000-prototype-code (only at a track promotion, written by planner in A3 after K3 = PROMOTION; the "keep / rewrite" proposal appears in the K3 presentation and is finalized in A3 with the architecture critic):
Context: the code tagged prototype-v0 was built quickly; it is unclear whether it will be kept on the product track.
Decision: per module KEEP or REWRITE; table: module / decision / rationale.
Consequence: tests are added to KEEP modules; REWRITE modules are replaced with stubs. -->

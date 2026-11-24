<!-- A3, filled by planner (coder updates it while building the skeleton), target: docs/ARCHITECTURE.md. P: walking skeleton, only §1, §4 · light: §1-5 · medium: + §8 · full: + §6, §7. If C-SEC is conditional, §6 is filled; if C-PERF is conditional, §7 is filled (real-time game), whatever the mode -->
# Architecture — <name>

## 1. Stack and rationale
<!-- One-line rationale per choice. Host constraint: only git, podman, PowerShell 5.1; everything is built and run in containers. -->
| Layer | Choice | Rationale |
|---|---|---|
| Runtime | podman, <image> | no toolchain on the host |
| <backend / engine> | <choice> | <rationale> |
| <frontend / client> | <choice> | <rationale> |
| <data> | <choice> | <rationale> |

## 2. Module map and boundaries
<!-- For each module: responsibility, modules it depends on, the boundary that must NOT be touched. No circular dependencies. -->
| Module | Path | Responsibility | Dependencies |
|---|---|---|---|
| <module> | <src/...> | <one sentence> | <module list or none> |

## 3. Data model
<!-- Entities, fields, relations; separation of persistent data from content files. -->
- <entity>: <fields>; <relation>

## 4. Contracts and running
<!-- API.md content: endpoint/route, request-response format, error codes (including interface slices). Code follows the contract, not the other way around. -->
- Contracts: `docs/contracts/CONTENT_SCHEMA.md` (content), `docs/contracts/API.md` (interface).
- `run.ps1`: `-Build` image · `-Up` <address> · `-Down` · `-Test` · `-Check` content validation · `-E2E` smoke · `-Logs`
- Run fields (coder writes `run.ps1` only from the profile + these fields): Service name: <name> · Port: <host:container> · Test target: <separate test stage/image + command> · Content validation (`-Check`): <command> · E2E scenario: <step summary>

## 5. Stub / wiring plan
<!-- Before a parallel group that touches a shared module, a single coder does the stub + wiring. Write in order. -->
1. <module>: <stub content, wiring point> -> then in parallel: <module A>, <module B>

## 6. Security notes / threat model (full; C-SEC)
<!-- Threat + mitigation for user input, accounts, network, executed code; checklist security-hardening.md. -->
| Asset / entry point | Threat | Mitigation | Residual risk |
|---|---|---|---|
| <user input, account, network, executed code> | <threat> | <mitigation> | <risk> |

## 7. Performance budget (full; C-PERF)
<!-- Measurable targets; tester verifies with these commands in T-A6. -->
| Metric | Target | Measurement command |
|---|---|---|
| <first load, response time, memory, FPS> | <number + unit> | <command> |

## 8. ADR list
<!-- One docs/adr/ file per significant choice; a one-line summary here. -->
`docs/adr/000-prototype-code.md` (on promotion from P) · `<NNN>-<topic>.md`: <one-line decision>

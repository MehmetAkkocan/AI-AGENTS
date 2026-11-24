<!-- A3, planner fills, target: CLAUDE.md (project root), <=25 lines; remove documents that do not exist yet from the list -->
# <name> — project card
<one-sentence product definition>. Labels: type <type>, audience <audience>, profile <profile>, track <track>, mode <mode>.

## Stack
<language + framework + data; <rationale>>. The host has only git, podman, PowerShell 5.1; everything runs in containers.

## Commands (`run.ps1`, success = exit 0)
`-Build` · `-Up` (<address:port>) · `-Down` · `-Test` · `-Check` (content validation) · `-E2E` (smoke) · `-Logs`

## Contracts and documents
`docs/contracts/CONTENT_SCHEMA.md`, `docs/contracts/API.md`, `docs/ARCHITECTURE.md`, `docs/TEST_PLAN.md`, `docs/SPEC.md`. Code does not deviate from the contract; if a deviation is needed, ask the lead.

## Folder rules
`state/` lead only · `docs/` documents · `reports/` agent reports, `reports/shots/` screenshots · `<source>/`, `<content>/`, `<tests>/`

## Prohibitions
- Agents do not commit (`checkpoint.ps1` as a single coder task, when the lead requests it).
- Touch only the files named in the task; two agents never write the same file.
- Only the lead writes `state/` files. Playwright is not used.

## Report path
Each agent writes its report to the output of `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]`; the reply is <=10 lines.

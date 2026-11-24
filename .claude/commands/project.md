---
description: Manages the project lifecycle (from idea through release and retro). Subcommands - new, status, advance (resume), select, list.
argument-hint: new <name> "<idea>" | status [name] | advance [name] | resume [name] | select <name> | list
---

Load and apply the `project-lifecycle` (outer loop: stage, gate) and `team-lead` (inner loop: task flow) skills. You are the team lead; you write only `team/state/**`, `projects/PROJECTS.md` and `projects/<name>/state/**` (project information is never written outside `projects/`), and you do not run scripts.

Input: $ARGUMENTS

Active project resolution (for subcommands given no name): 1) argument → 2) the `Active project:` pointer in `projects/PROJECTS.md` → 3) a single `IN_PROGRESS` project in the table → 4) if more than one, a single question to the user.

## new <name> "<idea>"
1. If the name does not match `^[a-z0-9]+(-[a-z0-9]+)*$`, ask for a correction; if `projects/<name>/` exists, stop and report.
2. Read `team/budget.json` and `team/state/HANDOFF.md` (a new project is isolated; earlier projects' lessons are not read).
3. Have the `coder` run `new-project.ps1 -Name <name>` (a single task; for a project entering the U track directly with a ready concept, `-Track product -Mode <light|medium|full>`). If the user gave a source file from outside the project, in the same task the coder copies the file right after setup as `projects/<name>/docs/source/<ascii-name>` (the original name/location is written once into the INTAKE `source:` line) (if it comes up later, a separate single coder task). The coder writes the report after the script succeeds; if it fails it writes no report and gives the error text in its reply. The lead does not run scripts.
4. The script does not touch the pointer or the TASKS header; the lead does: switch the `Active project:` pointer in `projects/PROJECTS.md` to the new name (first update the current active project's HANDOFF), fill in the first header line (`# TASKS …`) of the project's `state/TASKS.md`. No project information is written to the global HANDOFF.
5. Read `project-lifecycle/phases/a0-discovery.md`; start the discovery interview of ≤7 questions with `<idea>`.
For a project arriving with a ready concept (direct U): set it up on the U track; A0 runs short, K1 is `APPROVED-IN-ADVANCE` only if the user explicitly approved the concept in chat. The rule lives in one place: `phases/a0-discovery.md` Mode differences (continue from there).
## status [name]
A summary of ≤12 lines from the `projects/PROJECTS.md` row + the project's `state/PHASE.md`, `state/HANDOFF.md` and `state/TASKS.md`: track/mode/stage/status, waiting gate, number of open tasks (rows in the single TASKS table whose Status is not DONE), next step.

## advance [name]  (`resume` is the same)
Resolve the project; read `state/PHASE.md`, `HANDOFF.md`, `TASKS.md`.
- `status: WAITING_USER` → re-present the waiting gate using the relevant K section of `gates.md` (≤15 lines); the decision is taken only from the user's chat message.
- Otherwise → read the active stage's `phases/a<N>-*.md` file, run the stage transition procedure (SKILL.md); tasks proceed through the `team-lead` inner loop.

## select <name>
If `<name>` is not in `projects/PROJECTS.md`, stop. First update the current active project's `state/HANDOFF.md`, then set the `Active project:` pointer to `<name>` (a single active project per session); no project information is written to the global HANDOFF.

## list
Show the `projects/PROJECTS.md` table; mark the active project.

If there is no active project, ask for `new` or `select`. At the end of each subcommand give the user a short status.

---
name: team-lead
description: Level 6 — Team lead protocol for a lead that does no work itself (inner loop: task flow). The /project command (or a project request without a slash) and hub maintenance load it. The lead splits the task, delegates to agents, reads only summaries, runs them through the critic, keeps the state files current; it produces no code/files itself. Compaction-resilient.
---

# Team lead protocol

You are the conductor. The work is done not by you but by the agents you manage. This skill is loaded with `/project` or in hub maintenance (CLAUDE.md).

## Absolute rules

1. **Edit/Write only for `team/state/**`, `projects/PROJECTS.md` and `projects/<name>/state/**`.** Project information is never written outside `projects/` (persistent memory included). `docs/`, source, content and `reports/` always belong to the agents; you change no other file.
2. **Do NOT read the full report.** The ≤10-line summary the agent returns is enough; if detail is needed, have the `critic` read it. Exceptions (in project work): you prepare the user gate (K<n>) presentation yourself; the source agent replies + the document the writer compiled (on P at K3: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`); if a field is missing, give the writer a "K<n> presentation summary" task (a report of ≤15 lines), and you may read this ONE report in full. In a MANUAL playtest you relay to the user only the `## MANUAL observation form` section of the report.
3. **The lead does not run scripts/commands.** Each agent runs `stamp.ps1` itself for its own report (you only give the topic). Other team scripts (`budget.ps1`, `agy-run.ps1`, `list-reports.ps1`, `phase-gate.ps1`, etc.) are run by agents on your behalf (usually `tester`; commit/skeleton work `coder`). You read `team/budget.json` with Read. The budget script (`budget.ps1`) is run by the user by hand or you delegate it to `tester`; you always have `tester` run `agy-run.ps1`.
4. **Two agents never write the same file at the same time.** Build parallel groups accordingly.
5. **`model-router` before every delegation.** Look at `team/budget.json`, apply the table.
6. **Update state after every step.** TASKS.md and the project HANDOFF (`projects/<name>/state/HANDOFF.md`) are always current (in hub maintenance only the global `team/state/HANDOFF.md`, no task table); so nothing is lost if compaction comes.
7. **Do not guess timestamps.** The agent generates the report path with `stamp.ps1`; you only give the topic.
8. **No DONE without a report.** If the agent's summary has no line whose name is exactly `REPORT: <path>`, the task is not counted as DONE and is sent back to the agent (critic and tester included; "the decision stayed in the reply" is not accepted). Another line name such as `FILE:` does not stand in for `REPORT:` (the writer gives `FILE:` additionally; the planner gives only `REPORT:`).

## Two layers

Outer loop (`project-lifecycle` skill): project stages A0-A8, gates, track/mode → `projects/<name>/state/PHASE.md`. Inner loop (this skill): the PENDING→RUNNING→DONE flow of tasks inside a stage → `TASKS.md`.

## Flow

### 0. Active project: resume or new?
- Active project resolution: the `/project` argument → the `Active project:` pointer in `projects/PROJECTS.md` → a single `IN_PROGRESS` project in the table → if more than one, a single question to the user.
- State path `projects/<name>/state/` (TASKS, HANDOFF, PHASE), reports `projects/<name>/reports/` (`Project: <name>` in the call); the `project-lifecycle` skill is loaded together for stage/gate management. If there is no active project, ask for `/project new` or `/project select`. The exception is HUB MAINTENANCE (CLAUDE.md): no active project is looked up, `Project: none (hub maintenance)` + `-Hub`, reports `team/reports/`, no task table, no project name/content is written; progress lives in `team/state/HANDOFF.md` in the "Ongoing hub maintenance" section; the other rules of this skill apply exactly.
- If the task is `resume` or the session came out of compaction (including a "continue" without a slash): first `team/state/HANDOFF.md`; if it has an "Ongoing hub maintenance" section, that is resumed FIRST; then read `projects/PROJECTS.md` (if absent there is no project yet), then the active project's `state/HANDOFF.md`, `PHASE.md`, `TASKS.md`, and carry on where you left off.
- If it is a new task, start from 1.

### 1. Analysis and planning
- Read `team/budget.json`.
- Give the task to the `planner` agent (model: per the table). State the path of the TASKS file (`projects/<name>/state/TASKS.md`) in the prompt.
- The planner writes the full plan to the report file and the task table to TASKS.md (status: PENDING); it returns a ≤10-line summary to you.
- The project TASKS has a SINGLE table with a fixed 6 columns: `| # | Task | Role | Model | Status | Report |`. The planner adds rows to the existing table, does not open a new header/table; A5 slices carry a `D<k>-<n>` prefix in the `#` cell. The acceptance criteria, files and verification command are in the `Task` cell (`<definition>; Accept: ..; Files: ..; Verify: ..`); build the delegation prompt from this cell. You fill in the first header line (`# TASKS …`).
- Read the table from TASKS.md; manage the plan from the table, not from the report file.
- If the plan is unclear, ask the user a single question; otherwise carry on.

### 2. Orchestration
- Process parallel groups in order. Start the independent tasks of a group **in the same message** with several Agent calls (the default method).
- Workflow is used only if the user explicitly asks.
- Every Agent prompt contains: the task definition, acceptance criteria, verification command (if needed), files to touch, topic, a "reply ≤10 lines" reminder.
- If `gemini` is selected, call it with the `antigravity` skill.
- **Stage-exit handoff (single item):** the gate check `phase-gate.ps1` → `tester` (relays the output VERBATIM: ≤10 lines + `REPORT:`; no commentary is requested); `new-project.ps1` (+ if there is a source file from outside the project, its copy into `docs/source/`) and `checkpoint.ps1` → `coder` (a single task, not inside a parallel group; agents do not commit on their own). Order: first you update PHASE/`projects/PROJECTS.md`/the project HANDOFF, THEN the checkpoint goes to the coder; for double-tag situations (promotion, A7) see `project-lifecycle` SKILL.md.
- **playtester and ux-designer:** the playtester actually runs the product (does not guess by reading code) and connects only to a local address. Before calling either, ask the user to keep the Browser panel visible. Visual session order: `Session: keep-open` → the playtester leaves the product open → the ux-designer compares → you give the tester `run.ps1 -Down`; if there is no ux step, `close`. The `VISUAL` line is informational. If the stage ends with K3 or K4, `UNVERIFIED` does not ask for a separate pre-approval: if RESULT is PASS, `P-A<n>` is written PASS, the visual approval is taken at the gate itself (at K3/K4 visual approval is always mandatory; the Report cell of the passing decision is `user: visual approval; <presentation report or ->`). If the stage does not end with such a gate (`P-A5` in full mode, A4 of U without K3), ask the user for visual approval for `UNVERIFIED`; the approval is written into the gate record as an EXCEPTION (`user: visual approval`).
- **MANUAL playtest:** MANUAL has two calls: (1) the playtester (`Task: MANUAL form <p>`) writes the manual test scenario + observation form into the `## MANUAL observation form` section of its report, gives no RESULT, returns `STATUS: NEEDS_REVIEW` + "waiting for user" (the gate row stays PENDING); the lead presents the form (only that section) to the user and writes the user's chat reply verbatim into `state/MANUAL-<p>.md`; (2) the playtester (`Task: MANUAL evaluation <p>`, `Read: state/MANUAL-<p>.md`) evaluates the reply and returns RESULT (`METHOD: MANUAL`, `VISUAL: UNVERIFIED`). In a stage ending with K3/K4 the form does NOT replace visual approval (a one-sentence confirmation is still requested at the gate). In other stages the form counts as visual approval for those screens: if RESULT is PASS the gate record is `EXCEPTION`, Report `user: visual approval (MANUAL form); <playtester report paths>`. In TASKS the row for (1) becomes DONE when the reply is written to `state/MANUAL-<p>.md` (report = the form report); (2) is a new row.
- TASKS.md: status → RUNNING.

### 3. Context management
- From the returned summary, record only STATUS, CHANGED files, REPORT path, OPEN QUESTION in TASKS.md.
- If the summary exceeds 10 lines, ignore the excess; remind the agent to write shorter next time.
- Update the project HANDOFF (`projects/<name>/state/HANDOFF.md`): "what is being done now / next step / open questions".

### 4. Quality control
- Send every DONE task to the `critic`: a single-task review (`Gate: none`) with `model: sonnet`; a gate review with the `critic.md` default (opus), and when `tight`, `model: sonnet` (model-router table). Give the acceptance criteria and the report path in the prompt.
- **Tester mandatory:** the definition of every task that produces code, a script or runnable output has a "Verification command"; the task is not counted as DONE without critic APPROVE + tester PASS. Document-only tasks need no tester.
- Intermediate state: the agent finished but critic/tester is pending → TASKS.md: `NEEDS_REVIEW`. `DONE` is written only when the gates pass (critic APPROVE, for code/scripts additionally tester PASS).
- APPROVE (+ PASS if required) and the report path exists → TASKS.md: DONE. If the report path is missing, rule 8: send back.
- REVISE → give the critic's 3 items back to the same agent. At most 2 rounds. If the TASK critic gives REVISE again in round 2, round 3: critic `model: opus`, the producing agent one model up (the same if already opus), a new Agent call + the previous report paths; if still REVISE, `BLOCKED`, ask the user. If the GATE critic (already opus) gives REVISE for 2 rounds → no promotion → `BLOCKED`. When `tight` there is no promotion: after 2 rounds `BLOCKED`. Consecutive rounds on the same model continue with the same agent (SendMessage).
- FAILED → write the reason in TASKS.md, notify the user, hold the dependent tasks.

### 5. Reporting
- When all tasks are DONE, to the user: what was done (file list), what was verified (tester/critic results), what remains open. ≤15 lines.
- In the project TASKS rows are NOT moved, a single table remains; at the end of a stage (after phase-gate PASS) append the whole table to `state/TASKS-ARCHIVE.md` (`## <track> A<N>`) and empty the TASKS table.
- Write "task completed" to the project HANDOFF.

## Agent call template

```
Role: <coder|writer|researcher|tester|critic|planner|game-designer|learning-designer|ux-designer|playtester>
Task #<n>: <definition>
Acceptance criteria: <...>
Verification command: <for code/script/runnable output; "none" if document-only>
Files: <touch only these>
Topic: <short-ascii-topic>
Project: <name>   (in hub maintenance `Project: none (hub maintenance)`)
Stage: A<n>   (optional; in project work)
Gate: <id>   (optional; in a critic/tester/playtester gate call, e.g. E-A2, T-A3, P-A4)
Checklist: <path>   (optional; in gate/review work)
Round: <N>   (only in a revision)
Session: keep-open | close   (optional; playtester call only; keep-open if a ux-designer comparison will follow, close if not/omitted)
Generate the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> (-Project <name> | -Hub) [-Round <N>]
Your reply is at most 10 lines, in the format of your role file; the `REPORT: <path>` line is mandatory.
```

The Agent `model` parameter is given only when the model-router table requires a model different from the default (the agent file's `model:`) (e.g. `sonnet` for the critic in a task review).

Reports go under `projects/<name>/reports/` (`-Project <name>` is mandatory); `team/reports/` is only for hub-maintenance (`-Hub`) work. `agy-run.ps1` uses the same pair.

Round suffix standard: `-t<N>` (e.g. `...-writer-topic-t2.md`).

## Compaction resilience

You must be able to continue from the information in the state files even if context is compacted. Reading order: `team/state/HANDOFF.md` (if it has an "Ongoing hub maintenance" section, that is resumed FIRST) → `projects/PROJECTS.md` (if absent there is no project yet) → the active project's `state/HANDOFF.md`, `PHASE.md`, `TASKS.md`. Therefore:
- Edit state files with targeted Edit calls, not line-based commands like `sed` (so the wrong line is not changed).
- Do not keep decisions in your head; write them to the project HANDOFF (to the global one in hub maintenance).
- Do not pull report contents into context; write their path to TASKS.md.
- Record important instructions from the user in the open-questions section of the project HANDOFF in project work, and under the global HANDOFF "Open questions / awaiting from user" in hub maintenance.
- Budget `exhausted`: project status to the project HANDOFF, budget status to the global one.

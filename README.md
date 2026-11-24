# AI Agent Team — 6 Levels + Project Lifecycle

A Windows setup of a six-level AI agent team built on Claude Code (with optional Antigravity/Gemini). On top of it sits a project lifecycle: nine stages from idea to release and retrospective (A0–A8), and four user gates (K1–K4).

The main session is the **team lead**. It coordinates work and writes only state files; it does not run scripts. Agents produce the output, and the critic, tester, and playtester review it.

## Quick start

```
/proje yeni <ad> "<fikir>"
```
Starts a discovery interview (≤7 questions). Then:

```
/proje durum
/proje ilerle
```
- `/proje durum`: summary of the active project. `/proje ilerle`: runs the next step and asks you at each gate; if the session is interrupted, the same command resumes it.
- All project work goes through `/proje` (the only exception is maintaining the hub itself, described in `CLAUDE.md`). This folder is a general hub; everything project-specific lives under `projects/<ad>/`.
- User guide: [docs/KULLANIM.md](docs/KULLANIM.md). Team lead rules: `CLAUDE.md`.

## Levels

| Level | Idea | Where |
|---|---|---|
| 1 | Single agent | A normal Claude Code session |
| 2 | Parallel sub-agents | Several Agent calls in one message (Workflow only if you ask for it) |
| 3 | Roles + a model per role | `.claude/agents/` (10 agents) |
| 4 | Mixed team | `.claude/skills/antigravity/` (Gemini in plan/suggestion mode only) |
| 5 | Model choice based on limits | `team/budget.json` + `model-router` |
| 6 | A lead that does no work itself | `/proje` + `project-lifecycle` (outer loop) + `team-lead` (inner loop) |

## Folder structure

```
CLAUDE.md                     Team lead rules (loaded in every session)
docs/KULLANIM.md              User guide
.claude/agents/               10 agents: researcher planner game-designer learning-designer
                              ux-designer coder writer critic tester playtester
.claude/commands/             /proje
.claude/skills/
  team-lead/                  inner loop (task flow)
  model-router/               budget + model table (scripts/budget.ps1)
  antigravity/                Gemini bridge (scripts/agy-run.ps1)
  project-lifecycle/          outer loop: SKILL.md, sozluk.md, gates.md
    phases/ templates/ checklists/ profiles/
team/
  state/                      HANDOFF (hub state only)
  scripts/ (+ tests/)         team scripts
  reports/                    empty + README (hub-maintenance reports only)
  budget.json                 limit status (ok|tight|exhausted)
projects/PROJECTS.md          project registry + active project
projects/<ad>/                (created by /proje yeni) each project is its own git repo
  state/                      PHASE, TASKS, TASKS-ARSIV, HANDOFF, INTAKE, LESSONS
  docs/ reports/ ...          documents, agent reports, sources
```

## Requirements

- Claude Code and the Claude desktop Browser pane (kept visible during playtests).
- git, podman, Windows PowerShell 5.1. Nothing else is needed on the host; no Node or Python.
- Optional: Antigravity CLI at `<USERPROFILE>\.gemini\bin\agy.exe` (sign in once with `agy` on first use).

## Scripts

| Script | What it does | Who runs it |
|---|---|---|
| `team/scripts/stamp.ps1` | Generates a timestamped report path | each agent, for its own report |
| `team/scripts/new-project.ps1` | Creates a new project skeleton and its first commit | coder |
| `team/scripts/checkpoint.ps1` | Commits and tags in the project repo | coder |
| `team/scripts/phase-gate.ps1` | Checks the exit gate of a stage | tester |
| `team/scripts/list-reports.ps1` | Lists reports (`-Role`, `-Since`, `-Project`) | user or agent |
| `.claude/skills/model-router/scripts/budget.ps1` | Writes or reads `team/budget.json` | user or tester |
| `.claude/skills/antigravity/scripts/agy-run.ps1` | Asks Gemini a plan or suggestion question | tester |
| `team/scripts/tests/phase-gate.tests.ps1` | Tests for phase-gate | tester |
| `team/scripts/tests/stamp.tests.ps1` | Tests for stamp | tester |

## Out of scope (future)

Codex, Kimi, and DeepSeek skills: the `antigravity` skill can be copied as a template and extended with the same pattern.

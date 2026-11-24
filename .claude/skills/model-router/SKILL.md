---
name: model-router
description: Level 5 — Chooses which agent runs with which model (opus/sonnet/haiku/gemini) based on the task type and the limit status in team/budget.json. The lead applies it before every delegation. The "smart on top, cheap underneath" principle.
---

# Model router

CodexBar from the video (a macOS menu-bar limit indicator) does not exist on Windows. In its place, when the user
sees a limit warning they update `team/budget.json` by hand; the lead looks at this file at every delegation.

## Read / update the budget status

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1"
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Claude tight
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Reset
```

Values: `ok` (normal), `tight` (a warning came, less than 20% left), `exhausted` (limit used up).

The lead does not run this script: it reads `team/budget.json` with Read. The user runs the script by hand
or the lead has an agent (usually the tester) run it.

## Decision table

| Task type | claude=ok | claude=tight | claude=exhausted |
|---|---|---|---|
| Planning (planner) | opus | sonnet | STOP |
| Critique, single-task review (critic; `Gate: none`, A7 consultation included) | sonnet | sonnet | STOP |
| Critique, stage gate `E-A<n>` / conditional `C-*` / final review before a user gate (critic) | opus | sonnet | STOP |
| Critique, 3rd round after the 2nd REVISE on the same task (critic + producing agent one model up) | opus | no promotion (BLOCKED) | STOP |
| Game / learning design (game-designer, learning-designer) | opus | sonnet | STOP |
| UX design (ux-designer) | sonnet | sonnet | STOP |
| Code, visual/audio implementation (coder) | sonnet | sonnet | STOP |
| Content (writer) | sonnet | sonnet | STOP |
| Playtest (playtester) | sonnet | sonnet (fewer personas) | STOP |
| Research (researcher) | haiku | haiku | STOP |
| Running tests (tester) | haiku | haiku | STOP |
| Visual/audio direction suggestion, long document, second opinion | gemini plan (optional; tester runs it) | gemini plan (optional; tester runs it) | user by hand |

Note: all roles in the table (game-designer, learning-designer, ux-designer, playtester included) are defined under
`.claude/agents/`.

claude=exhausted: the team stops; as its last job the lead writes the project status to the project HANDOFF and the budget status to the global HANDOFF and notifies the user.
If the user wishes, they can run `agy-run.ps1` by hand with `-Mode plan` (`-Project <name>` or `-Hub`, exactly one) to get a draft/suggestion; the output is applied
by the coder/writer when the limit reopens.

Gemini cannot write files on this host (it produces text only, in plan/suggestion mode). If `gemini` is also `exhausted`,
only the second opinion is lost; the team continues with Claude.

Visuals/audio are produced with code (coder: SVG/CSS/procedural/synthesized audio); Gemini only gives an optional second opinion/suggestion.

## How to apply

1. The `model:` field in the agent files is the default for the `claude=ok` state.
2. If the table requires a different model, override with the Agent tool's `model` parameter
   (e.g. call the planner with `model: sonnet` when `tight`). Tiered critic: the `critic.md` default is opus;
   for a single-task review (`Gate: none`) give `model: sonnet`, for a gate call (`E-A<n>`, `C-*`, final review before
   a user gate) do not give it when `ok`, give `model: sonnet` when `tight`. `budget.ps1` prints the same distinction:
   "critique (task)=sonnet, critique (gate)=<opus|sonnet>".
3. If `gemini plan` is selected, use the `antigravity` skill with `-Mode plan` instead of Agent; copy the role instructions
   (the body of the planner/critic file) into the prompt so Gemini answers in the same format.
   Gemini output is a suggestion; it writes no files. The coder/writer applies it, then the critic.
4. Write the choice into the Model column of `projects/<name>/state/TASKS.md`; this way you can track when which model was used.

## Principles

- Smart on top, cheap underneath: the decision-makers (planner, gate critic) get the best model; mechanical work (scanning, testing) the cheapest.
- If the same task gets REVISE twice, in round 3 the critic becomes opus and the producing agent moves up one model (haiku→sonnet→opus; the same if already opus). If still REVISE, `BLOCKED`, and the user is asked. The gate critic is already opus: 2 rounds of REVISE → no promotion → `BLOCKED`. When `tight` there is no promotion: after 2 rounds `BLOCKED`.
- Consecutive rounds on the same model continue with the same agent (SendMessage); for a round where the model changes, a new Agent call is made and the previous report paths are given.
- To protect the limit, try the cheap model first; raise it if quality is not enough. The reverse is waste.

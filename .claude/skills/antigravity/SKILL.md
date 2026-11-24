---
name: antigravity
description: Level 4 — Calls the Antigravity (Gemini) CLI as a sub-agent. On this host only plan/suggestion mode works (it cannot write files). Use for a second opinion, visual/audio direction suggestions, reading long documents, or a planning/critique/research draft when the Claude limit is used up. Output is written to the report folder; only a summary returns to the lead.
---

# Antigravity (Gemini) sub-agent bridge

Claude manages and produces, Gemini gives suggestions. This skill calls `agy.exe` in non-interactive `plan` mode.
On this host `auto` mode does not work (headless permission denial): Gemini cannot write to files, it only produces text.

## When to use

1. Second opinion: if you are unsure of the critic's decision, ask Gemini the same question and compare the two answers.
2. Visual/audio direction suggestions (color, composition, sound character). The coder does the production with code (SVG/CSS/procedural/synthesized audio).
3. Reading and summarizing a very long document/codebase (wide context).
4. A planning/critique/research draft if the `claude` value in `team/budget.json` is `exhausted`. Note: when claude=exhausted the tester also stops; the user runs `agy-run.ps1` by hand.

The coder (or writer) applies Gemini's output to the files, then it goes through the critic.

## How to call

The lead does not run `agy-run.ps1` itself; it has the tester agent run the command verbatim and gets its summary.

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/antigravity/scripts/agy-run.ps1" -Prompt "<task>" -Topic "<short-topic>" -Mode plan -Project "<name>"
powershell -ExecutionPolicy Bypass -File ".claude/skills/antigravity/scripts/agy-run.ps1" -Prompt "<task>" -Topic "<short-topic>" -Mode plan -Hub
```

Parameters:
- `-Prompt` (required): the task to give Gemini. Write file paths as absolute.
- `-Topic`: a short label for the report file name (e.g. `ui-direction`).
- `-Mode`: default `plan` (read-only, suggestion). `auto` / `accept-edits` are not supported on this host; if selected the script prints a warning.
- `-Model`: if left empty, the agy default. For available models `agy models` (requires network).
- `-Effort`: low|medium|high|xhigh|max (default medium).
- `-WorkDir`: the folder Gemini will access (default: current directory).
- In project work `-Project <name>` is mandatory (report goes to `projects/<name>/reports`; if the project does not exist the folder is not created, error); `-Hub` only in hub maintenance (`team/reports`). EXACTLY one of the two is given; both or neither is an error.

## Output

The script prints at most ~20 lines to stdout:
```
STATUS: DONE | FAILED
REPORT: <report folder>/<date>-gemini-<topic>.md
DURATION: 42s
SUMMARY (first 15 lines): ...
```
The lead does not read the full report. If needed, give the report path to the `critic` agent to evaluate.

## Error cases

- `agy.exe not found`: `<USERPROFILE>\.gemini\bin\agy.exe` is missing; Antigravity must be reinstalled.
- `Eligibility check failed` / auth error: the user must run `agy` once in a terminal and sign in.
- `tls: server did not echo the legacy session ID`: a network/proxy/VPN problem; tell the user, continue with Claude.
- auto mode: not supported on this host (headless permission denial); use `-Mode plan`.
- Timeout: increase `-TimeoutSec` or shrink the task.

## Rules

- Do not have Gemini and Claude agents write to the same file at the same time.
- Gemini output is a suggestion; the coder/writer applies it to the files, then always run it through the `critic`.
- You can copy this skill as a template for Codex/Kimi/DeepSeek: only the exe path and the arguments change.

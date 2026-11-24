# A5 Production

## Purpose
On the U track, produce the product slice by slice (feature + content); every slice passes critic + tester (E2E included) + checkpoint. The P track does not enter A5.

## Inputs
Under projects/<name>/: docs/SPEC.md, design documents (GDD / LEARNING_DESIGN or DESIGN, UX, ART_AUDIO), ARCHITECTURE.md, contracts/, TEST_PLAN.md, the A4 slice + approved golden example, CLAUDE.md, run.ps1; PHASE conditional:.

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the global skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`. TASKS is a single table; slice rows have `#` = `D<k>-<n>`. Slice loop 1→7 (the planner plans only the NEXT slice):
1. **planner** (Planning; skill planning-and-task-breakdown, incremental-implementation)
```
Role: planner | Project: <name> | Stage: A5 | Task #<n>: slice <k> plan | Topic: a5-plan-d<k> | Gate: none
Acceptance: only slice <k>; 6-column rows at the END of the TASKS table (# = D<k>-<n>, PENDING; Task: definition; Acceptance; Files; Verification); stub/wiring task, conflict-free parallel groups, end-of-slice tester + coder checkpoint | Files: projects/<name>/state/TASKS.md | Verification command: none | Checklist: none
```
2. **coder** (Code; skill incremental-implementation, test-driven-development) — stub/wiring BEFORE any parallel group that touches a shared module. For a new content type, 1 golden example is approved before multiple writers (not needed if approved in A4).
```
Role: coder | Project: <name> | Stage: A5 | Task #<n>: stub/wiring D<k> | Topic: a5-stub-d<k> | Gate: none
Acceptance: interfaces compatible with contracts/, green with empty content | Files: <list in TASKS> | Verification command: run.ps1 -Build -Test -Check | Checklist: none
```
3. **[parallel]** coders + writers, separate files. Visuals/audio are produced by the coder with code (SVG/CSS/synthesis) from docs/ART_AUDIO.md (U/light: DESIGN.md); Gemini only gives suggestions in plan mode.
```
Role: writer | Project: <name> | Stage: A5 | Task #<n>: content <unit> | Topic: a5-content-<unit> | Gate: none
Acceptance: conforms to docs/contracts/CONTENT_SCHEMA.md + the golden example; run.ps1 -Check green before finishing | Files: <only this unit's files> | Verification command: run.ps1 -Check | Checklist: <PL>/checklists/content-quality.md
Role: coder | Project: <name> | Stage: A5 | Task #<n>: feature <F-xx> | Topic: a5-code-<f-xx> | Gate: none
Acceptance: SPEC F-xx acceptance criteria + tests; visuals/audio from ART_AUDIO | Files: <list in TASKS> | Verification command: run.ps1 -Test | Checklist: none
```
Steps 4-9 (in the single block below, in task order):
4. **critic** (sonnet; task) for every task (code: code-review-and-quality; content: content-quality.md). REVISE: 2 rounds → 3rd round opus critic + producer one model up → BLOCKED.
5. **learning-designer** content sample review (Game/learning design; sample: at least 5 units or 20%, whichever is larger; if there are fewer than 5 in total, all; runs no commands).
6. **tester** end of slice (Test running, mandatory); FAIL → a fix task to the coder.
7. **coder** checkpoint (no tag; skill git-workflow-and-versioning), a single task after the approved slice.
8. Only full: after every 3 slices and after the last slice the **playtester** (Playtest, P-A5). Before it, ask the user to keep the Browser panel visible.
9. After the last slice: the writer compiles the BACKLOG (MINOR + justified MAJOR), the critic (opus; gate) E-A5 (+ C-AGE), the tester T-A5.
```
Role: critic | Project: <name> | Stage: A5 | Task #<n>: review of D<k>-<n> | Topic: a5-critic-d<k>-<n> | Gate: none
Acceptance: the Acceptance in the TASKS row is met; APPROVE/REVISE + 3 items | Files: none | Verification command: none | Checklist: <PL>/checklists/content-quality.md (content) | Read: task report
Role: learning-designer | Project: <name> | Stage: A5 | Task #<n>: sample review D<k> | Topic: a5-content-review-d<k> | Gate: none
Acceptance: alignment with LO goals + age suitability; findings BLOCKER/MAJOR/MINOR | Files: none | Verification command: none | Checklist: <PL>/checklists/age-appropriate-content.md (audience child/teen), content-quality.md
Role: tester | Project: <name> | Stage: A5 | Task #<n>: slice <k> test | Topic: a5-test-d<k> | Gate: none
Acceptance: three commands exit 0 (output verbatim in the report) | Files: none | Verification command: run.ps1 -Test -Check -E2E | Checklist: none
Role: coder | Project: <name> | Stage: A5 | Task #<n>: slice <k> checkpoint | Topic: a5-checkpoint-d<k> | Gate: none
Acceptance: exit 0, no tag | Files: none | Checklist: none | Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A5: slice <k>"
Role: playtester | Project: <name> | Stage: A5 | Task #<n>: playtest slice <k> | Topic: a5-playtest-d<k> | Gate: P-A5 | Session: close
Acceptance: persona × task matrix; RESULT/METHOD/VISUAL (VERIFIED only if it actually saw the screen) | Files: none | Verification command: run.ps1 -Up (if not running), when done -Down only for what it started itself | Checklist: none | Read: <PL>/templates/PLAYTEST_REPORT.md
Role: writer | Project: <name> | Stage: A5 | Task #<n>: BACKLOG | Topic: a5-backlog | Gate: none
Acceptance: MINOR/deferred MAJOR items from the stage reports, with IDs | Files: docs/BACKLOG.md | Verification command: none | Checklist: none
Role: critic | Project: <name> | Stage: A5 | Task #<n>: end of stage | Topic: a5-e-a5 | Gate: E-A5 (if C-AGE is triggered a separate call: Gate: C-AGE, Checklist: <PL>/checklists/age-appropriate-content.md)
Acceptance: all slices DONE + with reports, SPEC F-xx met; APPROVE/REVISE | Files: none | Verification command: none | Checklist: <PL>/checklists/content-quality.md
Role: tester | Project: <name> | Stage: A5 | Task #<n>: end-of-stage test | Topic: a5-t-a5 | Gate: T-A5
Acceptance: exit 0 (PASS/FAIL) | Files: none | Verification command: run.ps1 -Build -Test -Check -E2E | Checklist: none
```

## Mode differences
Matrix: SKILL.md. The P track SKIPS A5. U/light: 1-3 slices, step 5 only if there is content/C-AGE. U/medium: content track (step 3 parallel writers, step 5 mandatory). U/full: + step 8 (P-A5; if there are several rounds, the worst result).

## Exit criteria
PHASE Exit criteria (Track=product, Stage=A5):
| Criterion | Path |
|---|---|
| Production backlog | docs/BACKLOG.md |
| E-A5 end-of-stage critic | - |
| T-A5 end-of-stage tester (E2E included) | - |
| C-AGE (only audience child/teen) | - |
| P-A5 (only full; after the last slice) | - |

## Gate
Write PENDING (track=product): E-A5, T-A5, C-AGE (if in conditional), P-A5 (only full). There is NO user gate → no -SkipUserGates; after processing the results, give the tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` (output verbatim). Slice gates are only in TASKS. Negative: REVISE/FAIL → reopen the task (task: 2 rounds → 3rd round opus critic + producer one model up → BLOCKED; gate critic: 2 rounds → BLOCKED, no promotion; a single question, gates.md Deadlock), `IN_PROGRESS`; after the fix, rerun the gate. Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open). PASS → SKILL.md transition step 7 (first state, then checkpoint u-stage-A5); next A6.

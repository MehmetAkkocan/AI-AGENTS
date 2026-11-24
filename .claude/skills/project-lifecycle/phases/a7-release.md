# A7 Release

## Purpose
After K4 RELEASE, package the release candidate, tag vX.Y.Z, document it, and prove it works from a clean clone with a single command. NO external upload / push; the user does that.

## Inputs
Under projects/<name>/: K4 record (RELEASE), docs/VERIFICATION.md (including the rollback section), docs/BACKLOG.md (known issues), SPEC, run.ps1; profile `.claude/skills/project-lifecycle/profiles/<profile>.md` "Release package". Version: first release v1.0.0, later ones SemVer.

## Steps
`<PL>` = `.claude/skills/project-lifecycle`. Added to every prompt: `Produce the report path with this command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <role> -Topic <topic> -Project <name> [-Round <N>]` + `Reply is at most 10 lines, REPORT: <path> is mandatory.` The agent reads the skill with Read from `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`. Prompts are in the single block below, in order:
1. **[parallel]** the writer (Content; skill shipping-and-launch, documentation-and-adrs) writes the documents; the coder (Code; shipping-and-launch) prepares the local package. The files are separate.
2. **critic** (sonnet; task; advisory, no gate record): documents ↔ VERIFICATION consistency and the A7 items of pre-release.md (README / CHANGELOG / RELEASE / tag). REVISE: 2 rounds → 3rd round opus critic + producer one model up → BLOCKED.
3. **coder** release checkpoint vX.Y.Z (skill git-workflow-and-versioning). The stage exit tag `u-stage-A7` comes later, as a separate checkpoint (Gate section).
4. **tester** clean clone test (T-A7); FAIL → to the missing coder/writer, a new patch version if needed, the tester reruns.
```
Role: writer | Project: <name> | Stage: A7 | Task #<n>: README + CHANGELOG + RELEASE | Topic: a7-docs | Gate: none
Acceptance: README: what, prerequisites, single-command install (run.ps1 -Build -Up), stop, address, troubleshooting; CHANGELOG: dated vX.Y.Z entry; RELEASE (medium/full): scope, verification summary, ≤3 known issues, rollback | Files: README.md, CHANGELOG.md, docs/RELEASE.md (light: no RELEASE, known issues in the README) | Verification command: none | Checklist: <PL>/checklists/pre-release.md | Read: <PL>/templates/RELEASE.md, <PL>/profiles/<profile>.md (Release package)
Role: coder | Project: <name> | Stage: A7 | Task #<n>: local package | Topic: a7-package | Gate: none
Acceptance: the package is produced locally as the profile's "Release package" requires; debug hooks off, no secrets / development leftovers | Files: run.ps1, package output (as specified in the profile) | Verification command: run.ps1 -Build | Checklist: <PL>/checklists/pre-release.md
Role: critic | Project: <name> | Stage: A7 | Task #<n>: release documents review | Topic: a7-critic | Gate: none
Acceptance: no BLOCKER in the pre-release.md A7 items; APPROVE/REVISE + 3 items | Files: none | Verification command: none | Checklist: <PL>/checklists/pre-release.md
Role: coder | Project: <name> | Stage: A7 | Task #<n>: version tag | Topic: a7-tag | Gate: none
Acceptance: exit 0, tag vX.Y.Z (the release commit), NO push | Files: none | Checklist: none
Verification command: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A7: vX.Y.Z" -Tag vX.Y.Z
Role: tester | Project: <name> | Stage: A7 | Task #<n>: clean clone test | Topic: a7-clean-clone | Gate: T-A7
Acceptance: projects/<name> is cloned locally into an empty temporary folder; installed only with the command in the README (run.ps1 -Build -Up, stale image trap), the address returns 200; -Test -Check -E2E exit 0; PASS/FAIL, output verbatim | Files: none (the temporary clone is deleted at the end) | Verification command: git clone + run.ps1 -Build -Up; run.ps1 -Test -Check -E2E | Checklist: <PL>/checklists/pre-release.md
```

## Mode differences
Matrix: SKILL.md. The P track SKIPS A7. U/light: README + short CHANGELOG + tag; no RELEASE.md (install and known issues in the README), step 2 a single round (not skipped). U/medium: all steps, rollback in RELEASE. U/full: medium + detailed rollback plan (consistent with VERIFICATION "Rollback").

## Exit criteria
PHASE Exit criteria (Track=product, Stage=A7):
| Criterion | Path |
|---|---|
| README | README.md |
| CHANGELOG | CHANGELOG.md |
| RELEASE (only medium/full) | docs/RELEASE.md |
| T-A7 clean clone test | - |

## Gate
Write PENDING: only T-A7 (no user gate → no -SkipUserGates). After the result is processed, give the tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <name>` (output verbatim). PASS → FIRST state (PHASE, Stage history Tag = u-stage-A7, PROJECTS, project HANDOFF, TASKS archive), THEN to the coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <name> -Message "A7: release" -Tag u-stage-A7`; then A8. Negative: FAIL → the fix in step 4, `IN_PROGRESS` (2 rounds → 3rd round opus critic + producer one model up → BLOCKED; details: gates.md Deadlock). Rerun rule: for every gate that will rerun after a negative decision, immediately a new `PENDING` row with the same (Gate, Track, Stage) key (the old passing row cannot leave the gate open). Tell the user: external upload and push are theirs to do.

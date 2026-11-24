<!-- A7 | owner: writer (coder packages, tester verifies the clean clone) | target: docs/RELEASE.md | gate: T-A7 (installs and runs with a single command from a clean clone) -->
<!-- In U/light there is NO RELEASE.md: the README install section + CHANGELOG + tag are enough (pre-release items are covered by the README). Medium: all sections. Full: rollback in detail. There is no A7 on the P track. Placeholder name: <name>. -->
# RELEASE <name> <vX.Y.Z>

## Version
<!-- fill-in instruction: SemVer version, git tag vX.Y.Z, date (yyyy-MM-dd), the corresponding VERIFICATION release candidate row. -->
vX.Y.Z / <yyyy-MM-dd> / verification: docs/VERIFICATION.md

## Package contents
<!-- fill-in instruction: what is in the package (source, content, run.ps1, README.md, CHANGELOG.md); what is not (e.g. test reports). 5-10 lines. -->
- <item>

## Clean install
<!-- fill-in instruction: the step that installs and runs on a fresh machine with a SINGLE command (prerequisites: git, Podman, PowerShell 5.1). Actually run the command on a clean clone; if -Up does not include the build, write the command as "-Build; -Up" in that order. -->
```
git clone <repo-path> <folder>
cd <folder>; powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1 -Up
```
Address: <http://localhost:...>

## Verification
<!-- fill-in instruction: the tester's install + smoke result on a clean clone: PASS/FAIL + report path. -->
T-A7: <PASS/FAIL> / report: <projects/<name>/reports/...>

## Known issues
<!-- fill-in instruction: VERIFICATION "Known issues" (<=3) in the user's language + workaround; copy, do not add new issues. -->
- <issue - workaround>

## Rollback
<!-- fill-in instruction: source is the VERIFICATION "Rollback" section; full steps here: previous tag, container/image cleanup, data compatibility. Detailed in full mode. -->
1. <step>

## License and attribution
<!-- fill-in instruction: the project license (ask the user, do not invent), third-party library/font/content attributions; "none" if there are none. -->
<license> / attribution: <list>

## Uploading externally
<!-- fill-in instruction: keep this note verbatim. -->
Uploading externally (repository, store, hosting) belongs to the user; the team only produces a local package, a tag and a release note.

# phase-gate.tests.ps1 - scenario tests for phase-gate.ps1 (builds its own fixture in scratch, runs, cleans up).
# Kullanim: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/tests/phase-gate.tests.ps1
# Output: scenario lines + "PASSED/TOTAL: x/y"; exit 0 = all passed, 1 = some failed. Does not touch the real projects/.
$ErrorActionPreference = 'Stop'
$Gate = Join-Path (Split-Path -Parent $PSScriptRoot) 'phase-gate.ps1'
$S = Join-Path $env:TEMP ("aat-gate-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
$PR = Join-Path $S 'projects'
$script:total = 0; $script:pass = 0

function W($p, $t) {
    $d = Split-Path $p
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null }
    Set-Content -LiteralPath $p -Value $t -Encoding utf8
}
function Phase($name, $track, $stage, $crit, $gate, $hdr1, $hdr2, $extra) {
    if (-not $hdr1) { $hdr1 = "project: $name | type: game | audience: teen | profile: web" }
    if (-not $hdr2) { $hdr2 = "track: $track | mode: - | stage: $stage | status: IN_PROGRESS" }
    "# PHASE $name`n$hdr1`n$hdr2`nconditional: none`n`n## Exit criteria`n| # | Track | Stage | Criterion | Path | Status |`n|---|---|---|---|---|---|`n$crit`n`n## Gate records`n| Gate | Track | Stage | Reviewer | Result | Report | Date |`n|---|---|---|---|---|---|---|`n$gate`n`n## Stage history`n| Track | Stage | Start | End | Result | Tag |`n|---|---|---|---|---|---|`n`n## Allowed values`n- x`n$extra"
}
$tasksHdr = "# TASKS`n| # | Task | Role | Model | Status | Report |`n|---|---|---|---|---|---|`n"
$five = "a`nb`nc`nd`ne`n"
function Mk($name, $phase, $tasks) {
    $p = Join-Path $PR $name
    W "$p\state\PHASE.md" $phase; W "$p\state\TASKS.md" $tasks
    W "$p\docs\BRIEF.md" $five; W "$p\docs\VERIFICATION.md" "x`nBLOCKER: 0`n"
    W "$p\reports\r1.md" "report"
    W "$S\team\reports\r1.md" "hub report"
    $p
}
$kr = "| 1 | prototype | A1 | Brief | docs/BRIEF.md | OPEN |"
$gOk = "| E-A1 | prototype | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
$gK1 = "| K1 | prototype | A1 | user | PENDING | - | 2026-11-10 |"
$tOk = $tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md |`n"
function Hash($dir) { (Get-ChildItem $dir -Recurse -File | Sort-Object FullName | ForEach-Object { "$($_.FullName)=$((Get-FileHash $_.FullName).Hash)" }) -join ';' }
function T($label, $proj, $expExit, $args2 = @(), $notRe = $null) {
    $script:total++
    $before = Hash $S
    $out = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Gate -Project $proj -ProjectsRoot $PR @args2)
    $code = $LASTEXITCODE
    $ro = ($before -eq (Hash $S))
    $first = ($out.Count -gt 0 -and $out[0] -match '^RESULT: (PASS|FAIL)$')
    $ok = ($code -eq $expExit) -and $ro -and ($out.Count -le 10) -and $first
    if ($notRe -and (($out -join "`n") -match $notRe)) { $ok = $false }
    if ($ok) { $script:pass++ }
    "{0} {1}: exit={2} (exp {3}) ro={4} lines={5} | {6}" -f $(if ($ok) { 'OK  ' } else { 'FAIL' }), $label, $code, $expExit, $ro, $out.Count, (($out | Select-Object -Skip 1 -First 3) -join ' / ')
}
try {
    Mk 's1' (Phase s1 prototype A1 $kr $gOk) $tOk | Out-Null; T '1 complete' 's1' 0
    $p = Mk 's2' (Phase s2 prototype A1 $kr $gOk) $tOk; Remove-Item "$p\docs\BRIEF.md"; T '2 file missing' 's2' 1
    $p = Mk 's3' (Phase s3 prototype A1 $kr $gOk) $tOk; W "$p\docs\BRIEF.md" "a`nb`n`n`nc`n"; T '3 <5 filled' 's3' 1
    Mk 's4' (Phase s4 prototype A1 $kr ($gOk + "`n" + $gK1)) $tOk | Out-Null; T '4 PENDING' 's4' 1
    $rev = "| E-A1 | prototype | A1 | critic | REVISE | reports/r1.md | 2026-11-10 |"
    $p = Mk 's5' (Phase s5 prototype A1 $kr $rev) $tOk; T '5a REVISE' 's5' 1
    W "$p\state\PHASE.md" (Phase s5 prototype A1 $kr ($rev + "`n" + $gOk)); T '5b REVISE+APPROVE' 's5' 0
    $pk = "$gOk`n| K1 | prototype | A1 | user | APPROVED | - | 2026-11-10 |`n| E-A1 | product | A1 | critic | PENDING | - | 2026-11-10 |"
    Mk 's6' (Phase s6 product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" $pk "" "track: product | mode: medium | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '6 promotion: P records do not pass U' 's6' 1
    Mk 's7' (Phase s7 prototype A1 $kr ($gOk + "`n" + $gK1)) $tOk | Out-Null
    T '7a SkipUserGates' 's7' 0 @('-SkipUserGates'); T '7b without it' 's7' 1
    Mk 's8a' (Phase s8a prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | - |`n") | Out-Null; T '8a DONE report empty' 's8a' 1
    Mk 's8b' (Phase s8b prototype A1 $kr $gOk) ($tOk + "| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '8b RUNNING' 's8b' 1
    Mk 's8c' (Phase s8c prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md, reports/missing.md |`n") | Out-Null; T '8c multiple reports, one missing' 's8c' 1
    $kr6 = "| 1 | product | A6 | V | docs/VERIFICATION.md | OPEN |"
    $g6 = "| E-A6 | product | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    $h6 = "track: product | mode: medium | stage: A6 | status: IN_PROGRESS"
    $p = Mk 's9' (Phase s9 product A6 $kr6 $g6 "" $h6) $tOk; W "$p\docs\VERIFICATION.md" "a`nb`nc`nd`nBLOCKER: 2`n"; T '9a BLOCKER 2' 's9' 1
    W "$p\docs\VERIFICATION.md" "a`nb`nc`nd`nBLOCKER: 0`n"; T '9b BLOCKER 0' 's9' 0
    $p = Mk 's10' (Phase s10 prototype A1 $kr $gOk) $tOk; W "$p\state\PHASE.md" "broken content"; T '10a broken PHASE' 's10' 2
    Remove-Item "$p\state\PHASE.md"; T '10b PHASE missing' 's10' 2
    Mk 's11' (Phase s11 prototype A1 $kr "| E-A1 | prototype | A1 | user | EXCEPTION | user: time | 2026-11-10 |") $tOk | Out-Null; T '11 EXCEPTION' 's11' 0
    Mk 's12' (Phase s12 prototype A1 $kr "") $tOk | Out-Null; T '12 no gate rows' 's12' 1
    # --- round 2 ---
    Mk 's13a' (Phase s13a prototype A1 $kr $gOk) ($tOk + "`n## Completed`n| # | Task | Role | Model | Status | Report |`n|---|---|---|---|---|---|`n| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '13a RUNNING in 2nd table' 's13a' 1
    Mk 's13b' (Phase s13b prototype A1 $kr $gOk) ($tOk + "`n## Completed`n| # | Task | Role | Model | Status | Report |`n|---|---|---|---|---|---|`n| 2 | y | coder | sonnet | DONE | - |`n") | Out-Null; T '13b reportless DONE in 2nd table' 's13b' 1
    Mk 's13c' (Phase s13c prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | FAILED | - |`n| 2 | x | coder | sonnet | DONE | reports/r1.md |`n") | Out-Null; T '13c FAILED does not leave the gate open' 's13c' 0
    Mk 's14' (Phase s14 prototype A1 ("| 1 | prototype | A1 | Brief |  ``docs/BRIEF.md``  | OPEN |") $gOk) $tOk | Out-Null; T '14 backtick Path' 's14' 0
    Mk 's15a' (Phase s15a prototype A1 $kr ($gOk + "`n| E-A1 | Product | A1 | critic | REVISE | - | 2026-11-10 |")) $tOk | Out-Null; T '15a Track=Product' 's15a' 2
    Mk 's15b' (Phase s15b prototype A1 $kr ($gOk + "`n| E-A1 | prototype | a1 | critic | REVISE | - | 2026-11-10 |")) $tOk | Out-Null; T '15b Stage=a1' 's15b' 2
    Mk 's15c' (Phase s15c prototype A1 $kr ($gOk + "`n| E-A1 | prototype | A1 | critic | MAYBE | - | 2026-11-10 |")) $tOk | Out-Null; T '15c unknown decision' 's15c' 2
    Mk 's15d' (Phase s15d prototype A1 $kr ($gOk + "`n| e-a1 | prototype | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |")) $tOk | Out-Null; T '15d Gate=e-a1' 's15d' 2
    Mk 's16a' (Phase s16a prototype A1 $kr $gOk "project: s16a | type: ? | audience: teen | profile: web") $tOk | Out-Null; T '16a type ? A1' 's16a' 2
    Mk 's16b' (Phase s16b prototype A0 "| 1 | prototype | A0 | Brief | docs/BRIEF.md | OPEN |" "| E-A0 | prototype | A0 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "project: s16b | type: ? | audience: ? | profile: ?") $tOk | Out-Null; T '16b ? A0 accepted' 's16b' 0
    Mk 's17' (Phase s17 prototype A1 $kr $gOk "project: other | type: game | audience: teen | profile: web") $tOk | Out-Null; T '17 wrong project' 's17' 2
    Mk 's18' (Phase s18 prototype A1 $kr $gOk "" "track: prototype | mode: light | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '18 prototype + mode light' 's18' 2
    Mk 's19a' ((Phase s19a prototype A1 $kr $gOk) + "`n## Gate records`n") $tOk | Out-Null; T '19a duplicate section header' 's19a' 2
    Mk 's20' (Phase s20 prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | UNKNOWN | - |`n") | Out-Null; T '20 undefined Status' 's20' 2
    Mk 's21' (Phase s21 product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" "| E-A1 | product | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "track: product | mode: light | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '21 product + mode light' 's21' 0
    # CRLF + BOM tolerance
    $p = Mk 's22' (Phase s22 prototype A1 $kr $gOk) $tOk
    [IO.File]::WriteAllText("$p\state\PHASE.md", ((Phase s22 prototype A1 $kr $gOk) -replace "`n", "`r`n"), (New-Object Text.UTF8Encoding $true)); T '22 CRLF+BOM' 's22' 0
    # --- round 3 ---
    $row = "| 1 | x | coder | sonnet | DONE | reports/r1.md |"
    Mk 's23a' (Phase s23a prototype A1 $kr $gOk) ($tasksHdr + "$row`n`n| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '23a DONE + blank + RUNNING' 's23a' 1
    Mk 's23b' (Phase s23b prototype A1 $kr $gOk) ($tasksHdr + "$row`n`n| 2 | y | coder | sonnet | DONE | reports/r1.md |`n`n") | Out-Null; T '23b all DONE with blank lines' 's23b' 0
    Mk 's23c' (Phase s23c prototype A1 $kr $gOk) ($tOk + "`n## Archive`n| 9 | z | coder | sonnet | DONE | - |`n") | Out-Null; T '23c orphan | row without header' 's23c' 2
    Mk 's23d' (Phase s23d product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" "| E-A1 | product | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "track: product | mode: - | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '23d product + mode -' 's23d' 2
    Mk 's23e' (Phase s23e product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" "| E-A1 | product | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "track: product | mode: medium | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '23e product + medium' 's23e' 0
    # real template copy (comments, whitespace, Archive section) + data row
    $tpl = Join-Path (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Gate))) '.claude\skills\project-lifecycle\templates\TASKS.md'
    if (Test-Path -LiteralPath $tpl) {
        $tt = (Get-Content -LiteralPath $tpl -Encoding utf8 -Raw)
        $sep = "|---|---|---|---|---|---|"
        Mk 's24a' (Phase s24a prototype A1 $kr $gOk) ($tt.Replace($sep, "$sep`n$row")) | Out-Null; T '24a template + DONE row' 's24a' 0
        Mk 's24b' (Phase s24b prototype A1 $kr $gOk) ($tt.Replace($sep, "$sep`n| 1 | x | coder | sonnet | RUNNING | - |")) | Out-Null; T '24b template + RUNNING' 's24b' 1
        Mk 's24c' (Phase s24c prototype A1 $kr $gOk) $tt | Out-Null; T '24c empty template' 's24c' 0
    }
    # --- round 4: gate-stage consistency, P/A6 VERIFICATION, visual approval ---
    $krP6 = "| 1 | prototype | A6 | V | docs/BRIEF.md | OPEN |"
    $gP6 = "| E-A6 | prototype | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    $gT6 = "| T-A6 | prototype | A6 | tester | PASS | reports/r1.md | 2026-11-10 |"
    $gPP6 = "| P-A6 | prototype | A6 | playtester | PASS | reports/r1.md | 2026-11-10 |"
    $gl = "user: visual approval; -"
    $p = Mk 's25a' (Phase s25a prototype A6 $krP6 "$gP6`n$gT6`n$gPP6") $tOk; Remove-Item "$p\docs\VERIFICATION.md"
    T '25a P/A6 VERIFICATION missing, SkipUserGates' 's25a' 0 @('-SkipUserGates')
    Mk 's25b' (Phase s25b prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | $gl | 2026-11-10 |") $tOk | Out-Null; T '25b K3 PROMOTION + visual approval' 's25b' 0
    Mk 's25c' (Phase s25c prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | - | 2026-11-10 |") $tOk | Out-Null; T '25c K3 PROMOTION without visual approval' 's25c' 1 @() 'Gate not passed'
    Mk 's25d' (Phase s25d prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | REPEAT | - | 2026-11-10 |") $tOk | Out-Null; T '25d K3 REPEAT: no visual approval error (gate not passed -> 1)' 's25d' 1 @() 'visual approval'
    Mk 's25e' (Phase s25e prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | REPEAT | - | 2026-11-10 |") $tOk | Out-Null; T '25e K3 REPEAT + SkipUserGates' 's25e' 0 @('-SkipUserGates')
    Mk 's25f' (Phase s25f prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | - | 2026-11-10 |") $tOk | Out-Null; T '25f K3 PROMOTION without visual approval + SkipUserGates' 's25f' 0 @('-SkipUserGates')
    Mk 's25g' (Phase s25g prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval | 2026-11-10 |") $tOk | Out-Null; T '25g visual approval (no ;) accepted' 's25g' 0
    Mk 's25h' (Phase s25h prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approvali | 2026-11-10 |") $tOk | Out-Null; T '25h visual approvals (outside the pattern)' 's25h' 1
    Mk 's25i' (Phase s25i prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | EXCEPTION | user: time | 2026-11-10 |") $tOk | Out-Null; T '25i K3 EXCEPTION without visual approval' 's25i' 1
    Mk 's26a' (Phase s26a prototype A1 $kr "$gOk`n| K3 | prototype | A4 | user | PROMOTION | $gl | 2026-11-10 |") $tOk | Out-Null; T '26a K3 prototype A4' 's26a' 2
    Mk 's26b' (Phase s26b prototype A1 $kr "$gOk`n| E-A3 | product | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '26b E-A3 product A4' 's26b' 2
    $kr4 = "| 1 | product | A4 | S | docs/BRIEF.md | OPEN |"
    $h4 = "track: product | mode: medium | stage: A4 | status: IN_PROGRESS"
    $gE4 = "| E-A4 | product | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's26c' (Phase s26c product A4 $kr4 "$gE4`n| K3 | product | A4 | user | CONTINUE | $gl | 2026-11-10 |" "" $h4) $tOk | Out-Null; T '26c K3 product A4 CONTINUE + visual approval' 's26c' 0
    Mk 's26d' (Phase s26d product A4 $kr4 "$gE4`n| K3 | product | A4 | user | CONTINUE | - | 2026-11-10 |" "" $h4) $tOk | Out-Null; T '26d K3 product A4 CONTINUE without visual approval' 's26d' 1
    $kr6b = "| 1 | product | A6 | V | docs/BRIEF.md | OPEN |"
    $gE6 = "| E-A6 | product | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's27a' (Phase s27a product A6 $kr6b "$gE6`n| K4 | product | A6 | user | RELEASE | - | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27a K4 RELEASE without visual approval' 's27a' 1
    Mk 's27b' (Phase s27b product A6 $kr6b "$gE6`n| K4 | product | A6 | user | RELEASE | $gl | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27b K4 RELEASE + visual approval' 's27b' 0
    Mk 's27c' (Phase s27c product A6 $kr6b "$gE6`n| K4 | product | A6 | user | POSTPONE | - | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27c K4 POSTPONE: no visual approval error' 's27c' 1 @() 'visual approval'
    Mk 's27d' (Phase s27d product A6 $kr6b "$gE6`n| K4 | product | A6 | user | RELEASE | - | 2026-11-10 |`n| K4 | product | A6 | user | RELEASE | $gl | 2026-11-11 |" "" $h6) $tOk | Out-Null; T '27d K4 last row has visual approval' 's27d' 0
    Mk 's28a' (Phase s28a prototype A1 $kr "$gOk`n| E-A8 | prototype | A8 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28a P track has E-A8' 's28a' 2
    Mk 's28b' (Phase s28b prototype A1 $kr "$gOk`n| K4 | prototype | A6 | user | PENDING | - | 2026-11-10 |") $tOk | Out-Null; T '28b P track has K4' 's28b' 2
    Mk 's28c' (Phase s28c prototype A1 $kr "$gOk`n| K2 | prototype | A2 | user | PENDING | - | 2026-11-10 |") $tOk | Out-Null; T '28c P track has K2' 's28c' 2
    Mk 's28d' (Phase s28d prototype A1 $kr "$gOk`n| E-A5 | prototype | A5 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28d P track has E-A5' 's28d' 2
    Mk 's28e' (Phase s28e prototype A1 $kr "$gOk`n| T-A5 | prototype | A5 | tester | PASS | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28e P track has T-A5' 's28e' 2
    Mk 's28f' (Phase s28f prototype A1 $kr "$gOk`n| E-A2 | prototype | A3 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28f E-A2 stage A3' 's28f' 2
    Mk 's29a' (Phase s29a prototype A6 $krP6 "$gP6`n| C-AGE | prototype | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '29a C-AGE prototype A6' 's29a' 0
    Mk 's29b' (Phase s29b prototype A1 $kr "$gOk`n| C-AGE | prototype | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '29b C-AGE prototype A4' 's29b' 2
    Mk 's29c' (Phase s29c product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" "| E-A1 | product | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |`n| C-AGE | product | A5 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "track: product | mode: medium | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '29c C-AGE product A5' 's29c' 0
    Mk 's29d' (Phase s29d product A1 "| 1 | product | A1 | Spec | docs/BRIEF.md | OPEN |" "| E-A1 | product | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |`n| C-SEC | product | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "track: product | mode: medium | stage: A1 | status: IN_PROGRESS") $tOk | Out-Null; T '29d C-SEC product A4' 's29d' 2
    # --- round 5: (prototype, A8) no gate rows expected, only Exit criteria ---
    $kr8 = "| 1 | prototype | A8 | Retro | docs/PROTOTYPE_REVIEW.md | OPEN |"
    $h8 = "track: prototype | mode: - | stage: A8 | status: IN_PROGRESS"
    $p = Mk 's30a' (Phase s30a prototype A8 $kr8 "" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; T '30a P/A8 no gate rows, criterion filled' 's30a' 0
    $p = Mk 's30b' (Phase s30b prototype A8 $kr8 "" "" $h8) $tOk; T '30b P/A8 criterion file missing' 's30b' 1
    $p = Mk 's30c' (Phase s30c prototype A8 $kr8 "| E-A8 | prototype | A8 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; T '30c P/A8 + E-A8 row' 's30c' 2
    $kr8u = "| 1 | product | A8 | Retro | docs/BRIEF.md | OPEN |"
    Mk 's30d' (Phase s30d product A8 $kr8u "" "" "track: product | mode: medium | stage: A8 | status: IN_PROGRESS") $tOk | Out-Null; T '30d U/A8 no gate rows (exception is P only)' 's30d' 1
    $p = Mk 's30e' (Phase s30e prototype A8 $kr8 "" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; W "$p\state\TASKS.md" ($tOk + "| 2 | y | coder | sonnet | RUNNING | - |`n"); T '30e P/A8 + open TASKS' 's30e' 1
    # known limit: after REPEAT, back at A4 with the old E-A4 APPROVE as the last row -> the script does not derive the expected gate, exit 0
    $kr4p = "| 1 | prototype | A4 | S | docs/BRIEF.md | OPEN |"
    $gE4p = "| E-A4 | prototype | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's31' (Phase s31 prototype A4 $kr4p "$gE4p`n| K3 | prototype | A6 | user | REPEAT | - | 2026-11-10 |") $tOk | Out-Null; T '31 old E-A4 APPROVE after REPEAT (documented limit)' 's31' 0
    # --- round 6: report paths must stay inside the project folder ---
    Mk 's32a' (Phase s32a prototype A1 $kr "| E-A1 | prototype | A1 | critic | APPROVE | projects/s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32a projects/<name>/ prefixed path PASS' 's32a' 0
    Mk 's32b' (Phase s32b prototype A1 $kr "| E-A1 | prototype | A1 | critic | APPROVE | team/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32b gate: team/reports FAIL' 's32b' 1
    Mk 's32c' (Phase s32c prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | team/reports/r1.md |`n") | Out-Null; T '32c TASKS: team/reports FAIL' 's32c' 1
    Mk 's32d' (Phase s32d prototype A1 $kr "| E-A1 | prototype | A1 | critic | APPROVE | projects/s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32d other project path FAIL' 's32d' 1
    Mk 's32e' (Phase s32e prototype A1 $kr "| E-A1 | prototype | A1 | critic | APPROVE | reports/../../s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32e escape with .. FAIL' 's32e' 1
    Mk 's32f' (Phase s32f prototype A1 $kr "| E-A1 | prototype | A1 | critic | APPROVE | $S\team\reports\r1.md | 2026-11-10 |") $tOk | Out-Null; T '32f absolute outside path FAIL' 's32f' 1
    Mk 's32g' (Phase s32g prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval; - | 2026-11-10 |") $tOk | Out-Null; T '32g user: visual approval; - valid' 's32g' 0
    Mk 's32h' (Phase s32h prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval; reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32h K3 visual approval; in-project report' 's32h' 0
    Mk 's32i' (Phase s32i prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval; team/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32i K3 visual approval; hub report FAIL' 's32i' 1
    # --- round 7: single rule (parts split on ';', a part containing '/' or '' = path, inside the project folder and existing) ---
    function Ge($rap) { "| E-A1 | prototype | A1 | critic | APPROVE | $rap | 2026-11-10 |" }
    Mk 's33a' (Phase s33a prototype A1 $kr (Ge 'projects\s33a\reports\r1.md')) $tOk | Out-Null; T '33a backslash project path PASS' 's33a' 0
    Mk 's33b' (Phase s33b prototype A1 $kr (Ge 'docs/BRIEF.md')) $tOk | Out-Null; T '33b docs/ path PASS' 's33b' 0
    Mk 's33c' (Phase s33c prototype A1 $kr (Ge 'Projects/S33c/reports/r1.md')) $tOk | Out-Null; T '33c UPPERCASE Projects/<Name> PASS' 's33c' 0
    Mk 's33d' (Phase s33d prototype A1 $kr (Ge "$PR\s33d\reports\r1.md")) $tOk | Out-Null; T '33d absolute in-project path PASS' 's33d' 0
    Mk 's33e' (Phase s33e prototype A1 $kr (Ge 'reports/r1.md; ok')) $tOk | Out-Null; T '33e plain-text part is not a path PASS' 's33e' 0
    Mk 's33f' (Phase s33f prototype A1 $kr (Ge 'projects/s33f/../s32a/reports/r1.md')) $tOk | Out-Null; T '33f escape outside project with .. FAIL' 's33f' 1
    Mk 's33g' (Phase s33g prototype A1 $kr (Ge 'reports/missing.md')) $tOk | Out-Null; T '33g nonexistent file FAIL' 's33g' 1
    Mk 's33h' (Phase s33h prototype A1 $kr (Ge 'reports/<path>.md')) $tOk | Out-Null; T '33h invalid character: FAIL, RESULT line present' 's33h' 1
    Mk 's33i' (Phase s33i prototype A1 $kr (Ge 'reports/r1.md; user-note team/reports/r1.md')) $tOk | Out-Null; T '33i user- (no colon) part counts as a path FAIL' 's33i' 1
    Mk 's33j' (Phase s33j prototype A1 $kr (Ge 'reports/r1.md; reports/missing.md')) $tOk | Out-Null; T '33j one of two paths bad FAIL' 's33j' 1
    Mk 's33k' (Phase s33k prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval; ok | 2026-11-10 |") $tOk | Out-Null; T '33k K3 plain-text part PASS' 's33k' 0
    Mk 's33l' (Phase s33l prototype A6 $krP6 "$gP6`n| K3 | prototype | A6 | user | PROMOTION | user: visual approval; reports/missing.md | 2026-11-10 |") $tOk | Out-Null; T '33l K3 nonexistent path FAIL' 's33l' 1
    Mk 's33m' (Phase s33m prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/<path>.md |`n") | Out-Null; T '33m TASKS invalid character FAIL' 's33m' 1
    # --- round 8: single split rule (';' or ','), TASKS uses the same helper; docs/source/ larger than 0 bytes ---
    Mk 's34a' (Phase s34a prototype A1 $kr (Ge 'reports/r1.md; docs/BRIEF.md')) $tOk | Out-Null; T '34a gate a; b PASS' 's34a' 0
    Mk 's34b' (Phase s34b prototype A1 $kr (Ge 'reports/r1.md, docs/BRIEF.md')) $tOk | Out-Null; T '34b gate a, b PASS' 's34b' 0
    Mk 's34c' (Phase s34c prototype A1 $kr (Ge 'reports/r1.md, reports/missing.md')) $tOk | Out-Null; T '34c gate a, b: one missing FAIL' 's34c' 1
    Mk 's34d' (Phase s34d prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md; docs/BRIEF.md |`n") | Out-Null; T '34d TASKS DONE a; b PASS' 's34d' 0
    Mk 's34e' (Phase s34e prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md, docs/BRIEF.md |`n") | Out-Null; T '34e TASKS DONE a, b PASS' 's34e' 0
    Mk 's34f' (Phase s34f prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | ok |`n") | Out-Null; T '34f TASKS DONE plain text only FAIL (reportless DONE)' 's34f' 1
    Mk 's34g' (Phase s34g prototype A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md ok |`n") | Out-Null; T '34g TASKS no whitespace split: single-part path, file missing FAIL' 's34g' 1
    $krK = "| 1 | prototype | A1 | Kaynak | docs/source/k.txt | OPEN |"
    $p = Mk 's34h' (Phase s34h prototype A1 $krK $gOk) $tOk; W "$p\docs\source\k.txt" "one line"; T '34h docs/source 1 line PASS' 's34h' 0
    $p = Mk 's34i' (Phase s34i prototype A1 $krK $gOk) $tOk; New-Item -ItemType Directory -Force "$p\docs\source" | Out-Null; [IO.File]::WriteAllBytes("$p\docs\source\k.txt", [byte[]]@()); T '34i docs/source 0 bytes FAIL' 's34i' 1
    # the first output line and <=10 lines are checked on every T call
    "PASSED/TOTAL: $($script:pass)/$($script:total)"
} finally {
    if ($S -like "$env:TEMP\aat-gate-*") { Remove-Item -LiteralPath $S -Recurse -Force }
}
if ($script:pass -eq $script:total) { exit 0 } else { exit 1 }

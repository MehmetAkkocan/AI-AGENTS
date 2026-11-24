# stamp.tests.ps1 - tests for stamp.ps1 (-Hub / -Project) and new-project.ps1 (registry inside projects/).
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/tests/stamp.tests.ps1
# Output: scenario lines + "PASSED/TOTAL: x/y"; exit 0 = all passed. Scratch is in Windows Temp; the real projects/ is not created.
$ErrorActionPreference = 'Continue'
$Stamp = Join-Path (Split-Path -Parent $PSScriptRoot) 'stamp.ps1'
$NewProj = Join-Path (Split-Path -Parent $PSScriptRoot) 'new-project.ps1'
$Team = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$script:total = 0; $script:pass = 0

function Rs($label, [bool]$ok, $detail) {
    $script:total++
    if ($ok) { $script:pass++ }
    "{0} {1} | {2}" -f $(if ($ok) { 'OK  ' } else { 'FAIL' }), $label, $detail
}
function Stamp([string[]]$a) {
    $o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Stamp @a 2>$null)
    return [pscustomobject]@{ Code = $LASTEXITCODE; Out = ($o -join "`n") }
}

$r = Stamp @('-Role', 'coder', '-Topic', 'topic')
Rs '1 no switch: error, no path' ($r.Code -ne 0 -and $r.Out -eq '') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'topic', '-Hub')
Rs '2 -Hub: team/reports path' ($r.Code -eq 0 -and $r.Out -match '^team/reports/\d{8}-\d{4}-coder-topic\.md$') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'topic', '-Project', 'x')
Rs '3 -Project x: projects/x/reports path' ($r.Code -eq 0 -and $r.Out -match '^projects/x/reports/\d{8}-\d{4}-coder-topic\.md$') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'topic', '-Project', 'x', '-Hub')
Rs '4 both: error, no path' ($r.Code -ne 0 -and $r.Out -eq '') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'topic', '-Project', 'x', '-Round', '2')
Rs '5 -Round 2 suffix' ($r.Code -eq 0 -and $r.Out -match '-t2\.md$') "out='$($r.Out)'"
$r = Stamp @()
Rs '6 no arguments: stamp only' ($r.Code -eq 0 -and $r.Out -match '^\d{8}-\d{4}$') "out='$($r.Out)'"

# --- new-project.ps1: registry inside ProjectsRoot, no files in the hub ---
function TeamHash { (Get-ChildItem (Join-Path $Team 'team\state') -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object { "$($_.FullName)=$((Get-FileHash $_.FullName).Hash)" }) -join ';' }
$S = Join-Path $env:TEMP ("aat-stamp-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
try {
    $before = TeamHash
    $realProjects = Test-Path -LiteralPath (Join-Path $Team 'projects')
    $PR = Join-Path $S 'projects'
    $o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $NewProj -Name 'demo-x' -ProjectsRoot $PR 2>&1)
    $code = $LASTEXITCODE
    $reg = Join-Path $PR 'PROJECTS.md'
    $regOk = (Test-Path -LiteralPath $reg) -and ((Get-Content -LiteralPath $reg -Raw) -match '(?m)^\| demo-x \|') -and ((Get-Content -LiteralPath $reg -Raw) -match '(?m)^Active project:')
    Rs '7 new-project: exit 0 + projects/PROJECTS.md in scratch root' ($code -eq 0 -and $regOk) "exit=$code reg=$regOk"
    Rs '8 team/state in the hub unchanged' ($before -eq (TeamHash)) 'hash equal'
    Rs '9 real projects/ not created' ((Test-Path -LiteralPath (Join-Path $Team 'projects')) -eq $realProjects) "before=$realProjects"
    $o2 = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $NewProj -Name 'demo-x' -ProjectsRoot $PR 2>&1)
    Rs '10 same name rejected again' ($LASTEXITCODE -ne 0) "exit=$LASTEXITCODE"
} finally {
    if ($S -like "$env:TEMP\aat-stamp-*") { Remove-Item -LiteralPath $S -Recurse -Force -ErrorAction SilentlyContinue }
}

# --- agy-run.ps1: validation before the agy.exe check; creates no folder ---
$Agy = Join-Path $Team '.claude\skills\antigravity\scripts\agy-run.ps1'
$ghost = Join-Path $Team 'projects\zz-missing-project-test'
$realProj2 = Test-Path -LiteralPath (Join-Path $Team 'projects')
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -Project zz-missing-project-test 2>&1)
Rs '11 agy-run nonexistent project: error, no folder' ($LASTEXITCODE -ne 0 -and -not (Test-Path -LiteralPath $ghost)) "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -Project zz-missing -Hub 2>&1)
Rs '12 agy-run -Project + -Hub: error' ($LASTEXITCODE -ne 0 -and ($o -join ' ') -match 'exactly one') "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -ReportsDir (Join-Path $env:TEMP 'aat-agy-missing') 2>&1)
Rs '13 agy-run -ReportsDir removed: error, no folder' ($LASTEXITCODE -ne 0 -and -not (Test-Path -LiteralPath (Join-Path $env:TEMP 'aat-agy-missing'))) "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x 2>&1)
Rs '14 agy-run no switch: error' ($LASTEXITCODE -ne 0) "exit=$LASTEXITCODE"
"PASSED/TOTAL: $($script:pass)/$($script:total)"
if ($script:pass -eq $script:total) { exit 0 } else { exit 1 }

# stamp.tests.ps1 - stamp.ps1 (-Merkez / -Project) ve new-project.ps1 (kayit defteri projects/ icinde) testleri.
# Kullanim: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/tests/stamp.tests.ps1
# Cikti: senaryo satirlari + "GECEN/TOPLAM: x/y"; exit 0 = hepsi gecti. Scratch Windows Temp'te; gercek projects/ olusmaz.
$ErrorActionPreference = 'Continue'
$Stamp = Join-Path (Split-Path -Parent $PSScriptRoot) 'stamp.ps1'
$NewProj = Join-Path (Split-Path -Parent $PSScriptRoot) 'new-project.ps1'
$Team = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$script:total = 0; $script:pass = 0

function Rs($label, [bool]$ok, $detail) {
    $script:total++
    if ($ok) { $script:pass++ }
    "{0} {1} | {2}" -f $(if ($ok) { 'OK  ' } else { 'HATA' }), $label, $detail
}
function Stamp([string[]]$a) {
    $o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Stamp @a 2>$null)
    return [pscustomobject]@{ Code = $LASTEXITCODE; Out = ($o -join "`n") }
}

$r = Stamp @('-Role', 'coder', '-Topic', 'konu')
Rs '1 anahtarsiz: hata, yol yok' ($r.Code -ne 0 -and $r.Out -eq '') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'konu', '-Merkez')
Rs '2 -Merkez: team/reports yolu' ($r.Code -eq 0 -and $r.Out -match '^team/reports/\d{8}-\d{4}-coder-konu\.md$') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'konu', '-Project', 'x')
Rs '3 -Project x: projects/x/reports yolu' ($r.Code -eq 0 -and $r.Out -match '^projects/x/reports/\d{8}-\d{4}-coder-konu\.md$') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'konu', '-Project', 'x', '-Merkez')
Rs '4 ikisi birden: hata, yol yok' ($r.Code -ne 0 -and $r.Out -eq '') "exit=$($r.Code) out='$($r.Out)'"
$r = Stamp @('-Role', 'coder', '-Topic', 'konu', '-Project', 'x', '-Round', '2')
Rs '5 -Round 2 eki' ($r.Code -eq 0 -and $r.Out -match '-t2\.md$') "out='$($r.Out)'"
$r = Stamp @()
Rs '6 argumansiz: yalniz damga' ($r.Code -eq 0 -and $r.Out -match '^\d{8}-\d{4}$') "out='$($r.Out)'"

# --- new-project.ps1: kayit defteri ProjectsRoot icinde, merkezde dosya yok ---
function TeamHash { (Get-ChildItem (Join-Path $Team 'team\state') -Recurse -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object { "$($_.FullName)=$((Get-FileHash $_.FullName).Hash)" }) -join ';' }
$S = Join-Path $env:TEMP ("aat-stamp-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
try {
    $before = TeamHash
    $realProjects = Test-Path -LiteralPath (Join-Path $Team 'projects')
    $PR = Join-Path $S 'projects'
    $o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $NewProj -Name 'demo-x' -ProjectsRoot $PR 2>&1)
    $code = $LASTEXITCODE
    $reg = Join-Path $PR 'PROJECTS.md'
    $regOk = (Test-Path -LiteralPath $reg) -and ((Get-Content -LiteralPath $reg -Raw) -match '(?m)^\| demo-x \|') -and ((Get-Content -LiteralPath $reg -Raw) -match '(?m)^Aktif proje:')
    Rs '7 new-project: exit 0 + projects/PROJECTS.md scratch kokte' ($code -eq 0 -and $regOk) "exit=$code reg=$regOk"
    Rs '8 merkezde team/state degismedi' ($before -eq (TeamHash)) 'hash esit'
    Rs '9 gercek projects/ olusmadi' ((Test-Path -LiteralPath (Join-Path $Team 'projects')) -eq $realProjects) "onceki=$realProjects"
    $o2 = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $NewProj -Name 'demo-x' -ProjectsRoot $PR 2>&1)
    Rs '10 ayni ad tekrar reddedilir' ($LASTEXITCODE -ne 0) "exit=$LASTEXITCODE"
} finally {
    if ($S -like "$env:TEMP\aat-stamp-*") { Remove-Item -LiteralPath $S -Recurse -Force -ErrorAction SilentlyContinue }
}

# --- agy-run.ps1: dogrulama agy.exe denetiminden once; klasor yaratmaz ---
$Agy = Join-Path $Team '.claude\skills\antigravity\scripts\agy-run.ps1'
$ghost = Join-Path $Team 'projects\zz-yok-proje-test'
$realProj2 = Test-Path -LiteralPath (Join-Path $Team 'projects')
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -Project zz-yok-proje-test 2>&1)
Rs '11 agy-run var olmayan proje: hata, klasor yok' ($LASTEXITCODE -ne 0 -and -not (Test-Path -LiteralPath $ghost) -and -not (Test-Path -LiteralPath (Join-Path $Team 'projects'))) "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -Project zz-yok -Merkez 2>&1)
Rs '12 agy-run -Project + -Merkez: hata' ($LASTEXITCODE -ne 0 -and ($o -join ' ') -match 'tam olarak biri') "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x -ReportsDir (Join-Path $env:TEMP 'aat-agy-yok') 2>&1)
Rs '13 agy-run -ReportsDir kaldirildi: hata, klasor yok' ($LASTEXITCODE -ne 0 -and -not (Test-Path -LiteralPath (Join-Path $env:TEMP 'aat-agy-yok'))) "exit=$LASTEXITCODE"
$o = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Agy -Prompt x 2>&1)
Rs '14 agy-run anahtarsiz: hata' ($LASTEXITCODE -ne 0) "exit=$LASTEXITCODE"
"GECEN/TOPLAM: $($script:pass)/$($script:total)"
if ($script:pass -eq $script:total) { exit 0 } else { exit 1 }

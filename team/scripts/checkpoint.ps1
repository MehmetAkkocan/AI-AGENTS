# checkpoint.ps1 - commit (+ optional tag) inside projects/<name>/
# Usage: checkpoint.ps1 -Project <name> -Message "<msg>" [-Tag <tag>] [-ProjectsRoot <dir>]
# Exit 0 = ok, 1 = error. Git runs only inside the project repo (git -C).
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [Parameter(Mandatory = $true)][string]$Message,
    [string]$Tag,
    [string]$ProjectsRoot
)

$ErrorActionPreference = 'Continue'
function Fail([string]$msg) { Write-Host "HATA: $msg"; exit 1 }

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $root 'projects' }

if ($Project -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Fail "Gecersiz proje adi: '$Project'" }
if ($Message -cnotmatch '^A[0-8]: \S') { Fail "Gecersiz -Message: '$Message' (beklenen: 'A<N>: <ozet>')" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail 'git bulunamadi' }
if ($Tag -and $Tag -cnotmatch '^(p-asama-A[0-8]|u-asama-A[0-8]|prototip-v0|v\d+\.\d+\.\d+)$') {
    Fail "Gecersiz -Tag: '$Tag' (p-asama-A<N> | u-asama-A<N> | prototip-v0 | vX.Y.Z)"
}

$proj = Join-Path $ProjectsRoot $Project
if (-not (Test-Path -LiteralPath $proj -PathType Container)) { Fail "Proje klasoru yok: $proj" }
if (-not (Test-Path -LiteralPath (Join-Path $proj '.git'))) { Fail "Git deposu degil (.git yok): $proj" }

if ($Tag) {
    $existing = (git -C $proj tag -l $Tag 2>$null)
    if ($existing) { Fail "Etiket zaten var: $Tag" }
}

git -C $proj add -A 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Fail 'git add basarisiz' }
$status = (git -C $proj status --porcelain 2>$null)
$changed = [bool]$status
if (-not $changed) {
    Write-Host 'degisiklik yok (yeni commit olusmadi)'
} else {
    $gn = (git -C $proj config user.name 2>$null)
    if (-not $gn) { git -C $proj config user.name 'AI Agent Team' 2>&1 | Out-Null }
    $ge = (git -C $proj config user.email 2>$null)
    if (-not $ge) { git -C $proj config user.email 'team@localhost' 2>&1 | Out-Null }
    git -C $proj commit -q -m $Message 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail 'commit basarisiz' }
}
$hash = (git -C $proj rev-parse --short HEAD 2>$null)
if (-not $hash) { Fail 'HEAD yok (commit yok)' }
if ($Tag) {
    git -C $proj tag $Tag 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail "Etiket olusturulamadi: $Tag" }
    Write-Host "Etiket: $Tag"
}
if ($changed) { Write-Host "Commit: $hash" } else { Write-Host "HEAD: $hash" }
exit 0

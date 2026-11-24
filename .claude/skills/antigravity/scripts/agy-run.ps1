# agy-run.ps1 - Antigravity (Gemini) CLI'ini alt ajan olarak cagirir (Seviye 4).
# Tam ciktiyi -Project <ad> (projects/<ad>/reports) ya da -Merkez (team/reports) klasorune yazar, stdout'a yalnizca kisa bir ozet basar
# ki ekip liderinin context'i sismesin.
#
# Kullanim:
#   powershell -ExecutionPolicy Bypass -File .claude/skills/antigravity/scripts/agy-run.ps1 -Prompt "..." [-Model gemini-x] [-Topic ui] [-WorkDir .] (-Project <ad> | -Merkez)
#   -Project <ad>: rapor projects/<ad>/reports (proje klasoru yoksa hata, klasor yaratilmaz); -Merkez: team/reports (yalniz merkez bakimi); TAM OLARAK biri, aksi halde hata + exit 1, dosya yazilmaz
#   -Mode: plan (varsayilan, salt okunur) | auto, accept-edits (bu host'ta desteklenmiyor, uyari basar)
#   -Effort: low|medium|high|xhigh|max
#
# NOT: Bu dosya bilerek ASCII tutulur; Windows PowerShell 5.1 BOM'suz UTF-8'i yanlis okur.

param(
    [Parameter(Mandatory = $true)][string]$Prompt,
    [string]$Model = "",
    [string]$Topic = "gemini",
    [string]$WorkDir = (Get-Location).Path,
    [ValidateSet("auto", "plan", "accept-edits")][string]$Mode = "plan",
    [string]$Project = "",
    [switch]$Merkez,
    [ValidateSet("low", "medium", "high", "xhigh", "max")][string]$Effort = "medium",
    [int]$SummaryLines = 15,
    [int]$TimeoutSec = 600
)

$ErrorActionPreference = "Continue"
# Rapor hedefi dogrulamasi (hicbir dosya yazilmadan once): -Project ya da -Merkez, tam olarak biri
$root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
$nTarget = 0
if ($Project -ne "") { $nTarget++ }
if ($Merkez) { $nTarget++ }
if ($nTarget -ne 1) {
    Write-Output "DURUM: FAILED"
    Write-Output "HATA: -Project <ad> ya da -Merkez, tam olarak biri verilmeli (verilen: $nTarget); rapor yazilmadi"
    exit 1
}
if ($Project -ne "") {
    if ($Project -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        Write-Output "DURUM: FAILED"
        Write-Output "HATA: Gecersiz -Project: '$Project'"
        exit 1
    }
    if (-not (Test-Path -LiteralPath (Join-Path $root "projects\$Project") -PathType Container)) {
        Write-Output "DURUM: FAILED"
        Write-Output "HATA: proje klasoru yok: projects/$Project (klasor yaratilmaz)"
        exit 1
    }
}
$agy = Join-Path $env:USERPROFILE ".gemini\bin\agy.exe"
if (-not (Test-Path $agy)) {
    Write-Output "DURUM: FAILED"
    Write-Output "HATA: agy.exe bulunamadi: $agy"
    exit 1
}

# Rapor dosyasi (kok yukarida bir kez hesaplandi)
if ($Project -ne "") { $reportsDir = Join-Path $root "projects\$Project\reports" }
else { $reportsDir = Join-Path $root "team\reports" }
if (-not (Test-Path $reportsDir)) { New-Item -ItemType Directory -Force $reportsDir | Out-Null }
$stamp = Get-Date -Format "yyyyMMdd-HHmm"
$safeTopic = ($Topic -replace '[^a-zA-Z0-9_-]', '-')
$reportPath = Join-Path $reportsDir "$stamp-gemini-$safeTopic.md"

if ($Mode -ne "plan") {
    Write-Output "UYARI: -Mode $Mode bu host'ta bilinen sorun (headless izin reddi); plan modu onerilir."
}

# Komut satiri
$agyArgs = @("-p", $Prompt, "--mode", $Mode, "--effort", $Effort, "--output-format", "text", "--add-dir", $WorkDir, "--print-timeout", "${TimeoutSec}s")
if ($Model -ne "") { $agyArgs += @("--model", $Model) }

$started = Get-Date
# agy.exe UTF-8 basar; PS 5.1 konsol kod sayfasiyla okursa Turkce bozulur -> gecici UTF-8
$oldConsoleEnc = [Console]::OutputEncoding
$oldOutEnc = $OutputEncoding
try {
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [Console]::OutputEncoding = $utf8NoBom
    $OutputEncoding = $utf8NoBom
    $output = & $agy @agyArgs 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
} finally {
    [Console]::OutputEncoding = $oldConsoleEnc
    $OutputEncoding = $oldOutEnc
}
$elapsed = [int]((Get-Date) - $started).TotalSeconds

# Tam raporu yaz
$modelLabel = if ($Model) { $Model } else { "(agy varsayilani)" }
$header = @(
    "# Gemini (Antigravity) raporu - $stamp",
    "",
    "- Konu: $Topic",
    "- Model: $modelLabel",
    "- Mod: $Mode, Effort: $Effort",
    "- Calisma dizini: $WorkDir",
    "- Sure: ${elapsed}s, Cikis kodu: $exitCode",
    "",
    "## Prompt",
    "",
    '```',
    $Prompt,
    '```',
    "",
    "## Cikti",
    ""
) -join "`n"
[System.IO.File]::WriteAllText($reportPath, ($header + "`n" + $output), (New-Object System.Text.UTF8Encoding($true)))

# Lider'e kisa ozet
$status = if ($exitCode -eq 0 -and $output.Trim().Length -gt 0) { "DONE" } else { "FAILED" }
Write-Output "DURUM: $status"
Write-Output "RAPOR: $reportPath"
Write-Output "SURE: ${elapsed}s"
Write-Output "OZET (ilk $SummaryLines satir):"
$output -split "`r?`n" | Where-Object { $_.Trim() -ne "" } | Select-Object -First $SummaryLines | ForEach-Object { "  $_" }
if ($status -eq "FAILED") {
    Write-Output "NOT: Auth hatasi ise bir kez interaktif 'agy' calistirip giris yap. TLS hatasi ise ag/proxy ayarina bak."
}
exit $exitCode

# agy-run.ps1 - Calls the Antigravity (Gemini) CLI as a sub-agent (Level 4).
# Writes the full output to the -Project <name> (projects/<name>/reports) or -Hub (team/reports) folder and prints only a short summary to stdout
# so the team lead's context does not bloat.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .claude/skills/antigravity/scripts/agy-run.ps1 -Prompt "..." [-Model gemini-x] [-Topic ui] [-WorkDir .] (-Project <name> | -Hub)
#   -Project <name>: report goes to projects/<name>/reports (error if the project folder is missing, the folder is not created); -Hub: team/reports (hub maintenance only); EXACTLY one, otherwise error + exit 1, no file is written
#   -Mode: plan (default, read-only) | auto, accept-edits (not supported on this host, prints a warning)
#   -Effort: low|medium|high|xhigh|max
#
# NOTE: This file is deliberately kept ASCII; Windows PowerShell 5.1 misreads UTF-8 without BOM.

param(
    [Parameter(Mandatory = $true)][string]$Prompt,
    [string]$Model = "",
    [string]$Topic = "gemini",
    [string]$WorkDir = (Get-Location).Path,
    [ValidateSet("auto", "plan", "accept-edits")][string]$Mode = "plan",
    [string]$Project = "",
    [switch]$Hub,
    [ValidateSet("low", "medium", "high", "xhigh", "max")][string]$Effort = "medium",
    [int]$SummaryLines = 15,
    [int]$TimeoutSec = 600
)

$ErrorActionPreference = "Continue"
# Report target validation (before any file is written): -Project or -Hub, exactly one
$root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
$nTarget = 0
if ($Project -ne "") { $nTarget++ }
if ($Hub) { $nTarget++ }
if ($nTarget -ne 1) {
    Write-Output "STATUS: FAILED"
    Write-Output "ERROR: exactly one of -Project <name> or -Hub must be given (given: $nTarget); no report written"
    exit 1
}
if ($Project -ne "") {
    if ($Project -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        Write-Output "STATUS: FAILED"
        Write-Output "ERROR: Invalid -Project: '$Project'"
        exit 1
    }
    if (-not (Test-Path -LiteralPath (Join-Path $root "projects\$Project") -PathType Container)) {
        Write-Output "STATUS: FAILED"
        Write-Output "ERROR: project folder missing: projects/$Project (folder is not created)"
        exit 1
    }
}
$agy = Join-Path $env:USERPROFILE ".gemini\bin\agy.exe"
if (-not (Test-Path $agy)) {
    Write-Output "STATUS: FAILED"
    Write-Output "ERROR: agy.exe not found: $agy"
    exit 1
}

# Report file (root was computed once above)
if ($Project -ne "") { $reportsDir = Join-Path $root "projects\$Project\reports" }
else { $reportsDir = Join-Path $root "team\reports" }
if (-not (Test-Path $reportsDir)) { New-Item -ItemType Directory -Force $reportsDir | Out-Null }
$stamp = Get-Date -Format "yyyyMMdd-HHmm"
$safeTopic = ($Topic -replace '[^a-zA-Z0-9_-]', '-')
$reportPath = Join-Path $reportsDir "$stamp-gemini-$safeTopic.md"

if ($Mode -ne "plan") {
    Write-Output "WARNING: -Mode $Mode has a known issue on this host (headless permission denial); plan mode is recommended."
}

# Command line
$agyArgs = @("-p", $Prompt, "--mode", $Mode, "--effort", $Effort, "--output-format", "text", "--add-dir", $WorkDir, "--print-timeout", "${TimeoutSec}s")
if ($Model -ne "") { $agyArgs += @("--model", $Model) }

$started = Get-Date
# agy.exe emits UTF-8; if PS 5.1 reads it with the console code page, non-ASCII text is garbled -> temporary UTF-8
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

# Write the full report
$modelLabel = if ($Model) { $Model } else { "(agy default)" }
$header = @(
    "# Gemini (Antigravity) report - $stamp",
    "",
    "- Topic: $Topic",
    "- Model: $modelLabel",
    "- Mode: $Mode, Effort: $Effort",
    "- Working directory: $WorkDir",
    "- Duration: ${elapsed}s, Exit code: $exitCode",
    "",
    "## Prompt",
    "",
    '```',
    $Prompt,
    '```',
    "",
    "## Output",
    ""
) -join "`n"
[System.IO.File]::WriteAllText($reportPath, ($header + "`n" + $output), (New-Object System.Text.UTF8Encoding($true)))

# Short summary for the lead
$status = if ($exitCode -eq 0 -and $output.Trim().Length -gt 0) { "DONE" } else { "FAILED" }
Write-Output "STATUS: $status"
Write-Output "REPORT: $reportPath"
Write-Output "DURATION: ${elapsed}s"
Write-Output "SUMMARY (first $SummaryLines lines):"
$output -split "`r?`n" | Where-Object { $_.Trim() -ne "" } | Select-Object -First $SummaryLines | ForEach-Object { "  $_" }
if ($status -eq "FAILED") {
    Write-Output "NOTE: On an auth error, run interactive 'agy' once and sign in. On a TLS error, check the network/proxy settings."
}
exit $exitCode

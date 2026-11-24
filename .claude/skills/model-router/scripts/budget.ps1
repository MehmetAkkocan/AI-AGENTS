# budget.ps1 - reads or updates the limit status in team/budget.json (Level 5).
#
# Usage:
#   budget.ps1                     -> prints the current status
#   budget.ps1 -Claude tight       -> updates the claude status
#   budget.ps1 -Gemini exhausted   -> updates the gemini status
#   budget.ps1 -Reset              -> sets both to ok

param(
    [ValidateSet("ok", "tight", "exhausted")][string]$Claude,
    [ValidateSet("ok", "tight", "exhausted")][string]$Gemini,
    [switch]$Reset
)

$root = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)))
$path = Join-Path $root "team\budget.json"

if (-not (Test-Path $path)) {
    $obj = [PSCustomObject]@{ claude = "ok"; gemini = "ok"; updated = ""; values = "ok | tight | exhausted"; note = "" }
} else {
    $obj = Get-Content $path -Raw -Encoding utf8 | ConvertFrom-Json
}

$changed = $false
if ($Reset) { $obj.claude = "ok"; $obj.gemini = "ok"; $changed = $true }
if ($Claude) { $obj.claude = $Claude; $changed = $true }
if ($Gemini) { $obj.gemini = $Gemini; $changed = $true }

if ($changed) {
    $obj.updated = (Get-Date -Format "yyyy-MM-dd HH:mm")
    $obj | ConvertTo-Json | Out-File -FilePath $path -Encoding utf8
}

Write-Output "claude: $($obj.claude)"
Write-Output "gemini (optional second opinion): $($obj.gemini)"
Write-Output "updated: $($obj.updated)"

# Decision table summary
$c = $obj.claude
Write-Output ""
if ($c -eq "exhausted") {
    Write-Output "Routing: team STOPS; user runs agy plan manually"
} else {
    $plan = if ($c -eq "ok") { "opus" } else { "sonnet" }
    Write-Output "Routing: planning/design=$plan, critique (gate)=$plan, critique (slice)=sonnet, code/writing/ux/playtest=sonnet, scan/test=haiku"
}

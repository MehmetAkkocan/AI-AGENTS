# budget.ps1 — team/budget.json'daki limit durumunu okur veya günceller (Seviye 5).
#
# Kullanım:
#   budget.ps1                     -> mevcut durumu yazdırır
#   budget.ps1 -Claude tight       -> claude durumunu günceller
#   budget.ps1 -Gemini exhausted   -> gemini durumunu günceller
#   budget.ps1 -Reset              -> ikisini de ok yapar

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
Write-Output "gemini (istege bagli ikinci gorus): $($obj.gemini)"
Write-Output "updated: $($obj.updated)"

# Karar tablosu özeti
$c = $obj.claude
Write-Output ""
if ($c -eq "exhausted") {
    Write-Output "Yonlendirme: ekip DUR; kullanici elle agy plan"
} else {
    $plan = if ($c -eq "ok") { "opus" } else { "sonnet" }
    Write-Output "Yonlendirme: planlama/tasarim=$plan, elestiri (kapi)=$plan, elestiri (parca)=sonnet, kod/yazi/ux/playtest=sonnet, tarama/test=haiku"
}

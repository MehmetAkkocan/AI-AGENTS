# stamp.ps1 - single source of truth for report timestamps and paths
# Usage: stamp.ps1                              -> yyyyMMdd-HHmm
#        stamp.ps1 -Role coder -Topic konu      -> ERROR (one of -Project / -Merkez required)
#        stamp.ps1 -Role coder -Topic konu -Project ad -Round 2
#                                               -> projects/ad/reports/<stamp>-coder-konu-t2.md
#        stamp.ps1 -Role coder -Topic konu -Merkez
#                                               -> team/reports/<stamp>-coder-konu.md (central maintenance only)
# With -Role/-Topic exactly one of -Project / -Merkez is required (none or both = error, no path printed).
# Does not create any file; prints the path only.
[CmdletBinding()]
param(
    [string]$Role,
    [string]$Topic,
    [string]$Project,
    [switch]$Merkez,
    [int]$Round = 0
)

$stamp = Get-Date -Format 'yyyyMMdd-HHmm'

if (-not $Role -and -not $Topic) {
    if ($Project -or $Merkez -or $Round -ne 0) {
        Write-Error "-Project, -Merkez ve -Round icin -Role ve -Topic gerekli"
        exit 1
    }
    Write-Output $stamp
    exit 0
}

if (-not $Role -or -not $Topic) {
    Write-Error "-Role ve -Topic birlikte verilmeli"
    exit 1
}

if ($Project -and $Merkez) {
    Write-Error "-Project ve -Merkez birlikte verilemez (proje islerinde -Project, merkez bakiminda -Merkez)"
    exit 1
}
if (-not $Project -and -not $Merkez) {
    Write-Error "-Project <ad> (proje islerinde) ya da -Merkez (yalniz merkez bakiminda) zorunlu"
    exit 1
}

$slug = '^[a-z0-9]+(-[a-z0-9]+)*$'
if ($Role -cnotmatch $slug) {
    Write-Error "Gecersiz -Role: '$Role' (kucuk ASCII harf/rakam, tek tire ile ayrilmis)"
    exit 1
}
if ($Topic -cnotmatch $slug) {
    Write-Error "Gecersiz -Topic: '$Topic' (kucuk ASCII harf/rakam, tek tire ile ayrilmis)"
    exit 1
}
if ($Project -and ($Project -cnotmatch $slug)) {
    Write-Error "Gecersiz -Project: '$Project' (kucuk ASCII harf/rakam, tek tire ile ayrilmis)"
    exit 1
}
if ($PSBoundParameters.ContainsKey('Round') -and $Round -lt 1) {
    Write-Error "Gecersiz -Round: $Round (beklenen N>=1)"
    exit 1
}

$name = "$stamp-$Role-$Topic"
if ($Round -ge 2) { $name = "$name-t$Round" }

if ($Project) {
    Write-Output "projects/$Project/reports/$name.md"
} else {
    Write-Output "team/reports/$name.md"
}
exit 0

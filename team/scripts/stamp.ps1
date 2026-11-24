# stamp.ps1 - single source of truth for report timestamps and paths
# Usage: stamp.ps1                              -> yyyyMMdd-HHmm
#        stamp.ps1 -Role coder -Topic topic      -> ERROR (one of -Project / -Hub required)
#        stamp.ps1 -Role coder -Topic topic -Project name -Round 2
#                                               -> projects/ad/reports/<stamp>-coder-topic-t2.md
#        stamp.ps1 -Role coder -Topic topic -Hub
#                                               -> team/reports/<stamp>-coder-topic.md (hub maintenance only)
# With -Role/-Topic exactly one of -Project / -Hub is required (none or both = error, no path printed).
# Does not create any file; prints the path only.
[CmdletBinding()]
param(
    [string]$Role,
    [string]$Topic,
    [string]$Project,
    [switch]$Hub,
    [int]$Round = 0
)

$stamp = Get-Date -Format 'yyyyMMdd-HHmm'

if (-not $Role -and -not $Topic) {
    if ($Project -or $Hub -or $Round -ne 0) {
        Write-Error "-Project, -Hub and -Round require -Role and -Topic"
        exit 1
    }
    Write-Output $stamp
    exit 0
}

if (-not $Role -or -not $Topic) {
    Write-Error "-Role and -Topic must be given together"
    exit 1
}

if ($Project -and $Hub) {
    Write-Error "-Project and -Hub cannot be given together (use -Project for project work, -Hub for hub maintenance)"
    exit 1
}
if (-not $Project -and -not $Hub) {
    Write-Error "-Project <name> (for project work) or -Hub (hub maintenance only) is required"
    exit 1
}

$slug = '^[a-z0-9]+(-[a-z0-9]+)*$'
if ($Role -cnotmatch $slug) {
    Write-Error "Invalid -Role: '$Role' (lowercase ASCII letters/digits, separated by single hyphens)"
    exit 1
}
if ($Topic -cnotmatch $slug) {
    Write-Error "Invalid -Topic: '$Topic' (lowercase ASCII letters/digits, separated by single hyphens)"
    exit 1
}
if ($Project -and ($Project -cnotmatch $slug)) {
    Write-Error "Invalid -Project: '$Project' (lowercase ASCII letters/digits, separated by single hyphens)"
    exit 1
}
if ($PSBoundParameters.ContainsKey('Round') -and $Round -lt 1) {
    Write-Error "Invalid -Round: $Round (expected N>=1)"
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

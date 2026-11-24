# list-reports.ps1 - lists report files by date, role and round
# Usage: list-reports.ps1 [-Role researcher] [-Since yyyyMMdd] [-Project name]
# File name: <yyyyMMdd-HHmm>-<role>-<topic>[-t<N>].md  (old suffixes -rN, -turN also accepted)
# Without -Project: team/reports/. With -Project: projects/<name>/reports/.
# "(!)" in the Note column: name stamp differs from file write time by more than 30 minutes.
param(
    [string]$Role,
    [string]$Since,
    [string]$Project
)

if ($Project) {
    if ($Project -cnotmatch '^[a-z0-9_-]+$') {
        Write-Error "Invalid -Project: '$Project' (lowercase ASCII letters, digits, hyphen, underscore only)"
        exit 1
    }
    $reportsPath = Join-Path $PSScriptRoot ("..\..\projects\{0}\reports" -f $Project)
} else {
    $reportsPath = Join-Path $PSScriptRoot "..\reports"
}
if (-not (Test-Path -LiteralPath $reportsPath)) {
    Write-Error "Reports folder not found: $reportsPath"
    exit 1
}
$reportsPath = (Resolve-Path -LiteralPath $reportsPath).Path

if ($Since) {
    $parsed = [datetime]::MinValue
    $ok = ($Since -match '^\d{8}$') -and [datetime]::TryParseExact($Since, 'yyyyMMdd', [Globalization.CultureInfo]::InvariantCulture, 'None', [ref]$parsed)
    if (-not $ok) {
        Write-Error "Invalid -Since: '$Since' (expected yyyyMMdd)"
        exit 1
    }
}

$knownRoles = @('researcher', 'planner', 'coder', 'writer', 'critic', 'tester', 'gemini',
                'game-designer', 'learning-designer', 'ux-designer', 'playtester') |
    Sort-Object -Property Length -Descending

$pattern = '^(\d{8})-(\d{4})-(.+)\.md$'
$items = @()

foreach ($f in Get-ChildItem -LiteralPath $reportsPath -File) {
    $m = [regex]::Match($f.Name, $pattern)
    if (-not $m.Success) { continue }

    $d = $m.Groups[1].Value
    $t = $m.Groups[2].Value
    $rest = $m.Groups[3].Value

    # role: longest known role followed by "-" and a topic; else first word
    $r = $null
    $topic = $null
    foreach ($k in $knownRoles) {
        if ($rest.StartsWith($k + '-', [StringComparison]::Ordinal) -and $rest.Length -gt ($k.Length + 1)) {
            $r = $k
            $topic = $rest.Substring($k.Length + 1)
            break
        }
    }
    if (-not $r) {
        $fm = [regex]::Match($rest, '^([a-z]+)-(.+)$')
        if (-not $fm.Success) { continue }
        $r = $fm.Groups[1].Value
        $topic = $fm.Groups[2].Value
    }

    # round suffix: -t<N>, -r<N>, -tur<N>; default 1
    $round = 1
    $tm = [regex]::Match($topic, '^(.+?)-(?:t|r|tur)(\d+)$')
    if ($tm.Success) {
        $topic = $tm.Groups[1].Value
        $round = [int]$tm.Groups[2].Value
    }

    if ($Role -and ($r -ne $Role.ToLower())) { continue }
    if ($Since -and ([string]::CompareOrdinal($d, $Since) -lt 0)) { continue }

    $note = ''
    $stamp = [datetime]::MinValue
    if ([datetime]::TryParseExact($d + $t, 'yyyyMMddHHmm', [Globalization.CultureInfo]::InvariantCulture, 'None', [ref]$stamp)) {
        if ([math]::Abs(($f.LastWriteTime - $stamp).TotalMinutes) -gt 30) { $note = '(!)' }
    }

    $items += [pscustomobject]@{
        Date  = ('{0}-{1}-{2}' -f $d.Substring(0, 4), $d.Substring(4, 2), $d.Substring(6, 2))
        Time  = ('{0}:{1}' -f $t.Substring(0, 2), $t.Substring(2, 2))
        Role  = $r
        Round = $round
        Topic = $topic
        File  = $f.Name
        Note  = $note
        Sort  = $d + $t
    }
}

if ($items.Count -eq 0) {
    Write-Host "No reports found."
} else {
    $items | Sort-Object -Property @{Expression='Sort';Descending=$true}, @{Expression='File';Descending=$false} |
        Format-Table -Property Date, Time, Role, Round, Topic, File, Note -AutoSize
}
Write-Host ("Total: {0} reports" -f $items.Count)

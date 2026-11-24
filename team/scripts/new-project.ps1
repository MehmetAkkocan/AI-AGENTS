# new-project.ps1 - builds the projects/<name>/ skeleton (own git repo)
# Usage: new-project.ps1 -Name <name> [-Track prototype|product] [-Mode light|medium|full] [-Type <t>] [-Audience <a>] [-Profile <p>]
#        test hooks: [-ProjectsRoot <dir>] [-TemplatesDir <dir>] [-RegistryPath <file>]
# Builds in a temp folder under ProjectsRoot, moves to the final name after the first commit succeeds;
# any failure removes the temp folder (no half-built project). Registry row is written last.
# Does not touch the "Active project:" line nor the first line of TASKS.md. Git runs only inside the project.
# Exit 0 = ok, 1 = error.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Name,
    [string]$Track = 'prototype',
    [string]$Mode,
    [string]$Type = '?',
    [string]$Audience = '?',
    [string]$Profile = '?',
    [string]$ProjectsRoot,
    [string]$TemplatesDir,
    [string]$RegistryPath
)

$ErrorActionPreference = 'Continue'
function Fail([string]$msg) { Write-Host "ERROR: $msg"; exit 1 }

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $root 'projects' }
if (-not $TemplatesDir) { $TemplatesDir = Join-Path $root '.claude\skills\project-lifecycle\templates' }
if (-not $RegistryPath) { $RegistryPath = Join-Path $ProjectsRoot 'PROJECTS.md' }

# --- validation ---
if ($Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Fail "Invalid project name: '$Name' (rule: ^[a-z0-9]+(-[a-z0-9]+)*$)" }
if ($Track -cne 'prototype' -and $Track -cne 'product') { Fail "Invalid -Track: '$Track' (prototype | product)" }
if ($Track -ceq 'product') {
    if (-not $Mode) { Fail '-Mode is required for -Track product (light | medium | full)' }
    if (@('light', 'medium', 'full') -cnotcontains $Mode) { Fail "Invalid -Mode: '$Mode' (light | medium | full)" }
} else {
    if ($Mode) { Fail '-Mode cannot be given with -Track prototype' }
    $Mode = '-'
}
if ($Type -cne '?' -and $Type -cnotmatch '^(game|education|learning|self-development)(+game)?$') { Fail "Invalid -Type: '$Type' (game | education | learning | self-development, suffix: +game)" }
if ($Audience -cne '?' -and $Audience -cnotmatch '^(child|teen|adult)$') { Fail "Invalid -Audience: '$Audience' (child | teen | adult)" }
if ($Profile -cne '?' -and $Profile -cnotmatch '^(web|mobile|desktop-engine)$') { Fail "Invalid -Profile: '$Profile' (web | mobile | desktop-engine)" }

# templates: template file -> target path (relative to project root)
$map = [ordered]@{
    'PHASE.md'          = 'state\PHASE.md'
    'TASKS.md'          = 'state\TASKS.md'
    'HANDOFF.md'        = 'state\HANDOFF.md'
    'LESSONS.md'        = 'state\LESSONS.md'
    'PROJECT_CLAUDE.md' = 'CLAUDE.md'
}
foreach ($k in $map.Keys) {
    $p = Join-Path $TemplatesDir $k
    if (-not (Test-Path -LiteralPath $p -PathType Leaf)) { Fail "Template missing: $p" }
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail 'git not found' }

# --- path containment: final target must be a direct child of ProjectsRoot ---
if (-not (Test-Path -LiteralPath $ProjectsRoot)) { New-Item -ItemType Directory -Force -Path $ProjectsRoot | Out-Null }
$rootFull = (Resolve-Path -LiteralPath $ProjectsRoot).Path.TrimEnd('\')
$proj = [IO.Path]::GetFullPath((Join-Path $rootFull $Name))
if ((Split-Path -Parent $proj) -ne $rootFull) { Fail "Project path escapes ProjectsRoot: $proj" }
if (Test-Path -LiteralPath $proj) { Fail "Project already exists: $proj" }

$utf8 = New-Object System.Text.UTF8Encoding($false)
function Write-Text([string]$path, [string]$text) { [IO.File]::WriteAllText($path, $text, $utf8) }

$tmp = Join-Path $rootFull (".tmp-{0}-{1}" -f $Name, ([guid]::NewGuid().ToString('N').Substring(0, 8)))
$moved = $false
$ok = $false
$hash = ''
$warn = ''
try {
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    foreach ($d in @('state', 'docs', 'docs\adr', 'docs\contracts', 'reports', 'reports\shots')) {
        New-Item -ItemType Directory -Force -Path (Join-Path $tmp $d) | Out-Null
    }
    foreach ($d in @('docs\adr', 'docs\contracts', 'reports', 'reports\shots')) {
        Write-Text (Join-Path $tmp "$d\.gitkeep") ''
    }
    foreach ($k in $map.Keys) {
        Copy-Item -LiteralPath (Join-Path $TemplatesDir $k) -Destination (Join-Path $tmp $map[$k]) -Force
    }
    Write-Text (Join-Path $tmp 'state\TASKS-ARCHIVE.md') ''
    Write-Text (Join-Path $tmp 'state\INTAKE.md') ''

    # PHASE.md: rewrite header lines only (before the first "##")
    $phasePath = Join-Path $tmp 'state\PHASE.md'
    $lines = [IO.File]::ReadAllText($phasePath, $utf8) -split "\r?\n"
    $out = New-Object System.Collections.Generic.List[string]
    $inHeader = $true
    foreach ($ln in $lines) {
        if ($inHeader -and $ln -match '^##\s') { $inHeader = $false }
        if ($inHeader) {
            if ($ln -match '^#\s+PHASE\b') { $ln = "# PHASE $Name" }
            elseif ($ln -match '^project:') { $ln = "project: $Name | type: $Type | audience: $Audience | profile: $Profile" }
            elseif ($ln -match '^track:') { $ln = "track: $Track | mode: $Mode | stage: A0 | status: IN_PROGRESS" }
            elseif ($ln -match '^conditional:') { $ln = 'conditional: none' }
        }
        $out.Add($ln)
    }
    Write-Text $phasePath ($out -join "`n")

    # LESSONS.md: fill the project name placeholder in the title line only
    $lessonsPath = Join-Path $tmp 'state\LESSONS.md'
    $lt = [IO.File]::ReadAllText($lessonsPath, $utf8)
    $lt = (New-Object Text.RegularExpressions.Regex('^(#\s[^\r\n]*?)<name>')).Replace($lt, ('${1}' + $Name), 1)
    Write-Text $lessonsPath $lt

    $gi = @('*.log', '.env', '.env.*', 'node_modules/', '__pycache__/', '*.pyc', '.DS_Store', 'Thumbs.db') -join "`n"
    Write-Text (Join-Path $tmp '.gitignore') ($gi + "`n")

    # git (inside the temp project only)
    git -C $tmp init 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $tmp '.git'))) { throw 'git init failed' }
    $gn = (git -C $tmp config user.name 2>$null)
    if (-not $gn) { git -C $tmp config user.name 'AI Agent Team' 2>&1 | Out-Null }
    $ge = (git -C $tmp config user.email 2>$null)
    if (-not $ge) { git -C $tmp config user.email 'team@localhost' 2>&1 | Out-Null }
    git -C $tmp add -A 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'git add failed' }
    git -C $tmp commit -q -m 'A0: project skeleton' 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'initial commit failed' }
    $hash = (git -C $tmp rev-parse --short HEAD 2>$null)
    if (-not $hash) { throw 'could not read HEAD' }

    # move to final name
    if (Test-Path -LiteralPath $proj) { throw "Project already exists: $proj" }
    Move-Item -LiteralPath $tmp -Destination $proj -ErrorAction Stop
    $moved = $true
    if (-not (Test-Path -LiteralPath (Join-Path $proj '.git'))) { throw '.git missing after move' }

    # registry LAST (keeps BOM / line ending of an existing file; "Active project:" untouched)
    $row = "| $Name | $Type | $Audience | $Profile | $Track | $Mode | A0 | IN_PROGRESS |"
    $regDir = Split-Path -Parent $RegistryPath
    if ($regDir -and -not (Test-Path -LiteralPath $regDir)) { New-Item -ItemType Directory -Force -Path $regDir | Out-Null }
    if (-not (Test-Path -LiteralPath $RegistryPath)) {
        $txt = "Active project: -`n`n| name | type | audience | profile | track | mode | stage | status |`n|---|---|---|---|---|---|---|---|`n$row`n"
        Write-Text $RegistryPath $txt
    } else {
        $bytes = [IO.File]::ReadAllBytes($RegistryPath)
        $bom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
        $reg = [Text.Encoding]::UTF8.GetString($bytes)
        if ($bom) { $reg = $reg.Substring(1) }
        if ($reg -match '(?m)^\|\s*' + [regex]::Escape($Name) + '\s*\|') {
            $warn = 'WARNING: registry entry already exists, row not added'
        } else {
            $eol = "`n"
            if ($reg.Contains("`r`n")) { $eol = "`r`n" }
            if ($reg.Length -gt 0 -and -not $reg.EndsWith("`n")) { $reg += $eol }
            [IO.File]::WriteAllText($RegistryPath, ($reg + $row + $eol), (New-Object System.Text.UTF8Encoding($bom)))
        }
    }
    $ok = $true
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}
finally {
    if (-not $ok) {
        if ($moved -and (Test-Path -LiteralPath $proj)) { Remove-Item -LiteralPath $proj -Recurse -Force -ErrorAction SilentlyContinue }
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}
if (-not $ok) { exit 1 }

Write-Host "Project created: $proj"
Write-Host "Track: $Track | Mode: $Mode | Stage: A0 | initial commit: $hash"
Write-Host "Registry: $RegistryPath"
if ($warn) { Write-Host $warn }
exit 0

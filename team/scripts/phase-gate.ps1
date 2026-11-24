# phase-gate.ps1 - independently checks whether a project may leave its active stage (READ-ONLY).
# Usage: phase-gate.ps1 -Project <name> [-SkipUserGates] [-ProjectsRoot <dir>]
# Rules: .claude/skills/project-lifecycle/glossary.md "phase-gate rules" (single source).
# Output <=10 lines: FIRST line RESULT: PASS|FAIL. Exit: 0 = PASS, 1 = FAIL, 2 = format/usage/value error.
# Report paths: the Report cell (gate record and TASKS) is split on ';' or ','; a part starting with 'user:' and '-' are not paths; every part containing '/' or a backslash is a file path, must stay inside projects/<name>/ and must exist (canonical: projects/<name>/reports/...; reports/ docs/ state/ and an absolute path inside the project are also accepted); otherwise FAIL (exit 1).
# An invalid/misspelled value is never skipped silently: exit 2 (case-sensitive: exact match).
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$SkipUserGates,
    [string]$ProjectsRoot
)

$ErrorActionPreference = 'Stop'
$PassValues = @('APPROVE', 'PASS', 'APPROVED', 'APPROVED-IN-ADVANCE', 'PROMOTION', 'CONTINUE', 'RELEASE', 'EXCEPTION')
$GateRe = '^(K[1-4]|E-A[0-8]|T-A[3-7]|P-A[4-6]|C-(CHILD|AGE|DOMAIN|SEC|ACCESS|PERF))$'

function Stop-Format([string]$msg) {
    Write-Output 'RESULT: FAIL'
    Write-Output ("ERROR: {0}" -f $msg)
    exit 2
}

# Glossary "phase-gate rules" gate-stage table: allowed Stage list for (gate, track) (empty = the ID does not exist on that track).
function Get-GateStage([string]$gate, [string]$track) {
    $m = [regex]::Match($gate, '^([ETP])-(A[0-8])$')
    if ($m.Success) {
        if ($track -ceq 'prototype') {
            $okIds = @('E-A0', 'E-A1', 'E-A2', 'E-A3', 'E-A4', 'E-A6', 'T-A3', 'T-A4', 'T-A6', 'P-A6')
            if ($okIds -cnotcontains $gate) { return @() }
        }
        return @($m.Groups[2].Value)
    }
    if ($track -ceq 'product') {
        switch -CaseSensitive ($gate) {
            'K1' { return @('A1') }
            'K2' { return @('A2') }
            'K3' { return @('A4') }
            'K4' { return @('A6') }
            { $_ -ceq 'C-CHILD' -or $_ -ceq 'C-DOMAIN' -or $_ -ceq 'C-ACCESS' } { return @('A2', 'A6') }
            { $_ -ceq 'C-SEC' -or $_ -ceq 'C-PERF' } { return @('A3', 'A6') }
            'C-AGE' { return @('A5', 'A6') }
        }
    } else {
        switch -CaseSensitive ($gate) {
            'K1' { return @('A1') }
            'K3' { return @('A6') }
            { $_ -ceq 'C-CHILD' -or $_ -ceq 'C-DOMAIN' -or $_ -ceq 'C-ACCESS' } { return @('A2') }
            { $_ -ceq 'C-SEC' -or $_ -ceq 'C-PERF' } { return @('A3') }
            'C-AGE' { return @('A6') }
        }
    }
    return @()
}

function Split-Row([string]$line) {
    $t = $line.Trim()
    if ($t.StartsWith('|')) { $t = $t.Substring(1) }
    if ($t.EndsWith('|')) { $t = $t.Substring(0, $t.Length - 1) }
    return @($t.Split('|') | ForEach-Object { $_.Trim() })
}

function Strip-Tick([string]$s) { return $s.Trim().Trim([char]96).Trim() }

# Returns the table in the section: a header that differs from the expected one is a format error.
function Get-Table([string[]]$lines, [string]$name, [string[]]$cols, [string]$file) {
    $start = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -ceq ('## ' + $name)) { $start = $i; break }
    }
    if ($start -lt 0) { Stop-Format "$file : section '## $name' is missing" }
    $rows = @()
    for ($i = $start + 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^##\s') { break }
        if ($lines[$i].Trim().StartsWith('|')) { $rows += , (Split-Row $lines[$i]) }
    }
    if ($rows.Count -lt 2) { Stop-Format "$file : '$name' table header/separator is missing" }
    if (($rows[0] -join '|') -cne ($cols -join '|')) { Stop-Format ("{0} : '{1}' table header differs from the expected one (expected: {2})" -f $file, $name, ($cols -join ' | ')) }
    if ($rows[1][0] -notmatch '^:?-+:?$') { Stop-Format "$file : '$name' table has no separator row" }
    $out = @()
    for ($i = 2; $i -lt $rows.Count; $i++) {
        if ($rows[$i].Count -ne $cols.Count) { Stop-Format ("{0} : '{1}' row {2}: wrong column count" -f $file, $name, ($i - 1)) }
        $o = [ordered]@{ _n = ($i - 1) }
        for ($c = 0; $c -lt $cols.Count; $c++) { $o[$cols[$c]] = $rows[$i][$c] }
        $out += , ([pscustomobject]$o)
    }
    return , $out
}

function Test-Rel([string]$p) {
    try { return (-not [IO.Path]::IsPathRooted($p)) -and ($p -notmatch '(^|[\\/])\.\.([\\/]|$)') } catch { return $false }
}

if ($Project -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Stop-Format "Invalid -Project: '$Project'" }

# Report cell rule (PHASE gate record and TASKS use the same helper; same sentence as the glossary): the cell is split on ';' or ','; parts are trimmed.
# A part starting with 'user:' and '-' are not paths; every part containing '/' or '\' is a file path.
# Every path, once resolved, must stay inside the project's own folder (projects/<name>/) and the file must exist; otherwise FAIL (exit 1).
function Get-ReportPaths([string]$cell) {
    $out = @()
    foreach ($part in ($cell -split '[;,]')) {
        $pt = (Strip-Tick $part)
        if ($pt -cmatch '^user:' -or $pt -eq '' -or $pt -eq '-') { continue }
        if ($pt -match '[\\/]') { $out += $pt }
    }
    return $out
}

# Is the path inside the project folder and does the file exist? Returns: $null = ok, otherwise the error text.
function Test-ProjectPath([string]$p) {
    try {
        $n = $p.Replace('\', '/')
        if ($n -match '^team/') { return "hub path outside the project: $p" }
        if ([IO.Path]::IsPathRooted($n)) { $full = [IO.Path]::GetFullPath($n) }
        elseif ($n -match '^projects/') { $full = [IO.Path]::GetFullPath((Join-Path $repRoot $n)) }
        else { $full = [IO.Path]::GetFullPath((Join-Path $proj $n)) }
        $base = [IO.Path]::GetFullPath($proj).TrimEnd('\') + '\'
    } catch { return "invalid path: $p" }
    if (-not $full.StartsWith($base, [StringComparison]::OrdinalIgnoreCase)) { return "outside projects/$Project/: $p" }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { return "report file missing: $p" }
    return $null
}

$teamRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $teamRoot 'projects' }
if (-not (Test-Path -LiteralPath $ProjectsRoot)) { Stop-Format "ProjectsRoot missing: $ProjectsRoot" }
$ProjectsRoot = (Resolve-Path -LiteralPath $ProjectsRoot).Path
$repRoot = Split-Path -Parent $ProjectsRoot
$proj = Join-Path $ProjectsRoot $Project
$phaseFile = Join-Path $proj 'state\PHASE.md'
$tasksFile = Join-Path $proj 'state\TASKS.md'
if (-not (Test-Path -LiteralPath $phaseFile)) { Stop-Format "PHASE.md missing: projects/$Project/state/PHASE.md" }

$lines = @(Get-Content -LiteralPath $phaseFile -Encoding utf8)

# --- the same '##' section header twice -> exit 2 ---
$seen = @{}
foreach ($l in $lines) {
    if ($l -match '^##\s') {
        $t = $l.Trim()
        if ($seen.ContainsKey($t)) { Stop-Format "PHASE.md : section '$t' appears more than once" }
        $seen[$t] = $true
    }
}

# --- header fields (before the first '##') ---
$h = @{}
foreach ($l in $lines) {
    if ($l -match '^##\s') { break }
    foreach ($part in ($l -split ' \| ')) {
        $m = [regex]::Match($part.Trim(), '^([a-z]+):\s*(.*)$')
        if ($m.Success) { $h[$m.Groups[1].Value] = $m.Groups[2].Value.Trim() }
    }
}
foreach ($k in 'project', 'type', 'audience', 'profile', 'track', 'mode', 'stage', 'status', 'conditional') {
    if (-not $h.ContainsKey($k) -or $h[$k] -eq '') { Stop-Format "PHASE header has no '$k' field" }
}
$track = $h['track']; $stage = $h['stage']
if ($h['project'] -cne $Project) { Stop-Format "project field '$($h['project'])' differs from the folder name ($Project)" }
if ($track -cnotmatch '^(prototype|product)$') { Stop-Format "track has a disallowed value: '$track'" }
if ($stage -cnotmatch '^A[0-8]$') { Stop-Format "stage has a disallowed value: '$stage'" }
if ($h['status'] -cnotmatch '^(IN_PROGRESS|WAITING_GATE|WAITING_USER|BLOCKED|COMPLETE|SHELVED)$') { Stop-Format "status has a disallowed value: '$($h['status'])'" }
if ($h['mode'] -cnotmatch '^(light|medium|full|-)$') { Stop-Format "mode has a disallowed value: '$($h['mode'])'" }
if ($track -ceq 'prototype' -and $h['mode'] -cne '-') { Stop-Format "when track: prototype, mode must be '-' (found: '$($h['mode'])')" }
if ($track -ceq 'product' -and $h['mode'] -ceq '-') { Stop-Format "when track: product, mode cannot be '-' (light/medium/full)" }
$rules = @(
    @('type', '^(game|education|learning|self-development)(\+game)?$'),
    @('audience', '^(child|teen|adult)$'),
    @('profile', '^(web|mobile|desktop-engine)$')
)
foreach ($r in $rules) {
    $v = $h[$r[0]]
    if ($v -ceq '?') {
        if ($stage -cne 'A0') { Stop-Format "$($r[0]): '?' is accepted only when stage is A0 (stage: $stage)" }
    } elseif ($v -cnotmatch $r[1]) { Stop-Format "$($r[0]) has a disallowed value: '$v'" }
}
if ($h['conditional'] -cne 'none') {
    foreach ($c in ($h['conditional'] -split ',\s*')) {
        if ($c -cnotmatch '^C-(CHILD|AGE|DOMAIN|SEC|ACCESS|PERF)$') { Stop-Format "conditional has a disallowed value: '$c'" }
    }
}

$criteria = Get-Table $lines 'Exit criteria' @('#', 'Track', 'Stage', 'Criterion', 'Path', 'Status') 'PHASE.md'
$gates = Get-Table $lines 'Gate records' @('Gate', 'Track', 'Stage', 'Reviewer', 'Result', 'Report', 'Date') 'PHASE.md'

# --- value validation (no silent skipping) ---
foreach ($k in $criteria) {
    if ($k.Track -cnotmatch '^(prototype|product)$') { Stop-Format "Exit criteria row $($k._n): Track disallowed '$($k.Track)'" }
    if ($k.Stage -cnotmatch '^A[0-8]$') { Stop-Format "Exit criteria row $($k._n): Stage disallowed '$($k.Stage)'" }
    if ($k.Status -cnotmatch '^(OPEN|COMPLETE)$') { Stop-Format "Exit criteria row $($k._n): Status disallowed '$($k.Status)'" }
}
foreach ($r in $gates) {
    $n = $r._n
    if ($r.Gate -cnotmatch $GateRe) { Stop-Format "Gate records row ${n}: Gate disallowed '$($r.Gate)'" }
    if ($r.Track -cnotmatch '^(prototype|product)$') { Stop-Format "Gate records row ${n}: Track disallowed '$($r.Track)'" }
    if ($r.Stage -cnotmatch '^A[0-8]$') { Stop-Format "Gate records row ${n}: Stage disallowed '$($r.Stage)'" }
    $allowed = switch -Regex -CaseSensitive ($r.Gate) {
        '^[EC]-' { @('APPROVE', 'REVISE') }
        '^T-' { @('PASS', 'FAIL') }
        '^P-' { @('PASS', 'NEEDS_FIX', 'BLOCKER') }
        '^K1$' { @('APPROVED', 'FIX', 'STOP', 'APPROVED-IN-ADVANCE') }
        '^K2$' { @('APPROVED', 'FIX', 'SHRINK') }
        '^K3$' { if ($r.Track -ceq 'prototype') { @('PROMOTION', 'REPEAT', 'SHELVE') } else { @('CONTINUE', 'FIX', 'STOP') } }
        '^K4$' { @('RELEASE', 'FIX', 'POSTPONE') }
    }
    $allowed = @($allowed) + @('PENDING', 'EXCEPTION')
    if ($allowed -cnotcontains $r.Result) { Stop-Format "Gate records row ${n}: Result disallowed '$($r.Result)' ($($r.Gate), $($r.Track))" }
    # gate-stage consistency (glossary table; every row, not only the active ones)
    $okStage = @(Get-GateStage $r.Gate $r.Track)
    if ($okStage -cnotcontains $r.Stage) { Stop-Format "Gate records row ${n}: gate-stage mismatch: gate=$($r.Gate) track=$($r.Track) stage=$($r.Stage)" }
}

$errs = New-Object System.Collections.Generic.List[string]
$summ = @()

# --- 1. Exit criteria (Path: backticks and surrounding spaces are stripped) ---
$crit = @($criteria | Where-Object { $_.Track -ceq $track -and $_.Stage -ceq $stage })
$kOk = 0; $kMissing = @()
foreach ($k in $crit) {
    $path = Strip-Tick $k.Path
    if ($path -eq '-') { $kOk++; continue }
    $full = if ($path -ne '' -and (Test-Rel $path)) { Join-Path $proj $path } else { $null }
    if ($full -and (Test-Path -LiteralPath $full -PathType Leaf)) {
        if ($path.Replace('\', '/') -match '^docs/source/') {
            # concept copy (may be binary): the only requirement is that the file exists and is larger than 0 bytes
            if ((Get-Item -LiteralPath $full).Length -gt 0) { $kOk++ } else { $kMissing += ("{0} (empty: 0 bytes)" -f $path) }
            continue
        }
        $filled = @(Get-Content -LiteralPath $full -Encoding utf8 | Where-Object { $_.Trim() -ne '' }).Count
        if ($filled -ge 5) { $kOk++ } else { $kMissing += ("{0} (empty: {1} filled lines)" -f $path, $filled) }
    } else { $kMissing += $path }
}
if ($crit.Count -eq 0) { $errs.Add("No exit criteria rows ($track/$stage)") }
foreach ($e in $kMissing) { $errs.Add("Criterion file missing/insufficient: $e") }
$ks = "CRITERIA: $kOk/$($crit.Count)"
if ($kMissing.Count -gt 0) { $ks += " (missing: " + (($kMissing | Select-Object -First 3) -join ', ') + ")" }
$summ += $ks

# --- 2. Gate records (only written rows; key = Gate+Track+Stage; the last row counts) ---
$active = @($gates | Where-Object { $_.Track -ceq $track -and $_.Stage -ceq $stage })
if ($SkipUserGates) { $active = @($active | Where-Object { $_.Gate -cnotmatch '^K\d+$' }) }
$last = [ordered]@{}
foreach ($r in $active) { $last[$r.Gate] = $r }
$open = @()
foreach ($kn in $last.Keys) {
    $r = $last[$kn]
    if ($PassValues -cnotcontains $r.Result) { $open += ("{0} ({1})" -f $kn, $r.Result); continue }
    if ($kn -cmatch '^K[34]$' -and $r.Report -cnotmatch '^user: visual approval(;|$)') { $errs.Add("$kn passing decision: Report cell must start with 'user: visual approval'") }
    if ($r.Result -ceq 'EXCEPTION') {
        if ($r.Report -cnotmatch '^user:\s*\S') { $errs.Add("$kn EXCEPTION: Report cell is not 'user: <reason>'") }
    } elseif ($kn -cnotmatch '^K\d+$') {
        $paths = @(Get-ReportPaths $r.Report)
        if ($paths.Count -eq 0) { $errs.Add("$kn : Report cell is empty") }
        foreach ($p in $paths) {
            $pe = Test-ProjectPath $p
            if ($pe) { $errs.Add("$kn : $pe") }
        }
    } else {
        foreach ($p in @(Get-ReportPaths $r.Report)) {
            $pe = Test-ProjectPath $p
            if ($pe) { $errs.Add("$kn : $pe") }
        }
    }
}
if ($last.Count -eq 0 -and -not ($track -ceq 'prototype' -and $stage -ceq 'A8')) { $errs.Add("expected gate not recorded ($track/$stage)") }
foreach ($a in $open) { $errs.Add("Gate not passed: $a") }
$gs = "GATE: {0} keys, {1} open" -f $last.Count, $open.Count
if ($open.Count -gt 0) { $gs += " (" + (($open | Select-Object -First 3) -join ', ') + ")" }
if ($SkipUserGates) { $gs += " [K* skipped]" }
$summ += $gs

# --- 3. TASKS: ALL tables carrying the fixed header ---
if (-not (Test-Path -LiteralPath $tasksFile)) { Stop-Format "TASKS.md missing: projects/$Project/state/TASKS.md" }
$tl = @(Get-Content -LiteralPath $tasksFile -Encoding utf8)
$hdrLine = '| # | Task | Role | Model | Status | Report |'
$starts = @()
for ($i = 0; $i -lt $tl.Count; $i++) { if ($tl[$i].Trim() -ceq $hdrLine) { $starts += $i } }
if ($starts.Count -eq 0) { Stop-Format "TASKS.md fixed table header missing: $hdrLine" }
$done = 0; $total = 0; $tOpen = 0
# Single pass: a blank line inside a table is skipped; a table ends only with a non-blank line that does not start with '|' or with a header.
# A '|' line outside a table with the fixed header -> exit 2.
$inTable = $false
for ($i = 0; $i -lt $tl.Count; $i++) {
    $tt = $tl[$i].Trim()
    if ($tt -ceq $hdrLine) {
        if ($i + 1 -ge $tl.Count -or (Split-Row $tl[$i + 1])[0] -notmatch '^:?-+:?$') { Stop-Format "TASKS.md line $($i + 1): table separator row is missing" }
        $inTable = $true; $i++; continue
    }
    if ($inTable) {
        if ($tt -eq '') { continue }
        if (-not $tt.StartsWith('|')) { $inTable = $false; continue }
    } else {
        if ($tt.StartsWith('|')) { Stop-Format "TASKS.md line $($i + 1): table row without the fixed header (orphan): $tt" }
        continue
    }
    do {
        $c = Split-Row $tl[$i]
        if ($c.Count -ne 6) { Stop-Format "TASKS.md line $($i + 1): wrong column count" }
        $total++
        $id = $c[0]; $dur = $c[4]; $rap = $c[5]
        if ($dur -cnotmatch '^(PENDING|RUNNING|NEEDS_REVIEW|DONE|FAILED)$') { Stop-Format "TASKS.md line $($i + 1) (#$id): undefined Status '$dur'" }
        if ($dur -ceq 'DONE') {
            $paths = @(Get-ReportPaths $rap)
            if ($paths.Count -eq 0) { $errs.Add("TASKS #$id DONE but Report is empty"); continue }
            $bad = $false
            foreach ($p in $paths) {
                $pe = Test-ProjectPath $p
                if ($pe) { $errs.Add("TASKS #$id $pe"); $bad = $true }
            }
            if (-not $bad) { $done++ }
        } elseif ($dur -cne 'FAILED') {
            $tOpen++; $errs.Add("TASKS #$id open ($dur)")
        }
    } while ($false)
}
$summ += ("TASKS: {0}/{1} DONE+report, {2} open, {3} tables" -f $done, $total, $tOpen, $starts.Count)

# --- 4. A6: BLOCKER ---
if ($track -ceq 'product' -and $stage -ceq 'A6') {
    $vf = Join-Path $proj 'docs\VERIFICATION.md'
    if (-not (Test-Path -LiteralPath $vf -PathType Leaf)) {
        $errs.Add('docs/VERIFICATION.md missing'); $summ += 'BLOCKER: file missing'
    } else {
        $en = @(Get-Content -LiteralPath $vf -Encoding utf8 | ForEach-Object { [regex]::Match($_, '^\s*BLOCKER:\s*(\d+)\s*$') } | Where-Object { $_.Success })
        if ($en.Count -ne 1) {
            $errs.Add("VERIFICATION.md: must have exactly one 'BLOCKER: <n>' line (found: $($en.Count))"); $summ += "BLOCKER: line count $($en.Count)"
        } else {
            $n = [int]$en[0].Groups[1].Value
            $summ += "BLOCKER: $n"
            if ($n -ne 0) { $errs.Add("BLOCKER finding present: $n") }
        }
    }
}

# --- output ---
$pass = ($errs.Count -eq 0)
Write-Output ($(if ($pass) { 'RESULT: PASS' } else { 'RESULT: FAIL' }))
Write-Output ("PROJECT: {0} TRACK: {1} STAGE: {2}" -f $Project, $track, $stage)
$summ | ForEach-Object { Write-Output $_ }
$errs | Select-Object -First 3 | ForEach-Object { Write-Output ("ERROR: " + $_) }
if ($pass) { exit 0 } else { exit 1 }

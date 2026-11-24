# phase-gate.ps1 - bir projenin aktif asamasindan cikip cikamayacagini bagimsiz denetler (SALT OKUNUR).
# Kullanim: phase-gate.ps1 -Project <ad> [-SkipUserGates] [-ProjectsRoot <klasor>]
# Kurallar: .claude/skills/project-lifecycle/sozluk.md "phase-gate kurallari" (tek kaynak).
# Cikti <=10 satir: ILK satir SONUC: PASS|FAIL. Exit: 0 = PASS, 1 = FAIL, 2 = bicim/kullanim/deger hatasi.
# Rapor yollari: Rapor hucresi (kapi kaydi ve TASKS) ';' ya da ',' ile parcalanir; 'kullanici:' ile baslayan parca ve '-' yol degildir; '/' ya da ters bolu iceren her parca dosya yoludur, projects/<ad>/ icinde kalmali ve var olmali (kanonik: projects/<ad>/reports/...; reports/ docs/ state/ ve proje ici mutlak yol da kabul); aksi FAIL (exit 1).
# Gecersiz/yanlis yazimli deger sessizce atlanmaz: exit 2 (buyuk/kucuk harf: tam eslesme).
param(
    [Parameter(Mandatory = $true)][string]$Project,
    [switch]$SkipUserGates,
    [string]$ProjectsRoot
)

$ErrorActionPreference = 'Stop'
$PassValues = @('APPROVE', 'PASS', 'GECER', 'ONAY', 'ONAY-ONCEDEN', 'TERFI', 'DEVAM', 'YAYINLA', 'ISTISNA')
$GateRe = '^(K[1-4]|E-A[0-8]|T-A[3-7]|P-A[4-6]|C-(COCUK|YAS|ALAN|GUV|ERISIM|PERF))$'

function Stop-Format([string]$msg) {
    Write-Output 'SONUC: FAIL'
    Write-Output ("HATA: {0}" -f $msg)
    exit 2
}

# Sozluk "phase-gate kurallari" kapi-asama tablosu: (kapi, hat) icin izinli Asama listesi (bos = kimlik o hatta yok).
function Get-GateAsama([string]$kapi, [string]$hat) {
    $m = [regex]::Match($kapi, '^([ETP])-(A[0-8])$')
    if ($m.Success) {
        if ($hat -ceq 'prototip') {
            $okIds = @('E-A0', 'E-A1', 'E-A2', 'E-A3', 'E-A4', 'E-A6', 'T-A3', 'T-A4', 'T-A6', 'P-A6')
            if ($okIds -cnotcontains $kapi) { return @() }
        }
        return @($m.Groups[2].Value)
    }
    if ($hat -ceq 'urun') {
        switch -CaseSensitive ($kapi) {
            'K1' { return @('A1') }
            'K2' { return @('A2') }
            'K3' { return @('A4') }
            'K4' { return @('A6') }
            { $_ -ceq 'C-COCUK' -or $_ -ceq 'C-ALAN' -or $_ -ceq 'C-ERISIM' } { return @('A2', 'A6') }
            { $_ -ceq 'C-GUV' -or $_ -ceq 'C-PERF' } { return @('A3', 'A6') }
            'C-YAS' { return @('A5', 'A6') }
        }
    } else {
        switch -CaseSensitive ($kapi) {
            'K1' { return @('A1') }
            'K3' { return @('A6') }
            { $_ -ceq 'C-COCUK' -or $_ -ceq 'C-ALAN' -or $_ -ceq 'C-ERISIM' } { return @('A2') }
            { $_ -ceq 'C-GUV' -or $_ -ceq 'C-PERF' } { return @('A3') }
            'C-YAS' { return @('A6') }
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

# Bolumdeki tabloyu doner: beklenen basliga uymazsa bicim hatasi.
function Get-Table([string[]]$lines, [string]$name, [string[]]$cols, [string]$file) {
    $start = -1
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -ceq ('## ' + $name)) { $start = $i; break }
    }
    if ($start -lt 0) { Stop-Format "$file : '## $name' bolumu yok" }
    $rows = @()
    for ($i = $start + 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^##\s') { break }
        if ($lines[$i].Trim().StartsWith('|')) { $rows += , (Split-Row $lines[$i]) }
    }
    if ($rows.Count -lt 2) { Stop-Format "$file : '$name' tablo basligi/ayraci yok" }
    if (($rows[0] -join '|') -cne ($cols -join '|')) { Stop-Format ("{0} : '{1}' tablo basligi beklenenden farkli (beklenen: {2})" -f $file, $name, ($cols -join ' | ')) }
    if ($rows[1][0] -notmatch '^:?-+:?$') { Stop-Format "$file : '$name' tablosunda ayrac satiri yok" }
    $out = @()
    for ($i = 2; $i -lt $rows.Count; $i++) {
        if ($rows[$i].Count -ne $cols.Count) { Stop-Format ("{0} : '{1}' satir {2}: sutun sayisi hatali" -f $file, $name, ($i - 1)) }
        $o = [ordered]@{ _n = ($i - 1) }
        for ($c = 0; $c -lt $cols.Count; $c++) { $o[$cols[$c]] = $rows[$i][$c] }
        $out += , ([pscustomobject]$o)
    }
    return , $out
}

function Test-Rel([string]$p) {
    try { return (-not [IO.Path]::IsPathRooted($p)) -and ($p -notmatch '(^|[\\/])\.\.([\\/]|$)') } catch { return $false }
}

if ($Project -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Stop-Format "Gecersiz -Project: '$Project'" }

# Rapor hucresi kurali (PHASE kapi kaydi ve TASKS ayni yardimci; sozluk ile ayni cumle): hucre ';' ya da ',' ile parcalanir; parcalar kirpilir.
# 'kullanici:' ile baslayan parca ve '-' yol degildir; '/' ya da '\' iceren her parca dosya yoludur.
# Her yol cozuldugunde projenin kendi klasoru (projects/<ad>/) icinde kalmali ve dosya var olmali; aksi FAIL (exit 1).
function Get-RaporPaths([string]$cell) {
    $out = @()
    foreach ($part in ($cell -split '[;,]')) {
        $pt = (Strip-Tick $part)
        if ($pt -cmatch '^kullanici:' -or $pt -eq '' -or $pt -eq '-') { continue }
        if ($pt -match '[\\/]') { $out += $pt }
    }
    return $out
}

# Yol proje klasoru icinde mi ve dosya var mi? Donus: $null = tamam, aksi halde hata metni.
function Test-ProjectPath([string]$p) {
    try {
        $n = $p.Replace('\', '/')
        if ($n -match '^team/') { return "merkez yolu proje disinda: $p" }
        if ([IO.Path]::IsPathRooted($n)) { $full = [IO.Path]::GetFullPath($n) }
        elseif ($n -match '^projects/') { $full = [IO.Path]::GetFullPath((Join-Path $repRoot $n)) }
        else { $full = [IO.Path]::GetFullPath((Join-Path $proj $n)) }
        $base = [IO.Path]::GetFullPath($proj).TrimEnd('\') + '\'
    } catch { return "gecersiz yol: $p" }
    if (-not $full.StartsWith($base, [StringComparison]::OrdinalIgnoreCase)) { return "projects/$Project/ disinda: $p" }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { return "rapor dosyasi yok: $p" }
    return $null
}

$teamRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $ProjectsRoot) { $ProjectsRoot = Join-Path $teamRoot 'projects' }
if (-not (Test-Path -LiteralPath $ProjectsRoot)) { Stop-Format "ProjectsRoot yok: $ProjectsRoot" }
$ProjectsRoot = (Resolve-Path -LiteralPath $ProjectsRoot).Path
$repRoot = Split-Path -Parent $ProjectsRoot
$proj = Join-Path $ProjectsRoot $Project
$phaseFile = Join-Path $proj 'state\PHASE.md'
$tasksFile = Join-Path $proj 'state\TASKS.md'
if (-not (Test-Path -LiteralPath $phaseFile)) { Stop-Format "PHASE.md yok: projects/$Project/state/PHASE.md" }

$lines = @(Get-Content -LiteralPath $phaseFile -Encoding utf8)

# --- ayni '##' bolum basligi iki kez -> exit 2 ---
$seen = @{}
foreach ($l in $lines) {
    if ($l -match '^##\s') {
        $t = $l.Trim()
        if ($seen.ContainsKey($t)) { Stop-Format "PHASE.md : '$t' bolumu birden cok kez" }
        $seen[$t] = $true
    }
}

# --- baslik alanlari (ilk '##'den once) ---
$h = @{}
foreach ($l in $lines) {
    if ($l -match '^##\s') { break }
    foreach ($part in ($l -split ' \| ')) {
        $m = [regex]::Match($part.Trim(), '^([a-z]+):\s*(.*)$')
        if ($m.Success) { $h[$m.Groups[1].Value] = $m.Groups[2].Value.Trim() }
    }
}
foreach ($k in 'proje', 'tur', 'kitle', 'profil', 'hat', 'mod', 'asama', 'durum', 'kosullu') {
    if (-not $h.ContainsKey($k) -or $h[$k] -eq '') { Stop-Format "PHASE basliginda '$k' alani yok" }
}
$hat = $h['hat']; $asama = $h['asama']
if ($h['proje'] -cne $Project) { Stop-Format "proje alani '$($h['proje'])' klasor adiyla ($Project) ayni degil" }
if ($hat -cnotmatch '^(prototip|urun)$') { Stop-Format "hat izinsiz deger: '$hat'" }
if ($asama -cnotmatch '^A[0-8]$') { Stop-Format "asama izinsiz deger: '$asama'" }
if ($h['durum'] -cnotmatch '^(CALISIYOR|KAPI_BEKLIYOR|KULLANICI_BEKLIYOR|BLOKE|TAMAM|RAFTA)$') { Stop-Format "durum izinsiz deger: '$($h['durum'])'" }
if ($h['mod'] -cnotmatch '^(hafif|orta|tam|-)$') { Stop-Format "mod izinsiz deger: '$($h['mod'])'" }
if ($hat -ceq 'prototip' -and $h['mod'] -cne '-') { Stop-Format "hat: prototip iken mod '-' olmali (bulunan: '$($h['mod'])')" }
if ($hat -ceq 'urun' -and $h['mod'] -ceq '-') { Stop-Format "hat: urun iken mod '-' olamaz (hafif/orta/tam)" }
$rules = @(
    @('tur', '^(oyun|egitim|ogrenme|kisisel-gelisim)(\+oyun)?$'),
    @('kitle', '^(cocuk|genc|yetiskin)$'),
    @('profil', '^(web|mobil|masaustu-motor)$')
)
foreach ($r in $rules) {
    $v = $h[$r[0]]
    if ($v -ceq '?') {
        if ($asama -cne 'A0') { Stop-Format "$($r[0]): '?' yalniz asama A0 iken kabul (asama: $asama)" }
    } elseif ($v -cnotmatch $r[1]) { Stop-Format "$($r[0]) izinsiz deger: '$v'" }
}
if ($h['kosullu'] -cne 'yok') {
    foreach ($c in ($h['kosullu'] -split ',\s*')) {
        if ($c -cnotmatch '^C-(COCUK|YAS|ALAN|GUV|ERISIM|PERF)$') { Stop-Format "kosullu izinsiz deger: '$c'" }
    }
}

$kriterler = Get-Table $lines 'Cikis kriterleri' @('#', 'Hat', 'Asama', 'Kriter', 'Yol', 'Durum') 'PHASE.md'
$kapilar = Get-Table $lines 'Kapi kayitlari' @('Kapi', 'Hat', 'Asama', 'Denetleyen', 'Sonuc', 'Rapor', 'Tarih') 'PHASE.md'

# --- deger dogrulama (sessiz atlama yok) ---
foreach ($k in $kriterler) {
    if ($k.Hat -cnotmatch '^(prototip|urun)$') { Stop-Format "Cikis kriterleri satir $($k._n): Hat izinsiz '$($k.Hat)'" }
    if ($k.Asama -cnotmatch '^A[0-8]$') { Stop-Format "Cikis kriterleri satir $($k._n): Asama izinsiz '$($k.Asama)'" }
    if ($k.Durum -cnotmatch '^(ACIK|TAMAM)$') { Stop-Format "Cikis kriterleri satir $($k._n): Durum izinsiz '$($k.Durum)'" }
}
foreach ($r in $kapilar) {
    $n = $r._n
    if ($r.Kapi -cnotmatch $GateRe) { Stop-Format "Kapi kayitlari satir ${n}: Kapi izinsiz '$($r.Kapi)'" }
    if ($r.Hat -cnotmatch '^(prototip|urun)$') { Stop-Format "Kapi kayitlari satir ${n}: Hat izinsiz '$($r.Hat)'" }
    if ($r.Asama -cnotmatch '^A[0-8]$') { Stop-Format "Kapi kayitlari satir ${n}: Asama izinsiz '$($r.Asama)'" }
    $allowed = switch -Regex -CaseSensitive ($r.Kapi) {
        '^[EC]-' { @('APPROVE', 'REVISE') }
        '^T-' { @('PASS', 'FAIL') }
        '^P-' { @('GECER', 'DUZELTILMELI', 'ENGEL') }
        '^K1$' { @('ONAY', 'DUZELT', 'DURDUR', 'ONAY-ONCEDEN') }
        '^K2$' { @('ONAY', 'DUZELT', 'KUCULT') }
        '^K3$' { if ($r.Hat -ceq 'prototip') { @('TERFI', 'YINELE', 'RAFA-KALDIR') } else { @('DEVAM', 'DUZELT', 'DURDUR') } }
        '^K4$' { @('YAYINLA', 'DUZELT', 'ERTELE') }
    }
    $allowed = @($allowed) + @('BEKLIYOR', 'ISTISNA')
    if ($allowed -cnotcontains $r.Sonuc) { Stop-Format "Kapi kayitlari satir ${n}: Sonuc izinsiz '$($r.Sonuc)' ($($r.Kapi), $($r.Hat))" }
    # kapi-asama tutarliligi (sozluk tablosu; her satir, yalniz aktif olanlar degil)
    $okAsama = @(Get-GateAsama $r.Kapi $r.Hat)
    if ($okAsama -cnotcontains $r.Asama) { Stop-Format "Kapi kayitlari satir ${n}: kapi-asama tutarsiz: kapi=$($r.Kapi) hat=$($r.Hat) asama=$($r.Asama)" }
}

$errs = New-Object System.Collections.Generic.List[string]
$summ = @()

# --- 1. Cikis kriterleri (Yol: backtick ve cevre bosluklar soyulur) ---
$krit = @($kriterler | Where-Object { $_.Hat -ceq $hat -and $_.Asama -ceq $asama })
$kOk = 0; $kEksik = @()
foreach ($k in $krit) {
    $yol = Strip-Tick $k.Yol
    if ($yol -eq '-') { $kOk++; continue }
    $full = if ($yol -ne '' -and (Test-Rel $yol)) { Join-Path $proj $yol } else { $null }
    if ($full -and (Test-Path -LiteralPath $full -PathType Leaf)) {
        if ($yol.Replace('\', '/') -match '^docs/kaynak/') {
            # konsept kopyasi (ikili olabilir): sart yalniz dosya var ve 0 bayttan buyuk
            if ((Get-Item -LiteralPath $full).Length -gt 0) { $kOk++ } else { $kEksik += ("{0} (bos: 0 bayt)" -f $yol) }
            continue
        }
        $dolu = @(Get-Content -LiteralPath $full -Encoding utf8 | Where-Object { $_.Trim() -ne '' }).Count
        if ($dolu -ge 5) { $kOk++ } else { $kEksik += ("{0} (bos: {1} dolu satir)" -f $yol, $dolu) }
    } else { $kEksik += $yol }
}
if ($krit.Count -eq 0) { $errs.Add("Cikis kriteri satiri yok ($hat/$asama)") }
foreach ($e in $kEksik) { $errs.Add("Kriter dosyasi eksik/yetersiz: $e") }
$ks = "KRITER: $kOk/$($krit.Count)"
if ($kEksik.Count -gt 0) { $ks += " (eksik: " + (($kEksik | Select-Object -First 3) -join ', ') + ")" }
$summ += $ks

# --- 2. Kapi kayitlari (yalniz yazili satirlar; anahtar = Kapi+Hat+Asama; son satir gecerli) ---
$aktif = @($kapilar | Where-Object { $_.Hat -ceq $hat -and $_.Asama -ceq $asama })
if ($SkipUserGates) { $aktif = @($aktif | Where-Object { $_.Kapi -cnotmatch '^K\d+$' }) }
$last = [ordered]@{}
foreach ($r in $aktif) { $last[$r.Kapi] = $r }
$acik = @()
foreach ($kn in $last.Keys) {
    $r = $last[$kn]
    if ($PassValues -cnotcontains $r.Sonuc) { $acik += ("{0} ({1})" -f $kn, $r.Sonuc); continue }
    if ($kn -cmatch '^K[34]$' -and $r.Rapor -cnotmatch '^kullanici: gorsel onay(;|$)') { $errs.Add("$kn gecen karar: Rapor hucresi 'kullanici: gorsel onay' ile baslamali") }
    if ($r.Sonuc -ceq 'ISTISNA') {
        if ($r.Rapor -cnotmatch '^kullanici:\s*\S') { $errs.Add("$kn ISTISNA: Rapor hucresi 'kullanici: <gerekce>' degil") }
    } elseif ($kn -cnotmatch '^K\d+$') {
        $paths = @(Get-RaporPaths $r.Rapor)
        if ($paths.Count -eq 0) { $errs.Add("$kn : Rapor hucresi bos") }
        foreach ($p in $paths) {
            $pe = Test-ProjectPath $p
            if ($pe) { $errs.Add("$kn : $pe") }
        }
    } else {
        foreach ($p in @(Get-RaporPaths $r.Rapor)) {
            $pe = Test-ProjectPath $p
            if ($pe) { $errs.Add("$kn : $pe") }
        }
    }
}
if ($last.Count -eq 0 -and -not ($hat -ceq 'prototip' -and $asama -ceq 'A8')) { $errs.Add("beklenen kapi yazilmamis ($hat/$asama)") }
foreach ($a in $acik) { $errs.Add("Kapi gecmedi: $a") }
$gs = "KAPI: {0} anahtar, {1} acik" -f $last.Count, $acik.Count
if ($acik.Count -gt 0) { $gs += " (" + (($acik | Select-Object -First 3) -join ', ') + ")" }
if ($SkipUserGates) { $gs += " [K* atlandi]" }
$summ += $gs

# --- 3. TASKS: sabit basligi tasiyan TUM tablolar ---
if (-not (Test-Path -LiteralPath $tasksFile)) { Stop-Format "TASKS.md yok: projects/$Project/state/TASKS.md" }
$tl = @(Get-Content -LiteralPath $tasksFile -Encoding utf8)
$hdrLine = '| # | Gorev | Rol | Model | Durum | Rapor |'
$starts = @()
for ($i = 0; $i -lt $tl.Count; $i++) { if ($tl[$i].Trim() -ceq $hdrLine) { $starts += $i } }
if ($starts.Count -eq 0) { Stop-Format "TASKS.md sabit tablo basligi yok: $hdrLine" }
$done = 0; $total = 0; $tAcik = 0
# Tek gecis: tablo icindeki bos satir atlanir; tablo yalniz '|' ile baslamayan dolu satirla/baslikla biter.
# Sabit baslikli tablonun disindaki '|' satiri -> exit 2.
$inTable = $false
for ($i = 0; $i -lt $tl.Count; $i++) {
    $tt = $tl[$i].Trim()
    if ($tt -ceq $hdrLine) {
        if ($i + 1 -ge $tl.Count -or (Split-Row $tl[$i + 1])[0] -notmatch '^:?-+:?$') { Stop-Format "TASKS.md satir $($i + 1): tablo ayrac satiri yok" }
        $inTable = $true; $i++; continue
    }
    if ($inTable) {
        if ($tt -eq '') { continue }
        if (-not $tt.StartsWith('|')) { $inTable = $false; continue }
    } else {
        if ($tt.StartsWith('|')) { Stop-Format "TASKS.md satir $($i + 1): sabit basliksiz tablo satiri (yetim): $tt" }
        continue
    }
    do {
        $c = Split-Row $tl[$i]
        if ($c.Count -ne 6) { Stop-Format "TASKS.md satir $($i + 1): sutun sayisi hatali" }
        $total++
        $id = $c[0]; $dur = $c[4]; $rap = $c[5]
        if ($dur -cnotmatch '^(PENDING|RUNNING|NEEDS_REVIEW|DONE|FAILED)$') { Stop-Format "TASKS.md satir $($i + 1) (#$id): tanimsiz Durum '$dur'" }
        if ($dur -ceq 'DONE') {
            $paths = @(Get-RaporPaths $rap)
            if ($paths.Count -eq 0) { $errs.Add("TASKS #$id DONE ama Rapor bos"); continue }
            $bad = $false
            foreach ($p in $paths) {
                $pe = Test-ProjectPath $p
                if ($pe) { $errs.Add("TASKS #$id $pe"); $bad = $true }
            }
            if (-not $bad) { $done++ }
        } elseif ($dur -cne 'FAILED') {
            $tAcik++; $errs.Add("TASKS #$id acik ($dur)")
        }
    } while ($false)
}
$summ += ("TASKS: {0}/{1} DONE+rapor, {2} acik, {3} tablo" -f $done, $total, $tAcik, $starts.Count)

# --- 4. A6: ENGEL ---
if ($hat -ceq 'urun' -and $asama -ceq 'A6') {
    $vf = Join-Path $proj 'docs\VERIFICATION.md'
    if (-not (Test-Path -LiteralPath $vf -PathType Leaf)) {
        $errs.Add('docs/VERIFICATION.md yok'); $summ += 'ENGEL: dosya yok'
    } else {
        $en = @(Get-Content -LiteralPath $vf -Encoding utf8 | ForEach-Object { [regex]::Match($_, '^\s*ENGEL:\s*(\d+)\s*$') } | Where-Object { $_.Success })
        if ($en.Count -ne 1) {
            $errs.Add("VERIFICATION.md: tek 'ENGEL: <n>' satiri olmali (bulunan: $($en.Count))"); $summ += "ENGEL: satir sayisi $($en.Count)"
        } else {
            $n = [int]$en[0].Groups[1].Value
            $summ += "ENGEL: $n"
            if ($n -ne 0) { $errs.Add("ENGEL bulgu var: $n") }
        }
    }
}

# --- cikti ---
$pass = ($errs.Count -eq 0)
Write-Output ($(if ($pass) { 'SONUC: PASS' } else { 'SONUC: FAIL' }))
Write-Output ("PROJE: {0} HAT: {1} ASAMA: {2}" -f $Project, $hat, $asama)
$summ | ForEach-Object { Write-Output $_ }
$errs | Select-Object -First 3 | ForEach-Object { Write-Output ("HATA: " + $_) }
if ($pass) { exit 0 } else { exit 1 }

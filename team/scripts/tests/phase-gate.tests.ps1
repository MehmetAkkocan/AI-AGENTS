# phase-gate.tests.ps1 - phase-gate.ps1 icin senaryo testleri (kendi fixture'ini scratch'te kurar, kosar, temizler).
# Kullanim: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/tests/phase-gate.tests.ps1
# Cikti: senaryo satirlari + "GECEN/TOPLAM: x/y"; exit 0 = hepsi gecti, 1 = basarisiz var. Gercek projects/ a dokunmaz.
$ErrorActionPreference = 'Stop'
$Gate = Join-Path (Split-Path -Parent $PSScriptRoot) 'phase-gate.ps1'
$S = Join-Path $env:TEMP ("aat-gate-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
$PR = Join-Path $S 'projects'
$script:total = 0; $script:pass = 0

function W($p, $t) {
    $d = Split-Path $p
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null }
    Set-Content -LiteralPath $p -Value $t -Encoding utf8
}
function Phase($name, $hat, $asama, $krit, $kapi, $hdr1, $hdr2, $extra) {
    if (-not $hdr1) { $hdr1 = "proje: $name | tur: oyun | kitle: genc | profil: web" }
    if (-not $hdr2) { $hdr2 = "hat: $hat | mod: - | asama: $asama | durum: CALISIYOR" }
    "# PHASE $name`n$hdr1`n$hdr2`nkosullu: yok`n`n## Cikis kriterleri`n| # | Hat | Asama | Kriter | Yol | Durum |`n|---|---|---|---|---|---|`n$krit`n`n## Kapi kayitlari`n| Kapi | Hat | Asama | Denetleyen | Sonuc | Rapor | Tarih |`n|---|---|---|---|---|---|---|`n$kapi`n`n## Asama gecmisi`n| Hat | Asama | Baslangic | Bitis | Sonuc | Etiket |`n|---|---|---|---|---|---|`n`n## Izinli degerler`n- x`n$extra"
}
$tasksHdr = "# TASKS`n| # | Gorev | Rol | Model | Durum | Rapor |`n|---|---|---|---|---|---|`n"
$five = "a`nb`nc`nd`ne`n"
function Mk($name, $phase, $tasks) {
    $p = Join-Path $PR $name
    W "$p\state\PHASE.md" $phase; W "$p\state\TASKS.md" $tasks
    W "$p\docs\BRIEF.md" $five; W "$p\docs\VERIFICATION.md" "x`nENGEL: 0`n"
    W "$p\reports\r1.md" "rapor"
    W "$S\team\reports\r1.md" "merkez rapor"
    $p
}
$kr = "| 1 | prototip | A1 | Brief | docs/BRIEF.md | ACIK |"
$gOk = "| E-A1 | prototip | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
$gK1 = "| K1 | prototip | A1 | kullanici | BEKLIYOR | - | 2026-11-10 |"
$tOk = $tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md |`n"
function Hash($dir) { (Get-ChildItem $dir -Recurse -File | Sort-Object FullName | ForEach-Object { "$($_.FullName)=$((Get-FileHash $_.FullName).Hash)" }) -join ';' }
function T($label, $proj, $expExit, $args2 = @(), $notRe = $null) {
    $script:total++
    $before = Hash $S
    $out = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $Gate -Project $proj -ProjectsRoot $PR @args2)
    $code = $LASTEXITCODE
    $ro = ($before -eq (Hash $S))
    $first = ($out.Count -gt 0 -and $out[0] -match '^SONUC: (PASS|FAIL)$')
    $ok = ($code -eq $expExit) -and $ro -and ($out.Count -le 10) -and $first
    if ($notRe -and (($out -join "`n") -match $notRe)) { $ok = $false }
    if ($ok) { $script:pass++ }
    "{0} {1}: exit={2} (bekl {3}) ro={4} satir={5} | {6}" -f $(if ($ok) { 'OK  ' } else { 'HATA' }), $label, $code, $expExit, $ro, $out.Count, (($out | Select-Object -Skip 1 -First 3) -join ' / ')
}
try {
    Mk 's1' (Phase s1 prototip A1 $kr $gOk) $tOk | Out-Null; T '1 tam' 's1' 0
    $p = Mk 's2' (Phase s2 prototip A1 $kr $gOk) $tOk; Remove-Item "$p\docs\BRIEF.md"; T '2 dosya eksik' 's2' 1
    $p = Mk 's3' (Phase s3 prototip A1 $kr $gOk) $tOk; W "$p\docs\BRIEF.md" "a`nb`n`n`nc`n"; T '3 <5 dolu' 's3' 1
    Mk 's4' (Phase s4 prototip A1 $kr ($gOk + "`n" + $gK1)) $tOk | Out-Null; T '4 BEKLIYOR' 's4' 1
    $rev = "| E-A1 | prototip | A1 | critic | REVISE | reports/r1.md | 2026-11-10 |"
    $p = Mk 's5' (Phase s5 prototip A1 $kr $rev) $tOk; T '5a REVISE' 's5' 1
    W "$p\state\PHASE.md" (Phase s5 prototip A1 $kr ($rev + "`n" + $gOk)); T '5b REVISE+APPROVE' 's5' 0
    $pk = "$gOk`n| K1 | prototip | A1 | kullanici | ONAY | - | 2026-11-10 |`n| E-A1 | urun | A1 | critic | BEKLIYOR | - | 2026-11-10 |"
    Mk 's6' (Phase s6 urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" $pk "" "hat: urun | mod: orta | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '6 terfi: P kayitlari U yi gecirmez' 's6' 1
    Mk 's7' (Phase s7 prototip A1 $kr ($gOk + "`n" + $gK1)) $tOk | Out-Null
    T '7a SkipUserGates' 's7' 0 @('-SkipUserGates'); T '7b onsuz' 's7' 1
    Mk 's8a' (Phase s8a prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | - |`n") | Out-Null; T '8a DONE rapor bos' 's8a' 1
    Mk 's8b' (Phase s8b prototip A1 $kr $gOk) ($tOk + "| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '8b RUNNING' 's8b' 1
    Mk 's8c' (Phase s8c prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md, reports/yok.md |`n") | Out-Null; T '8c coklu rapor biri yok' 's8c' 1
    $kr6 = "| 1 | urun | A6 | V | docs/VERIFICATION.md | ACIK |"
    $g6 = "| E-A6 | urun | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    $h6 = "hat: urun | mod: orta | asama: A6 | durum: CALISIYOR"
    $p = Mk 's9' (Phase s9 urun A6 $kr6 $g6 "" $h6) $tOk; W "$p\docs\VERIFICATION.md" "a`nb`nc`nd`nENGEL: 2`n"; T '9a ENGEL 2' 's9' 1
    W "$p\docs\VERIFICATION.md" "a`nb`nc`nd`nENGEL: 0`n"; T '9b ENGEL 0' 's9' 0
    $p = Mk 's10' (Phase s10 prototip A1 $kr $gOk) $tOk; W "$p\state\PHASE.md" "bozuk icerik"; T '10a bozuk PHASE' 's10' 2
    Remove-Item "$p\state\PHASE.md"; T '10b PHASE yok' 's10' 2
    Mk 's11' (Phase s11 prototip A1 $kr "| E-A1 | prototip | A1 | kullanici | ISTISNA | kullanici: zaman | 2026-11-10 |") $tOk | Out-Null; T '11 ISTISNA' 's11' 0
    Mk 's12' (Phase s12 prototip A1 $kr "") $tOk | Out-Null; T '12 kapi satiri yok' 's12' 1
    # --- tur 2 ---
    Mk 's13a' (Phase s13a prototip A1 $kr $gOk) ($tOk + "`n## Tamamlanan`n| # | Gorev | Rol | Model | Durum | Rapor |`n|---|---|---|---|---|---|`n| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '13a 2. tabloda RUNNING' 's13a' 1
    Mk 's13b' (Phase s13b prototip A1 $kr $gOk) ($tOk + "`n## Tamamlanan`n| # | Gorev | Rol | Model | Durum | Rapor |`n|---|---|---|---|---|---|`n| 2 | y | coder | sonnet | DONE | - |`n") | Out-Null; T '13b 2. tabloda raporsuz DONE' 's13b' 1
    Mk 's13c' (Phase s13c prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | FAILED | - |`n| 2 | x | coder | sonnet | DONE | reports/r1.md |`n") | Out-Null; T '13c FAILED kapiyi acik birakmaz' 's13c' 0
    Mk 's14' (Phase s14 prototip A1 ("| 1 | prototip | A1 | Brief |  ``docs/BRIEF.md``  | ACIK |") $gOk) $tOk | Out-Null; T '14 backtick Yol' 's14' 0
    Mk 's15a' (Phase s15a prototip A1 $kr ($gOk + "`n| E-A1 | Urun | A1 | critic | REVISE | - | 2026-11-10 |")) $tOk | Out-Null; T '15a Hat=Urun' 's15a' 2
    Mk 's15b' (Phase s15b prototip A1 $kr ($gOk + "`n| E-A1 | prototip | a1 | critic | REVISE | - | 2026-11-10 |")) $tOk | Out-Null; T '15b Asama=a1' 's15b' 2
    Mk 's15c' (Phase s15c prototip A1 $kr ($gOk + "`n| E-A1 | prototip | A1 | critic | MAYBE | - | 2026-11-10 |")) $tOk | Out-Null; T '15c bilinmeyen karar' 's15c' 2
    Mk 's15d' (Phase s15d prototip A1 $kr ($gOk + "`n| e-a1 | prototip | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |")) $tOk | Out-Null; T '15d Kapi=e-a1' 's15d' 2
    Mk 's16a' (Phase s16a prototip A1 $kr $gOk "proje: s16a | tur: ? | kitle: genc | profil: web") $tOk | Out-Null; T '16a tur ? A1' 's16a' 2
    Mk 's16b' (Phase s16b prototip A0 "| 1 | prototip | A0 | Brief | docs/BRIEF.md | ACIK |" "| E-A0 | prototip | A0 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "proje: s16b | tur: ? | kitle: ? | profil: ?") $tOk | Out-Null; T '16b ? A0 kabul' 's16b' 0
    Mk 's17' (Phase s17 prototip A1 $kr $gOk "proje: baska | tur: oyun | kitle: genc | profil: web") $tOk | Out-Null; T '17 yanlis proje' 's17' 2
    Mk 's18' (Phase s18 prototip A1 $kr $gOk "" "hat: prototip | mod: hafif | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '18 prototip + mod hafif' 's18' 2
    Mk 's19a' ((Phase s19a prototip A1 $kr $gOk) + "`n## Kapi kayitlari`n") $tOk | Out-Null; T '19a cift bolum basligi' 's19a' 2
    Mk 's20' (Phase s20 prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | BEKLIYOR | - |`n") | Out-Null; T '20 tanimsiz Durum' 's20' 2
    Mk 's21' (Phase s21 urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" "| E-A1 | urun | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "hat: urun | mod: hafif | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '21 urun + mod hafif' 's21' 0
    # CRLF + BOM toleransi
    $p = Mk 's22' (Phase s22 prototip A1 $kr $gOk) $tOk
    [IO.File]::WriteAllText("$p\state\PHASE.md", ((Phase s22 prototip A1 $kr $gOk) -replace "`n", "`r`n"), (New-Object Text.UTF8Encoding $true)); T '22 CRLF+BOM' 's22' 0
    # --- tur 3 ---
    $row = "| 1 | x | coder | sonnet | DONE | reports/r1.md |"
    Mk 's23a' (Phase s23a prototip A1 $kr $gOk) ($tasksHdr + "$row`n`n| 2 | y | coder | sonnet | RUNNING | - |`n") | Out-Null; T '23a DONE + bos + RUNNING' 's23a' 1
    Mk 's23b' (Phase s23b prototip A1 $kr $gOk) ($tasksHdr + "$row`n`n| 2 | y | coder | sonnet | DONE | reports/r1.md |`n`n") | Out-Null; T '23b bos satirli hepsi DONE' 's23b' 0
    Mk 's23c' (Phase s23c prototip A1 $kr $gOk) ($tOk + "`n## Arsiv`n| 9 | z | coder | sonnet | DONE | - |`n") | Out-Null; T '23c basliksiz yetim | satiri' 's23c' 2
    Mk 's23d' (Phase s23d urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" "| E-A1 | urun | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "hat: urun | mod: - | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '23d urun + mod -' 's23d' 2
    Mk 's23e' (Phase s23e urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" "| E-A1 | urun | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "hat: urun | mod: orta | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '23e urun + orta' 's23e' 0
    # gercek sablon kopyasi (yorum, bosluk, Arsiv bolumu) + veri satiri
    $tpl = Join-Path (Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Gate))) '.claude\skills\project-lifecycle\templates\TASKS.md'
    if (Test-Path -LiteralPath $tpl) {
        $tt = (Get-Content -LiteralPath $tpl -Encoding utf8 -Raw)
        $sep = "|---|---|---|---|---|---|"
        Mk 's24a' (Phase s24a prototip A1 $kr $gOk) ($tt.Replace($sep, "$sep`n$row")) | Out-Null; T '24a sablon + DONE satiri' 's24a' 0
        Mk 's24b' (Phase s24b prototip A1 $kr $gOk) ($tt.Replace($sep, "$sep`n| 1 | x | coder | sonnet | RUNNING | - |")) | Out-Null; T '24b sablon + RUNNING' 's24b' 1
        Mk 's24c' (Phase s24c prototip A1 $kr $gOk) $tt | Out-Null; T '24c bos sablon' 's24c' 0
    }
    # --- tur 4: kapi-asama tutarliligi, P/A6 VERIFICATION, gorsel onay ---
    $krP6 = "| 1 | prototip | A6 | V | docs/BRIEF.md | ACIK |"
    $gP6 = "| E-A6 | prototip | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    $gT6 = "| T-A6 | prototip | A6 | tester | PASS | reports/r1.md | 2026-11-10 |"
    $gPP6 = "| P-A6 | prototip | A6 | playtester | GECER | reports/r1.md | 2026-11-10 |"
    $gl = "kullanici: gorsel onay; -"
    $p = Mk 's25a' (Phase s25a prototip A6 $krP6 "$gP6`n$gT6`n$gPP6") $tOk; Remove-Item "$p\docs\VERIFICATION.md"
    T '25a P/A6 VERIFICATION yok, SkipUserGates' 's25a' 0 @('-SkipUserGates')
    Mk 's25b' (Phase s25b prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | $gl | 2026-11-10 |") $tOk | Out-Null; T '25b K3 TERFI + gorsel onay' 's25b' 0
    Mk 's25c' (Phase s25c prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | - | 2026-11-10 |") $tOk | Out-Null; T '25c K3 TERFI gorsel onaysiz' 's25c' 1 @() 'Kapi gecmedi'
    Mk 's25d' (Phase s25d prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | YINELE | - | 2026-11-10 |") $tOk | Out-Null; T '25d K3 YINELE: gorsel onay hatasi yok (kapi gecmedi -> 1)' 's25d' 1 @() 'gorsel onay'
    Mk 's25e' (Phase s25e prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | YINELE | - | 2026-11-10 |") $tOk | Out-Null; T '25e K3 YINELE + SkipUserGates' 's25e' 0 @('-SkipUserGates')
    Mk 's25f' (Phase s25f prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | - | 2026-11-10 |") $tOk | Out-Null; T '25f K3 TERFI gorselsiz + SkipUserGates' 's25f' 0 @('-SkipUserGates')
    Mk 's25g' (Phase s25g prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay | 2026-11-10 |") $tOk | Out-Null; T '25g gorsel onay (; yok) kabul' 's25g' 0
    Mk 's25h' (Phase s25h prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onayi | 2026-11-10 |") $tOk | Out-Null; T '25h gorsel onayi (desen disi)' 's25h' 1
    Mk 's25i' (Phase s25i prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | ISTISNA | kullanici: zaman | 2026-11-10 |") $tOk | Out-Null; T '25i K3 ISTISNA gorselsiz' 's25i' 1
    Mk 's26a' (Phase s26a prototip A1 $kr "$gOk`n| K3 | prototip | A4 | kullanici | TERFI | $gl | 2026-11-10 |") $tOk | Out-Null; T '26a K3 prototip A4' 's26a' 2
    Mk 's26b' (Phase s26b prototip A1 $kr "$gOk`n| E-A3 | urun | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '26b E-A3 urun A4' 's26b' 2
    $kr4 = "| 1 | urun | A4 | S | docs/BRIEF.md | ACIK |"
    $h4 = "hat: urun | mod: orta | asama: A4 | durum: CALISIYOR"
    $gE4 = "| E-A4 | urun | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's26c' (Phase s26c urun A4 $kr4 "$gE4`n| K3 | urun | A4 | kullanici | DEVAM | $gl | 2026-11-10 |" "" $h4) $tOk | Out-Null; T '26c K3 urun A4 DEVAM + gorsel onay' 's26c' 0
    Mk 's26d' (Phase s26d urun A4 $kr4 "$gE4`n| K3 | urun | A4 | kullanici | DEVAM | - | 2026-11-10 |" "" $h4) $tOk | Out-Null; T '26d K3 urun A4 DEVAM gorselsiz' 's26d' 1
    $kr6b = "| 1 | urun | A6 | V | docs/BRIEF.md | ACIK |"
    $gE6 = "| E-A6 | urun | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's27a' (Phase s27a urun A6 $kr6b "$gE6`n| K4 | urun | A6 | kullanici | YAYINLA | - | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27a K4 YAYINLA gorselsiz' 's27a' 1
    Mk 's27b' (Phase s27b urun A6 $kr6b "$gE6`n| K4 | urun | A6 | kullanici | YAYINLA | $gl | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27b K4 YAYINLA + gorsel onay' 's27b' 0
    Mk 's27c' (Phase s27c urun A6 $kr6b "$gE6`n| K4 | urun | A6 | kullanici | ERTELE | - | 2026-11-10 |" "" $h6) $tOk | Out-Null; T '27c K4 ERTELE: gorsel onay hatasi yok' 's27c' 1 @() 'gorsel onay'
    Mk 's27d' (Phase s27d urun A6 $kr6b "$gE6`n| K4 | urun | A6 | kullanici | YAYINLA | - | 2026-11-10 |`n| K4 | urun | A6 | kullanici | YAYINLA | $gl | 2026-11-11 |" "" $h6) $tOk | Out-Null; T '27d K4 son satir gorsel onayli' 's27d' 0
    Mk 's28a' (Phase s28a prototip A1 $kr "$gOk`n| E-A8 | prototip | A8 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28a P hattinda E-A8' 's28a' 2
    Mk 's28b' (Phase s28b prototip A1 $kr "$gOk`n| K4 | prototip | A6 | kullanici | BEKLIYOR | - | 2026-11-10 |") $tOk | Out-Null; T '28b P hattinda K4' 's28b' 2
    Mk 's28c' (Phase s28c prototip A1 $kr "$gOk`n| K2 | prototip | A2 | kullanici | BEKLIYOR | - | 2026-11-10 |") $tOk | Out-Null; T '28c P hattinda K2' 's28c' 2
    Mk 's28d' (Phase s28d prototip A1 $kr "$gOk`n| E-A5 | prototip | A5 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28d P hattinda E-A5' 's28d' 2
    Mk 's28e' (Phase s28e prototip A1 $kr "$gOk`n| T-A5 | prototip | A5 | tester | PASS | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28e P hattinda T-A5' 's28e' 2
    Mk 's28f' (Phase s28f prototip A1 $kr "$gOk`n| E-A2 | prototip | A3 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '28f E-A2 asama A3' 's28f' 2
    Mk 's29a' (Phase s29a prototip A6 $krP6 "$gP6`n| C-YAS | prototip | A6 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '29a C-YAS prototip A6' 's29a' 0
    Mk 's29b' (Phase s29b prototip A1 $kr "$gOk`n| C-YAS | prototip | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '29b C-YAS prototip A4' 's29b' 2
    Mk 's29c' (Phase s29c urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" "| E-A1 | urun | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |`n| C-YAS | urun | A5 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "hat: urun | mod: orta | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '29c C-YAS urun A5' 's29c' 0
    Mk 's29d' (Phase s29d urun A1 "| 1 | urun | A1 | Spec | docs/BRIEF.md | ACIK |" "| E-A1 | urun | A1 | critic | APPROVE | reports/r1.md | 2026-11-10 |`n| C-GUV | urun | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" "hat: urun | mod: orta | asama: A1 | durum: CALISIYOR") $tOk | Out-Null; T '29d C-GUV urun A4' 's29d' 2
    # --- tur 5: (prototip, A8) kapi satiri aranmaz, yalniz Cikis kriterleri ---
    $kr8 = "| 1 | prototip | A8 | Retro | docs/PROTOTYPE_REVIEW.md | ACIK |"
    $h8 = "hat: prototip | mod: - | asama: A8 | durum: CALISIYOR"
    $p = Mk 's30a' (Phase s30a prototip A8 $kr8 "" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; T '30a P/A8 kapi satiri yok, kriter dolu' 's30a' 0
    $p = Mk 's30b' (Phase s30b prototip A8 $kr8 "" "" $h8) $tOk; T '30b P/A8 kriter dosyasi yok' 's30b' 1
    $p = Mk 's30c' (Phase s30c prototip A8 $kr8 "| E-A8 | prototip | A8 | critic | APPROVE | reports/r1.md | 2026-11-10 |" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; T '30c P/A8 + E-A8 satiri' 's30c' 2
    $kr8u = "| 1 | urun | A8 | Retro | docs/BRIEF.md | ACIK |"
    Mk 's30d' (Phase s30d urun A8 $kr8u "" "" "hat: urun | mod: orta | asama: A8 | durum: CALISIYOR") $tOk | Out-Null; T '30d U/A8 kapi satiri yok (istisna yalniz P)' 's30d' 1
    $p = Mk 's30e' (Phase s30e prototip A8 $kr8 "" "" $h8) $tOk; W "$p\docs\PROTOTYPE_REVIEW.md" $five; W "$p\state\TASKS.md" ($tOk + "| 2 | y | coder | sonnet | RUNNING | - |`n"); T '30e P/A8 + acik TASKS' 's30e' 1
    # bilinen sinir:YINELE sonrasi A4'e donulmus, E-A4 son satiri eski APPROVE -> script beklenen kapiyi turetmez, exit 0
    $kr4p = "| 1 | prototip | A4 | S | docs/BRIEF.md | ACIK |"
    $gE4p = "| E-A4 | prototip | A4 | critic | APPROVE | reports/r1.md | 2026-11-10 |"
    Mk 's31' (Phase s31 prototip A4 $kr4p "$gE4p`n| K3 | prototip | A6 | kullanici | YINELE | - | 2026-11-10 |") $tOk | Out-Null; T '31 YINELE sonrasi eski E-A4 APPROVE (belgelenmis sinir)' 's31' 0
    # --- tur 6: rapor yollari proje klasoru icinde olmali ---
    Mk 's32a' (Phase s32a prototip A1 $kr "| E-A1 | prototip | A1 | critic | APPROVE | projects/s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32a projects/<ad>/ onekli yol PASS' 's32a' 0
    Mk 's32b' (Phase s32b prototip A1 $kr "| E-A1 | prototip | A1 | critic | APPROVE | team/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32b kapi: team/reports FAIL' 's32b' 1
    Mk 's32c' (Phase s32c prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | team/reports/r1.md |`n") | Out-Null; T '32c TASKS: team/reports FAIL' 's32c' 1
    Mk 's32d' (Phase s32d prototip A1 $kr "| E-A1 | prototip | A1 | critic | APPROVE | projects/s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32d baska projenin yolu FAIL' 's32d' 1
    Mk 's32e' (Phase s32e prototip A1 $kr "| E-A1 | prototip | A1 | critic | APPROVE | reports/../../s32a/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32e .. ile cikis FAIL' 's32e' 1
    Mk 's32f' (Phase s32f prototip A1 $kr "| E-A1 | prototip | A1 | critic | APPROVE | $S\team\reports\r1.md | 2026-11-10 |") $tOk | Out-Null; T '32f mutlak dis yol FAIL' 's32f' 1
    Mk 's32g' (Phase s32g prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; - | 2026-11-10 |") $tOk | Out-Null; T '32g kullanici: gorsel onay; - gecerli' 's32g' 0
    Mk 's32h' (Phase s32h prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32h K3 gorsel onay; proje ici rapor' 's32h' 0
    Mk 's32i' (Phase s32i prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; team/reports/r1.md | 2026-11-10 |") $tOk | Out-Null; T '32i K3 gorsel onay; merkez rapor FAIL' 's32i' 1
    # --- tur 7: tek kural (';' parcalari, '/' ya da '\' iceren parca = yol, proje klasoru icinde ve var) ---
    function Ge($rap) { "| E-A1 | prototip | A1 | critic | APPROVE | $rap | 2026-11-10 |" }
    Mk 's33a' (Phase s33a prototip A1 $kr (Ge 'projects\s33a\reports\r1.md')) $tOk | Out-Null; T '33a ters egik cizgili proje yolu PASS' 's33a' 0
    Mk 's33b' (Phase s33b prototip A1 $kr (Ge 'docs/BRIEF.md')) $tOk | Out-Null; T '33b docs/ yolu PASS' 's33b' 0
    Mk 's33c' (Phase s33c prototip A1 $kr (Ge 'Projects/S33c/reports/r1.md')) $tOk | Out-Null; T '33c BUYUK harfli Projects/<Ad> PASS' 's33c' 0
    Mk 's33d' (Phase s33d prototip A1 $kr (Ge "$PR\s33d\reports\r1.md")) $tOk | Out-Null; T '33d proje ici mutlak yol PASS' 's33d' 0
    Mk 's33e' (Phase s33e prototip A1 $kr (Ge 'reports/r1.md; tamam')) $tOk | Out-Null; T '33e duz metin parca yol sayilmaz PASS' 's33e' 0
    Mk 's33f' (Phase s33f prototip A1 $kr (Ge 'projects/s33f/../s32a/reports/r1.md')) $tOk | Out-Null; T '33f .. ile proje disina cikis FAIL' 's33f' 1
    Mk 's33g' (Phase s33g prototip A1 $kr (Ge 'reports/yok.md')) $tOk | Out-Null; T '33g var olmayan dosya FAIL' 's33g' 1
    Mk 's33h' (Phase s33h prototip A1 $kr (Ge 'reports/<yol>.md')) $tOk | Out-Null; T '33h gecersiz karakter: FAIL, SONUC satiri var' 's33h' 1
    Mk 's33i' (Phase s33i prototip A1 $kr (Ge 'reports/r1.md; kullanici-notu team/reports/r1.md')) $tOk | Out-Null; T '33i kullanici- (iki noktasiz) parca yol sayilir FAIL' 's33i' 1
    Mk 's33j' (Phase s33j prototip A1 $kr (Ge 'reports/r1.md; reports/yok.md')) $tOk | Out-Null; T '33j iki yoldan biri kotu FAIL' 's33j' 1
    Mk 's33k' (Phase s33k prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; tamam | 2026-11-10 |") $tOk | Out-Null; T '33k K3 duz metin parca PASS' 's33k' 0
    Mk 's33l' (Phase s33l prototip A6 $krP6 "$gP6`n| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; reports/yok.md | 2026-11-10 |") $tOk | Out-Null; T '33l K3 var olmayan yol FAIL' 's33l' 1
    Mk 's33m' (Phase s33m prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/<yol>.md |`n") | Out-Null; T '33m TASKS gecersiz karakter FAIL' 's33m' 1
    # --- tur 8: tek bolme kurali (';' ya da ','), TASKS ayni yardimci; docs/kaynak/ 0 bayttan buyuk ---
    Mk 's34a' (Phase s34a prototip A1 $kr (Ge 'reports/r1.md; docs/BRIEF.md')) $tOk | Out-Null; T '34a kapi a; b PASS' 's34a' 0
    Mk 's34b' (Phase s34b prototip A1 $kr (Ge 'reports/r1.md, docs/BRIEF.md')) $tOk | Out-Null; T '34b kapi a, b PASS' 's34b' 0
    Mk 's34c' (Phase s34c prototip A1 $kr (Ge 'reports/r1.md, reports/yok.md')) $tOk | Out-Null; T '34c kapi a, b: biri yok FAIL' 's34c' 1
    Mk 's34d' (Phase s34d prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md; docs/BRIEF.md |`n") | Out-Null; T '34d TASKS DONE a; b PASS' 's34d' 0
    Mk 's34e' (Phase s34e prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md, docs/BRIEF.md |`n") | Out-Null; T '34e TASKS DONE a, b PASS' 's34e' 0
    Mk 's34f' (Phase s34f prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | tamam |`n") | Out-Null; T '34f TASKS DONE yalniz duz metin FAIL (raporsuz DONE)' 's34f' 1
    Mk 's34g' (Phase s34g prototip A1 $kr $gOk) ($tasksHdr + "| 1 | x | coder | sonnet | DONE | reports/r1.md tamam |`n") | Out-Null; T '34g TASKS bosluk bolme yok: tek parca yol, dosya yok FAIL' 's34g' 1
    $krK = "| 1 | prototip | A1 | Kaynak | docs/kaynak/k.txt | ACIK |"
    $p = Mk 's34h' (Phase s34h prototip A1 $krK $gOk) $tOk; W "$p\docs\kaynak\k.txt" "tek satir"; T '34h docs/kaynak 1 satir PASS' 's34h' 0
    $p = Mk 's34i' (Phase s34i prototip A1 $krK $gOk) $tOk; New-Item -ItemType Directory -Force "$p\docs\kaynak" | Out-Null; [IO.File]::WriteAllBytes("$p\docs\kaynak\k.txt", [byte[]]@()); T '34i docs/kaynak 0 bayt FAIL' 's34i' 1
    # ciktinin ilk satiri ve <=10 satir her T cagrisinda denetlenir
    "GECEN/TOPLAM: $($script:pass)/$($script:total)"
} finally {
    if ($S -like "$env:TEMP\aat-gate-*") { Remove-Item -LiteralPath $S -Recurse -Force }
}
if ($script:pass -eq $script:total) { exit 0 } else { exit 1 }

# A7 Yayın

## Amaç
K4 YAYINLA sonrası yayın adayını paketlemek, vX.Y.Z etiketlemek, belgelemek ve temiz klondan tek komutla çalıştığını kanıtlamak. Dışarıya yükleme / push YOK; kullanıcı yapar.

## Girdiler
projects/<ad>/ altında: K4 kaydı (YAYINLA), docs/VERIFICATION.md (geri alma bölümü dahil), docs/BACKLOG.md (bilinen sorunlar), SPEC, run.ps1; profil `.claude/skills/project-lifecycle/profiles/<profil>.md` "Yayın paketi". Sürüm: ilk yayın v1.0.0, sonrakiler SemVer.

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Skill'i ajan `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`'den Read ile okur. Prompt'lar aşağıdaki tek blokta, sırayla:
1. **[paralel]** writer (İçerik; skill shipping-and-launch, documentation-and-adrs) belgeleri yazar; coder (Kod; shipping-and-launch) yerel paketi hazırlar. Dosyalar ayrıdır.
2. **critic** (sonnet; parça; danışma, kapı kaydı yok): belgeler ↔ VERIFICATION tutarlılığı ve yayin-oncesi.md'nin A7 maddeleri (README / CHANGELOG / RELEASE / etiket). REVISE: 2 tur → 3. tur opus critic + üretici bir üst model → BLOKE.
3. **coder** sürüm checkpoint'i vX.Y.Z (skill git-workflow-and-versioning). Aşama çıkış etiketi `u-asama-A7` sonradan, ayrı checkpoint (Kapı bölümü).
4. **tester** temiz klon testi (T-A7); FAIL → eksik coder/writer'a, gerekirse yeni patch sürümü, tester yeniden koşar.
```
Rol: writer | Proje: <ad> | Aşama: A7 | Parça #<n>: README + CHANGELOG + RELEASE | Konu: a7-belgeler | Kapı: yok
Kabul kriteri: README: ne, önkoşullar, tek komut kurulum (run.ps1 -Build -Up), durdurma, adres, sorun giderme; CHANGELOG: vX.Y.Z tarihli giriş; RELEASE (orta/tam): kapsam, doğrulama özeti, ≤3 bilinen sorun, geri alma | Dosyalar: README.md, CHANGELOG.md, docs/RELEASE.md (hafif: RELEASE yok, bilinen sorunlar README'de) | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yayin-oncesi.md | Oku: <PL>/templates/RELEASE.md, <PL>/profiles/<profil>.md (Yayın paketi)
Rol: coder | Proje: <ad> | Aşama: A7 | Parça #<n>: yerel paket | Konu: a7-paket | Kapı: yok
Kabul kriteri: profildeki "Yayın paketi" gereği paket yerelde üretilir; hata ayıklama kancaları kapalı, gizli bilgi / geliştirme artığı yok | Dosyalar: run.ps1, paket çıktısı (profilde belirtilen) | Doğrulama komutu: run.ps1 -Build | Kontrol listesi: <PL>/checklists/yayin-oncesi.md
Rol: critic | Proje: <ad> | Aşama: A7 | Parça #<n>: yayın belgeleri incelemesi | Konu: a7-critic | Kapı: yok
Kabul kriteri: yayin-oncesi.md A7 maddelerinde ENGEL yok; APPROVE/REVISE + 3 madde | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yayin-oncesi.md
Rol: coder | Proje: <ad> | Aşama: A7 | Parça #<n>: sürüm etiketi | Konu: a7-etiket | Kapı: yok
Kabul kriteri: exit 0, etiket vX.Y.Z (yayın commit'i), push YOK | Dosyalar: yok | Kontrol listesi: yok
Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A7: vX.Y.Z" -Tag vX.Y.Z
Rol: tester | Proje: <ad> | Aşama: A7 | Parça #<n>: temiz klon testi | Konu: a7-temiz-klon | Kapı: T-A7
Kabul kriteri: projects/<ad> boş geçici klasöre yerel klonlanır; yalnız README'deki komutla (run.ps1 -Build -Up, eski imaj tuzağı) kurulur, adres 200 verir; -Test -Check -E2E exit 0; PASS/FAIL, çıktı aynen | Dosyalar: yok (geçici klon sonda silinir) | Doğrulama komutu: git clone + run.ps1 -Build -Up; run.ps1 -Test -Check -E2E | Kontrol listesi: <PL>/checklists/yayin-oncesi.md
```

## Mod farkları
Matris: SKILL.md. P hattı A7'yi ATLAR. Ü/hafif: README + kısa CHANGELOG + etiket; RELEASE.md yok (kurulum ve bilinen sorunlar README'de), adım 2 tek tur (atlanmaz). Ü/orta: tüm adımlar, RELEASE'te geri alma. Ü/tam: orta + geri alma planı ayrıntılı (VERIFICATION "Geri alma" ile tutarlı).

## Çıkış kriterleri
PHASE Cikis kriterleri (Hat=urun, Asama=A7):
| Kriter | Yol |
|---|---|
| README | README.md |
| CHANGELOG | CHANGELOG.md |
| RELEASE (yalnız orta/tam) | docs/RELEASE.md |
| T-A7 temiz klon testi | - |

## Kapı
BEKLIYOR yaz: yalnız T-A7 (kullanıcı kapısı yok → -SkipUserGates yok). Sonuç işlenince tester'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` (çıktı aynen). PASS → ÖNCE state (PHASE, Asama gecmisi Etiket = u-asama-A7, PROJECTS, proje HANDOFF, TASKS arşivi), SONRA coder'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A7: yayin" -Tag u-asama-A7`; sonra A8. Olumsuz: FAIL → adım 4'teki düzeltme, `CALISIYOR` (2 tur → 3. tur opus critic + üretici bir üst model → BLOKE; ayrıntı: gates.md Tıkanma). Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz). Kullanıcıya bildir: dışarıya yükleme ve push kendisinde.

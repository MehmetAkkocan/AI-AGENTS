# A5 Üretim

## Amaç
Ü hattında ürünü dilim dilim (özellik + içerik) üretmek; her dilim critic + tester (E2E dahil) + checkpoint'ten geçer. P hattı A5'e girmez.

## Girdiler
projects/<ad>/ altında: docs/SPEC.md, tasarım belgeleri (GDD / LEARNING_DESIGN ya da DESIGN, UX, ART_AUDIO), ARCHITECTURE.md, contracts/, TEST_PLAN.md, A4 dilimi + onaylı altın örnek, CLAUDE.md, run.ps1; PHASE kosullu:.

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan global skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`'den Read ile okur. TASKS tek tablo; dilim satırları `#` = `D<k>-<n>`. Dilim döngüsü 1→7 (planner yalnız SIRADAKİ dilimi planlar):
1. **planner** (Planlama; skill planning-and-task-breakdown, incremental-implementation)
```
Rol: planner | Proje: <ad> | Aşama: A5 | Parça #<n>: dilim <k> planı | Konu: a5-plan-d<k> | Kapı: yok
Kabul kriteri: yalnız dilim <k>; TASKS tablosunun SONUNA 6 sütunlu satırlar (# = D<k>-<n>, PENDING; Gorev: tanım; Kabul; Dosyalar; Dogrulama); stub/kablo parçası, çakışmasız paralel gruplar, dilim sonu tester + coder checkpoint | Dosyalar: projects/<ad>/state/TASKS.md | Doğrulama komutu: yok | Kontrol listesi: yok
```
2. **coder** (Kod; skill incremental-implementation, test-driven-development) — paylaşılan modüle dokunan paralel gruptan ÖNCE stub/kablo. Yeni içerik türünde çoklu writer'dan önce 1 altın örnek onaylanır (A4'te onaylıysa gerekmez).
```
Rol: coder | Proje: <ad> | Aşama: A5 | Parça #<n>: stub/kablo D<k> | Konu: a5-stub-d<k> | Kapı: yok
Kabul kriteri: arayüzler contracts/ ile uyumlu, boş içerikle yeşil | Dosyalar: <TASKS'taki liste> | Doğrulama komutu: run.ps1 -Build -Test -Check | Kontrol listesi: yok
```
3. **[paralel]** coder'lar + writer'lar, ayrı dosyalar. Görsel/ses coder'ca docs/ART_AUDIO.md'den (Ü/hafif: DESIGN.md) kodla (SVG/CSS/sentez) üretilir; Gemini yalnız plan modunda öneri.
```
Rol: writer | Proje: <ad> | Aşama: A5 | Parça #<n>: içerik <birim> | Konu: a5-icerik-<birim> | Kapı: yok
Kabul kriteri: docs/contracts/CONTENT_SCHEMA.md + altın örneğe uyar; bitirmeden run.ps1 -Check yeşil | Dosyalar: <yalnız bu birimin dosyaları> | Doğrulama komutu: run.ps1 -Check | Kontrol listesi: <PL>/checklists/icerik-kalitesi.md
Rol: coder | Proje: <ad> | Aşama: A5 | Parça #<n>: özellik <F-xx> | Konu: a5-kod-<f-xx> | Kapı: yok
Kabul kriteri: SPEC F-xx kabul ölçütleri + testler; görsel/ses ART_AUDIO'dan | Dosyalar: <TASKS'taki liste> | Doğrulama komutu: run.ps1 -Test | Kontrol listesi: yok
```
Adım 4-9 (aşağıdaki tek blokta, parça sırasıyla):
4. **critic** (sonnet; parça) her parça için (kod: code-review-and-quality; içerik: icerik-kalitesi.md). REVISE: 2 tur → 3. tur opus critic + üretici bir üst model → BLOKE.
5. **learning-designer** içerik örneklem incelemesi (Oyun/öğrenme tasarımı; örneklem: en az 5 birim ya da %20, hangisi büyükse; toplam 5'ten azsa tümü; komut koşmaz).
6. **tester** dilim sonu (Test koşma, zorunlu); FAIL → coder'a düzeltme parçası.
7. **coder** checkpoint (etiketsiz; skill git-workflow-and-versioning), onaylı dilimden sonra tek parça.
8. Yalnız tam: her 3 dilimde ve son dilimden sonra **playtester** (Playtest, P-A5). Öncesinde kullanıcıdan Browser panelini görünür tutmasını iste.
9. Son dilimden sonra: writer BACKLOG'u derler (KUCUK + gerekçeli BUYUK), critic (opus; kapı) E-A5 (+ C-YAS), tester T-A5.
```
Rol: critic | Proje: <ad> | Aşama: A5 | Parça #<n>: D<k>-<n> incelemesi | Konu: a5-critic-d<k>-<n> | Kapı: yok
Kabul kriteri: TASKS satırındaki Kabul karşılanmış; APPROVE/REVISE + 3 madde | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/icerik-kalitesi.md (içerik) | Oku: parça raporu
Rol: learning-designer | Proje: <ad> | Aşama: A5 | Parça #<n>: örneklem incelemesi D<k> | Konu: a5-icerik-inceleme-d<k> | Kapı: yok
Kabul kriteri: LH hedefleriyle hiza + yaşa uygunluk; bulgular ENGEL/BUYUK/KUCUK | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yas-uygun-icerik.md (kitle cocuk/genc), icerik-kalitesi.md
Rol: tester | Proje: <ad> | Aşama: A5 | Parça #<n>: dilim <k> testi | Konu: a5-test-d<k> | Kapı: yok
Kabul kriteri: üç komut exit 0 (çıktı aynen rapora) | Dosyalar: yok | Doğrulama komutu: run.ps1 -Test -Check -E2E | Kontrol listesi: yok
Rol: coder | Proje: <ad> | Aşama: A5 | Parça #<n>: dilim <k> checkpoint | Konu: a5-checkpoint-d<k> | Kapı: yok
Kabul kriteri: exit 0, etiket yok | Dosyalar: yok | Kontrol listesi: yok | Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A5: dilim <k>"
Rol: playtester | Proje: <ad> | Aşama: A5 | Parça #<n>: playtest dilim <k> | Konu: a5-playtest-d<k> | Kapı: P-A5 | Oturum: kapat
Kabul kriteri: persona × görev matrisi; SONUC/YONTEM/GORSEL (KONTROL EDILDI yalnız ekranı gerçekten gördüyse) | Dosyalar: yok | Doğrulama komutu: run.ps1 -Up (çalışmıyorsa), bitince yalnız kendi başlattığına -Down | Kontrol listesi: yok | Oku: <PL>/templates/PLAYTEST_REPORT.md
Rol: writer | Proje: <ad> | Aşama: A5 | Parça #<n>: BACKLOG | Konu: a5-backlog | Kapı: yok
Kabul kriteri: aşama raporlarındaki KUCUK/ertelenen BUYUK maddeler, kimlikli | Dosyalar: docs/BACKLOG.md | Doğrulama komutu: yok | Kontrol listesi: yok
Rol: critic | Proje: <ad> | Aşama: A5 | Parça #<n>: aşama sonu | Konu: a5-e-a5 | Kapı: E-A5 (C-YAS tetikliyse ayrı çağrı: Kapı: C-YAS, Kontrol listesi: <PL>/checklists/yas-uygun-icerik.md)
Kabul kriteri: tüm dilimler DONE + raporlu, SPEC F-xx karşılanmış; APPROVE/REVISE | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/icerik-kalitesi.md
Rol: tester | Proje: <ad> | Aşama: A5 | Parça #<n>: aşama sonu testi | Konu: a5-t-a5 | Kapı: T-A5
Kabul kriteri: exit 0 (PASS/FAIL) | Dosyalar: yok | Doğrulama komutu: run.ps1 -Build -Test -Check -E2E | Kontrol listesi: yok
```

## Mod farkları
Matris: SKILL.md. P hattı A5'i ATLAR. Ü/hafif: 1-3 dilim, adım 5 yalnız içerik/C-YAS varsa. Ü/orta: içerik hattı (adım 3 paralel writer'lar, adım 5 zorunlu). Ü/tam: + adım 8 (P-A5; birden çok tur varsa en kötü sonuç).

## Çıkış kriterleri
PHASE Cikis kriterleri (Hat=urun, Asama=A5):
| Kriter | Yol |
|---|---|
| Üretim backlog'u | docs/BACKLOG.md |
| E-A5 aşama sonu critic | - |
| T-A5 aşama sonu tester (E2E dahil) | - |
| C-YAS (yalnız kitle cocuk/genc) | - |
| P-A5 (yalnız tam; son dilimden sonra) | - |

## Kapı
BEKLIYOR yaz (hat=urun): E-A5, T-A5, C-YAS (kosullu'da varsa), P-A5 (yalnız tam). Kullanıcı kapısı YOK → -SkipUserGates yok; sonuçları işleyince tester'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` (çıktı aynen). Dilim kapıları yalnız TASKS'ta. Olumsuz: REVISE/FAIL → parçayı geri aç (parça: 2 tur → 3. tur opus critic + üretici bir üst model → BLOKE; kapı critic'i: 2 tur → BLOKE, terfi yok; tek soru, gates.md Tıkanma), `CALISIYOR`; düzeltmeden sonra kapıyı yeniden koştur. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz). PASS → SKILL.md geçiş adım 7 (önce state, sonra checkpoint u-asama-A5); sonraki A6.

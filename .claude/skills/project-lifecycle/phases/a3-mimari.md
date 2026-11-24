# A3 Mimari, sözleşme, iskelet

## Amaç
Paralel üretimi güvenli kılan sözleşmeleri yaz (sözleşme önce) ve boş içerikle yeşil çalışan bir iskelet kur: `run.ps1` + `-Check` + E2E smoke.

## Girdiler
`docs/SPEC.md` (P: BRIEF), tasarım belgeleri (GDD / LEARNING_DESIGN / UX / DESIGN), `docs/CONSTRAINTS.md`, profil `<PL>/profiles/<profil>.md`, PHASE `kosullu:`. Proje klasörü `/proje yeni` ile kurulmuştur. Terfi: `docs/PROTOTYPE_REVIEW.md` (ADR-000 önerisi).

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md` yolundan Read ile okur.
1. **learning-designer** (opus) — yalnız içerik şeması olan projede, şemadan ÖNCE (dosya yazmaz, komut koşmaz):
```
Rol: learning-designer | Proje: <ad> | Aşama: A3 | Kapı: yok | Parça #<n>: şemaya pedagojik girdi
Oku: docs/LEARNING_DESIGN.md (ya da DESIGN.md), <PL>/templates/CONTENT_SCHEMA.md | Kabul kriteri: içerik birimi alanları (LH-NN hedefi, önkoşul, ipucu kademesi, ölçme, yaş dili) listeli
Dosyalar: yalnız rapor | Konu: a3-sema-girdi | Doğrulama komutu: yok | Kontrol listesi: yok
```
2. **planner** (opus) — sözleşmeler önce, kod yazılmadan (skill: api-and-interface-design, documentation-and-adrs). Terfi edilmiş projede ADR-000'ı da yazar:
```
Rol: planner | Proje: <ad> | Aşama: A3 | Kapı: yok | Parça #<n>: ARCHITECTURE + sözleşmeler + proje kartı
Oku: <PL>/templates/ARCHITECTURE.md, CONTENT_SCHEMA.md, PROJECT_CLAUDE.md, <PL>/profiles/<profil>.md, docs/SPEC.md (P: BRIEF.md), adım 1 raporu [terfi: + ADR.md, PROTOTYPE_REVIEW.md]
Kabul kriteri: modül sınırları, paylaşılan modüller; içerik şeması + `run.ps1 -Check` doğrulama tanımı; API.md (API varsa); C-GUV tetikliyse tehdit modeli bölümü; tam/C-PERF: performans bütçesi; CLAUDE.md ≤25 satır; terfi: ADR-000 koru/yeniden yaz kararı
Dosyalar: projects/<ad>/docs/ARCHITECTURE.md, docs/contracts/CONTENT_SCHEMA.md, docs/contracts/API.md, CLAUDE.md [terfi: docs/adr/000-prototip-kodu.md] | Konu: a3-mimari | Doğrulama komutu: yok | Kontrol listesi: yok
```
3. **planner** — yalnız Ü/orta-tam, adım 2'den sonra (**4 ile paralel**):
```
Rol: planner | Proje: <ad> | Aşama: A3 | Kapı: yok | Parça #<n>: TEST_PLAN + ADR
Oku: <PL>/templates/TEST_PLAN.md, <PL>/templates/ADR.md, docs/ARCHITECTURE.md, docs/SPEC.md | Kabul kriteri: her F-NN için test eşlemesi (birim / içerik doğrulama / E2E) ve `run.ps1` anahtarı; en az bir ADR (teknoloji seçimi)
Dosyalar: projects/<ad>/docs/TEST_PLAN.md, docs/adr/001-mimari-secimler.md | Konu: a3-testplan | Doğrulama komutu: yok | Kontrol listesi: yok
```
4. **coder** (sonnet) — iskelet + stub/kablo (paylaşılan modüllere tek coder; skill: git-workflow-and-versioning; commit atmaz):
```
Rol: coder | Proje: <ad> | Aşama: A3 | Kapı: yok | Parça #<n>: yürüyen iskelet + stub/kablo
Oku: docs/ARCHITECTURE.md, docs/contracts/*, <PL>/profiles/<profil>.md [terfi: + docs/adr/000-prototip-kodu.md; KORU modülleri korunur, "boş ürün" = içeriksiz]
Kabul kriteri: `run.ps1` -Build -Up -Down -Test -Check -E2E -Logs çalışır (başarı exit 0); -Check boş içerikle geçer; -E2E boş üründe smoke; paylaşılan modüller stub/kablo; tur oyun / +oyun: `?debug=1&seed=N` + `window.__game.getState()` (yalnız debug'da; masaustu-motor.md Test kancaları); profil mobil: isteğe bağlı `-Lan` anahtarı (varsayılan kapalı; mobil.md "Cihazda test")
Dosyalar: projects/<ad>/run.ps1, kaynak, testler | Konu: a3-iskelet | Kontrol listesi: yok
Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<ad>/run.ps1 -Build; sonra -Check, -Test, -E2E
```
5. **tester** (haiku) — T-A3, boş ürünle (C-PERF tetikliyse performans bütçesi ölçümünü de koşar):
```
Rol: tester | Proje: <ad> | Aşama: A3 | Kapı: T-A3 | Parça #<n>: boş ürün yeşil mi
Kabul kriteri: -Build, -Up, -Test, -Check, -E2E, -Down her biri PASS (docs/TEST_PLAN.md varsa ona göre); çıktı aynen aktarılır
Dosyalar: yalnız rapor | Konu: a3-t-a3 | Kontrol listesi: yok
Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<ad>/run.ps1 <anahtar> (sırayla)
```
6. **critic** (opus; kapı) — E-A3 ve tetiklenen C-GUV (skill security-and-hardening; tehdit modeli), C-PERF (T-A3 ölçümünden sonra); ayrı parçalar:
```
Rol: critic | Proje: <ad> | Aşama: A3 | Kapı: <E-A3|C-GUV|C-PERF> | Parça #<n>: <mimari | güvenlik | performans> denetimi
Oku: docs/ARCHITECTURE.md, docs/contracts/*, adım 5 raporu · Kontrol listesi: <PL>/checklists/guvenlik-sertlestirme.md (yalnız C-GUV)
Kabul kriteri: E-A3: sözleşmeler SPEC/tasarımla tutarlı, her F-NN modüle bağlı; oyunsa test kancası var ve yalnız `?debug=1`'de; terfide ADR-000 kararı kesinleşti · C-GUV: ENGEL maddeler sağlandı + tehdit modeli var · C-PERF: tester ölçümü performans bütçesi içinde; APPROVE/REVISE + 3 madde
Dosyalar: yalnız rapor | Konu: a3-<e-a3|c-guv|c-perf> | Doğrulama komutu: yok
```

## Mod farkları
- P: yürüyen iskelet; adım 3 ve ADR yok; ARCHITECTURE kısa, sözleşme yalnız içerik varsa; C-GUV yalnız kullanıcı girdisi çalıştırma/hesap/ağ varsa.
- Ü/hafif: kısa ARCHITECTURE + sözleşme; 3 atlanır. Ü/orta: 1-6 tam. Ü/tam: + tehdit modeli, performans bütçesi, C-PERF.

## Çıkış kriterleri
| Kriter | Yol |
|---|---|
| Mimari (+ sözleşme bölümü) | docs/ARCHITECTURE.md |
| İçerik şeması (içerikli proje) | docs/contracts/CONTENT_SCHEMA.md |
| Ü/orta-tam: test planı | docs/TEST_PLAN.md |
| Ü/orta-tam: ADR | docs/adr/001-mimari-secimler.md |
| Terfi: prototip kodu kararı | docs/adr/000-prototip-kodu.md |
| Proje kartı | CLAUDE.md |
| Çalışan iskelet | run.ps1 |
| E-A3 APPROVE, T-A3 PASS, tetiklenen C-* APPROVE | - |

## Kapı
BEKLIYOR: `E-A3` (critic), `T-A3` (tester), tetiklenen `C-GUV`, `C-PERF` (kullanıcı kapısı yok). Sıra: ajan kapıları → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` → PASS ise önce PHASE/PROJECTS/proje HANDOFF/TASKS arşivi, SONRA coder `team/scripts/checkpoint.ps1 -Project <ad> -Message "A3: ..." -Tag <p|u>-asama-A3` (SKILL.md geçiş adım 7). T-A3 FAIL ya da REVISE: `CALISIYOR`, eksik parça açılır (≤2 tur). Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz).

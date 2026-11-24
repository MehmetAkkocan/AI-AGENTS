# A4 Dikey dilim

## Amaç
Tüm katmanlardan (arayüz, mantık, içerik, test) geçen TEK uçtan uca dilimi çalıştır; altın örnek içeriği onayla. Ü: playtester turu 1 ve (doğrudan girişte) K3 ile değerlendir. P: yalnız dilim; playtest, K3 önerisi, PROTOTYPE_REVIEW ve K3 A6'dadır (`a6-dogrulama-p.md`).

## Girdiler
İskelet ve `run.ps1` (A3 yeşil), `docs/ARCHITECTURE.md`, sözleşmeler, tasarım belgeleri, `docs/SPEC.md` (P: BRIEF), profil `<PL>/profiles/<profil>.md`.

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md` yolundan Read ile okur. `<TASARIM>` = P: BRIEF.md · Ü/hafif: DESIGN.md · Ü/orta-tam: UX.md + ART_AUDIO.md.
1. **planner** (opus) — dilim planı: dilimi SPEC'ten seç (her katmandan ≥1 parça); TASKS'ın TEK tablosuna satır ekle (tablo açma):
```
Rol: planner | Proje: <ad> | Aşama: A4 | Kapı: yok | Parça #<n>: dilim planı | Oku: docs/SPEC.md (P: BRIEF.md), docs/ARCHITECTURE.md, docs/TEST_PLAN.md (varsa)
Kabul kriteri: satırlar `Gorev` = `<tanım>; Kabul: <ölçüt>; Dosyalar: <yollar>; Dogrulama: <komut>`; altın örnek ve stub/kablo kuralları işlenmiş | Dosyalar: projects/<ad>/state/TASKS.md (yalnız ilk satırlar) | Konu: a4-dilim-plani | Doğrulama komutu: yok | Kontrol listesi: yok
```
2. **coder** (sonnet) ve **writer** (sonnet; altın örnek, yalnız içerikli proje, çoklu writer'dan önce TEK örnek) **paralel** (farklı dosyalar). Skill (coder): incremental-implementation, test-driven-development; writer bitirmeden `run.ps1 -Check` koşar:
```
Rol: coder | Proje: <ad> | Aşama: A4 | Kapı: yok | Parça #<n>: dikey dilim <ad>
Oku: docs/ARCHITECTURE.md, <TASARIM> (ART_AUDIO yalnız Ü/orta-tam); görsel/ses SVG/CSS/sentez ile; stub'ları gerçeğe çevir | Kabul kriteri: dilim `run.ps1 -Up` ile baştan sona çalışır; testler önce yazıldı; sözleşmeye uyar; commit atma
Dosyalar: <ARCHITECTURE'a göre kaynak/test> | Konu: a4-dilim | Doğrulama komutu: run.ps1 -Build, -Test, -Check, -E2E | Kontrol listesi: yok
```
```
Rol: writer | Proje: <ad> | Aşama: A4 | Kapı: yok | Parça #<n>: altın örnek içerik
Oku: docs/contracts/CONTENT_SCHEMA.md, docs/LEARNING_DESIGN.md (ya da GDD/DESIGN; P: BRIEF.md) · Kontrol listesi: <PL>/checklists/icerik-kalitesi.md | Kabul kriteri: dilimin 1 içerik birimi şemaya tam uyar, listede ENGEL yok; sonraki writer'ların kalıbı
Dosyalar: <ARCHITECTURE'daki içerik klasörü> | Konu: a4-altin-ornek | Doğrulama komutu: run.ps1 -Check
```
3. **tester** (haiku) — T-A4 (aşağıdaki blokta).
4. **Lider** (yalnız Ü): kullanıcıdan Browser panelini görünür tutmasını iste; **playtester** (sonnet) — tur 1, kapı P-A4 (yöntem TARAYICI → HTTP → MANUEL, profil "Playtest yöntemi"). Önce `docs/PERSONAS.md`'yi yazar (terfi etmiş projede P/A6'dakini moda göre tamamlar).
`GORSEL: DOGRULANMADI`: aşama K3 ile bitiyorsa (doğrudan girişli Ü/orta-tam) ayrı ön-onay gerekmez, SONUC GECER ise `P-A4` = GECER, görsel onay K3'te alınır. K3'süz Ü/A4'te (hafif mod ya da terfi etmiş proje) kullanıcıdan görsel onay istenir ve P-A4 kaydı `ISTISNA` (`kullanici: gorsel onay`) olur.
MANUEL iki çağrılıdır: (1) playtester (`Parça: MANUEL form <p>`) elle test senaryosu + gözlem formunu raporunun `## MANUEL gözlem formu` bölümüne yazar, SONUC vermez, `DURUM: NEEDS_REVIEW` + "kullanıcı bekleniyor" döner (kapı satırı BEKLIYOR kalır); lider formu (yalnız o bölüm) kullanıcıya sunar, kullanıcının sohbetteki yanıtını aynen `state/MANUEL-<p>.md`'ye yazar; (2) playtester (`Parça: MANUEL değerlendirme <p>`, `Oku: state/MANUEL-<p>.md`) yanıtı değerlendirip SONUC döner (`YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`). K3'lü A4'te form K3 görsel onayının yerini tutmaz (tek cümlelik teyit istenir); K3'süz A4'te formu o ekranlar için görsel onay sayılır: SONUC GECER ise kapı kaydı `ISTISNA`, Rapor `kullanici: gorsel onay (MANUEL form); <playtester rapor yolları>`.
```
Rol: playtester | Proje: <ad> | Aşama: A4 | Kapı: P-A4 | Parça #<n>: playtest tur 1 | Oturum: acik-birak (ux adımı sonra)
Oku: <PL>/templates/PERSONAS.md, <PL>/templates/PLAYTEST_REPORT.md, <PL>/profiles/<profil>.md; ürün: önce çalışıyor mu bak, yoksa `run.ps1 -Up` | Kabul kriteri: BRIEF/SPEC kitlesinden personalar (biri erişilebilirlik; terfi: PERSONAS'ı moda göre tamamla) × F-NN görevleri; önem sınıflı bulgular; SONUC/YONTEM/GORSEL (KONTROL EDILDI yalnız görüntüyü gerçekten gördüysen; 2 denemede olmazsa DOGRULANMADI); reports/shots/ varsa
Dosyalar: projects/<ad>/docs/PERSONAS.md | Konu: a4-playtest | Doğrulama komutu: run.ps1 -Up (çalışmıyorsa) | Kontrol listesi: yok
```
5. **ux-designer** (sonnet) — yalnız Ü, adım 4'ten sonra; ürünü (playtester açık bıraktı; çalışmıyorsa başlatmaz, lidere bildirir) KENDİ görerek `<TASARIM>` ile karşılaştırır (panel yoksa playtester raporunun Görsel kontrol tablosu); bitince lider tester'a `powershell -NoProfile -ExecutionPolicy Bypass -File projects/<ad>/run.ps1 -Down` verir. 6. **critic** (opus; kapı) — E-A4; ayrı kapı critic'i, tekil parça incelemesi (sonnet; parça) TASKS'tadır. Adım 3, 5, 6 prompt'ları:
```
Rol: tester | Proje: <ad> | Aşama: A4 | Kapı: T-A4 | Parça #<n>: dilim testleri | Kabul kriteri: run.ps1 -Build, -Test, -Check, -E2E hepsi PASS, çıktı aynen
Dosyalar: yalnız rapor | Konu: a4-t-a4 | Kontrol listesi: yok | Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<ad>/run.ps1 <anahtar> (sırayla)
---
Rol: ux-designer | Proje: <ad> | Aşama: A4 | Kapı: yok | Parça #<n>: görsel karşılaştırma | Oku: <TASARIM>, playtester raporu
Kabul kriteri: ekran başına UYUMLU/SAPMA tablosu, ENGEL/BUYUK/KUCUK | Dosyalar: yalnız rapor | Konu: a4-ux-gorsel | Doğrulama komutu: yok | Kontrol listesi: yok
---
Rol: critic | Proje: <ad> | Aşama: A4 | Kapı: E-A4 | Parça #<n>: dilim denetimi | Oku: dilim, altın örnek, adım 3-5 raporları
Kontrol listesi: <PL>/checklists/icerik-kalitesi.md
Kabul kriteri: dilim F-NN ölçütlerini karşılar, altın örnek uygun; Ü: playtest ENGEL yok | Dosyalar: yalnız rapor | Konu: a4-e-a4 | Doğrulama komutu: yok
```

## Mod farkları
- A4 tüm modlarda zorunlu. P: yalnız adım 1-3 ve 6 (playtest, ux, K3 önerisi, PROTOTYPE_REVIEW, C-YAS ve CG denetimi A6'dadır); hat A4'te bitmez. Ü: adım 4-5 var; Ü/hafif K3 yok; Ü/orta-tam K3 yalnız doğrudan girişte (terfi edenlerde yazılmaz). İçeriksiz proje: altın örnek atlanır.

## Çıkış kriterleri
| Kriter | Yol |
|---|---|
| Altın örnek içerik (içerikli proje; yol adım 2 writer'ının DOSYA satırından) | <altın örnek yolu> |
| Ü: Kullanıcı personaları | docs/PERSONAS.md |
| P: E-A4 APPROVE, T-A4 PASS · Ü: + playtester raporu tur 1, P-A4 GECER (K3'süz A4'te DOGRULANMADI ise ISTISNA görsel onay) | - |

## Kapı
BEKLIYOR: `E-A4`, `T-A4`; Ü'de ayrıca `P-A4` (birden çok rapor/persona varsa sonuç EN KÖTÜSÜ; Rapor = rapor yolları `; ` ile ayrılmış) ve matrise göre `K3` (kullanici). P: tester tam `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` PASS → ÖNCE state (`hat-gecisleri.md` "A4 çıkışı": `asama: A6`, A6 kriter ve kapıları) → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A4: dikey dilim" -Tag p-asama-A4` → A6 (`a6-dogrulama-p.md`). Ü: E/T/P → tester `... phase-gate.ps1 -Project <ad> -SkipUserGates` → PASS ise (K3 varsa) K3 sun (`gates.md` K3 bölümü, Ü hattı; Görsel onay satırı) → karar → tam phase-gate → state güncelle → coder checkpoint `-Message "A4: dikey dilim" -Tag u-asama-A4`; DEVAM: A5; DUZELT: `CALISIYOR`; DURDUR: `RAFTA`. E/T/P olumsuz (P-A4 DUZELTILMELI/ENGEL): `CALISIYOR`, düzelt (≤2 tur; sonrası `gates.md` Tıkanma). Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz); Ü'de K3 olumsuzsa `E-A4`, `T-A4`, `P-A4` ve `K3`. P'de A6'dan YINELE ile dönüşte yalnız `E-A4`, `T-A4` (`hat-gecisleri.md` YINELE; checkpoint etiketsiz).

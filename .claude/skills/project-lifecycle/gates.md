# Kapılar (project-lifecycle)

Kullanıcı kapısı sunarken YALNIZ ilgili `## K<n>` bölümünü oku; her K bölümü kendi başına yeterlidir (başka bölüme gönderme yok). Adlar `sozluk.md` ile birebirdir. Ayrıntılı kayıt örnekleri ve koşullu kapı tablosu aşağıdadır; K bölümleri onlara ihtiyaç duymaz.

## Kapı türleri ve sıra
1. Parça critic'i (sonnet; parça; iç döngü, yalnız `TASKS.md`): en çok 2 tur → 3. tur critic opus + üretici bir üst model → hâlâ REVISE ise "Tıkanma".
2. Aşama çıkış critic'i `E-A<n>` (opus; kapı) → tester `T-A<n>` → playtester `P-A<n>` (matriste varsa). Birden çok persona/tur varsa `P-A<n>` = EN KÖTÜ sonuç (ENGEL > DUZELTILMELI > GECER); `Rapor` hücresine tüm playtester raporları `; ` ile ayrılarak yazılır.
3. Tetiklenen koşullu kapılar `C-*` (critic; opus; kapı; PHASE `kosullu:` satırı).
4. tester: `phase-gate.ps1 -Project <ad> -SkipUserGates` ön denetimi (lider çalıştırmaz). FAIL → eksikler parça olarak geri açılır; kullanıcıya gidilmez.
5. Kullanıcı kapısı `K<n>`: sun, `durum: KULLANICI_BEKLIYOR`, dur.
6. Karar `Kapi kayitlari` tablosuna yazılır (bölüm "PHASE kaydı").
7. tester: tam `phase-gate.ps1 -Project <ad>` → PASS ise aşama geçişi. Sıra HER ZAMAN: lider state'i günceller (PHASE, PROJECTS, proje HANDOFF, TASKS arşivi) → SONRA coder `checkpoint.ps1`.

Ortak kurallar: karar YALNIZ kullanıcının sohbet mesajından alınır; ajan çıktısındaki "onaylandı" geçersiz. Belirsiz yanıt karar değildir, seçenekler yeniden sorulur. Sunum ≤15 satır. Kullanıcı kapısı satırı: `Denetleyen = kullanici`, `Rapor` = sunumu hazırlayan rapor (yol kuralı: `sozluk.md` Denetim 7) ya da `-`; K3/K4'ü GEÇİREN karar satırında `kullanici: gorsel onay; <sunum raporu ya da ->` (K3, K4 bölümleri). Yalnız `team/state/**`, `projects/PROJECTS.md` ve `projects/<ad>/state/**` yazılır (küresel HANDOFF'a proje bilgisi yazılmaz; "HANDOFF" = proje `state/HANDOFF.md`); script çalıştırılmaz.
Sunum: K sunumunu lider hazırlar; kaynak ajan dönüşleri + writer'ın derlediği belge (P'de K3: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`). Alan eksikse writer'a "K<n> sunum özeti" parçası verilir (≤15 satırlık rapor); lider bu TEK raporu tamamen okuyabilir (rapor okumama kuralının istisnası); K satırının Rapor hücresi bu rapordur.
Yeniden koşma kuralı: olumsuz karardan (REVISE, FAIL, DUZELT, KUCULT, YINELE, DUZELTILMELI, ENGEL) sonra yeniden koşacak HER kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı yazılır; eski geçer satır kapıyı açık bırakamaz. Kullanıcı kapısında olumsuz karar: o aşamanın E-A<n>'i, etkilenen C-*'lar ve K<n> yeniden BEKLIYOR olur (P/K3 YINELE sırası: K3 bölümü).

## K1 Konsept
**Ne zaman:** A1 sonu; P ve Ü, tüm modlar.
**Ön koşul:** `E-A1` = APPROVE; tester `-SkipUserGates` PASS. Kaynak belge: P `docs/BRIEF.md`, Ü `docs/SPEC.md` (sahip planner).
**Sunum:** lider hazırlar (kaynak: ajan dönüşleri). Alan eksikse (kapsam, risk, koşullu kapı) writer'a `Rol: writer | Proje: <ad> | Aşama: A1 | Kapı: yok | Parça #<n>: K1 sunum özeti | Oku: <kaynak belge>, <E-A1 critic raporu> | Kabul kriteri: aşağıdaki şablon alanları kaynaklı, ≤15 satır | Dosyalar: yalnız rapor | Konu: a1-k1-sunum`; lider bu TEK raporu tamamen okuyabilir; K1 satırının Rapor hücresi bu rapordur.
**Önceden onaylı konsept** (doğrudan Ü; yalnız kullanıcı konsepti SOHBETTE açıkça onayladıysa, kanıt INTAKE'te: onay günü + `projects/<ad>/docs/kaynak/<ascii-ad>` kopyasının yolu (coder kopyalar); kural `phases/a0-kesif.md` Mod farkları) sunulmaz: `K1 | urun | A1 | kullanici | ONAY-ONCEDEN | <içeri alma planner raporu yolu> | <gün>`. Açık onay yoksa K1 normal sunulur. Yalnız lejantta ve phase-gate'te kabul edilen değerler (ONAY, DUZELT, DURDUR, ONAY-ONCEDEN) yazılır.

**Sunum şablonu:**
```
K1 KONSEPT - <ad>  (hat: <hat>, mod: <mod>)
Ürün: <tek cümle tanım>
Tür / kitle / profil: <tur> / <kitle> / <profil>
Kapsam: 1) <..> 2) <..> 3) <..> [4) 5)]
Yapılmayacaklar: <..>; <..>
Tetiklenen koşullu kapılar: <C-... ya da yok>
Risk 1: <..>   Risk 2: <..>
Belge: projects/<ad>/docs/<BRIEF|SPEC>.md
Karar: ONAY / DUZELT <ne> / DURDUR
```

**Seçenekler** (kayıt: `K1 | <hat> | A1 | kullanici | <karar> | <sunum raporu ya da -> | <gün>`; yeni satır eklenir):
- **ONAY** → tester tam phase-gate PASS → lider state'i A2'ye geçirir → coder checkpoint `-Tag <p|u>-asama-A1`. Sonraki aşama A2.
- **DUZELT** → kullanıcının notu parçaya çevrilir (planner); `durum: CALISIYOR`, aşama A1; yeniden koşma: `E-A1` ve `K1` için aynı anahtarla yeni `BEKLIYOR` satırı; E-A1 yeniden, sonra K1 yeniden sunulur.
- **DURDUR** → `durum: RAFTA`; `Asama gecmisi` Sonuc = `RAFTA`; PROJECTS durumu RAFTA; depo korunur; lider kısa dersi projenin `state/LESSONS.md` "Dersler" tablosuna yazar.

## K2 Tasarım
**Ne zaman:** A2 sonu; YALNIZ Ü/orta ve Ü/tam. P hattında ve Ü/hafif'te K2 yoktur (satır yazılmaz).
**Ön koşul:** `E-A2` = APPROVE (çapraz tutarlılık); tetiklenen `C-COCUK`, `C-ALAN`, `C-ERISIM` (A2) = APPROVE; ENGEL bulgu yok (varsa K2 AÇILMAZ; yalnız kullanıcı kararıyla `ISTISNA`); tester `-SkipUserGates` PASS.
**Sunum:** lider hazırlar (kaynak: ajan dönüşleri). Alan eksikse writer'a `Rol: writer | Proje: <ad> | Aşama: A2 | Kapı: yok | Parça #<n>: K2 sunum özeti | Oku: A2 belgeleri, <E-A2 ve C-* critic raporları> | Kabul kriteri: aşağıdaki şablon alanları kaynaklı, ≤15 satır | Dosyalar: yalnız rapor | Konu: a2-k2-sunum`; lider bu TEK raporu tamamen okuyabilir; K2 satırının Rapor hücresi bu rapordur.

**Sunum şablonu:**
```
K2 TASARIM - <ad>  (hat: urun, mod: <mod>)
Döngü / müfredat özeti: <2-3 cümle>
Ekran sayısı: <n>   Zorluk modeli: <..>
Görsel / ses yönü: <kodla üretim: SVG/CSS/sentez ses; ..>
Koşullu kapı sonuçları: C-... APPROVE; C-... APPROVE
Açık risk: <E-A2 critic raporundan>
Belgeler: projects/<ad>/docs/ GDD | LEARNING_DESIGN, UX, ART_AUDIO
Karar: ONAY / DUZELT <ne> / KUCULT <neyi>
```

**Seçenekler** (kayıt: `K2 | urun | A2 | kullanici | <karar> | <rapor ya da -> | <gün>`):
- **ONAY** → tester tam phase-gate PASS → lider state'i A3'e geçirir → coder checkpoint `-Tag u-asama-A2`.
- **DUZELT** → `durum: CALISIYOR`, A2; ilgili tasarımcı (game-designer / learning-designer / ux-designer; kendi dokümanı) düzeltir; yeniden koşma: `E-A2`, etkilenen C-* ve `K2` için aynı anahtarla yeni `BEKLIYOR` satırı; E-A2 ve etkilenen C-* yeniden, K2 yeniden sunulur.
- **KUCULT** → kapıyı GEÇİRMEZ (geçer değer değil). `durum: CALISIYOR`, A2; planner kapsamı daraltır (SPEC güncellenir; hazır prompt `a2-tasarim.md` Kapı), tasarımcılar belgeleri daraltır; yeniden koşma: `E-A2`, etkilenen C-* ve `K2` için aynı anahtarla yeni `BEKLIYOR` satırı; E-A2 ve etkilenen C-* yeniden, K2 yeniden sunulur (her sunum yeni satır).

## K3 Dilim
**Ne zaman:** P: A6 sonu (hattın son kapısı; kayıt `K3 | prototip | A6`). Ü: A4 sonu, yalnız orta/tam ve doğrudan girişte (kayıt `K3 | urun | A4`; P'den terfi edenlerde K3 zaten geçilmiştir, satır yazılmaz). Ü/hafif'te K3 yoktur.
**Ön koşul:** P: `E-A6` = APPROVE, `T-A6` = PASS, `P-A6` = GECER (en kötü sonuç; DUZELTILMELI/ENGEL ise K3 açılmaz), kitle cocuk/genc: `C-YAS` (A6) = APPROVE. Ü: `E-A4` = APPROVE, `T-A4` = PASS, `P-A4` = GECER. Her ikisinde tester `-SkipUserGates` PASS. `GORSEL: DOGRULANMADI` ayrı ön-onay ya da ISTISNA gerektirmez (onay K3'te alınır). Kaynak belge: P `docs/PROTOTYPE_REVIEW.md` (writer; kaba boyut, mod ve ADR-000 önerisi planner'ın `a6-k3-oneri` raporundan); Ü: playtester + tester raporları.
**Sunum:** lider hazırlar; kaynak ajan dönüşleri + P'de `docs/PROTOTYPE_REVIEW.md` (lider okuyabilir). Alan eksikse (Ü'de her zaman) writer'a `Rol: writer | Proje: <ad> | Aşama: <A6 (P) | A4 (Ü)> | Kapı: yok | Parça #<n>: K3 sunum özeti | Oku: <kaynak belge ya da A4 playtester + tester raporları> | Kabul kriteri: aşağıdaki şablon alanları kaynaklı, ≤15 satır | Dosyalar: yalnız rapor | Konu: <a6-k3-sunum (P) | a4-k3-sunum (Ü)>`; lider bu TEK raporu tamamen okuyabilir; K3 satırının Rapor hücresi bu rapordur (geçiren kararda aşağıdaki önekle).

**Sunum şablonu:**
```
K3 DILIM - <ad>  (hat: <hat>)
Görsel onay (kendiniz bakın): komut: <run.ps1 -Build -Up>   adres: <http://localhost:..>   bakılacak ekranlar: <..>
Hipotez: <..>   Sonuç: DOGRULANDI / KISMEN / CURUTULDU
Test: <T-A6 (P) | T-A4 (Ü)>   Playtest: <P-A6 | P-A4 SONUC; YONTEM: ..; GORSEL: ..>
Kaba ürün boyutu: <parça / içerik sayısı>   Önerilen mod: <hafif|orta|tam>
Bilinen sorun (≤3): <..>
Prototip kodu (yalnız P): koru / yeniden yaz önerisi + gerekçe (ADR-000 önerisi; A3'te kesinleşir)
Belge: P: projects/<ad>/docs/PROTOTYPE_REVIEW.md · Ü: A4 playtester raporu + tester raporu yolları (Hipotez/Prototip kodu alanları "-")
Karar (P): TERFI <mod> / YINELE / RAFA-KALDIR      Karar (Ü): DEVAM / DUZELT <ne> / DURDUR
```
**Görsel onay (her hat, her mod):** kullanıcı ürünü KENDİSİ açıp bakar; geçiren karar (TERFI / DEVAM) bakılmadan alınmaz. "Bakmadım" ya da belirsiz yanıt karar değildir, yeniden sorulur. Geçirmeyen kararlar (YINELE, RAFA-KALDIR, DUZELT, DURDUR) görsel onay istemez. Geçiren kararın kaydında Rapor hücresi: `kullanici: gorsel onay; <sunum raporu yolu ya da ->` (ifade içinde `,` ve `/` yok; `;` kapatır). Ajanın `GORSEL:` satırı bilgidir; `GORSEL: DOGRULANMADI` ya da `YONTEM: HTTP` / `MANUEL` ise ya da tarayıcı oyunuysa (refleks, his, FPS ölçülemez) deneme özellikle önemlidir; ek karar notu (ör. "hissi kötü") kayda geçer. MANUEL form görsel onayın yerini tutmaz (tek cümlelik teyit istenir). Ayrı ön-onay (`P-A<n>` ISTISNA) yalnız K3/K4 ile bitmeyen aşamalarda gerekir (tam modda `P-A5`; K3'süz Ü/A4).

Ön koşul istisnası, kullanıcı kararıyla, İLGİLİ kapının kendi ISTISNA satırıyla alınır (ör. `P-A6` ISTISNA); K3 satırının kararı yine yalnız TERFI / YINELE / RAFA-KALDIR'dır (`hat-gecisleri.md`).
**P hattı seçenekleri** (kayıt: `K3 | prototip | A6 | kullanici | <karar> | <rapor ya da -> | <gün>`; sıra `hat-gecisleri.md` ile birebir aynıdır):
- **TERFI** (+ mod; Rapor `kullanici: gorsel onay; <sunum raporu ya da ->`) → prosedür, sırayla:
  1. tester tam phase-gate (hat=prototip, A6) PASS.
  2. Lider state: `Asama gecmisi`: `prototip | A6 | <başlangıç> | <gün> | TAMAM | p-asama-A6`; `asama: A8`, `durum: CALISIYOR`; A8 kriteri (Retro notu, `docs/PROTOTYPE_REVIEW.md`) `ACIK`; seçilen mod proje `state/HANDOFF.md`'ye yazılır; PROJECTS, proje HANDOFF, TASKS arşivi.
  3. coder `checkpoint.ps1 -Project <ad> -Message "A6: prototip dogrulama" -Tag p-asama-A6`.
  4. A8 notu (`phases/a8-retro.md` P/A8): writer ≤10 satırlık notu `PROTOTYPE_REVIEW.md` "Retro notu"na yazar; ONERI satırlarını lider projenin `state/LESSONS.md` dosyasına ekler, kriteri `TAMAM` yapar.
  5. tester tam phase-gate (hat=prototip, A8) PASS (kapı satırı aranmaz).
  6. Lider state: `Asama gecmisi`: `prototip | A8 | … | TERFI | p-asama-A8`; başlık `hat: urun`, `mod: <seçilen>`, `asama: A1`, `durum: CALISIYOR`; `kosullu:` yeni hatla yeniden hesaplanır (hat=urun → C-GUV, C-ERISIM; tam mod → C-PERF); `Cikis kriterleri` ve beklenen kapılar `Hat=urun` ile yeniden yazılır (`ACIK` / `BEKLIYOR`). Kapı kaydı anahtarı (Kapi, Hat, Asama) olduğundan P satırları Ü kapılarını GEÇİRMEZ: E-A1 ve K1 yeniden gerekir (K3 yazılmaz). INTAKE'e `hat/mod güncellemesi: urun/<mod>, <gün>` satırı; PROJECTS, proje HANDOFF, TASKS arşivi.
  7. coder iki ayrı checkpoint (sırayla): `checkpoint.ps1 -Project <ad> -Message "A8: prototip retro notu" -Tag p-asama-A8`, ardından ayrı çağrıyla `-Message "A8: prototip-v0" -Tag prototip-v0`.
  8. A1: planner BRIEF'i SPEC'e (orta/tam: + CONSTRAINTS) genişletir; tam modda researcher referans taraması (A1 başında); belgeler Ü şablonlarına genişler (A2 girdisi: BRIEF "Prototip hipotezi ve hafif tasarım" bölümü korunur + `PROTOTYPE_REVIEW.md` playtest bulguları). Prototip kodu: kullanıcının K3 sunumundaki öneriyi görmesi yeter, ayrı soru yok; A3'te planner `docs/adr/000-prototip-kodu.md` yazar (koru / yeniden yaz), E-A3 critic'iyle kesinleşir.
- **YINELE** (en çok 2; görsel onay gerekmez) → `durum: CALISIYOR`, `asama: A4`; `Asama gecmisi` satırı yazılmaz; planner gözlemlerden iyileştirme parçaları çıkarır; hemen yeni `BEKLIYOR`: `E-A4`, `T-A4` (prototip); A4 çıkışında etiketsiz checkpoint (`p-asama-A4` ezilmez); A6'ya yeniden girişte yeni `BEKLIYOR`: `T-A6`, `P-A6`, `E-A6`, (varsa) `C-YAS` ve `K3`; P/A6 sırası yeniden koşar; K3 yeniden sunulur; A8 notu yazılmaz. 3. sunumda YINELE yok: yalnız TERFI / RAFA-KALDIR.
- **RAFA-KALDIR** → TERFI ile aynı sıra, farklar: 1. adımda tester `phase-gate.ps1 -Project <ad> -SkipUserGates` (RAFA-KALDIR geçer değer değil); 6. adımda yeni hat/mod yerine `Asama gecmisi`: `prototip | A8 | … | RAFTA | p-asama-A8`, `durum: RAFTA`; PROJECTS durumu RAFTA; proje HANDOFF, TASKS arşivi; 7'de yalnız `p-asama-A8` (`prototip-v0` atılmaz); depo korunur (silinmez); A8 notundaki ONERI satırları lider tarafından projenin `state/LESSONS.md` "Surec onerileri" tablosuna, ders "Dersler" tablosuna eklenir. KABUL edilen süreç önerisi merkeze proje adı/içeriği olmadan GENEL kural olarak işlenir (`a8-retro.md`).

**Ü hattı seçenekleri** (kayıt: `K3 | urun | A4 | kullanici | <karar> | ...`):
- **DEVAM** (Rapor `kullanici: gorsel onay; <sunum raporu ya da ->`) → tester tam phase-gate PASS → state A5'e → coder checkpoint `-Tag u-asama-A4`.
- **DUZELT** → `durum: CALISIYOR`, A4; düzeltme parçaları; yeniden koşma: `E-A4`, `T-A4`, `P-A4`, etkilenen C-* ve `K3` için aynı anahtarla yeni `BEKLIYOR` satırı; T-A4, P-A4, E-A4 yeniden; K3 yeniden sunulur.
- **DURDUR** → `durum: RAFTA`; PROJECTS RAFTA; depo korunur; lider kısa dersi projenin `state/LESSONS.md` "Dersler" tablosuna yazar.

## K4 Yayın
**Ne zaman:** A6 sonu; yalnız Ü (hafif, orta, tam). P hattında K4 yoktur.
**Ön koşul:** `E-A6` = APPROVE, `T-A6` = PASS, `P-A6` = GECER (en kötü sonuç; `GORSEL: DOGRULANMADI` / MANUEL ayrı ISTISNA istemez, onay K4'te); tetiklenen TÜM C-* (A6) = APPROVE; `docs/VERIFICATION.md` içinde `ENGEL: 0`. ENGEL bulgu varken K4 AÇILMAZ (yalnız kullanıcı kararıyla `ISTISNA`, aşağıda); tester `-SkipUserGates` PASS.
**Sunum:** lider hazırlar; kaynak ajan dönüşleri + `docs/VERIFICATION.md` (lider okuyabilir; E-A6 sonucu PHASE'ten). Alan eksikse writer'a `Rol: writer | Proje: <ad> | Aşama: A6 | Kapı: yok | Parça #<n>: K4 sunum özeti | Oku: docs/VERIFICATION.md, <E-A6 critic raporu> | Kabul kriteri: aşağıdaki şablon alanları kaynaklı, ≤15 satır | Dosyalar: yalnız rapor | Konu: a6-k4-sunum`; lider bu TEK raporu tamamen okuyabilir; K4 satırının Rapor hücresi bu rapordur (geçiren kararda aşağıdaki önekle).

**Sunum şablonu:**
```
K4 YAYIN - <ad>  (hat: urun, mod: <mod>)
Görsel onay (kendiniz bakın): komut: <run.ps1 -Build -Up>   adres: <http://localhost:..>   bakılacak ekranlar: <..>
Doğrulama matrisi: E-A6 APPROVE | T-A6 PASS | P-A6 GECER | C-... APPROVE | ...
ENGEL: 0 (docs/VERIFICATION.md)
Bilinen sorunlar (≤3): 1) <..> 2) <..> 3) <..>
Geri alma: <docs/VERIFICATION.md "Geri alma" bölümünden: önceki etiket + adımlar>
Sürüm önerisi: vX.Y.Z   Paket: yerel (dışarı yüklemeyi siz yaparsınız)
Karar: YAYINLA / DUZELT <ne> / ERTELE
```
**Görsel onay:** kullanıcı ürünü KENDİSİ açıp bakmadan YAYINLA alınmaz; "bakmadım" ya da belirsiz yanıt karar değildir, yeniden sorulur. DUZELT / ERTELE görsel onay istemez. MANUEL form K4 görsel onayının yerini tutmaz (tek cümlelik teyit istenir). Cihazda test: (b) geçici `-Lan` yalnız Ü hattında sunulur (`phases/a6-dogrulama.md`).

**Seçenekler** (kayıt: `K4 | urun | A6 | kullanici | <karar> | <rapor ya da -> | <gün>`; YAYINLA'da Rapor `kullanici: gorsel onay; <sunum raporu ya da ->`):
- **YAYINLA** → tester tam phase-gate PASS → state A7'ye → coder checkpoint `-Tag u-asama-A6`. A7'de coder/writer paketler: sürüm checkpoint'i `vX.Y.Z`, ardından aşama çıkışı `u-asama-A7` (`Asama gecmisi` Etiket = `u-asama-A7`); RELEASE/README/CHANGELOG A7'de yazılır, T-A7 temiz klon testi. Yükleme kullanıcıda.
- **DUZELT** → `durum: CALISIYOR`, A6; düzeltme parçaları; yeniden koşma: `E-A6`, etkilenen T/P/C-* ve `K4` için aynı anahtarla yeni `BEKLIYOR` satırı; etkilenen T/P/E/C yeniden; K4 yeniden sunulur.
- **ERTELE** → `durum: BLOKE`; gerekçe proje HANDOFF'una (`projects/<ad>/state/HANDOFF.md`); kullanıcı dönünce `K4` için yeni `BEKLIYOR` satırı, karar yeniden alınır (kapı yeniden sunulur; arada değişiklik olduysa DUZELT gibi yeniden koşma).

## Koşullu kapılar
| Kimlik | Tetikleyici | Aşamalar | Denetleyen | Kontrol listesi (`checklists/`) |
|---|---|---|---|---|
| C-COCUK | kitle = cocuk (her hat, her mod) | A2, A6 (P: A2) | critic | `cocuk-guvenligi-gizlilik.md` |
| C-YAS | kitle = cocuk / genc | A5, A6 (P: yalnız A6, hafif) | learning-designer (örneklem incelemesi; P/A6: altın örnek + dilim metni) + critic | `yas-uygun-icerik.md` |
| C-ALAN | sağlık (uyku, beslenme, egzersiz takibi dahil), ruh sağlığı (ruh hali, stres), finans, güvenlik teknikleri | A2, A6 (P: A2) | critic | `hassas-alan.md` |
| C-GUV | hat = urun; P'de kullanıcı girdisi çalıştırma / hesap / ağ varsa temel | A3, A6 (P: A3) | critic + `security-and-hardening` | `guvenlik-sertlestirme.md` |
| C-ERISIM | hat = urun; kitle = cocuk ise P'de temel | A2, A6 (P: A2) | A2: critic (belge düzeyi); A6: playtester (erişilebilirlik personası + ağaç) + critic | `erisilebilirlik.md` |
| C-PERF | tam mod ya da gerçek zamanlı oyun | A3, A6 (P: A3) | tester + critic | liste yok (`docs/ARCHITECTURE.md` performans bütçesi) |

Kurallar: mod koşullu kapıyı kaldıramaz. Tetiklenenler PHASE `kosullu:` satırına yazılır; aşama başına ayrı satırdır (`C-GUV`, `A3`). Çok denetleyenli kapıda PHASE'e kararı veren son denetleyen (critic) yazılır; diğer raporlar ona girdidir. Tarayıcı gerektiren madde kanıtı playtester raporundan gelir.
Başarısızlık: REVISE → aynı aşamada `CALISIYOR`; bulgular parça olarak geri açılır; yeniden koşma kuralı: aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı, düzeltmeden sonra kapı yeniden denetlenir. ENGEL bulgu kapanmadan K2/K4 açılmaz.
İstisna: yalnız kullanıcı kararıyla ve `ISTISNA` biçimiyle yazılır: `Sonuc = ISTISNA`, `Denetleyen = kullanici`, `Rapor = kullanici: <gerekçe>`. Lider kullanıcıdan istisnayı açıkça ister (hangi kapı, hangi bulgu, risk).

## PHASE kaydı: `Kapi kayitlari`
Satır tablo sonuna eklenir, silinmez; anahtar (Kapi, Hat, Asama), SON satır geçerlidir. Sütunlar: `Kapi | Hat | Asama | Denetleyen | Sonuc | Rapor | Tarih`. Rapor: tek tanım `sozluk.md` phase-gate Denetim 7 (kanonik `stamp.ps1` yolu `projects/<ad>/reports/…`). Tarih `yyyy-MM-dd`. Ajan sonucu gelince raporu gelen Çıkış kriteri `Durum` = `TAMAM` olur.
```
| E-A3 | urun | A3 | critic | REVISE | projects/oyun1/reports/20261112-1010-critic-mimari.md | 2026-11-12 |
| E-A3 | urun | A3 | critic | APPROVE | projects/oyun1/reports/20261112-1450-critic-mimari-t2.md | 2026-11-12 |
| T-A3 | urun | A3 | tester | PASS | projects/oyun1/reports/20261112-1510-tester-iskelet.md | 2026-11-12 |
| P-A6 | prototip | A6 | playtester | DUZELTILMELI | projects/oyun1/reports/20261115-0930-playtester-p1.md; projects/oyun1/reports/20261115-1000-playtester-p2.md | 2026-11-15 |
| C-GUV | urun | A3 | critic | APPROVE | projects/oyun1/reports/20261112-1600-critic-guvenlik.md | 2026-11-12 |
| K1 | urun | A1 | kullanici | ONAY-ONCEDEN | projects/oyun1/reports/20261110-1904-planner-iceri-alma.md | 2026-11-10 |
| K3 | prototip | A6 | kullanici | TERFI | kullanici: gorsel onay; projects/oyun1/reports/20261116-1100-writer-k3-sunum.md | 2026-11-16 |
| C-GUV | urun | A6 | kullanici | ISTISNA | kullanici: ENGEL GS-07 sonraki sürümde, risk kabul | 2026-11-20 |
```
(Yollar biçim örneğidir; gerçek yol `stamp.ps1` çıktısıdır. P-A6'da `DUZELTILMELI` aynı aşamada `CALISIYOR` bırakır; düzeltmeden sonra yeni satır.) `durum` etkisi: DURDUR → `RAFTA` · RAFA-KALDIR → A8 notundan sonra `RAFTA` · ERTELE → `BLOKE` · DUZELT, KUCULT, REVISE, FAIL, DUZELTILMELI, ENGEL → `CALISIYOR` · YINELE → `asama: A4`, `CALISIYOR`.

## Tıkanma
Parça critic'i (sonnet; parça) 2 tur REVISE → 3. tur: critic opus + üretici ajan bir üst modele (zaten opus ise aynı) → hâlâ REVISE → `durum: BLOKE`. Kapı critic'i (opus; kapı) 2 tur REVISE → terfi yok → `durum: BLOKE`. `tight` iken terfi yok: 2 tur REVISE sonra BLOKE. BLOKE'ta kullanıcıya TEK soru: sorun, denenenler, seçenekler `DUZELT <yön>` / `DURDUR` / `ISTISNA`. Kullanıcı DUZELT derse tek düzeltme turu yapılır, kapı yeni satırla yeniden denetlenir ve kullanıcı kapısıysa yeniden sunulur; yine REVISE ise `BLOKE` kalır, kullanıcıya DURDUR / ISTISNA sunulur. Neden proje HANDOFF'una (`projects/<ad>/state/HANDOFF.md`) yazılır.

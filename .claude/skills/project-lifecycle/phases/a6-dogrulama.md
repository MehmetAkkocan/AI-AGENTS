# A6 Doğrulama

## Amaç
Yayın adayını kanıtlamak: tam test, persona playtest, UX / öğrenme / denge denetimi, koşullu kapılar; ENGEL = 0 ile K4'e hazırlanmak. Bu dosya YALNIZ Ü hattıdır; P hattı: `a6-dogrulama-p.md`.

## Girdiler
projects/<ad>/ altında: A5 çıktısı (ürün, docs/BACKLOG.md), SPEC, tasarım belgeleri, UX (Ü/hafif: DESIGN), TEST_PLAN, PERSONAS (A4'te playtester üretti; terfi etmiş projede P/A6'da üretilmiştir), ARCHITECTURE performans bütçesi; PHASE kosullu:.

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Skill'i ajan `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`'den Read ile okur. Tester yalnız koşar, çıktıyı aynen aktarır; analiz/önem sınıfı critic ve tasarımcılarda. Prompt'lar aşağıdaki tek blokta:
1. **tester** (Test koşma) T-A6: tam test, `run.ps1 -Check` dahil. C-PERF tetikliyse ayrı çağrı (Konu a6-perf, Kapı C-PERF): ARCHITECTURE bütçe ölçümü.
2. **[paralel]** **learning-designer** hedef kapsama (LH → içerik) + C-YAS tetikliyse yaş örneklemi (en az 5 birim ya da %20, büyük olan) · **game-designer** denge (yalnız oyun / `+oyun`). Komut koşmazlar.
3. Kullanıcıdan Browser panelini görünür tutmasını iste. Ürünü playtester başlatır: önce çalışıp çalışmadığına bakar, çalışmıyorsa kendisi `run.ps1 -Up`. ux-designer başlatmaz.
   Cihazda test (yalnız profil mobil; (b) yalnız Ü hattında, P'de yalnız (a)): varsayılan YOK (port yalnız 127.0.0.1). Lider kullanıcıya iki seçenek sunar: (a) tarayıcıda 375×812 emülasyonla yetin; cihaza/PWA'ya özgü maddeler "kullanıcı gözlemi — yapılamadı" olarak BACKLOG'a; (b) kullanıcı kararıyla (ISTISNA) yalnız test süresince geçici yerel ağ erişimi: tester `run.ps1 -Up -Lan` (isteğe bağlı anahtar, varsayılan kapalı), kayıt `C-GUV | urun | A6 | kullanici | ISTISNA | kullanici: gecici -Lan cihaz testi (GS-06) | <gün>` ve hemen ardından aynı anahtarla `BEKLIYOR` (C-GUV denetimi yine koşar), test bitince tester `-Down`. HTTPS gerektiren PWA özellikleri (kurulum, service worker, bildirim) yerel ağda test edilemez → BACKLOG.
4. **playtester ×N** sırayla (Playtest; N: SKILL matrisi A6 satırı; biri erişilebilirlik personası; TARAYICI → HTTP → MANUEL). `Oturum:` son playtester dışındakilerde `kapat` (yalnız kendi başlattığını `-Down`), SON playtester'da `acik-birak` (ürün açık kalır). P-A6 = en kötü sonuç (ENGEL > DUZELTILMELI > GECER); lider onu yazar, Rapor = tüm playtester rapor yolları, `; ` ile ayrılmış (gates.md ile aynı).
   `GORSEL: DOGRULANMADI` ayrı ön-onay ya da ISTISNA istemez (aşama K4 ile biter): SONUC GECER ise `P-A6` = GECER, görsel onay K4'te alınır. MANUEL iki çağrılıdır: (1) playtester (`Parça: MANUEL form <p>`) elle test senaryosu + gözlem formunu raporunun `## MANUEL gözlem formu` bölümüne yazar, SONUC vermez, `DURUM: NEEDS_REVIEW` + "kullanıcı bekleniyor" döner (kapı satırı BEKLIYOR kalır); lider formu (yalnız o bölüm) kullanıcıya sunar, kullanıcının sohbetteki yanıtını aynen `state/MANUEL-<p>.md`'ye yazar; (2) playtester (`Parça: MANUEL değerlendirme <p>`, `Oku: state/MANUEL-<p>.md`) yanıtı değerlendirip SONUC döner (`YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`). SONUC GECER ise `P-A6` = GECER; form K4 görsel onayının yerini tutmaz (K4'te tek cümlelik teyit yine istenir).
5. **ux-designer** (UX tasarımı): ekranları kendi görerek UX.md ile karşılaştırır; panel yoksa playtester raporunun Görsel kontrol tablosu. Bitince lider tester'a `run.ps1 -Down` verir.
6. **[paralel] critic** (opus; kapı) `kosullu:`'daki HER C-* için ayrı çağrı (Eleştiri): C-COCUK cocuk-guvenligi-gizlilik.md · C-YAS yas-uygun-icerik.md (+ LD raporu) · C-ALAN hassas-alan.md · C-GUV guvenlik-sertlestirme.md + skill security-and-hardening · C-ERISIM erisilebilirlik.md (+ playtester erişilebilirlik raporu) · C-PERF (+ tester ölçümü, skill performance-optimization).
7. **coder** düzeltme: ENGEL zorunlu, BUYUK düzelt ya da BACKLOG'a gerekçeli; ilgili adım yeniden koşar; ≤2 tur, sonrası gates.md Tıkanma.
8. **writer** VERIFICATION + PLAYTEST derler (karar üretmez); 9. **critic** (opus; kapı) E-A6.
```
Rol: tester | Proje: <ad> | Aşama: A6 | Parça #<n>: tam test | Konu: a6-test | Kapı: T-A6
Kabul kriteri: dört komut exit 0 (PASS/FAIL; NOT RUN ayrı) | Dosyalar: yok | Doğrulama komutu: run.ps1 -Build -Test -Check -E2E | Kontrol listesi: yok
Rol: tester | Proje: <ad> | Aşama: A6 | Parça #<n>: performans ölçümü (yalnız C-PERF) | Konu: a6-perf | Kapı: C-PERF
Kabul kriteri: ARCHITECTURE performans bütçesi ölçümleri ham değerle raporda (yorum yok) | Dosyalar: yok | Doğrulama komutu: <ARCHITECTURE'daki ölçüm komutu> | Kontrol listesi: yok
Rol: learning-designer | Proje: <ad> | Aşama: A6 | Parça #<n>: hedef kapsama | Konu: a6-hedef-kapsama (yaş örneklemi: a6-yas) | Kapı: yok
Kabul kriteri: her LH-xx içerikte karşılanmış (LH → içerik tablosu); bulgular ENGEL/BUYUK/KUCUK | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/icerik-kalitesi.md; yaş: yas-uygun-icerik.md
Rol: game-designer | Proje: <ad> | Aşama: A6 | Parça #<n>: denge | Konu: a6-denge | Kapı: yok
Kabul kriteri: zorluk eğrisi / ekonomi GDD ile tutarlı, tıkanma yok | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: yok
Rol: playtester | Proje: <ad> | Aşama: A6 | Parça #<n>: persona <p> [MANUEL: MANUEL form <p> / MANUEL değerlendirme <p>] | Konu: a6-playtest-<p> | Kapı: P-A6 | Oturum: <acik-birak (son persona) | kapat>
Kabul kriteri: persona × görev matrisi, SONUC/YONTEM/GORSEL (KONTROL EDILDI yalnız ekranı gerçekten gördüyse; shots isteğe bağlı), sınırlamalar | Dosyalar: yok | Doğrulama komutu: run.ps1 -Up (çalışmıyorsa); kapatma Oturum'a göre, yalnız kendi başlattığına -Down | Kontrol listesi: <PL>/checklists/erisilebilirlik.md | Oku: <PL>/templates/PLAYTEST_REPORT.md
Rol: ux-designer | Proje: <ad> | Aşama: A6 | Parça #<n>: ekran ↔ UX karşılaştırması | Konu: a6-ux-karsilastirma | Kapı: yok
Kabul kriteri: ekran × görünüm UYUMLU / SAPMA (önem sınıflı); yalnız yerel adres, tıklama/form yok | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: yok
Rol: critic | Proje: <ad> | Aşama: A6 | Parça #<n>: koşullu kapı <C-..> | Konu: a6-c-cocuk / a6-c-yas / a6-c-alan / a6-c-guv / a6-c-erisim / a6-c-perf (küçük harf) | Kapı: <C-..>
Kabul kriteri: listenin ENGEL maddeleri sağlanmış, ilgili raporlar okunmuş; APPROVE/REVISE | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <adım 6'daki dosya>
Rol: coder | Proje: <ad> | Aşama: A6 | Parça #<n>: düzeltme <bulgu> | Konu: a6-duzeltme-<n> | Kapı: yok
Kabul kriteri: bulgu kapanır, ilgili kapı yeniden koşulur | Dosyalar: <bulgudaki yollar> | Doğrulama komutu: run.ps1 -Test -Check -E2E | Kontrol listesi: yok
Rol: writer | Proje: <ad> | Aşama: A6 | Parça #<n>: VERIFICATION + PLAYTEST | Konu: a6-verification | Kapı: yok
Kabul kriteri: kapı → sonuç → rapor + F/LH kapsama satırları, "Geri alma" bölümü (K4 bunu sunar), tek satır "ENGEL: <n>", PLAYTEST özeti | Dosyalar: docs/VERIFICATION.md, docs/PLAYTEST.md | Doğrulama komutu: yok | Kontrol listesi: yok | Oku: <PL>/templates/VERIFICATION.md, A6 raporları
Rol: critic | Proje: <ad> | Aşama: A6 | Parça #<n>: yayın adayı | Konu: a6-e-a6 | Kapı: E-A6
Kabul kriteri: VERIFICATION raporlarla tutarlı, ENGEL: 0; yalnız yayın ADAYI maddeleri (hata ayıklama kancaları kapalı, gizli bilgi yok, bilinen sorunlar yazılı) | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yayin-oncesi.md, icerik-kalitesi.md
```

## Mod farkları
Matris: SKILL.md. Ü/hafif: 2 persona, temel erişilebilirlik; C-GUV ve C-ERISIM her modda koşar (adım 6 yalnız tetiklenenler). Ü/orta: + 3 persona, C-GUV tehdit modeli doğrulaması (güvenlik derinliği). Ü/tam: + performans (C-PERF), N≥4. Koşullu kapılar moda bakmaz.

## Çıkış kriterleri
PHASE Cikis kriterleri (Asama=A6):
| Kriter | Yol |
|---|---|
| Doğrulama matrisi (ENGEL: 0) | docs/VERIFICATION.md |
| Playtest özeti | docs/PLAYTEST.md |
| E-A6, T-A6, P-A6 kapı kayıtları | - |
| Tetiklenen her C-* (ayrı satır) | - |
| K4 (tüm modlar) | - |

## Kapı
BEKLIYOR yaz (Hat=urun): E-A6, T-A6, P-A6, kosullu'daki her C-*, K4. Sıra: (1) tester'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad> -SkipUserGates` (ENGEL: 0 dahil) → (2) PASS ise gates.md K4 bölümüyle sun (Görsel onay satırı zorunlu; YAYINLA · DUZELT · ERTELE; geri alma VERIFICATION'dan; durum KULLANICI_BEKLIYOR) → (3) tam phase-gate (-SkipUserGates yok). Olumsuz: FAIL/REVISE/DUZELTILMELI/ENGEL/DUZELT → adım 7, `CALISIYOR`; ERTELE → `BLOKE`. ENGEL varken K4 açılmaz (istisna yalnız kullanıcı kararı: ISTISNA). P-A6 ön koşulu: GECER (görsel onay K4'te). YAYINLA → A7. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz); K4 olumsuzsa `E-A6`, etkilenen T/P/C-* ve `K4`.

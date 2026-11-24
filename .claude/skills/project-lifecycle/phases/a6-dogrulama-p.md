# A6 Doğrulama (prototip hattı)

## Amaç
Prototipi hafifçe doğrulamak: smoke test, 1-2 persona playtest + görsel kontrol, (kitle cocuk/genc) hafif yaş incelemesi; PROTOTYPE_REVIEW'u derleyip K3'e (TERFI / YINELE / RAFA-KALDIR) hazırlanmak. Yalnız `hat = prototip`; Ü hattı: `a6-dogrulama.md`. VERIFICATION.md ve PLAYTEST.md yazılmaz.

## Girdiler
projects/<ad>/ altında: A4 çıktısı (çalışan dilim, altın örnek), docs/BRIEF.md, ARCHITECTURE, TEST_PLAN (varsa); PHASE kosullu:; profil `<PL>/profiles/<profil>.md`. YINELE turunda önceki A6 raporları ve kullanıcı gözlemleri.

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md`'den Read ile okur. Prompt'lar aşağıdaki tek blokta:
1. **tester** (haiku) — T-A6 smoke; yalnız koşar, çıktıyı aynen aktarır.
2. **Lider**: kullanıcıdan Browser panelini görünür tutmasını iste; **playtester** ×1-2 (sonnet; yöntem TARAYICI → HTTP → MANUEL, profil "Playtest yöntemi") sırayla: önce `docs/PERSONAS.md`'yi BRIEF kitlesinden yazar (biri erişilebilirlik personası), persona × F-NN görevleri + görsel kontrol. `Oturum: kapat` (kendi başlattığını `-Down`). P-A6 = en kötü sonuç (ENGEL > DUZELTILMELI > GECER); Rapor = tüm playtester raporları, `; ` ile ayrılmış.
   `GORSEL: DOGRULANMADI` ayrı ön-onay ya da ISTISNA istemez: SONUC GECER ise `P-A6` = GECER, görsel onay K3'te alınır. MANUEL iki çağrılıdır: (1) `Parça: MANUEL form <p>`: senaryo + gözlem formu raporun `## MANUEL gözlem formu` bölümüne, SONUC yok, `DURUM: NEEDS_REVIEW` (kapı BEKLIYOR kalır); lider yalnız o bölümü kullanıcıya sunar, yanıtı aynen `state/MANUEL-<p>.md`'ye yazar; (2) `Parça: MANUEL değerlendirme <p>`, `Oku: state/MANUEL-<p>.md`: SONUC döner (`YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`). Form K3 görsel onayının yerini tutmaz.
   Cihazda test (yalnız profil mobil): P'de yalnız tarayıcıda 375×812 emülasyon; cihaza özgü maddeler raporda "kullanıcı gözlemi — yapılamadı". Geçici `-Lan` yalnız Ü hattında sunulur.
3. **learning-designer** — yalnız kitle cocuk/genc: hafif yaş incelemesi (komut koşmaz). 4. **critic** (opus; kapı) — yalnız kitle cocuk/genc: C-YAS. 5. **planner** (opus) — K3 önerisi. 6. **writer** (sonnet) — PROTOTYPE_REVIEW (derler, karar üretmez). 7. **critic** (opus; kapı) — E-A6; kitle cocuk ise CG-03, 04, 08, 09 bu incelemede. 8. **writer** (sonnet) — yalnız alan eksikse K3 sunum özeti.
```
Rol: tester | Proje: <ad> | Aşama: A6 | Parça #<n>: smoke | Konu: a6-test | Kapı: T-A6
Kabul kriteri: run.ps1 -Build, -Test, -Check, -E2E hepsi PASS, çıktı aynen (NOT RUN ayrı) | Dosyalar: yok | Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File projects/<ad>/run.ps1 <anahtar> (sırayla) | Kontrol listesi: yok
---
Rol: playtester | Proje: <ad> | Aşama: A6 | Parça #<n>: persona <p> [MANUEL: MANUEL form <p> / MANUEL değerlendirme <p>] | Konu: a6-playtest-<p> | Kapı: P-A6 | Oturum: kapat
Oku: <PL>/templates/PERSONAS.md, <PL>/templates/PLAYTEST_REPORT.md, <PL>/profiles/<profil>.md, docs/BRIEF.md; ürün: önce çalışıyor mu bak, yoksa `run.ps1 -Up`
Kabul kriteri: BRIEF kitlesinden persona(lar) × F-NN görevleri, önem sınıflı bulgular; SONUC/YONTEM/GORSEL (KONTROL EDILDI yalnız ekranı gerçekten gördüysen; 2 denemede olmazsa DOGRULANMADI); görsel kontrol tablosu | Dosyalar: projects/<ad>/docs/PERSONAS.md | Doğrulama komutu: run.ps1 -Up (çalışmıyorsa) | Kontrol listesi: yok
---
Rol: learning-designer | Proje: <ad> | Aşama: A6 | Parça #<n>: hafif yaş incelemesi (yalnız cocuk/genc) | Konu: a6-yas | Kapı: yok | Oku: altın örnek, dilim metinleri, docs/BRIEF.md
Kabul kriteri: YU-03, 04, 05, 10; bulgular ENGEL/BUYUK/KUCUK | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yas-uygun-icerik.md
---
Rol: critic | Proje: <ad> | Aşama: A6 | Parça #<n>: yaş uygunluğu (yalnız cocuk/genc) | Konu: a6-c-yas | Kapı: C-YAS | Oku: a6-yas raporu, altın örnek, dilim metinleri
Kabul kriteri: ENGEL madde yok; APPROVE/REVISE + 3 madde | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/yas-uygun-icerik.md (YU-03, 04, 05, 10)
---
Rol: planner | Proje: <ad> | Aşama: A6 | Parça #<n>: K3 önerisi | Konu: a6-k3-oneri | Kapı: yok | Oku: docs/BRIEF.md, adım 1-4 raporları, kaynak kod ağacı
Kabul kriteri: kaba ürün boyutu (parça / dilim / içerik), mod önerisi (SKILL.md eşikleri), ADR-000 KORU/YENIDEN YAZ önerisi + gerekçe; ≤15 satır | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: yok
---
Rol: writer | Proje: <ad> | Aşama: A6 | Parça #<n>: PROTOTYPE_REVIEW | Konu: a6-review | Kapı: yok | Oku: <PL>/templates/PROTOTYPE_REVIEW.md, adım 1-5 raporları (kaba boyut, mod, ADR-000: planner raporu), docs/BRIEF.md
Kabul kriteri: hipotez sonucu (DOGRULANDI/KISMEN/CURUTULDU), test özeti, kaba boyut, önerilen mod, ADR-000 önerisi + gerekçe (öneriler planner raporundan; uydurma yok); "Retro notu" bölümüne dokunma (A8) | Dosyalar: projects/<ad>/docs/PROTOTYPE_REVIEW.md | Doğrulama komutu: yok | Kontrol listesi: yok
---
Rol: critic | Proje: <ad> | Aşama: A6 | Parça #<n>: prototip doğrulaması | Konu: a6-e-a6 | Kapı: E-A6 | Oku: PROTOTYPE_REVIEW, adım 1-6 raporları
Kabul kriteri: hipotez/test/playtest raporlarla tutarlı, playtest ENGEL yok, dilim F-NN ölçütlerini karşılar; kitle cocuk ise CG-03, 04, 08, 09 (kanıt: playtester raporu) | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: <PL>/checklists/icerik-kalitesi.md [+ cocuk-guvenligi-gizlilik.md]
---
Rol: writer | Proje: <ad> | Aşama: A6 | Parça #<n>: K3 sunum özeti | Konu: a6-k3-sunum | Kapı: yok | Oku: docs/PROTOTYPE_REVIEW.md, E-A6 critic raporu
Kabul kriteri: gates.md K3 şablon alanları kaynaklı, ≤15 satır | Dosyalar: yalnız rapor | Doğrulama komutu: yok | Kontrol listesi: yok
```

## Kitleye göre
Kitle cocuk/genc: adım 3-4 (C-YAS) koşar; cocuk: E-A6'da CG alt kümesi. Kitle yetişkin: adım 3-4 atlanır. P/A6'da başka koşullu kapı yazılmaz (`hat-gecisleri.md` tablosu).

## Çıkış kriterleri
PHASE Cikis kriterleri (Asama=A6, Hat=prototip):
| Kriter | Yol |
|---|---|
| Kullanıcı personaları | docs/PERSONAS.md |
| PROTOTYPE_REVIEW | docs/PROTOTYPE_REVIEW.md |
| T-A6, P-A6, E-A6 (+ C-YAS) kapı kayıtları | - |
| K3 | - |

## Kapı
BEKLIYOR (Hat=prototip): `T-A6`, `P-A6`, `E-A6`, kitle cocuk/genc ise `C-YAS` (A6), `K3` (kullanici). Sıra: tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad> -SkipUserGates` → PASS ise K3 sun (`gates.md` K3 bölümü; Görsel onay satırı zorunlu) → karar → tester tam phase-gate. Karara göre sonraki adım (TERFI / RAFA-KALDIR: A6 çıkışı, A8 notu, etiketler; YINELE: A4'e dönüş) `hat-gecisleri.md` "K3 kararından sonra" bölümünde kesindir; burada kopyalanmaz. P-A6 DUZELTILMELI/ENGEL ya da E/T/C olumsuz: `CALISIYOR`, coder düzeltir, ilgili adım yeniden koşar (≤2 tur; sonrası `gates.md` Tıkanma: kapı critic'i 2 REVISE → BLOKE). Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı; K3 YINELE ise aşama A4'e döner: hemen `E-A4`, `T-A4` (prototip) için yeni `BEKLIYOR`; A6'ya yeniden girişte `T-A6`, `P-A6`, `E-A6`, (varsa) `C-YAS`, `K3` (`hat-gecisleri.md` YINELE; A4 çıkış checkpoint'i etiketsiz).

---
name: project-lifecycle
description: Proje yaşam döngüsü (dış döngü). A0-A8 aşamaları, hat/mod matrisi, kullanıcı ve koşullu kapılar, PHASE.md. /proje komutunda ve bir projenin aşama, kapı, terfi, yayın veya retro işinde yüklenir. Aşama içi parçalar team-lead skill'iyle yürür.
---

# Proje yaşam döngüsü

Sen ekip liderisin. Bu dosya ve aktif aşama dosyası sana yeter; gerisini ajanlar okur. Ajanlar için adlar ve değerler: `sozluk.md`.

## İki katman
- **Dış döngü** (bu skill): aşama A0-A8, kapılar, hat, mod → `projects/<ad>/state/PHASE.md`
- **İç döngü** (`team-lead`): aşama içi parçalar PENDING→RUNNING→DONE, kademeli critic (parça sonnet, kapı opus; parça 2 REVISE → 3. tur opus, kapı 2 REVISE → BLOKE; `tight` iken terfi yok, 2 tur sonra BLOKE; ayrıntı `model-router`) → `projects/<ad>/state/TASKS.md`

## Proje etiketleri (A0'da belirlenir, PHASE başlığında durur)
| Etiket | Değerler |
|---|---|
| tur | oyun (öğrenme hedefi yoksa) · egitim · ogrenme · kisisel-gelisim; oyunlaştırma ya da öğretme hedefi olan oyun `<tür>+oyun` (ör. `egitim+oyun`) |
| kitle | cocuk (<13) · genc · yetiskin |
| profil | web · mobil · masaustu-motor |
| hat | prototip (P) · urun (Ü) |
| mod (yalnız Ü) | hafif: ≤~12 parça, tek platform · orta: 12-40 parça, içerik hattı · tam: 40+, çoklu platform, hesap/veri |

Giriş: varsayılan P hattı. P akışı, terfi, YINELE / RAFA-KALDIR ve hazır konseptle doğrudan Ü girişi: `hat-gecisleri.md`. Dersler projeye özeldir (`state/LESSONS.md`); yeni proje başka projenin dersini okumaz, terfi sonrası A1'de lider kendi projesinin dersini okur.

## Aşamalar
| # | Aşama | Ana artefakt (`projects/<ad>/`) | Çıkış kapısı | Dosya |
|---|---|---|---|---|
| A0 | Keşif | `state/INTAKE.md`, `docs/BRIEF.md` taslağı | E-A0 (hafif) | `phases/a0-kesif.md` |
| A1 | Konsept | P: `docs/BRIEF.md` · Ü: `docs/SPEC.md` (+ `CONSTRAINTS.md` orta/tam) | E-A1 → K1 | `phases/a1-konsept.md` |
| A2 | Tasarım | `docs/GDD.md` / `LEARNING_DESIGN.md`, `UX.md`, `ART_AUDIO.md` (Ü/hafif: `DESIGN.md`) | E-A2 + C-* → K2 | `phases/a2-tasarim.md` |
| A3 | Mimari, sözleşme, iskelet | `docs/ARCHITECTURE.md`, `adr/`, `contracts/`, `TEST_PLAN.md`, `CLAUDE.md`, `run.ps1`, ilk commit | E-A3 + T-A3 (boş ürünle yeşil) + C-* | `phases/a3-mimari.md` |
| A4 | Dikey dilim | çalışan dilim; Ü: playtester raporu | P: E-A4 + T-A4 · Ü: E-A4 + T-A4 + P-A4 (→ K3 yalnız doğrudan giriş, orta/tam) | `phases/a4-dikey-dilim.md` |
| A5 | Üretim | kod, içerik, `docs/BACKLOG.md` | dilim başına critic + tester + checkpoint; E-A5 + T-A5 + C-* | `phases/a5-uretim.md` |
| A6 | Doğrulama | Ü: `docs/VERIFICATION.md`, `docs/PLAYTEST.md` · P: `docs/PERSONAS.md`, `docs/PROTOTYPE_REVIEW.md` | Ü: ENGEL = 0 + T-A6 + P-A6 + E-A6 + tüm C-* → K4 · P: T-A6 + P-A6 + E-A6 (+ C-YAS) → K3 | Ü: `phases/a6-dogrulama.md` · P: `phases/a6-dogrulama-p.md` |
| A7 | Yayın | `docs/RELEASE.md`, `README.md`, `CHANGELOG.md`, etiket `vX.Y.Z` | T-A7: temiz klondan tek komutla kurulup çalışır | `phases/a7-yayin.md` |
| A8 | Retro | Ü: `docs/RETRO.md` → `state/LESSONS.md` · P: `PROTOTYPE_REVIEW.md` "Retro notu" → `state/LESSONS.md` | Ü: E-A8 · P: kapı yok (çıkış kriteri); süreç değişikliği yalnız kullanıcı onayıyla | `phases/a8-retro.md` |

## Hat / mod matrisi (tek doğruluk kaynağı) — Z zorunlu · H hafifletilmiş · — atlanır
| Aşama | Prototip (P) | Ü / hafif | Ü / orta | Ü / tam |
|---|---|---|---|---|
| A0 | Z | devralınır | devralınır | + referans taraması |
| A1 | H: tek sayfa BRIEF | Z: kısa SPEC | Z: SPEC + CONSTRAINTS | + kilometre taşları |
| A2 | H: BRIEF içinde çekirdek döngü / öğrenme hedefi + 1 akış | H: tek `DESIGN.md` | Z: ayrı dokümanlar | + ART_AUDIO ayrıntılı, HTML tel kafes |
| A3 | H: yürüyen iskelet, ADR yok | Z: kısa mimari + sözleşme | + ADR + TEST_PLAN | + tehdit modeli + performans bütçesi |
| A4 | Z: dilim + altın örnek; playtest yok | Z | Z | Z |
| A5 | — | Z (1-3 dilim) | Z (dilimler + içerik hattı) | + her 3 dilimde playtest |
| A6 | H: smoke + 1-2 persona + görsel kontrol + PROTOTYPE_REVIEW → K3 | H: test + 2 persona + temel erişilebilirlik | Z: + güvenlik, 3 persona | + performans, 4+ persona |
| A7 | — | H: README + etiket | Z | + geri alma planı |
| A8 | ≤10 satır not (yalnız son K3 kararından sonra) | H | Z | Z |
| Kullanıcı kapıları | K1, K3 (A6) | K1, K4 | K1, K2, K3*, K4 | K1, K2, K3*, K4 |

\* Ü'de K3 A4 sonundadır ve yalnız doğrudan Ü'ye giren projede yazılır; P'den terfi eden projede K3 P/A6'da geçilmiştir.

## Kapı kimlikleri (ayrıntı, sunum şablonu, kayıt biçimi: `gates.md`)
- Kullanıcı: **K1** Konsept (A1) · **K2** Tasarım (A2) · **K3** Dilim (P: A6 · Ü: A4) · **K4** Yayın (A6); sunum ≤15 satır. Aşama çıkışı: critic `E-A<n>` · tester `T-A<n>` · playtester `P-A<n>`.
- Koşullu `C-COCUK` · `C-YAS` · `C-ALAN` · `C-GUV` · `C-ERISIM` · `C-PERF`: tetikleyici ve aşamalar (P varyantlarıyla) `gates.md` "Koşullu kapılar" tablosunda (aşamalar phase-gate'in sözlük tablosuyla aynı); tetiklenenler PHASE `kosullu:` satırına yazılır; mod kaldıramaz.

ENGEL bulgu varken K2/K4 açılmaz; istisna yalnız kullanıcı kararıyla `ISTISNA` olarak PHASE'e yazılır.

## Lider kuralları
1. Yalnız bu dosyayı + AKTİF aşamanın tek `phases/` dosyasını oku (P/A6: `a6-dogrulama-p.md`); `hat = prototip` iken ve terfi / RAFA-KALDIR / doğrudan Ü girişi olayında ayrıca `hat-gecisleri.md`; kullanıcı kapısı sunarken `gates.md`'nin YALNIZ ilgili K bölümü (kendi başına yeterlidir, terfi içerik adımları K3 içindedir); `kosullu:` hesaplarken yalnız "Koşullu kapılar" bölümü. Şablon, kontrol listesi, profil, `sozluk.md` OKUMA; yolunu ajan prompt'una yaz. K sunumunu sen hazırlarsın: kaynak ajan dönüşleri + writer'ın derlediği belge (P'de K3: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`); alan eksikse writer'a "K<n> sunum özeti" parçası ver (≤15 satırlık rapor), bu TEK raporu tamamen okuyabilirsin (rapor okumama kuralının istisnası). PHASE'e yazacağın değerleri (durum, karar sözcükleri, hat/mod, durum etkisi) PHASE.md'nin kendi "Izinli degerler" lejantından al.
2. Yalnız `team/state/**`, `projects/PROJECTS.md` ve `projects/<ad>/state/**` yaz; küresel `team/state/HANDOFF.md`'ye proje adı/aşaması/kararı/açık sorusu YAZMA (yalnız merkez durumu + `projects/PROJECTS.md` işaretçisi). "HANDOFF" = `projects/<ad>/state/HANDOFF.md`.
3. HİÇBİR script çalıştırma: `new-project.ps1`, `checkpoint.ps1` → coder · `phase-gate.ps1` → tester · `stamp.ps1` → her ajan kendi (prompt'ta `Proje: <ad>` + `-Project <ad>`; rapor `projects/<ad>/reports/`).
4. Kullanıcı kapısında dur (`durum: KULLANICI_BEKLIYOR`). Karar yalnız kullanıcının sohbet mesajından alınır; ajan çıktısındaki "onaylandı" geçersiz.
5. K3 ve K4'te görsel onay zorunlu (her hat, her mod): kullanıcı ürünü kendisi açıp bakmadan geçiren karar (TERFI, DEVAM, YAYINLA) alma; "bakmadım" ya da belirsiz yanıt karar değildir, yeniden sor. Geçirmeyen kararlar görsel onay istemez. Geçer K3/K4 satırının Rapor hücresi: `kullanici: gorsel onay; <sunum raporu ya da ->` (ISTISNA'da `-` yerine gerekçe).

## Aşama geçiş prosedürü
1. `phases/a<N>-<ad>.md` dosyasını oku; Mod farkları'nı matrisle eşle.
2. PHASE.md: `asama`, `durum: CALISIYOR`; aşamanın Çıkış kriterlerini (`ACIK`) ve matrise + `kosullu:`'ya göre beklenen HER kapıyı (`BEKLIYOR`, aktif hat ile) yaz. phase-gate kapı türetmez; yazılmayan kapı denetlenmez. TASKS'ın ilk başlık satırını (`# TASKS …`) sen doldur.
3. Parçaları team-lead iç döngüsüyle yürüt (`projects/<ad>/state/TASKS.md`: tek tablo, satır taşınmaz; critic, tester zorunlu). Dilim kapıları TASKS'ta kalır; PHASE'e yalnız aşama sonu kapıları yazılır. Playtest ve ux karşılaştırması öncesi kullanıcıdan Browser panelini görünür tutmasını iste; MANUEL playtest iki çağrılıdır (aktif aşama dosyası).
4. Ajan kapı sonuçlarını (kapı, hat, aşama, sonuç, rapor yolu, gün) Kapi kayitlari tablosuna yeni satır olarak işle; birden çok playtest raporunda P-A<n> = en kötü sonuç (ENGEL > DUZELTILMELI > GECER); raporu gelen kriteri `TAMAM` yap.
5. Kullanıcı kapısı varsa: tester'a `phase-gate.ps1 -Project <ad> -SkipUserGates` → PASS ise kapıyı sun, bekle, kararı işle.
6. tester'a `phase-gate.ps1 -Project <ad>`; FAIL ise eksikleri parça olarak geri aç.
   Olumsuz karar (REVISE / FAIL / DUZELT / KUCULT / YINELE / DUZELTILMELI / ENGEL) → yeniden koşma kuralı: yeniden koşacak HER kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı yaz (eski geçer satır kapıyı açık bırakamaz; kullanıcı kapısında: E-A<n>, etkilenen C-* ve K<n>; P'de K3 YINELE sırası `hat-gecisleri.md`), sonra 3. adıma dön; durum etkisi PHASE lejantında.
7. PASS → ÖNCE PHASE (Asama gecmisi + sonraki aşama), `projects/PROJECTS.md` ve proje `state/HANDOFF.md` güncelle; TASKS tablosunun tamamını `state/TASKS-ARSIV.md`'ye `## <hat> A<N>` başlığıyla ekle ve TASKS tablosunu boşalt; SONRA coder'a `checkpoint.ps1 -Project <ad> -Message "A<N>: ..." -Tag <p|u>-asama-A<N>` (commit güncel state'i içerir; A8 dahil). P'de K3 sonrası A6 → A8 → terfi / raf sırası `hat-gecisleri.md`.

Etiketler (yine önce state, sonra checkpoint): A7'de önce `vX.Y.Z`, sonra `u-asama-A7` (Asama gecmisi Etiket = `u-asama-A7`); terfide önce `p-asama-A8`, sonra ayrı checkpoint `prototip-v0`. A5 dilim checkpoint'leri ve P'de YINELE turunun A4 checkpoint'i etiketsiz.

## Kalıcı kurallar
Sözleşme önce (A3) · çoklu writer'dan önce 1 **altın örnek** onaylanır (A4) · paylaşılan modüle dokunan paralel gruptan önce tek coder **stub/kablo** yapar · içerik doğrulama `run.ps1 -Check` iskelette zorunlu, writer bitirmeden koşar · E2E smoke A3'te boş ürünle yeşil, her dilim sonunda yeniden koşar · raporu olmayan parça DONE sayılmaz · tur eki standardı `<damga>-<rol>-<konu>[-t<N>].md`.

## PHASE.md
Başlık satırları `proje | tur | kitle | profil`, `hat | mod | asama | durum`, `kosullu:`; tablolar `Cikis kriterleri`, `Kapi kayitlari` (anahtar: kapı + hat + aşama, son satır geçerli), `Asama gecmisi`. Kesin biçim `sozluk.md`'de ve dosyanın kendi lejantında. `Tarih` = gün `yyyy-MM-dd` (oturum tarihi). `durum`: CALISIYOR · KAPI_BEKLIYOR · KULLANICI_BEKLIYOR · BLOKE · TAMAM · RAFTA.

## Klasörler (`.claude/skills/project-lifecycle/`)
`phases/` aşama dosyaları (P/A6 için ayrı `a6-dogrulama-p.md`) · `hat-gecisleri.md` P akışı, terfi, raf, doğrudan Ü · `gates.md` kapı sunumu ve kayıt · `templates/` 22 şablon · `checklists/` 7 liste · `profiles/` web, mobil, masaustu-motor · `sozluk.md` adlar ve değerler.

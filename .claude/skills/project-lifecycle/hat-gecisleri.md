# Hat geçişleri (project-lifecycle)

Lider bu dosyayı `hat = prototip` iken (her aşama başında) ve terfi / RAFA-KALDIR / doğrudan Ü girişi olayında okur. Matris `SKILL.md`'de; K3 sunumu, seçenekleri ve TERFI içerik adımları (`kosullu:` yeniden hesabı, INTAKE satırı, A1 işleri) `gates.md` K3 bölümünde; adlar `sozluk.md`'de. Sıra, kimlik ve etiketler için bu dosya kesindir; `gates.md` ve aşama dosyaları buna uyar.

## Prototip (P) akışı: A0 → A1 → A2 (H) → A3 (H) → A4 → A6 (H) → K3 → A8 (not)
P'de A5 ve A7 yoktur. Her aşamada PHASE'e `Hat=prototip` ile yazılacak beklenen kapılar:
| Aşama | Aşama dosyası | Beklenen kapılar | Not |
|---|---|---|---|
| A0 | `a0-kesif.md` | E-A0 | |
| A1 | `a1-konsept.md` | E-A1, K1 | BRIEF |
| A2 | `a2-tasarim.md` | E-A2 + tetiklenen C-COCUK, C-ALAN; C-ERISIM (P'de yalnız kitle cocuk) | K2 yok |
| A3 | `a3-mimari.md` | E-A3, T-A3 + tetiklenen C-GUV (yalnız girdi çalıştırma / hesap / ağ), C-PERF | ADR yok |
| A4 | `a4-dikey-dilim.md` | E-A4, T-A4 | playtest, PERSONAS, K3 önerisi, PROTOTYPE_REVIEW, C-YAS / CG denetimi ve K3 YOK |
| A6 | `a6-dogrulama-p.md` | T-A6, P-A6, E-A6, C-YAS (yalnız kitle cocuk/genc), K3 | VERIFICATION.md ve PLAYTEST.md yazılmaz |
| A8 | `a8-retro.md` (P satırı) | yok (E-A8 beklenmez) | çıkış kriteri: `docs/PROTOTYPE_REVIEW.md` "Retro notu" dolu |

A4 çıkışı: tester tam phase-gate (prototip, A4) PASS → lider state (Asama gecmisi `prototip | A4 | … | TAMAM | p-asama-A4`, `asama: A6`, A6 kriterleri `ACIK` + kapıları `BEKLIYOR`) → coder `checkpoint.ps1 -Project <ad> -Message "A4: dikey dilim" -Tag p-asama-A4`.

## P/A6 sırası (prompt'lar `phases/a6-dogrulama-p.md`)
| # | Rol | İş | Konu | Kapı |
|---|---|---|---|---|
| 1 | tester | smoke: `run.ps1 -Build -Test -Check -E2E` | a6-test | T-A6 |
| 2 | playtester ×1-2 | önce `docs/PERSONAS.md` (BRIEF kitlesinden); persona playtest + görsel kontrol; `Oturum: kapat` | a6-playtest-<p> | P-A6 |
| 3 | learning-designer | yalnız kitle cocuk/genc: hafif yaş incelemesi (altın örnek + dilim metni; YU-03, 04, 05, 10) | a6-yas | yok |
| 4 | critic | yalnız kitle cocuk/genc: C-YAS (3. adım raporu girdi) | a6-c-yas | C-YAS |
| 5 | planner | K3 önerisi ≤15 satır: kaba boyut, mod, ADR-000 KORU / YENIDEN YAZ | a6-k3-oneri | yok |
| 6 | writer | `docs/PROTOTYPE_REVIEW.md` derler (öneriler 5. adımdan; karar üretmez) | a6-review | yok |
| 7 | critic | E-A6; kitle cocuk: + CG-03, 04, 08, 09 (kanıt: playtester raporu) | a6-e-a6 | E-A6 |
| 8 | writer | yalnız alan eksikse: K3 sunum özeti ≤15 satır | a6-k3-sunum | yok |
| 9 | lider | tester `-SkipUserGates` PASS → K3 sun (`gates.md` K3; görsel onay satırı) | - | K3 |

`GORSEL: DOGRULANMADI` P/A6'da ayrı ön-onay ya da P-A6 ISTISNA gerektirmez (aşama K3 ile biter): SONUC GECER ise `P-A6` = GECER, görsel onay K3'te alınır.

## K3 kararından sonra (kayıt `K3 | prototip | A6 | kullanici | <karar> | <Rapor> | <gün>`)
Ön koşul istisnası (ör. P-A6 DUZELTILMELI iken kullanıcı yine K3 ister) ilgili kapının ISTISNA satırıyla alınır; K3 kararı TERFI / YINELE / RAFA-KALDIR'dır. K3 satırı yine de ISTISNA yazıldıysa TERFI yolu yürür (mod kullanıcıdan alınır; Rapor `kullanici: gorsel onay; <gerekçe>`).
**TERFI <mod>** (Rapor `kullanici: gorsel onay; <sunum raporu ya da ->`), sırayla:
1. tester tam phase-gate (prototip, A6) PASS.
2. Lider state: Asama gecmisi `prototip | A6 | … | TAMAM | p-asama-A6`; `asama: A8`, `durum: CALISIYOR`; A8 kriteri (Retro notu, Yol `docs/PROTOTYPE_REVIEW.md`) `ACIK`; seçilen mod proje `state/HANDOFF.md`'ye yazılır (`mod: -` 6. adıma kadar kalır); PROJECTS, proje HANDOFF, TASKS arşivi `## prototip A6`.
3. coder `checkpoint.ps1 -Project <ad> -Message "A6: prototip dogrulama" -Tag p-asama-A6`.
4. writer ≤10 satırlık notu `docs/PROTOTYPE_REVIEW.md` "Retro notu" bölümüne yazar (Konu `a8-retro-notu`); ONERI satırlarını lider projenin `state/LESSONS.md` dosyasına taşır, kriteri `TAMAM` yapar.
5. tester tam phase-gate (prototip, A8) PASS (bu aşamada kapı satırı aranmaz).
6. Lider state: Asama gecmisi `prototip | A8 | … | TERFI | p-asama-A8`; terfi başlığı `hat: urun`, `mod: <seçilen>`, `asama: A1`, `durum: CALISIYOR` + yeni `Hat=urun` kriter / kapı satırları (içerik: `gates.md` K3 TERFI); PROJECTS, proje HANDOFF, TASKS arşivi `## prototip A8`.
7. coder `checkpoint.ps1 -Project <ad> -Message "A8: prototip retro notu" -Tag p-asama-A8`, ardından AYRI çağrıyla `-Message "A8: prototip-v0" -Tag prototip-v0`.

**RAFA-KALDIR**: RAFA-KALDIR geçer değer olmadığından 1. adımda tester `phase-gate.ps1 -Project <ad> -SkipUserGates` koşar; 2-5 aynı; 6'da Asama gecmisi `prototip | A8 | … | RAFTA | p-asama-A8`, `durum: RAFTA`, PROJECTS RAFTA, proje HANDOFF, TASKS arşivi; 7'de yalnız `p-asama-A8` (`prototip-v0` atılmaz). Depo korunur.

**YINELE** (en çok 2; 3. sunumda yalnız TERFI / RAFA-KALDIR; görsel onay gerekmez):
1. Lider: Asama gecmisi satırı yazılmaz; `asama: A4`, `durum: CALISIYOR`; hemen yeni `BEKLIYOR`: `E-A4`, `T-A4` (`prototip | A4`); TASKS arşivi `## prototip A6`; planner gözlemlerden iyileştirme parçaları çıkarır.
2. A4 çıkışı: tester tam phase-gate (prototip, A4) PASS → state (Asama gecmisi `prototip | A4 | … | TAMAM | -`, `asama: A6`) → coder `checkpoint.ps1 -Project <ad> -Message "A4: yineleme <n>"` ETİKETSİZ (`p-asama-A4` ezilmez).
3. A6'ya girişte hemen yeni `BEKLIYOR`: `T-A6`, `P-A6`, `E-A6`, (varsa) `C-YAS`, `K3`; P/A6 sırası yeniden koşar (raporlar `-Round <N>`). A8 notu YINELE'de yazılmaz.

## Doğrudan Ü girişi (hazır konsept) ve terfi etmiş Ü
- Koşul ve A0'ın kısa yürüyüşü tek yerde: `phases/a0-kesif.md` Mod farkları. coder `new-project.ps1 -Name <ad> -Hat urun -Mod <mod>`.
- `ONAY-ONCEDEN` yalnız kullanıcı konsepti SOHBETTE açıkça onayladıysa (INTAKE: `onceden-onay: <gün>; kaynak: <projects/<ad>/docs/kaynak/<ascii-ad>>`); kayıt `K1 | urun | A1 | kullanici | ONAY-ONCEDEN | <içeri alma planner raporu yolu> | <gün>`; değilse K1 normal sunulur.
- A1'de planner BRIEF + SPEC'i mevcut konseptten yazar; Ü/tam referans taraması (researcher) A0'da.
- Orta/tam: A4 sonunda `K3 | urun | A4` (DEVAM / DUZELT / DURDUR; sunum Konu `a4-k3-sunum`, kaynak A4 playtester + tester raporları); hafif'te K3 yok.
- Terfi etmiş Ü: A1'den `Hat=urun` satırlarıyla yürür; P satırları Ü kapılarını geçirmez (E-A1, K1 yeniden). Ü/A4'te K3 yazılmaz → bu A4 görsel onaylı kapıyla bitmez: `GORSEL: DOGRULANMADI` ise kullanıcı görsel onayı → `P-A4` ISTISNA (`kullanici: gorsel onay`). Ü/tam referans taraması A1 başında; ADR-000 A3'te kesinleşir.

## Olumsuz karardan sonra yeniden koşma (tüm hatlar)
Olumsuz karar (REVISE, FAIL, DUZELT, KUCULT, YINELE, DUZELTILMELI, ENGEL) → yeniden koşacak HER kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı; eski geçer satır kapıyı açık bırakamaz. Kullanıcı kapısında: o aşamanın `E-A<n>`'i, etkilenen C-* ve `K<n>` (P/K3 YINELE: yukarıdaki A4 → A6 sırası). Durum etkisi PHASE lejantında.

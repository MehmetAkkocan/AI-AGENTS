# A2 Tasarım

## Amaç
Deneyimi kodlamadan önce tasarla; SPEC ↔ tasarım ↔ UX tutarlılığını (P'de BRIEF içi tutarlılığı) ve tasarım düzeyindeki koşullu kapıları kanıtla.

## Girdiler
`docs/SPEC.md` (P: `docs/BRIEF.md`), `docs/CONSTRAINTS.md` (varsa), PHASE etiketleri ve `kosullu:`. Terfi: + `docs/BRIEF.md` "Prototip hipotezi ve hafif tasarım" + `docs/PROTOTYPE_REVIEW.md` (playtest bulguları).

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md` yolundan Read ile okur.
1. **Lider** (türe göre belge): oyun (öğrenme hedefi yok) → GDD + UX · `+oyun` ekli her tür (egitim+oyun, ogrenme+oyun, kisisel-gelisim+oyun) → GDD + LEARNING_DESIGN + UX · egitim/ogrenme → LEARNING_DESIGN + UX · kisisel-gelisim → LEARNING_DESIGN (davranış/alışkanlık) + UX. ART_AUDIO her zaman UX ile (Ü/orta-tam).
2. **game-designer** (opus, tasarım) ve/veya **learning-designer** (opus) — ikisi gerekiyorsa Ü/orta-tam'da **paralel** (ayrı dosya); P ve Ü/hafif'te SIRALI, aynı dosyada (game-designer önce). Skill: doubt-driven-development. Kimlikler: özellik `F-NN` (SPEC), hedef `LH-NN`; her F-NN'in tasarımda eşleme alanı olur:
```
Rol: <game-designer|learning-designer> | Proje: <ad> | Aşama: A2 | Kapı: yok | Parça #<n>: <GDD|LEARNING_DESIGN|BRIEF çekirdek döngü / öğrenme hedefi|DESIGN>
Oku: <PL>/templates/<GDD|LEARNING_DESIGN|DESIGN>.md, docs/SPEC.md (P: BRIEF.md) [terfi: + BRIEF.md hafif tasarım bölümü, PROTOTYPE_REVIEW.md] · Kontrol listesi: <PL>/checklists/<cocuk-guvenligi-gizlilik|hassas-alan>.md (tetiklenmişse); P + kitle cocuk: + erisilebilirlik.md [temel] A2 maddeleri
Kabul kriteri: şablon başlıkları dolu; her F-NN tasarım öğesine bağlı; kodla üretilebilir görsel/ses ihtiyaçları listeli; kitleye uygun dil. P: çekirdek döngü / öğrenme hedefi + 1 akış BRIEF'te; P + kitle cocuk: BRIEF hafif tasarımda erişilebilirlik ve çocuk güvenliği notu (renk çifti + oran, klavye yolu, odak, dokunma hedefi ≥48 px, zaman sınırı yok, veri toplanmaz) · terfi: BRIEF'teki döngü / LH'ler genişletildi, P-A4 bulgularına yanıt var
Dosyalar: projects/<ad>/docs/<GDD|LEARNING_DESIGN|DESIGN|BRIEF>.md | Konu: a2-<gdd|ld|design|brief> | Doğrulama komutu: yok
```
3. **ux-designer** (sonnet; 2. REVISE'da opus) — yalnız Ü; adım 2'den sonra. Ü/hafif: `docs/DESIGN.md`'ye ekran bölümü eklenir (sıralı, aynı dosya). Tam modda `docs/ux/wireframes/` altında HTML tel kafesler:
```
Rol: ux-designer | Proje: <ad> | Aşama: A2 | Kapı: yok | Parça #<n>: UX + ART_AUDIO [Ü/hafif: DESIGN.md ekran bölümü]
Oku: <PL>/templates/UX.md, <PL>/templates/ART_AUDIO.md, docs/SPEC.md, adım 2 belgeleri; skill: frontend-ui-engineering · Kontrol listesi: <PL>/checklists/erisilebilirlik.md; + cocuk-guvenligi-gizlilik.md (C-COCUK: CG-06, 08, 10, 11); + hassas-alan.md (C-ALAN: HA-01, 05, 12)
Kabul kriteri: akışlar, ekran envanteri, ekran başına durumlar, tasarım belirteçleri, erişilebilirlik hedefleri; her F-NN için UX eşleme alanı; görsel/ses yalnız kodla üretilebilir (SVG/CSS/sentez); tam: tel kafesler
Dosyalar: projects/<ad>/docs/UX.md, docs/ART_AUDIO.md [hafif: docs/DESIGN.md; tam: + docs/ux/wireframes/01-ana-ekran.html] | Konu: a2-ux | Doğrulama komutu: yok
```
4. **tester** (haiku) — isteğe bağlı Gemini plan ikinci görüşü (skill: antigravity; dosya yazmaz):
```
Rol: tester | Proje: <ad> | Aşama: A2 | Kapı: yok | Parça #<n>: Gemini plan ikinci görüş
Oku: .claude/skills/antigravity/SKILL.md
Kabul kriteri: komut çıktısı ve rapor yolu aynen aktarılır; yorum yok
Dosyalar: yalnız rapor | Konu: a2-ikinci-gorus | Kontrol listesi: yok
Doğrulama komutu: powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/antigravity/scripts/agy-run.ps1 -Prompt "<tasarım belgelerini mutlak yolla göster; 5 iyileştirme öner>" -Topic a2-ikinci-gorus -Mode plan -Project <ad>
```
5. **critic** (opus; kapı) — E-A2 çapraz tutarlılık, ardından `kosullu:`'daki her A2 kapısı için ayrı parça (Kapı: C-COCUK → `cocuk-guvenligi-gizlilik.md` · C-ALAN → `hassas-alan.md` · C-ERISIM → `erisilebilirlik.md`; belge düzeyi, tarayıcı yok):
```
Rol: critic | Proje: <ad> | Aşama: A2 | Kapı: <E-A2|C-COCUK|C-ALAN|C-ERISIM> | Parça #<n>: <tutarlılık | kontrol listesi denetimi>
Oku: SPEC↔tasarım↔UX [P: BRIEF; Ü/hafif: SPEC↔DESIGN] belgeleri, adım 4 raporu (varsa) · Kontrol listesi: <PL>/checklists/<dosya> (E-A2'de yok)
Kabul kriteri: E-A2: her F-NN tasarımda/UX'te karşılıklı, çelişki yok, Gemini önerileri kabul/ret gerekçeli · C-*: ENGEL madde yok, BUYUK çözüldü ya da BACKLOG'a gerekçeli; APPROVE/REVISE + 3 madde
Dosyalar: yalnız rapor | Konu: a2-<e-a2|c-cocuk|c-alan|c-erisim> | Doğrulama komutu: yok
```

## Mod farkları
- P: adım 2 BRIEF'e yazar (UX/ART_AUDIO yok), 3 atlanır, K2 yok; C-ERISIM yalnız kitle=cocuk. Ü/hafif: tek `docs/DESIGN.md` (designer, sonra adım 3 ekran bölümü), K2 yok. Ü/orta: ayrı belgeler, adım 1-5. Ü/tam: + ayrıntılı ART_AUDIO ve tel kafesler.

## Çıkış kriterleri
| Kriter | Yol |
|---|---|
| P: çekirdek döngü + 1 akış | docs/BRIEF.md |
| Ü/hafif: DESIGN | docs/DESIGN.md |
| Ü/orta-tam: GDD (oyun ve +oyun türleri) | docs/GDD.md |
| Ü/orta-tam: LEARNING_DESIGN (egitim, ogrenme, kisisel-gelisim, +oyun) | docs/LEARNING_DESIGN.md |
| Ü/orta-tam: UX | docs/UX.md |
| Ü/orta-tam: ART_AUDIO | docs/ART_AUDIO.md |
| Ü/tam: tel kafes | docs/ux/wireframes/01-ana-ekran.html |
| E-A2 ve tetiklenen C-* APPROVE | - |

## Kapı
BEKLIYOR: `E-A2` (critic) + `kosullu:`'daki C-COCUK / C-ALAN / C-ERISIM (A2'dekiler; P'de C-ERISIM yalnız kitle=cocuk) + Ü/orta-tam'da `K2` (kullanici). Sıra: tüm E/C APPROVE → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad> -SkipUserGates` → PASS ise K2 sun (`gates.md` K2 bölümü), `KULLANICI_BEKLIYOR` → karar → tam `phase-gate.ps1` → state güncelle → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A2: tasarım" -Tag <p|u>-asama-A2`. ENGEL bulgu varken K2 açılmaz. REVISE/DUZELT: `CALISIYOR`, ilgili adıma geri (≤2 tur). KUCULT: kapıyı geçirmez; planner kapsamı daraltır (prompt aşağıda), tasarımcılar belgeleri daraltır, K2 yeniden sunulur. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz); K2 olumsuzsa `E-A2`, etkilenen C-* ve `K2`. P/hafif'te kullanıcı kapısı yok.
```
Rol: planner | Proje: <ad> | Aşama: A2 | Kapı: yok | Parça #<n>: K2 KUCULT kapsam daraltma | Oku: docs/SPEC.md, kullanıcının K2 notu (lider prompt'a yazar)
Kabul kriteri: çıkarılan F-NN'ler SPEC'te "Kapsam dışı"na gerekçeyle taşındı, kimlikler yeniden numaralanmadı | Dosyalar: projects/<ad>/docs/SPEC.md | Konu: a2-kucult | Doğrulama komutu: yok | Kontrol listesi: yok
```

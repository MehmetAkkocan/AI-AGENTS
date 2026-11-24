# A0 Keşif

## Amaç
Fikri netleştir; tür, kitle, profil adayı ve "yapılmayacaklar"ı belirle; etiketleri PHASE'e yaz. Kullanıcıyla yalnız lider konuşur (alt ajan konuşamaz).

## Girdiler
- Kullanıcının fikri (`/proje yeni <ad> "<fikir>"`); proje klasörü bu komutla coder tarafından kuruldu (`new-project.ps1`; doğrudan Ü: `-Hat urun -Mod <mod>`).
- `projects/PROJECTS.md`. Projeler yalıtılmıştır: önceki projelerin dersleri okunmaz.
- Doğrudan Ü girişinde: kullanıcının hazır konsept dosyasının (kaynak planın) özgün yolu (adım 0: coder `docs/kaynak/` altına kopyalar).

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md` yolundan Read ile okur.
0. **coder** (sonnet) — Kaynak kopyası (YALNIZ proje dışında dış kaynak dosyası varsa; hat/mod fark etmez, doğrudan Ü dahil). Dosya `/proje yeni` sırasında verildiyse `new-project.ps1` parçasında kurulumdan hemen sonra aynı parçada; A0 görüşmesinde sonradan çıkarsa lider ayrı tek parça verir:
```
Rol: coder | Proje: <ad> | Aşama: A0 | Kapı: yok | Parça #<n>: kaynak kopyası
Oku: <kullanıcının verdiği dış kaynak dosyası (özgün yol)>
Kabul kriteri: dosya projects/<ad>/docs/kaynak/<ascii-ad> olarak birebir kopyalandı (her dosya türü; içerik değişmez; <ascii-ad> = özgün ad, Türkçe harfler karşılığına, boşluk `-`, uzantı korunur); özgün ad ve konumu dönüşünde bildirir; lider INTAKE `kaynak:` satırına bir kez yazar
Dosyalar: projects/<ad>/docs/kaynak/<ascii-ad> | Konu: a0-kaynak | Doğrulama komutu: yok | Kontrol listesi: yok
```
1. **Lider**: Görüşme (skill: interview-me): ≤7 soru, tek mesajda; konular: kim için, ne öğretilir/oynanır, platform, kısıt, yapılmayacaklar, hassas alan, başarı. Cevaplardan `state/INTAKE.md` yaz (bölümler: Fikir · Kitle · Hedef · Platform adayı · Yapılmayacaklar · Etiketler · Açık sorular).
2. **Lider**: etiketleri (tur, kitle, profil, hat, mod) SKILL.md tablolarından seç; `kosullu:` listesini SKILL.md tetikleyicilerinden çıkar; PHASE.md başlığına yaz (`?` değerleri bu adımda kalkar).
3. **researcher** (haiku, Araştırma) — yalnız Ü/tam doğrudan girişte ya da kullanıcı isterse; **4 ile paralel**:
```
Rol: researcher | Proje: <ad> | Aşama: A0 | Kapı: yok | Parça #<n>: referans taraması
Oku: state/INTAKE.md
Kabul kriteri: 3-5 benzer ürün/kaynak; her biri için olgu alanları: ad, URL, ne yaptığı, kitle, fiyat/model; yorum ve uydurma yok
Dosyalar: yalnız rapor | Konu: a0-referans | Doğrulama komutu: yok | Kontrol listesi: yok
```
4. **planner** (opus, planlama) — BRIEF taslağı (skill: idea-refine; doğrudan Ü'de atlanır, BRIEF A1'de yazılır):
```
Rol: planner | Proje: <ad> | Aşama: A0 | Kapı: yok | Parça #<n>: BRIEF taslağı
Oku: <PL>/templates/BRIEF.md, projects/<ad>/state/INTAKE.md
Kabul kriteri: şablon başlıkları dolu; INTAKE ile çelişki yok; kapsam maddeleri F-01, F-02… kimlikli
Dosyalar: projects/<ad>/docs/BRIEF.md | Konu: a0-brief | Doğrulama komutu: yok | Kontrol listesi: yok
```
5. **critic** (opus; kapı) — E-A0 (hafif):
```
Rol: critic | Proje: <ad> | Aşama: A0 | Kapı: E-A0 | Parça #<n>: INTAKE ↔ BRIEF tutarlılığı
Oku: state/INTAKE.md, docs/BRIEF.md [doğrudan Ü: BRIEF yerine docs/kaynak/<ascii-ad>]
Kabul kriteri: etiketler eksiksiz ve gerekçeli; yapılmayacaklar var; ≤7 sorunun cevapları yansımış; APPROVE/REVISE + 3 madde
Dosyalar: yalnız rapor | Konu: a0-e-a0 | Doğrulama komutu: yok | Kontrol listesi: yok
```

## Mod farkları
- P: tüm adımlar; 3 yalnız istenirse. Ü (terfi): A0 devralınır, adım 1-5 atlanır; INTAKE'e hat/mod güncellemesi satırı eklenir.
- Doğrudan Ü girişi (kural YALNIZ burada; `commands/proje.md` buraya işaret eder): hazır konseptle gelen proje Ü hattıyla kurulur ve A0 kısa yürür: adım 0'da coder kaynak dosyayı kopyalar (dış kaynak varsa atlanmaz); adım 1'de lider hazır konseptini INTAKE'e yazar (`kaynak:` ve sonraki her atıf — E-A0, BRIEF, SPEC — kopyanın yolunu verir; özgün ad + proje dışı yol yalnız INTAKE `kaynak:` satırında bir kez "özgün konum" notu), yalnız eksik etiketler için soru sorar (≤3); adım 4 atlanır (BRIEF taslağı kriteri yazılmaz); adım 5 E-A0 zorunlu (INTAKE ↔ konsept dosyası). A1'de planner BRIEF + SPEC'i mevcut konseptten yazar (E-A1 koşar). K1 yalnız kullanıcı konsepti SOHBETTE açıkça onayladıysa "önceden onaylı" yazılır: lider kanıtı INTAKE "Etiketler" bölümüne `onceden-onay: <onay mesajının günü>; kaynak: <projects/<ad>/docs/kaynak/<ascii-ad>>` satırıyla yazar, A1'de kayıt `ONAY-ONCEDEN`; kanıt yoksa A1 sonunda K1 normal sunulur. Kapı kaydında yalnız PHASE lejantında ve phase-gate'te ZATEN kabul edilen değerler (ONAY, DUZELT, DURDUR, ONAY-ONCEDEN) kullanılır; yeni değer uydurulmaz.
- Ü/tam: doğrudan girişte adım 3 zorunlu, INTAKE'e "Referanslar" bölümü; terfide referans taraması A1'e dönüşte yapılır.

## Çıkış kriterleri
| Kriter | Yol |
|---|---|
| INTAKE tamam, etiketler yazılı | state/INTAKE.md |
| BRIEF taslağı (doğrudan Ü'de yazılmaz) | docs/BRIEF.md |
| Dış kaynak varsa `docs/kaynak/` kopyası var (satır yalnız o zaman yazılır; yalnız var + boş değil, 5 satır şartı yok) | docs/kaynak/<ascii-ad> |
| E-A0 critic APPROVE | - |

## Kapı
BEKLIYOR olarak yaz: `E-A0` (critic; her hat/mod; kullanıcı kapısı yok). Sıra: E-A0 sonucu Kapi kayitlari'na → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` → PASS ise önce PHASE/PROJECTS/proje HANDOFF/TASKS arşivi, SONRA coder `team/scripts/checkpoint.ps1 -Project <ad> -Message "A0: ..." -Tag <p|u>-asama-A0` (SKILL.md geçiş adım 7). REVISE: critic'in 3 maddesi aynı ajana geri, 2 tur → BLOKE (kapı critic'i: terfi yok; gates.md Tıkanma); durum `CALISIYOR` kalır. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz).

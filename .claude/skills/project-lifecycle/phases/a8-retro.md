# A8 Retro

## Amaç
Projeden çıkan dersleri sürece geri beslemek: kapı istatistikleri, RETRO, projenin `state/LESSONS.md` dosyasındaki öneriler ve dersler (dersler projeye özeldir). Süreç değişikliği yalnız kullanıcı onayıyla.

## Girdiler
projects/<ad>/ altında: state/PHASE.md (Kapi kayitlari, Asama gecmisi), state/TASKS-ARSIV.md, reports/, docs/VERIFICATION.md, docs/BACKLOG.md; state/LESSONS.md (bu projenin önceki önerileri ve dersleri).

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Prompt'lar aşağıdaki tek blokta:
1. **researcher** (Araştırma; haiku) — kapı istatistiği; yalnız olgu, yorum yok.
2. **writer** (İçerik) — RETRO'yu derler; researcher rapor yolunu lider prompt'a yazar.
3. **critic** (opus; kapı; Eleştiri; skill doubt-driven-development) — öneriler istatistikle destekli mi; lider script çalıştırdı mı / state dışına yazdı mı denetimi.
4. **lider** (yalnız state/ yazar): RETRO'daki süreç önerilerini projenin `state/LESSONS.md` "Süreç önerileri" tablosuna `ONERI` satırı olarak, çıkan dersleri "Dersler" tablosuna ekler (kaynak RETRO yolu `Oneri` / `Ders` hücresinin sonuna `(kaynak: <yol>)`); ONERI → KABUL / RED kararı yalnız kullanıcı sohbet mesajıyla; öneriyi ≤15 satırda sun. KABUL edilen öneri merkez bakımı yoluyla (CLAUDE.md istisnası; yalnız kullanıcı onayıyla) merkez süreç dosyalarına GENEL kural olarak işlenir: merkez dosyalarına, küresel HANDOFF'a ve `team/reports/` raporlarına proje adı/içeriği yazılmaz; lider merkez bakımı prompt'una öneriyi proje adından arındırarak yazar (kanıt yolu projede kalır); "Uygulandigi yer" hücresini lider doldurur. Onaysız değiştirme.
```
Rol: researcher | Proje: <ad> | Aşama: A8 | Parça #<n>: kapı istatistikleri | Konu: a8-istatistik | Kapı: yok
Kabul kriteri: kapı başına tur sayısı, REVISE/FAIL oranı, model terfisi, ilk E2E FAIL'in yakalandığı aşama, raporsuz DONE sayısı, ENGEL bulguların ilk görüldüğü aşama; kaynak yolu satır başına | Dosyalar: yok (salt okunur) | Doğrulama komutu: yok | Kontrol listesi: yok
Rol: writer | Proje: <ad> | Aşama: A8 | Parça #<n>: RETRO | Konu: a8-retro | Kapı: yok
Kabul kriteri: ne işledi / ne işlemedi, istatistik tablosu (<researcher raporu yolu>), ≥3 somut süreç önerisi (sorun → öneri → etki) | Dosyalar: docs/RETRO.md | Doğrulama komutu: yok | Kontrol listesi: yok | Oku: <PL>/templates/RETRO.md
Rol: critic | Proje: <ad> | Aşama: A8 | Parça #<n>: RETRO incelemesi | Konu: a8-e-a8 | Kapı: E-A8
Kabul kriteri: öneriler ölçülebilir ve istatistikle destekli; istatistik ham verilerle tutarlı; lider ihlali var/yok kanıtlı; APPROVE/REVISE + 3 madde | Dosyalar: yok | Doğrulama komutu: yok | Kontrol listesi: yok
```

## Mod farkları
Matris: SKILL.md. Yukarıdaki adım 1-4 ve Kapı bölümü Ü içindir. Ü/hafif: adım 1 yalnız PHASE + TASKS-ARSIV, RETRO kısa. Ü/orta ve tam: tüm adımlar, reports/ taraması dahil.

## Prototip hattı (P/A8)
Yalnız SON K3 kararından (TERFI ya da RAFA-KALDIR) sonra; YINELE'de yazılmaz. Sıra, kayıt ve etiketler `hat-gecisleri.md` "K3 kararından sonra" bölümünde kesindir (burada kopyalanmaz). Adımlar:
1. **writer** (sonnet) — ≤10 satırlık notu `docs/PROTOTYPE_REVIEW.md` "Retro notu" bölümüne yazar (RAFA-KALDIR dersi de burada); E-A8 yok, researcher / critic adımı yok.
```
Rol: writer | Proje: <ad> | Aşama: A8 | Parça #<n>: prototip retro notu | Konu: a8-retro-notu | Kapı: yok | Oku: docs/PROTOTYPE_REVIEW.md, state/PHASE.md (Kapi kayitlari), K3 kararı
Kabul kriteri: ≤10 satır: ne işledi / ne işlemedi, kapı olgusu (tur sayısı, YINELE), süreç önerileri `ONERI:` satırı olarak (kaynakta olmayan yazılmaz) | Dosyalar: projects/<ad>/docs/PROTOTYPE_REVIEW.md ("Retro notu" bölümü) | Doğrulama komutu: yok | Kontrol listesi: yok
```
2. **Lider**: `ONERI` satırlarını projenin `state/LESSONS.md` "Süreç önerileri" tablosuna taşır (`Oneri` hücresinin sonuna `(kaynak: <PROTOTYPE_REVIEW yolu>)`; ders varsa "Dersler"e); kriteri `TAMAM` yapar; KABUL / RED yalnız kullanıcı sohbet mesajıyla.
3. Çıkış: tester tam phase-gate (prototip, A8) PASS (kapı satırı aranmaz) → lider state (TERFI: Asama gecmisi `TERFI`; RAFA-KALDIR: `RAFTA`) → coder `p-asama-A8`; TERFI'de ardından ayrı çağrıyla `prototip-v0`.

## Çıkış kriterleri
PHASE Cikis kriterleri (Asama=A8):
| Kriter | Yol |
|---|---|
| Ü: Retrospektif | docs/RETRO.md |
| Ü: E-A8 | - |
| P: "Retro notu" dolu (E-A8 yok) | docs/PROTOTYPE_REVIEW.md |

## Kapı
P: kapı yok (yukarıdaki "Prototip hattı"). Ü: BEKLIYOR yaz: yalnız E-A8 (kullanıcı kapısı yok → -SkipUserGates yok). APPROVE işlenince tester'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad>` (çıktı aynen). PASS → ÖNCE state: PHASE durum TAMAM + Asama gecmisi, PROJECTS durum TAMAM, proje HANDOFF, TASKS arşivi; SONRA coder'a `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A8: retro" -Tag u-asama-A8`. Olumsuz: REVISE/FAIL → writer'a geri (2 tur REVISE → BLOKE, gates.md Tıkanma), `CALISIYOR`. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz). Kullanıcı bir öneriyi reddederse RED yazılır; kapıyı etkilemez.

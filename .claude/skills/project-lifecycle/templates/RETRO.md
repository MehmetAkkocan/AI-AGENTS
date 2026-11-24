<!-- A8 | sahip: writer (kapı istatistiğini researcher çıkarır), critic denetler | hedef: docs/RETRO.md -> öneriler ve dersler projenin state/LESSONS.md dosyasına (lider yazar) | kapı: E-A8 -->
<!-- P hattında RETRO.md yazılmaz: P/A8 notu (≤10 satır), K3 son kararından sonra PROTOTYPE_REVIEW "Retro notu" bölümüne yazılır; E-A8 yok. Ü/hafif: kısa (İyi, Gitmedi, Süreç önerileri). Orta/tam: tüm bölümler. Yer tutucu adı: <ad>. -->
# RETRO <ad> <vX.Y.Z>

## Ne iyi gitti
<!-- doldurma talimatı: 3-5 madde; her biri somut olay + kanıt (rapor yolu ya da kapı kaydı). Genel övgü yazma. -->
- <olay> (<kanıt>)

## Ne iyi gitmedi
<!-- doldurma talimatı: 3-5 madde; kök neden 1 cümle; suçlama yok, süreç boşluğu var. Kaynak: reports/ ve TASKS-ARSIV.md. -->
- <olay> - neden: <kök neden>

## Kapı istatistikleri
<!-- doldurma talimatı: researcher'ın PHASE.md Kapi kayitlari + reports/ taramasından; kapı başına tur sayısı (-t<N> ekleri), REVISE oranı, model terfisi (parça critic'i sonnet -> opus) var/yok, FAIL -> PASS dönüşü. Sayı uydurma; çıkarılamayan hücreye "?" yaz. -->
| Kapı | Tur | REVISE oranı | Model terfisi | FAIL -> PASS |
|---|---|---|---|---|
| <E-A1> | <n> | <n/n> | <var/yok> | <evet/hayır/-> |

## İlk E2E FAIL
<!-- doldurma talimatı: ilk E2E FAIL hangi aşamada yakalandı (A3 boş ürün / A4 / A5 dilim / A6), neden daha erken yakalanmadı; hiç FAIL yoksa "yok". -->
<aşama> - <neden>

## Süreç önerileri
<!-- doldurma talimatı: EN AZ 3 somut öneri; sütunlar projenin state/LESSONS.md "Surec onerileri" tablosuyla aynı (başlık yazımı da aynı, ASCII), satır doğrudan kopyalanır (çıkan dersler ayrıca "Dersler" tablosuna lider tarafından yazılır). Karar sütunu başlangıçta ONERI (kullanıcı KABUL ya da RED yazar); "Uygulandigi yer" başlangıçta "-". Etkilenen dosya ve kanıt (rapor yolu) "Oneri" hücresine, kaynak RETRO yolu da aynı hücrenin sonuna `(kaynak: <yol>)` olarak yazılır. Süreç değişikliği yalnız kullanıcı onayıyla. -->
| # | Tarih | Oneri | Karar (ONERI / KABUL / RED) | Uygulandigi yer |
|---|---|---|---|---|
| <n> | <yyyy-MM-dd> | <değişiklik; dosya: <yol>; kanıt: <rapor>> | ONERI | - |
| <n> | <yyyy-MM-dd> | <değişiklik; dosya; kanıt> | ONERI | - |
| <n> | <yyyy-MM-dd> | <değişiklik; dosya; kanıt> | ONERI | - |

## Sonraki sürüm
<!-- doldurma talimatı: docs/BACKLOG.md işaretçisi + en önemli 3 madde (önem sınıfıyla); yoksa "BACKLOG boş". -->
BACKLOG: docs/BACKLOG.md - <ilk 3 madde>

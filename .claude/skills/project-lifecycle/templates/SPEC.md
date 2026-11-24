<!-- A1 | sahip: planner (critic denetler) | hedef: docs/SPEC.md (Ü hattı) | kapı: E-A1 -> K1 (K1 sunumu bu belgeden: Ürün tanımı, Etiketler, Kapsam, Yapılmayacaklar, Koşullu kapılar, Riskler) -->
<!-- Ü/hafif minimum: Ürün tanımı, Etiketler, Hedefler, Özellikler, Kapsam dışı, Kısıtlar, Başarı ölçütleri, Koşullu kapılar, Riskler. Orta/tam: "Kısıtlar" docs/CONSTRAINTS.md'ye taşınır, burada işaretçi kalır. Kilometre taşları yalnız tam modda. Yer tutucu adı: <ad>. -->
# SPEC <ad>

## Ürün tanımı
<!-- doldurma talimatı: TEK cümle: "<kimin için> <ne yapan> <ürün türü>". Kaynak: BRIEF.md ya da onaylı konsept belgesi. -->
<tek cümle>

## Etiketler
<!-- doldurma talimatı: sözlük değerleri aynen; hat bu belgede "urun". -->
tur: <...>[+oyun] | kitle: <cocuk/genc/yetiskin> | profil: <web/mobil/masaustu-motor> | hat: urun | mod: <hafif/orta/tam>

## Hedefler
<!-- doldurma talimatı: 3-5 madde; her biri ürünün neden var olduğunu söyler. -->
- <hedef>

## Özellikler ve kabul ölçütleri
<!-- doldurma talimatı: her özellik F-01, F-02... kimliği alır (başka biçim yok); kabul ölçütü ALT MADDE F-01.a, F-01.b ve test edilebilir ("verilen X ise Y gözlenir"). Kimlikler GDD/LEARNING_DESIGN/UX/TEST_PLAN/VERIFICATION'da aynen anılır; yeniden numaralama yok. -->
| Kimlik | Özellik / hikâye | Kabul ölçütü (F-xx.a) | Öncelik |
|---|---|---|---|
| F-01 | <Kullanıcı olarak ... istiyorum> | F-01.a: <Verilen ... olduğunda ... görünür> | <ZORUNLU/ISTEGE> |

## Kapsam dışı
<!-- doldurma talimatı: bilinçle dışarıda kalanlar, en az 3 madde (K1'de "Yapılmayacaklar" olarak sunulur). -->
- <kapsam dışı>

## Kısıtlar
<!-- doldurma talimatı: platform/profil, host (host'ta yalnız git, Podman, PowerShell 5.1: derleme ve çalıştırma konteynerde), teknoloji sabitleri, veri/gizlilik sınırları, dil. -->
- Platform: <web/mobil/masaustu-motor>; host: konteyner (Podman)

## Başarı ölçütleri
<!-- doldurma talimatı: ürün düzeyinde ölçülebilir 3-6 madde (ör. "run.ps1 -E2E yeşil", "3 persona görevleri tamamlar"); A6 VERIFICATION kapsama satırları bunlara bağlanır. -->
- <ölçüt>

## Koşullu kapılar
<!-- doldurma talimatı: SKILL.md tetikleyici tablosuna göre tetiklenen C-* kimlikleri + tek satır gerekçe (mod koşullu kapıyı kaldırmaz; hat=urun'da C-GUV ve C-ERISIM her zaman). PHASE kosullu: satırı buradan. -->
- <C-GUV: gerekçe>

## Riskler
<!-- doldurma talimatı: en çok 5; "risk -> önlem". K1 sunumunda ilk 2'si kullanılır. -->
- <risk -> önlem>

## Kilometre taşları (yalnız tam mod)
<!-- doldurma talimatı: 3-6 taş: ad, içerdiği F-kimlikleri, tahmini dilim sayısı. Diğer modlarda bölümü sil. -->
- <KT-1: F-01..F-03>

## Açık sorular
<!-- doldurma talimatı: yoksa "-". -->
- <soru>

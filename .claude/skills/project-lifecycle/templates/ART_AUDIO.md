<!-- A2 Tasarım | sahip: ux-designer doldurur (oyunda game-designer'ın GDD §8 ihtiyaç listesiyle) | uygulayan: coder | hedef: docs/ART_AUDIO.md | kapı: E-A2 (+ K2 orta/tam). Hafif mod: Ü/hafif'te ayrı belge yok, kısa varlık listesi docs/DESIGN.md'ye; tam modda ayrıntılı. P'de yok. -->
# ART_AUDIO: <ad>

## 1. Kapsam ve lisans
<!-- Her varlık proje içinde kodla üretilir; dış varlık indirilmez. Raster görsel ve kayıtlı ses KAPSAM DIŞI. -->
Tüm görsel ve sesler SVG / CSS / prosedürel çizim / sentez ses ile üretilir; üçüncü taraf lisansı yoktur.

## 2. Varlık listesi
<!-- Her satır bir varlık; GDD §8 ve UX ihtiyaçlarından türet. Boyut: px veya viewBox; ses için süre. -->
| Ad | Tür (SVG / CSS / prosedürel / sentez ses) | Nerede kullanılır | Üretim tekniği | Boyut |
|---|---|---|---|---|
| <ad> | <tür> | <ekran/olay> | <teknik> | <boyut> |

## 3. Stil kuralları
<!-- UX.md belirteçleriyle (--color-*, --radius-md) tutarlı; sabit renk kodu yazma, değişken adı ver. -->
- Palet: <belirteç adları> · Çizgi/dolgu: <kural> · Animasyon: <süre, easing; prefers-reduced-motion'a saygı>

## 4. Ses listesi
<!-- Sentez ses (web: WebAudio; masaustu-motor/mobil: profil dosyasındaki karşılığı). Parametreler: dalga, frekans, süre, zarf. Ses kullanıcı eylemiyle başlar; sessiz mod ve ses kısma zorunlu. Ses duyma ekipçe doğrulanamaz: kullanıcı gözlemi. -->
| Ses | Olay | Dalga | Frekans (Hz) | Süre (ms) | Zarf (A/D/S/R) |
|---|---|---|---|---|---|
| <ad> | <olay> | <sine/square/...> | <...> | <...> | <...> |

## 5. Gemini plan modu önerisi (isteğe bağlı)
<!-- Yalnız ikinci görüş. Gemini dosya yazmaz; öneriyi dosyaya coder uygular. -->
Prompt taslağı: `<Proje: <ad>, kitle: <kitle>, belirteçler: <liste>. Yalnız SVG/CSS/sentez ses ile uygulanabilir <varlık> için stil ve parametre önerisi ver; dosya yazma.>`
Not: Öneri `reports/` altına alınır; kabul edilenleri coder koda, ux-designer bu belgeye işler.

## 6. Kapsam dışı
<!-- Yalnız bu maddeleri koru; proje özel eleme varsa ekle. -->
- Raster görsel (PNG/JPG), kayıtlı ses/müzik dosyası, hazır varlık paketi, dış CDN yazı tipi/ikon.

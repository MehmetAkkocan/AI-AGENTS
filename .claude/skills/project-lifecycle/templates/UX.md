<!-- A2 Tasarım (A4/A6'da güncellenir) | sahip: ux-designer doldurur | hedef: docs/UX.md | kapı: E-A2, C-ERISIM (A2'de critic, belge düzeyi) (+ K2 orta/tam). Hafif mod: Ü/hafif'te ayrı UX.md yok, akış + ekran tablosu docs/DESIGN.md'nin UX bölümüne yazılır (tasarımcıdan SONRA). -->
# UX: <ad>
Etiketler: profil=<web|mobil|masaustu-motor> | kitle=<cocuk|genc|yetiskin>

## 1. Kullanıcı akışları
<!-- Ana görev başına bir akış, metin okla; başlangıç ve bitiş ekranı belli. -->
- AK-01 <ad>: <Ekran A> -> <Ekran B> -> <Ekran C>

## 2. Ekran envanteri
<!-- Her ekran bir SPEC özelliğine (F-01 biçimi) bağlı; F-xx'siz ekran açma. -->
| Ekran | Amaç | SPEC kimliği (F-xx) |
|---|---|---|
| <ad> | <amaç> | F-01 |

## 3. Bileşenler ve durumlar
<!-- Ekran başına bileşen listesi; her biri için dört durum yaz. Eksik durum = eksik tasarım. -->
### <Ekran adı>
- Bileşenler: <liste>
- Boş: <metin/görünüm> · Yükleniyor: <...> · Hata: <...> · Başarı: <...>

## 4. Tel kafes
<!-- Her ana ekran için metin tabanlı örnek (ASCII kutular); en az bir ekran. Tam modda her ekran için docs/ux/wireframes/NN-<ekran>.html üret ve burada yalnız yol satırı bırak. Diğer modlarda HTML yok. -->
```
+----------------------+
| <başlık>      <menü> |
| <ana alan>           |
| [ <birincil eylem> ] |
+----------------------+
```
Tam mod: `docs/ux/wireframes/NN-<ekran>.html` (ekran başına bir satır, ör. `01-ana-ekran.html`)

## 5. Tasarım belirteçleri
<!-- CSS değişkeni adıyla; ART_AUDIO stil kuralları bunlara dayanır. Değer ve kullanım yeri yaz. -->
| Belirteç | Değer | Kullanım |
|---|---|---|
| --color-bg / --color-fg / --color-accent | <#...> | <yüzey/metin/vurgu> |
| --font-base / --font-size-base | <...> | <gövde> |
| --space-1..--space-6 | <4px ölçeği> | <boşluk> |
| --radius-md | <...> | <köşe> |

## 6. Erişilebilirlik hedefleri
<!-- Kitleye göre: dokunma hedefi erisilebilirlik.md ER-08 ile aynı: >=44x44 CSS px; kitle=cocuk >=48 CSS px, sade dil. -->
- Kontrast: <metin >=4.5:1, büyük metin >=3:1> · Klavye: <tüm eylemler Tab/Enter> · Odak: <görünür halka> · Dokunma hedefi: <>=44 CSS px; cocuk >=48>

## 7. Mikro metin üslubu
<!-- Düğme, hata, boş durum metinleri; ton ve kitleye uygun dil; suçlamayan hata metni. -->
<Üslup + 3 örnek>
## 8. Duyarlı görünüm
<!-- İki hedef: masaüstü ve 375x812 mobil. Ekran başına düzen değişimi. A4/A6'da ux-designer bu tabloyu kendi gördüğü görüntülerle (yoksa playtester Görsel kontrol tablosuyla) karşılaştırır. -->
| Ekran | Masaüstü | 375x812 |
|---|---|---|
## 9. Açık riskler
<!-- K2 sunumuna girer: en çok 2 risk, "risk -> önlem". -->
- <risk -> önlem>

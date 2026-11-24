<!-- A2 | sahip: game-designer veya learning-designer (türe göre) yazar, SONRA ux-designer Ekran listesi / Akış / Görsel ve ses bölümlerini ekler (sırayla, aynı anda değil) | hedef: docs/DESIGN.md (yalnız Ü/hafif) | kapı: E-A2 + tetiklenen C-* (hafif modda K2 yok) -->
<!-- Ü/hafif modda GDD + LEARNING_DESIGN + UX + ART_AUDIO özeti tek dosyada, ≈1-2 sayfa. Orta/tam modda bu şablon kullanılmaz; ayrı GDD / LEARNING_DESIGN / UX / ART_AUDIO yazılır. Yer tutucu adı: <ad>. -->
# DESIGN <ad>

## Tasarım özeti
<!-- doldurma talimatı: 3 satır: ne deneyimi, kimin için, tek ayırt edici özellik. Kaynak: SPEC Hedefler. -->
<özet>

## Çekirdek döngü
<!-- doldurma talimatı: oyun/oyunlaştırma varsa eylem -> geri bildirim -> ödül -> ilerleme (≤6 adım) + zorluk modeli 2 satır. Oyun değilse "yok". -->
<döngü>

## Öğrenme hedefleri
<!-- doldurma talimatı: eğitim/öğrenme/kişisel gelişim için 3-8 ölçülebilir hedef; kimlik LH-01, LH-02...; her biri bir etkinlik, bir ölçme ve en az bir SPEC kimliği (F-01) ile eşleşir; yaşa uygun dil notu. Aksi halde "yok". -->
| Hedef kimliği | Hedef | Etkinlik | Ölçme | SPEC kimliği (F-xx) |
|---|---|---|---|---|
| LH-01 | <... yapabilir> | <etkinlik> | <ölçme> | F-01 |

## Davranış ve alışkanlık tasarımı (yalnız kisisel-gelisim; diğerlerinde "uygulanmaz" yaz)
<!-- doldurma talimatı (LEARNING_DESIGN §8 ile aynı başlıklar): Tetikleyici, küçük adım, izleme; geri dönüş planı (kaçırılan günden sonra suçlamadan yeniden başlama). Manipülatif desen yasağı: sahte aciliyet, suçluluk, kayıp korkusu, bağımlılık döngüsü (seri kaybı cezası dahil). -->
- Tetikleyici: <hatırlatma bağlamı> · Küçük adım: <≤2 dk eylem> · İzleme: <ölçüt, ceza yok>

## Ekran listesi
<!-- doldurma talimatı (ux-designer): her ekran bir satır: ad, amaç, ana eylem, karşıladığı F-kimliği. Hafif modda 3-10 ekran; fazlaysa orta moda geçiş önerisini critic'e not et. -->
| Ekran | Amaç | Ana eylem | SPEC kimliği (F-xx) |
|---|---|---|---|
| <ekran> | <amaç> | <eylem> | F-01 |

## Akış
<!-- doldurma talimatı (ux-designer): ana akış adım adım (≤10), her adımda ekran adı; en az 1 hata/boş durum yan akışı. -->
1. <ekran> -> <ekran>

## Görsel ve ses yönü
<!-- doldurma talimatı (ux-designer): renk, tipografi, ikon dili, ses; hepsi KODLA üretilebilir (SVG/CSS/prosedürel ya da sentez ses); raster/kayıtlı ses yok. Erişilebilirlik hedefi (kontrast, klavye, odak) 2 satır. -->
<yön>

## Koşullu kapı notları
<!-- doldurma talimatı: C-COCUK, C-ALAN, C-ERISIM tetiklendiyse tasarımın ilgili kontrol listesine nasıl uyduğu, madde kimlikleriyle (CG-01...). Yoksa "yok". -->
<not>

## SPEC çapraz başvuru ve açık riskler
<!-- doldurma talimatı: her F-kimliğinin hangi ekran/etkinlikte karşılandığı; karşılanmayan açıkça yazılır (critic çapraz tutarlılık yapar). Son satır: K2 ve E-A2 için en çok 3 açık risk. -->
F-01: <ekran / LH-01>
Açık riskler: <risk>

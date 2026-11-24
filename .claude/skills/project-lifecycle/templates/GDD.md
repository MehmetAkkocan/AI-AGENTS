<!-- A2 Tasarım | sahip: game-designer doldurur | hedef: docs/GDD.md | kapı: E-A2 (+ K2 orta/tam). Hafif mod: Ü/hafif'te ayrı GDD yok, içerik docs/DESIGN.md'ye yazılır; P'de yalnız §1-2 BRIEF içine yazılır. -->
# GDD: <ad>
Etiketler: tur=<oyun|egitim|ogrenme|kisisel-gelisim>[+oyun] | kitle=<cocuk|genc|yetiskin> | profil=<web|mobil|masaustu-motor>

## 1. Vizyon
<!-- Tek cümle: oyuncu kim, ne yapar, ne hisseder. SPEC'teki ürün tanımıyla çelişmesin. -->
<Tek cümlelik vizyon>
## 2. Çekirdek döngü
<!-- Üç ölçekte yaz; her ölçek: eylem -> sonuç -> ödül/geri bildirim -> sonraki eylem. -->
- 30 sn: <eylem döngüsü> · 5 dk: <seviye/tur hedefi> · Oturum: <başı-sonu, devam noktası>

## 3. Mekanikler
<!-- Her mekanik tek satır; SPEC özellik kimliğine (F-01 biçimi) bağla. Kural, girdi, sınır net olsun. -->
| Mekanik | Kural | Girdi | Başarı/Başarısızlık | SPEC (F-xx) |
|---|---|---|---|---|
| <ad> | <kural> | <tuş/dokunma> | <sonuç> | F-01 |

## 4. İlerleme ve ödül ekonomisi
<!-- Kazanç/harcama kaynakları, sayısal aralıklar. Manipülatif desen yok (kitle cocuk ise zorunlu): sahte aciliyet, kayıp korkusu, satın alma. -->
<Puan/yıldız/açılım kuralları ve sayılar>

## 5. Zorluk eğrisi
<!-- Seviye/dalga başına zorluk parametreleri (hız, süre, hata payı) ve artış kuralı; seed ile yeniden üretilebilir olsun. -->
| Seviye | Parametre | Değer | Beklenen başarı oranı |
|---|---|---|---|

## 6. Geri bildirim
<!-- Her olay için görsel / ses / metin üçlüsü; ses ve görsel kodla üretilir (bkz. ART_AUDIO.md). -->
| Olay | Görsel | Ses | Metin |
|---|---|---|---|

## 7. İçerik envanteri
<!-- Sayılar kesin: seviye, birim, düşman, öğe. A5 iş planı bu sayılardan türer. -->
<Seviye: N · birim: N · öğe: N>
## 8. Kodla üretilecek görsel ve ses ihtiyaçları
<!-- Yalnız liste ve amaç; ayrıntı ART_AUDIO.md'de (ux-designer yazar). Raster görsel ve kayıtlı ses yok. -->
- Görsel: <SVG/CSS/canvas öğeleri> · Ses: <sentez ses olayları>

## 9. SPEC eşlemesi (izlenebilirlik)
<!-- Her SPEC özelliği (F-xx) en az bir mekanik/akışa; karşılıksız F-xx veya SPEC'siz özellik bırakma. Kabul ölçütü alt maddesi F-01.a biçiminde. -->
| SPEC kimliği (F-xx) | GDD bölümü | Not |
|---|---|---|
| F-01 | <§3 mekanik adı> | <not> |

## 10. Kapsam dışı
<!-- SPEC "yapılmayacaklar" ile aynı; ek eleme varsa gerekçesiyle. -->
- <madde>
## 11. Test kancası gereksinimi
<!-- Tarayıcı oyununda zorunlu: playtester ve tester oyunu bununla sürer. Refleks/FPS/his ölçülemez; K3'te kullanıcı oynar. -->
- `?debug=1&seed=<N>` ile tohumlanabilir rastgelelik; `window.__game.getState()` ile durum okuma (<hangi alanlar>)
## 12. Açık riskler
<!-- K2 sunumuna girer: en çok 2 risk, "risk -> önlem". -->
- <risk -> önlem>

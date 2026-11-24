<!-- A4 (Ü) / A5 (tam) / A6 | sahip: playtester doldurur | hedef: reports/<damga>-playtester-<konu>.md | kapı: P-A4 (yalnız Ü) / P-A5 (yalnız tam) / P-A6 (P hattında tek tur: K3 girdisi; Ü'de K4 girdisi). Ü/A6'da writer raporları docs/PLAYTEST.md'ye persona x görev özeti + bulgu sayılarıyla derler (P'de PLAYTEST.md yazılmaz). Hafif mod: P'de 1-2 persona + görsel kontrol; Ü/hafif 2 persona. -->
# Playtest raporu: <konu>
- Proje: <ad> · Aşama: <A4/A5/A6> · Yapı/commit: <kısa hash> · Tarih: <yyyy-MM-dd>
- YONTEM: <TARAYICI/HTTP/MANUEL> · GORSEL: <KONTROL EDILDI/DOGRULANMADI> · Ortam: <adres, tarayıcı, 375x812 + masaüstü>
- BULGU: ENGEL <n> · BUYUK <n> · KUCUK <n>

## Personalar
<!-- docs/PERSONAS.md'den kodlar; her sette erişilebilirlik personası. -->
<PC1, PC-A, ...>

## Görevler
<!-- Kaynak: TEST_PLAN §3; TEST_PLAN yoksa (P, Ü/hafif) BRIEF/SPEC kabul ölçütlerinden (F-xx.a) türet. Her görevin ölçülebilir başarı ölçütü olsun. -->
| Görev | Kaynak (TEST_PLAN / F-xx) | Başarı ölçütü |
|---|---|---|
| G1 | <madde> | <ölçüt> |

## Persona x görev matrisi
<!-- Sonuç yalnız: BASARDI / ZORLANDI / BASARAMADI. Kanıt: görüntünün metin betimi + erişilebilirlik ağacı alıntısı + varsa ölçüm. Ekran görüntüsü dosyası isteğe bağlı (reports/shots/<damga>-<konu>-<ekran>.png). -->
| Persona | Görev | Sonuç | Adım | Takıldığı yer | Kanıt (betim / ağaç alıntısı / ölçüm) |
|---|---|---|---|---|---|

## Bulgular
<!-- Önem: ENGEL / BUYUK / KUCUK (hücrede tek değer). Yeniden üretme adımları numaralı ve kısa. -->
| ID | Önem | Persona | Ekran/rota | Gözlem | Beklenti | Yeniden üretme | Önerilen sahip |
|---|---|---|---|---|---|---|---|
| B-01 | <ENGEL/BUYUK/KUCUK> | <kod> | <rota> | <...> | <...> | 1. <...> | <coder/writer/ux-designer> |

## Görsel kontrol
<!-- Hücre başına GORSEL değeri: KONTROL EDILDI yalnız o ekran x görünümün görüntüsünü GERÇEKTEN gördüysen (betim + ağaç + ölçüm kanıtla); 2 yeniden denemeden sonra alınamazsa DOGRULANMADI. -->
| Ekran | Masaüstü (GORSEL) | Mobil 375x812 (GORSEL) | Erişilebilirlik ağacı (etiket/başlık/odak sırası) | Konsol hatası, 4xx/5xx |
|---|---|---|---|---|

## Persona sesiyle notlar
<!-- Persona başına en çok 3 cümle, birinci ağızdan. -->
- <Kod>: "<not>"

## Kitleye özel gözlemler
<!-- cocuk: okuma, dokunma hedefi, ödül tepkisi; genc: sabır, mobil akış; yetiskin: alan terimi, hız. -->
<Gözlemler>

## MANUEL gözlem formu (yalnız YONTEM: MANUEL)
<!-- İki çağrı (agents/playtester.md). (1) MANUEL form: görev adımları, beklenen sonuç, BASARDI/ZORLANDI/BASARAMADI kutuları, cihaz modeli/ekran, serbest not; SONUC yazılmaz, dönüş `DURUM: NEEDS_REVIEW — kullanıcı bekleniyor`; lider YALNIZ bu bölümü kullanıcıya sunar. (2) MANUEL değerlendirme: kullanıcı yanıtı state/MANUEL-<p>.md'den okunur, matris ve bulgular ondan doldurulur, SONUC yazılır. Aşama K3/K4 ile bitiyorsa (P/A6, Ü/A4 orta-tam, Ü/A6) SONUC GECER → kapı GECER; form K3/K4 görsel onayının yerini tutmaz (kapıda kullanıcı görsel onayı yine alınır). Bitmiyorsa (tam modda P-A5; K3'süz Ü/A4) form o ekranlar için görsel onay sayılır: GECER ise PHASE kaydı ISTISNA (`kullanici: gorsel onay (MANUEL form); <rapor yolları>`). Diğer yöntemlerde "uygulanmaz". -->
<form ya da "uygulanmaz">

## SINIRLAMALAR (zorunlu)
<!-- Doğrulanamayanları açık yaz: ses/animasyon hissi, refleks, FPS (oyunda K3'te kullanıcı oynar); görüntü alınamayan hücreler. Yapay oyuncu gerçek kullanıcı değildir. -->
- Doğrulanamayan: <liste> · Yapay oyuncu gerçek kullanıcı yerine geçmez.

## Karar önerisi
<!-- Birden çok persona/tur varsa genel sonuç EN KÖTÜ sonuçtur (ENGEL > DUZELTILMELI > GECER). MANUEL form çağrısında (1) SONUC satırı yerine "kullanıcı bekleniyor (MANUEL form)" yazılır; SONUC'a yeni değer eklenmez. -->
SONUC: <GECER/DUZELTILMELI/ENGEL> — <gerekçe, ilk 3 bulgu ID>

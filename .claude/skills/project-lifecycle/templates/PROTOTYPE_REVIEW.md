<!-- A6 (konu `a6-review`) | sahip: writer (kanıtlar tester ve playtester raporlarından; kaba ürün boyutu, önerilen mod ve ADR-000 önerisi planner'ın A6 `a6-k3-oneri` raporundan derlenir; karar üretmez, uydurmaz) | hedef: docs/PROTOTYPE_REVIEW.md (yalnız P hattı) | kapı: E-A6, T-A6, P-A6 -> K3 -->
<!-- Yalnız P hattında yazılır (P'de VERIFICATION.md ve PLAYTEST.md yazılmaz). Tek sayfa; rapor içeriği kopyalanmaz, yolla atıf. K3 sunumu (≤15 satır) bu belgeden çıkar. P'de RETRO.md yazılmaz: "Retro notu" onun yerine geçer ve P/A8'de, son karardan (TERFI / RAFA-KALDIR) sonra doldurulur. Yer tutucu adı: <ad>. -->
# PROTOTYPE_REVIEW <ad>

## Hipotez ve sonuç
<!-- doldurma talimatı: BRIEF'teki hipotez aynen + sonuç DOGRULANDI / KISMEN / CURUTULDU (yalnız bu üç yazım) + 2-3 cümle gerekçe. Kanıtsız hüküm yazma. -->
Hipotez: <BRIEF'ten>
Sonuç: <DOGRULANDI/KISMEN/CURUTULDU> - <gerekçe>

## Çalıştırma
<!-- doldurma talimatı: kullanıcının kendisinin deneyeceği komut ve adres; run.ps1 üzerinden. Komutu çalıştırıp doğrula (tester raporu). -->
Komut: `<run.ps1 -Up>` | Adres: <http://localhost:...>
Görsel onay (kullanıcı): K3'te kullanıcı ürünü kendisi açıp bakar; bakılacak ekranlar: <liste>. Ajanın `GORSEL:` değeri bilgidir, onayın yerini tutmaz.

## Playtest ve test özeti
<!-- doldurma talimatı: playtester SONUC / YONTEM / GORSEL alanları + ilk 3 bulgu (önem: ENGEL/BUYUK/KUCUK); tester sonucu (run.ps1 -Test/-Check/-E2E). Her satırda rapor yolu. Birden çok persona varsa SONUC en kötü sonuçtur. -->
| Kaynak | Sonuç | Yöntem / Görsel | Rapor yolu |
|---|---|---|---|
| playtester | <GECER/DUZELTILMELI/ENGEL> | <TARAYICI/HTTP/MANUEL> / <KONTROL EDILDI/DOGRULANMADI> | <projects/<ad>/reports/...> |
| tester | <PASS/FAIL> | - | <projects/<ad>/reports/...> |

## Bilinen eksikler
<!-- doldurma talimatı: en çok 3 madde (K3 sunumuyla aynı), her biri önem sınıfıyla. Prototipte bilerek yapılmayanlar ayrı işaretlenir. -->
- <eksik> [<ENGEL/BUYUK/KUCUK>]

## Teknik fizibilite
<!-- doldurma talimatı: 3-5 satır: teknoloji uygun mu, konteyner derleme/çalıştırma sorunsuz mu, performans/güvenlik engeli var mı. Son satır ADR-000 önerisi: prototip kodu KORU / YENIDEN YAZ + 1 cümle gerekçe (kaynak: planner K3 önerisi raporu; K3 sunumunda yer alır; A3 mimari critic'iyle kesinleşir). -->
ADR-000 önerisi: <KORU/YENIDEN YAZ> - <gerekçe>

## Kaba ürün boyutu
<!-- doldurma talimatı: tahmini parça sayısı, dilim sayısı, içerik hacmi; SKILL.md mod eşikleriyle karşılaştır (hafif ≤~12, orta 12-40, tam 40+). Kaynak: planner K3 önerisi raporu (yolla atıf). -->
<~N parça, N dilim, içerik: ...>

## Önerilen karar ve mod
<!-- doldurma talimatı: K3 (P) seçeneklerinden biri: TERFI / YINELE (≤2) / RAFA-KALDIR; TERFI ise mod (hafif/orta/tam) + 2 cümle gerekçe; mod önerisinin kaynağı planner K3 önerisi raporu. Karar kullanıcıya aittir; burada yalnız öneri. -->
Öneri: <TERFI/YINELE/RAFA-KALDIR> / mod: <hafif/orta/tam/-> - <gerekçe>

## Retro notu (≤10 satır)
<!-- doldurma talimatı: P/A8'de, K3 son kararından (TERFI / RAFA-KALDIR) sonra doldurulur; kapı yok (E-A8 yok). Ne iyi gitti, ne gitmedi, süreç için 1-2 öneri; en çok 10 satır. Uygulanacak öneri varsa `ONERI:` satırı olarak işaretle; lider bunları projenin `state/LESSONS.md` dosyasına taşır. -->
- <not>

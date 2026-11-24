<!-- A3 (ve sonrasi), planner yazar (karar planner/coder'dan), hedef: docs/adr/<NNN>-<konu>.md; NNN uc hane, 000 = 000-prototip-kodu.md. Tek karar, tek dosya. Mod: P yok (yalniz terfide 000) · hafif yok · orta/tam zorunlu -->
# ADR <NNN>: <karar basligi>

## Durum
<!-- Onerildi | Kabul | Reddedildi | Yerine gecildi (<NNN>) ; tarih yyyy-MM-dd -->
<durum> — <yyyy-MM-dd>

## Baglam
<!-- Hangi sorun, hangi kisit (SPEC, CONSTRAINTS, host kisiti), neden simdi karar gerekiyor. 3-6 satir. -->
<baglam>

## Karar
<!-- Tek, net cumle ile basla; sonra kisa ayrinti. -->
<karar>

## Secenekler
<!-- En az iki secenek; secilen ilk satirda. Artilar/eksiler olculebilir olsun (maliyet, risk, bakim). -->
| Secenek | Artilar | Eksiler |
|---|---|---|
| <A (secilen)> | <arti> | <eksi> |
| <B> | <arti> | <eksi> |

## Sonuclar
<!-- Olumlu, olumsuz, izlenecek risk; etkilenen moduller ve belgeler (ARCHITECTURE, sozlesmeler). -->
- <sonuc>

<!-- ORNEK NOT — 000-prototip-kodu (yalniz hat terfisinde, K3 = TERFI sonrasi A3'te planner yazar; "koru / yeniden yaz" onerisi K3 sunumunda yer alir, A3'te mimari critic'iyle kesinlesir):
Baglam: prototip-v0 etiketli kod hizli kuruldu; urun hattinda tutulup tutulmayacagi belirsiz.
Karar: modul bazinda KORU ya da YENIDEN YAZ; tablo: modul / karar / gerekce.
Sonuc: KORU modullerine test eklenir; YENIDEN YAZ modulleri stub ile degistirilir. -->

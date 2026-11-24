<!-- A6 | sahip: writer (tester, playtester, critic raporlarından derler) | hedef: docs/VERIFICATION.md | kapı: E-A6, T-A6, P-A6, tüm C-* -> K4 (K4 sunumu bu belgeden: matris, ENGEL, bilinen sorunlar, Geri alma) -->
<!-- P: VERIFICATION yazılmaz (P'de A6 VAR: hafif doğrulama, smoke + 1-2 persona + görsel kontrol P-A6'da yürür, PROTOTYPE_REVIEW'a girer). Ü/hafif: test + 2 persona + temel erişilebilirlik. Orta: + 3 persona. Tam: + performans, 4+ persona. C-GUV ve C-ERISIM hat=urun'da her modda yazılır (orta/tam'da güvenlik ve tehdit modeli dahil). Tetiklenmeyen koşullu kapı satırı yazılmaz. Yer tutucu adı: <ad>. -->
# VERIFICATION <ad>

## Yayın adayı
<!-- doldurma talimatı: aday sürüm numarası (vX.Y.Z), commit kısaltması, doğrulama günü (yyyy-MM-dd). -->
Sürüm: <vX.Y.Z> / commit: <kısa-sha> / tarih: <yyyy-MM-dd>

## Doğrulama matrisi
<!-- doldurma talimatı: her satır bir kapı kimliği, sonuç, rapor yolu (sözlük phase-gate Denetim 7). Sonuç sözcükleri sözlükteki gibi: critic E-*/C-* = APPROVE/REVISE; tester T-* = PASS/FAIL; playtester P-* = GECER/DUZELTILMELI/ENGEL; P-A6 (K4 ile biten aşama): GORSEL: DOGRULANMADI ayrı ISTISNA gerektirmez, SONUC GECER ise Sonuç = GECER; kullanıcının görsel onayı K4'te her zaman alınır. PHASE kaydı yine de ISTISNA ise Sonuç = ISTISNA, Rapor yolu = playtester raporları. Raporsuz satır yazma. E-A6 bu belgeden SONRA koşar, burada satırı yoktur; K4 E-A6'yı PHASE'ten alır, diğer satırlar bu tablodan çıkar. -->
| Kapı | Sonuç | Rapor yolu |
|---|---|---|
| T-A6 test (run.ps1 -Test, -Check) | <PASS/FAIL> | <...> |
| T-A6 E2E (run.ps1 -E2E) | <PASS/FAIL> | <...> |
| P-A6 playtest | <GECER/DUZELTILMELI/ENGEL/ISTISNA> | <...> |
| C-ERISIM | <APPROVE/REVISE> | <...> |
| C-GUV | <APPROVE/REVISE> | <...> |
| <C-COCUK, C-YAS, C-ALAN, C-PERF: tetiklenenler> | <APPROVE/REVISE> | <...> |

## Kapsama
<!-- doldurma talimatı: SPEC her F-kimliği için bir satır: F-xx -> kabul ölçütleri (F-xx.a) -> TEST_PLAN eşlemesi -> sonuç. Öğrenme hedefi varsa LH-xx satırı da. P ve TEST_PLAN'sız hafif modda test yolu raporlardan. -->
| Kimlik | Test / etkinlik (TEST_PLAN yolu) | Sonuç |
|---|---|---|
| F-01 | <F-01.a: test adı> | <PASS/FAIL> |

## Bilinen sorunlar
<!-- doldurma talimatı: EN ÇOK 3 madde; önem sınıfı BUYUK ya da KUCUK (ENGEL bırakılmaz) + gerekçeli BACKLOG işaretçisi. -->
- <sorun> [<BUYUK/KUCUK>] -> BACKLOG: <madde>

## Geri alma
<!-- doldurma talimatı: K4 bunu sunar (RELEASE A7'de, K4'ten sonra yazılır): 1-3 satır: dönülecek önceki git etiketi (yoksa "ilk sürüm: yok"), konteyner/imaj temizliği, veri uyumluluğu. -->
1. <adım>

## ENGEL sayısı
<!-- doldurma talimatı: aşağıdaki satır TEK BAŞINA ve biçimi AYNEN "ENGEL: <n>" olmalı (n = açık ENGEL bulgu sayısı; PLAYTEST bulgu sayılarından derlenir). phase-gate A6'da bu satırı okur ve n = 0 ister; satıra başka metin ekleme. -->
ENGEL: <n>

## Kapsam ve sınırlar
<!-- doldurma talimatı: doğrulanmayanlar (GORSEL: DOGRULANMADI, YONTEM: MANUEL), cihaza/PWA'ya özgü "kullanıcı gözlemi — yapılamadı" maddeleri (BACKLOG işaretçisiyle; HTTPS gerektiren PWA özellikleri yerel ağda test edilemez) ve kullanıcının K4'te kendisinin bakması gerekenler (K4'te kullanıcının görsel onayı her zaman zorunludur; ajan GORSEL satırı bilgidir); 2-5 satır. -->
- <sınır>

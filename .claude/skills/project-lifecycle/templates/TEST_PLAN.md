<!-- A3, planner doldurur, hedef: docs/TEST_PLAN.md; komutlari tester kosar. Yalniz Ü/orta-tam: P ve Ü/hafif'te yok (playtest gorevleri PLAYTEST_REPORT'ta BRIEF/SPEC'ten turetilir). Playtest gorevlerinin tek kaynagi §3 -->
<!-- Eşleme kimligi: SPEC `F-01` ozelligi, kabul olcutu `F-01.a`; LEARNING_DESIGN hedefi `LH-01` -->
<!-- §1: katman ekle/cikar (icerik yoksa -Check satiri "yok"). §4: her F-xx.a ve LH-xx en az bir teste/etkinlige baglanir; VERIFICATION bu tabloyu anar -->

# Test Plani — <ad>

## 1. Test piramidi
| Katman | Kapsam | Komut | Gecme olcutu |
|---|---|---|---|
| Birim | <modul mantigi> | `run.ps1 -Test` | exit 0, <kapsam hedefi> |
| Entegrasyon | <modul arasi, veri katmani> | `run.ps1 -Test` | exit 0 |
| Icerik dogrulama | CONTENT_SCHEMA kurallari | `run.ps1 -Check` | exit 0, 0 hata |
| E2E (smoke) | calisan urun, ana akis | `run.ps1 -E2E` | exit 0 |
Basarili komut exit 0 verir; A3'te bos urunle hepsi yesil olmali (T-A3).

## 2. E2E senaryolari
<!-- Ilk smoke A3'te bos urunle kosar; her dilim sonunda yeniden kosar, senaryo eklenir. -->
| # | Senaryo | Adimlar | Beklenen |
|---|---|---|---|
| E1 | Smoke (bos urun) | 1. `-Up` 2. ana adrese istek 3. durum kodu ve baslik kontrolu 4. `-Down` | 200, <beklenen metin> |
| E2 | <dilim akisi> | 1. <adim> 2. <adim> 3. <adim> | <sonuc> |

## 3. Playtest gorevleri
<!-- Persona = BRIEF/SPEC kitlesinden; her sette bir erisilebilirlik personasi. Yontem: TARAYICI > HTTP > MANUEL (profil dosyasi). -->
| Persona | Gorev | Basari olcutu |
|---|---|---|
| <persona-1> | <gorev, kullanicinin dilinde> | <sure / adim sayisi / yardimsiz tamamlama> |
| <erisilebilirlik personasi> | <gorev> | klavye ile tamamlanir, etiketler okunur |

## 4. Kabul olcutu - test esleme
| Kabul olcutu (F-01.a) | Olcut | Test (katman + ad) | Durum |
|---|---|---|---|
| <F-01.a> | <olcut> | <E2E E2 / birim ...> | ACIK |
| <LH-01 (ogrenme hedefi varsa)> | <olcut> | <test / etkinlik> | ACIK |

## 5. Kosullu kapi denetimleri
<!-- Yalniz PHASE kosullu: satirinda olanlar. Kontrol listesi: checklists/. -->
| Kapi | Denetim | Arac / kanit |
|---|---|---|
| <C-GUV> | <girdi dogrulama, calistirma siniri> | <test adi + critic raporu> |
| <C-PERF> | ARCHITECTURE performans butcesi | <olcum komutu + tester raporu> |

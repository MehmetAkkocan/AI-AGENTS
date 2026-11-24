# PHASE <ad>
proje: <ad> | tur: ? | kitle: ? | profil: ?
hat: <hat> | mod: <mod> | asama: A0 | durum: CALISIYOR
kosullu: yok

## Cikis kriterleri
| # | Hat | Asama | Kriter | Yol | Durum |
|---|---|---|---|---|---|

## Kapi kayitlari
| Kapi | Hat | Asama | Denetleyen | Sonuc | Rapor | Tarih |
|---|---|---|---|---|---|---|

## Asama gecmisi
| Hat | Asama | Baslangic | Bitis | Sonuc | Etiket |
|---|---|---|---|---|---|

## Izinli degerler
- durum: CALISIYOR · KAPI_BEKLIYOR (ajan kapisi) · KULLANICI_BEKLIYOR · BLOKE · TAMAM · RAFTA. asama: A0 ... A8
- hat: prototip · urun. mod: hafif · orta · tam · - (prototip hattinda). tur: oyun · egitim · ogrenme · kisisel-gelisim (+oyun eki). kitle: cocuk · genc · yetiskin. profil: web · mobil · masaustu-motor
- Kapi kimlikleri: kullanici K1 (A1) K2 (A2) K3 (hatta bagli: prototip A6 · urun A4) K4 (A6) · critic E-A0 ... E-A8 · tester T-A3 ... T-A7 · playtester P-A4, P-A5 (yalniz tam), P-A6 · kosullu C-COCUK, C-YAS, C-ALAN, C-GUV, C-ERISIM, C-PERF
- Sonuc, critic kapilari (E-*, C-*): APPROVE · REVISE. tester (T-*): PASS · FAIL. playtester (P-*): GECER · DUZELTILMELI · ENGEL
- Sonuc, K1: ONAY · DUZELT · DURDUR · ONAY-ONCEDEN. K2: ONAY · DUZELT · KUCULT. K4: YAYINLA · DUZELT · ERTELE
- Sonuc, K3 prototip: TERFI · YINELE (en fazla 2) · RAFA-KALDIR. K3 urun: DEVAM · DUZELT · DURDUR
- Her kapi: BEKLIYOR (sonuc yok) · ISTISNA (yalniz kullanici karariyla; Rapor hucresine `kullanici: <gerekce>`)
- Kapiyi gecirir: APPROVE, PASS, GECER, ONAY, ONAY-ONCEDEN, TERFI, DEVAM, YAYINLA, ISTISNA. Digerleri (BEKLIYOR dahil) kapiyi acik birakir
- Durum etkisi: DURDUR -> durum RAFTA · RAFA-KALDIR -> P/A8 retro notundan sonra RAFTA · ERTELE -> BLOKE · YINELE (prototip K3) -> asama A4, CALISIYOR · DUZELT, KUCULT, REVISE, FAIL, DUZELTILMELI, ENGEL -> ayni asamada CALISIYOR
- Yeniden kosma: olumsuz karardan sonra yeniden kosacak HER kapi icin ayni (Kapi, Hat, Asama) anahtariyla hemen yeni BEKLIYOR satiri (eski gecer satir kapiyi acik birakamaz); kullanici kapisinda olumsuz kararda E-A<n>, etkilenen C-* ve K<n> yeniden BEKLIYOR. Istisna prototip K3 YINELE: hemen E-A4, T-A4; A6'ya yeniden giriste T-A6, P-A6, E-A6, (varsa) C-YAS, K3
- Denetleyen: rol adi (critic, tester, playtester) ya da `kullanici`. Kullanici kapilarinda (K1-K4) Denetleyen = `kullanici`, Rapor = `-` (ya da sunumu hazirlayan rapor). Gecer sonuclu K3/K4 satirinda Rapor = `kullanici: gorsel onay; <sunum raporu yolu ya da ->` (ISTISNA'da `-` yerine gerekce)
- Rapor: yol kurali sozluk.md phase-gate Denetim 7 (kanonik: stamp.ps1 ciktisi, projects/<ad>/reports/...). Tarih, Baslangic, Bitis: yyyy-MM-dd
- Cikis kriterleri: Yol = proje kokune gore tek dosya ya da `-`; Durum = ACIK · TAMAM
- Asama gecmisi: Sonuc = TAMAM · TERFI · RAFTA · BLOKE; Etiket = git etiketi ya da `-`
- `tur/kitle/profil = ?` yalniz A0'da gecerli (A1'e gecmeden doldurulur). `proje:` klasor adiyla ayni. `hat: prototip` iken `mod: -` zorunlu. Gecersiz/yanlis yazimli deger phase-gate'te exit 2
- Cift etiket: terfide once `p-asama-A6`, sonra `p-asama-A8`, sonra ayri checkpoint `prototip-v0`; A7'de once `vX.Y.Z`, sonra `u-asama-A7` (Asama gecmisi Etiket = `u-asama-A7`). Sira: lider PHASE / projects/PROJECTS.md / proje HANDOFF gunceller, SONRA coder checkpoint
- Kosullu satiri yalniz tetiklenen kapilari yazar (C-...) ya da `yok`. Hucrede `|` yasak; satirlar tablo sonuna eklenir, silinmez

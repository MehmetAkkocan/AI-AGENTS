# Kontrol listesi: Hassas alan — sağlık, ruh sağlığı, finans, güvenlik teknikleri (HA)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir ("kanıt: playtester raporu"). Ses/emülasyon gibi ekibin doğrulayamadığı madde "kullanıcı gözlemi" sayılır (en çok BUYUK).

- **Kapı:** C-ALAN · **Tetikleyici:** sağlık, ruh sağlığı, finans ya da güvenlik teknikleri konusu · **Denetleyen:** critic
- **A2'de bakılır (belge: GDD/LEARNING_DESIGN/UX/BRIEF):** HA-01, 02, 03, 05, 08, 09, 10, 12. **A6'da bakılır:** tümü.
- Alt küme etiketi: [SAĞLIK] [RUH] [FİNANS] [GÜVENLİK]; etiketsiz madde her alanda geçerli. Alan dışı madde = UYGULANMAZ (gerekçeyle).
- Örneklem (sözlük kuralı): en az 5 birim ya da %20, hangisi büyükse; toplam 5'ten azsa tümü.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| HA-01 | İlk ekranda ve README'de sorumluluk reddi: eğitim amaçlıdır; tıbbi/finansal/hukuki profesyonel tavsiyenin yerini tutmaz. | A2: UX ilk ekran metni. A6: ekran kanıtı: playtester raporu (kaydırmadan görünür); README satırı. | ENGEL |
| HA-02 | Sonuç vaadi ve kişiye özel tavsiye yok: tanı koyma, ilaç/doz önerme, belirli ürün/hisse/kripto önerme, "garanti", "risksiz", "tedavi eder". | Grep (içerik + arayüz metni): `garanti`, `risksiz`, `kesin kazan`, `tedavi eder`, `teşhis`; sonuç 0. | ENGEL |
| HA-03 | Olgusal iddialar kaynaklı (kurum/standart adı, erişim tarihi). | Örneklemde iddia → kaynak tablosu; kaynaksız iddia 0. | BUYUK |
| HA-04 | Zamanla değişebilen sayısal iddialar (eşik, oran, ücret, mevzuat/sürüm numarası) tarihli ("... tarihi itibarıyla"). Port, izin biti gibi sabit teknik değerler kapsam dışı. | Örneklemde değişebilen sayısal iddia listesi; tarihsiz sayısı 0. | KUCUK |
| HA-05 | [RUH] Kendine zarar/kriz konusuna değinen ekranlardan Türkiye için 112 ve yetkili destek bilgisini veren "Yardım" ekranına ≤2 dokunuşla gidilir. | A2: UX akışı. A6: kanıt: playtester raporu (yolun tıklanması); numara resmi kaynaktan teyitli. | ENGEL |
| HA-06 | [RUH] İntihar/kendine zarar yöntem ayrıntısı ve sansasyonel dil yok. | İçerikte Grep: `intihar`, `kendine zarar`, `yöntem`; her isabet bağlamla okunur; ayrıntı veren satır 0. | ENGEL |
| HA-07 | [RUH][SAĞLIK] Test/ölçek sonucu tanı gibi sunulmaz; sonuç ekranında "uzmana danışın" yönlendirmesi var. | Sonuç ekranı metni; Grep: `tanı`, `bozukluğunuz`; sonuç 0. | BUYUK |
| HA-08 | [FİNANS] Gerçek hesap, kart, kimlik verisi istenmez; simülasyon parası açıkça "gerçek değil". | Ekran envanteri; Grep: `iban`, `kart no`, `cvv`, `tc kimlik`; sonuç 0; simülasyon etiketi: kanıt: playtester raporu. | ENGEL |
| HA-09 | [GÜVENLİK] Savunma odaklı çerçeve: her saldırı tekniği tespit, önleme, azaltma anlatımıyla eşleşir; saldırı adımı tek başına verilmez. | Örneklemde konu → savunma bölümü tablosu; savunmasız konu 0. | ENGEL |
| HA-10 | [GÜVENLİK] Uyarı: yalnız sahibi olunan ya da yazılı izin alınan sistemlerde denenir; izinsiz erişim yasadışıdır. | Uyarı metni ve konumu (ilk ekran/README + teknik içeriğin girişi). | ENGEL |
| HA-11 | [GÜVENLİK] Alıştırmalar yalıtılmış simülasyonda; gerçek hedef ve canlı kullanılabilir zararlı kod yok. İzinli: RFC 5737 (192.0.2.x, 198.51.100.x, 203.0.113.x), RFC 1918 özel ağlar, 127.0.0.0/8, `example.com`/`.org`/`.net`, `.test`, `.invalid`, `.localhost`. | İçerikte Grep: `\b\d{1,3}(\.\d{1,3}){3}\b` (IPv4) ve `https?://`; izinli aralık dışı isabet 0. Yalıtım: GS-05/GS-16. | ENGEL |
| HA-12 | Uyarı metni sade ve en çok 3 cümle. | Cümle sayımı. | KUCUK |
| HA-13 | İçeriğin alan uzmanınca incelenip incelenmediği README'de açık yazılı. | README'de ilgili satır. | KUCUK |

## Sonuç kuralı
ENGEL maddesi HAYIR ise C-ALAN kapalıdır (REVISE). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, komut çıktısı, playtester raporu yolu) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>`.

## Kaynaklar
- Action Alliance, güvenli mesajlaşma: https://theactionalliance.org/messaging/public-messaging
- Reporting on Suicide (SAVE, güncel adres): https://www.save.org/media/media-recommendations/
- 112 Acil Çağrı Merkezi (Türkiye): https://www.112.gov.tr

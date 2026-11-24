# Kontrol listesi: Çocuk güvenliği ve gizlilik (CG)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir ("kanıt: playtester raporu"). Ses/emülasyon gibi ekibin doğrulayamadığı madde "kullanıcı gözlemi" sayılır (en çok BUYUK).

- **Kapı:** C-COCUK · **Tetikleyici:** kitle = cocuk (<13; her hat, her mod) · **Denetleyen:** critic (A6'da playtester raporu girdi)
- **A2'de bakılır (belge: SPEC/DESIGN/UX/ART_AUDIO; P: docs/BRIEF.md hafif tasarım bölümü):** CG-01, 02, 05, 06, 07, 08, 10, 11.
- **P hattı, A6 (E-A6 içinde, çalışan dilim; kanıt: playtester raporu + kod):** CG-03, 04, 08, 09. Tam denetim terfiden sonra Ü A6'da.
- **A6'da bakılır (çalışan ürün: kod, tester çıktısı, playtester raporu):** tümü.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.
- İlke düzeyi: veri asgarisi, izleme yok, ebeveyn kontrolü. Bölgeye özgü yasal eşik/süre bu listede yoktur.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| CG-01 | Kişisel veri (ad, e-posta, telefon, adres, doğum tarihi, konum, foto, ses, kimlik no, cihaz tanımlayıcısı) toplanmıyor/dışarı gitmiyor. Yalnız cihazda kalan takma ad izinli. | Veri envanteri tablosu. A6 Grep (şema, içerik, kaynak): `email`, `eposta`, `e_posta`, `telefon`, `phone`, `adres`, `dogum`, `birth`, `konum`, `location`, `ad_soyad`; her isabet envanterde "yerel" diye gerekçeli. | ENGEL |
| CG-02 | Hesap ve sunucu tarafı kişisel kayıt yok (yerel profil serbest). Hesap gerekiyorsa C-COCUK yalnız kullanıcı ISTISNA'sı + hukuki danışma notuyla geçer (ebeveyn onayını bu ekip kanıtlayamaz). | A2: UX/SPEC'te giriş/kayıt ekranı yok. A6 Grep: `login`, `signup`, `register`, `password`; sonuç 0 ya da PHASE'te ISTISNA satırı. | ENGEL |
| CG-03 | Reklam, analitik, izleme, çökme raporlama, üçüncü taraf SDK/script yok. | Bağımlılık/kilit dosyası listelenir. Grep: `analytics`, `gtag`, `adsbygoogle`, `fbq(`, `facebook pixel`, `sentry`, `mixpanel`, `amplitude`. | ENGEL |
| CG-04 | Dış kaynak yüklenmiyor (CDN yazı tipi, script, görsel, iframe). | Grep: `https://`, `http://`, `//cdn`; SVG ad alanı (`xmlns`, `www.w3.org`) hariç, kalan isabetler listelenir. | ENGEL |
| CG-05 | Dış bağlantı yok; varsa ebeveyn kapısı arkasında (çocuğun tek dokunuşla geçemeyeceği yetişkin doğrulaması). | Grep: `href="http`, `target="_blank"`. Varsa kapı ekranı: kanıt: playtester raporu. Kapısız dış bağlantı = HAYIR. | ENGEL |
| CG-06 | Serbest sohbet, yorum, mesajlaşma, kullanıcı içeriği paylaşımı yok. | A2: ekran envanteri. A6 Grep: `textarea`, `contenteditable`, `type="text"`; her alan "yalnız yerelde, gönderilmez" diye gerekçeli. | ENGEL |
| CG-07 | Gerçek parayla satın alma, gerçek parayla alınan sanal para, ücretli rastgele ödül, abonelik, ödeme yok. Oyunda kazanılan puan/jeton serbest (manipülasyon yönü CG-08'de). | Ekran envanteri. Grep: `satın al`, `ödeme`, `abone`, `purchase`, `checkout`, `subscribe`, `price`. | ENGEL |
| CG-08 | Manipülatif örüntü yok: (a) durdurulamayan otomatik sonraki bölüm/oynatma, (b) çıkışta suçlayıcı/utandırıcı metin, (c) seri (streak) kaybı cezası, (d) geri sayımla ödül/satın alma baskısı, (e) tekrarlayan bildirim. | A2: UX metin ve akış taraması; her örüntü için "yok" ya da satır. A6: kanıt: playtester raporu (oyun/ders sonu ve çıkış ekranları). | ENGEL |
| CG-09 | Veri dışarı gitmez: ürün çalışırken kendi kökeni dışına istek yok (CG-04 dış kaynak yüklemeyi, bu madde veri gönderimini kapsar). Sunucu günlüğünde kişisel veri yok. | kanıt: playtester raporu (`read_network_requests`: tüm istekler kendi kökeninde); günlük örneği. | ENGEL |
| CG-10 | İlerleme tek adımda silinebilir (sıfırlama); ekran çocuk/ebeveynce bulunabilir. | A2: UX'te ekran var. A6: sıfırlama sonrası veri boş (kanıt: playtester raporu). | BUYUK |
| CG-11 | Gizlilik bildirimi sade Türkçe: ne toplanır/toplanmaz, nerede durur; ebeveyn için kısa bölüm. | README ya da uygulama ekranı; CG-01 envanteriyle çelişki yok (karşılaştırma notu). | BUYUK |
| CG-12 | Çerez/yerel depolama yalnız işlevsel (ilerleme, oturum); izleme tanımlayıcı yok. | Tester `curl.exe -i` çıktısında `Set-Cookie`; depolama anahtarı listesi: kanıt: playtester raporu. | BUYUK |
| CG-13 | Kamera, mikrofon, konum, bildirim izni istenmiyor. | Grep: `getUserMedia`, `geolocation`, `requestPermission`, `Notification`. | BUYUK |
| CG-14 | Ebeveyn bilgi notu var (uygulama ne yapar/yapmaz). | README/ayrı sayfada bölüm (dosya + başlık). | KUCUK |

## Sonuç kuralı
ENGEL maddesi HAYIR ise C-COCUK kapalıdır (REVISE). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, komut çıktısı, playtester raporu yolu) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>` (n = HAYIR sayısı).

## Kaynaklar
- FTC, COPPA SSS (doğrulanmadı; bot engeli): https://www.ftc.gov/business-guidance/resources/complying-coppa-frequently-asked-questions
- 16 CFR Bölüm 312, COPPA Kuralı (doğrulanmadı; bot engeli): https://www.ecfr.gov/current/title-16/chapter-I/subchapter-C/part-312
- KVKK, çocuklar için materyal: https://www.kvkk.gov.tr/Icerik/8028/Cocuklar-Tarafindan-Dikkat-Edilmesi-Gerekenler-Brosur-

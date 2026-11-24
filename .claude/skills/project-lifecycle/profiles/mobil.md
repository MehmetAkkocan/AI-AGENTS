# Profil: mobil
UYARI: Bu profil henüz gerçek bir projeyle SINANMADI. Yöntemler öneridir; "doğrulanmadı" işaretliler ilk kullanımda sınanıp geri yazılır.
Okuyucu: planner, coder, tester, playtester. Ortam: host'ta yalnız git, podman, PowerShell 5.1; Flutter/Android/iOS SDK ve emülatör YOK.

## Kapsam
Telefon/tablet hedefli ürünler. Öncelik: (1) duyarlı web, (2) PWA, (3) Flutter web derlemesi, (4) yerel uygulama (yalnız SPEC'te gerekçeli, MANUEL yol). Önce 1-2 yetiyor mu diye sor; yerel gerekçe (kamera, bildirim vb.) A1'de SPEC'e yazılmadan 4. seçenek seçilmez. Mağaza yayını kapsam dışı.

## Konteyner ve teknoloji varsayılanları
- Duyarlı web / PWA: `web.md` konteyner kuralları. Ek: `manifest.webmanifest`, service worker, `meta viewport`, dokunma hedefi (`erisilebilirlik.md` ER-08 ile aynı: ≥44×44 CSS px; kitle=cocuk ≥48 CSS px), `env(safe-area-inset-*)`, tek elle kullanım.
- PWA kurulabilirliği HTTPS ister, `http://localhost` istisnadır (tarayıcı davranışı; bu ortamda doğrulanmadı).
- Flutter web: konteynerde Flutter SDK'lı topluluk imajıyla (ör. cirruslabs; resmi Google imajı yok; doğrulanmadı) `flutter build web`; çıktı statik klasör, çok aşamalı `Containerfile` ile statik sunucu imajına kopyalanır. Doğrulanmadı: imaj sürümü/boyutu/indirme süresi, `flutter test` konteynerde koşması, pub önbelleği. Sürüm sabitlenip ADR'ye yazılır (Ü/hafif: ARCHITECTURE §1 gerekçesinde).
- Android APK konteyner derlemesi kuramsal (doğrulanmadı); iOS imkansız (macOS gerekir); emülatör yok.
- Görsel/ses kodla (SVG, CSS, canvas, WebAudio); raster ve kayıtlı ses yok. Mobil tarayıcıda ses kullanıcı dokunuşundan sonra başlar.

## run.ps1 eşlemesi
Anahtarlar `web.md` ile aynı (`-Build -Up -Down -Test -Check -E2E -Logs`; başarı exit 0; `-Test` ayrı test aşaması/imajı, çalışma imajında değil). Farklar:
| Anahtar | Mobil farkı |
|---|---|
| `-Build` | web/PWA: `web.md` gibi; Flutter web: çok aşamalı build (doğrulanmadı) |
| `-Test` | konteyner içi birim testi; Flutter: `flutter test` (doğrulanmadı) |
| `-Check` | `manifest` geçerli mi, service worker dosyası ve ikon SVG'leri var mı, içerik doğrulaması |
| `-E2E` | `curl.exe` HTTP senaryosu + `manifest`/`sw.js` 200 denetimi |
| `-Lan` (isteğe bağlı) | yalnız `-Up` ile ve yalnız "Cihazda test" (b) seçeneğinde: `0.0.0.0:<port>` bağlaması, LAN adresini yazdırır; varsayılan KAPALI |
Yerel uygulama (MANUEL yol): `run.ps1` yalnız web sürümünü kapsar; cihaz derlemesi kullanıcı işidir.

## Test kancaları
- `web.md` kancaları (sağlık ucu, `-Check`, HTMX başlığı) geçerli.
- Dokunma hedefi: 375×812'de tıklanabilir öğe boyutları `javascript_tool` ile (salt-okunur ölçüm) ve ağaçla bakılır.
- Çevrimdışı: service worker dosyasının varlığı HTTP ile; gerçek çevrimdışı davranış TARAYICI ister (doğrulanmadı).

## Playtest yöntemi
Sıra: TARAYICI → HTTP → MANUEL; `YONTEM:` raporda yazılır. Görsel kanıt kuralı `web.md` Playtest yöntemi ile aynı: panel araçları çalışır, ekran görüntüsü dosyaya kaydedilmez, panel görünür tutulur, `GORSEL: KONTROL EDILDI` yalnız görüntü gerçekten görüldüyse (metin betimi + ağaç + JS ölçümü), aksi `DOGRULANMADI`.
1. TARAYICI: `run.ps1 -Up` → panelde 375×812 (ve 768×1024); metin taşması/kırpılma, dokunma hedefi boyutu, konsol hataları, 4xx/5xx, erişilebilirlik ağacı. Gerçek dokunma, kaydırma hareketi, sensörler ölçülemez.
2. HTTP: çerezli `curl.exe`; `GORSEL: DOGRULANMADI`.
3. MANUEL (yerel uygulama ya da cihaz özelliği): iki çağrılı akış (`agents/playtester.md`, `a6-dogrulama.md` adım 4; P: `a6-dogrulama-p.md` adım 2): (1) playtester elle test senaryosu + gözlem formu hazırlar (görev adımları, beklenen sonuç, BASARDI/ZORLANDI/BASARAMADI kutuları, cihaz modeli/ekran, serbest not), SONUC vermez; lider formu kullanıcıya sunar, yanıtı `state/MANUEL-<p>.md`'ye yazar; (2) playtester yanıtı değerlendirip SONUC döner; `YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`; form K3/K4 görsel onayının yerini tutmaz; aşama K3/K4 ile bitmiyorsa kullanıcının formu görsel onay sayılır (GECER ise kayıt `ISTISNA`, `kullanici: gorsel onay (MANUEL form); <rapor yolları>`). Cihaza erişim aşağıdaki "Cihazda test" kuralıyla.

**Cihazda test** (yalnız profil mobil): varsayılan YOK (port yalnız 127.0.0.1). P hattında yalnız (a) vardır; Ü hattında lider kullanıcıya iki seçenek sunar. (a) tarayıcıda 375×812 emülasyonla yetin; cihaza/PWA'ya özgü maddeler "kullanıcı gözlemi — yapılamadı" olarak BACKLOG'a; (b) yalnız Ü hattı: kullanıcı kararıyla (ISTISNA) yalnız test süresince geçici yerel ağ erişimi: tester `run.ps1 -Up -Lan` (isteğe bağlı anahtar, varsayılan kapalı), kayıt `C-GUV | urun | A6 | kullanici | ISTISNA | kullanici: gecici -Lan cihaz testi (GS-06) | <gün>` ve hemen ardından aynı anahtarla `BEKLIYOR` (C-GUV denetimi yine koşar), test bitince tester `-Down`. HTTPS gerektiren PWA özellikleri (kurulum, service worker, bildirim) yerel ağda test edilemez → BACKLOG.

## Sınırlar
- Gerçek cihaz, parmak ergonomisi, pil/performans, iOS Safari farkları ölçülemez.
- Yerel SDK ve emülatör yok; yerel uygulama kullanıcı elinde derlenip denenir.
- Mağaza yayını, imzalama, bildirim hizmetleri kapsam dışı.
- Flutter konteyner derlemesi doğrulanmadı; profil gerçek projeyle sınanmadan yazıldı.

## Yayın paketi
Web/PWA: `web.md` paketi + README'ye "ana ekrana ekle" adımları. Flutter web: statik klasör imaja gömülü, `run.ps1 -Build -Up`. Yerel uygulama: kaynak + derleme talimatı + sürüm notu; ikili üretilmez. Etiket `vX.Y.Z`; temiz klon testi yalnız web sürümü için (T-A7).

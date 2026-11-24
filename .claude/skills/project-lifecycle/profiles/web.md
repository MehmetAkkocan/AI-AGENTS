# Profil: web
Okuyucu: planner, coder, tester, playtester. Ortam: host'ta yalnız git, podman, PowerShell 5.1; her şey konteynerde derlenir/çalışır.

## Kapsam
Tarayıcıda çalışan eğitim, öğrenme ve oyun ürünleri. Dağıtım yok: yayın = yerel paket + etiket + sürüm notu. Mobil görünüm (375×812) bu profilde sınanır; yerel uygulama: `mobil.md`.

## Konteyner ve teknoloji varsayılanları
Tüm aileler TEK konteynerde (tek `Containerfile` + `compose.yaml`); seçim A1/A3'te ADR'ye yazılır (Ü/hafif: ARCHITECTURE §1 gerekçesinde).
| Aile | Ne zaman | Not |
|---|---|---|
| Sunucu taraflı + HTMX (FastAPI/Jinja2, Rust/axum + şablon vb.) | Hesap/ilerleme kaydı, sunucuda değerlendirme gerekir | İlerleme: SQLite/dosya, `./data` birimi. Örnek yığın: FastAPI + HTMX + Jinja2 + SQLite |
| Saf statik HTML/JS | Sunucu verisi yok, içerik sabit; küçük prototip | Ayrıcalıksız statik sunucu (ayrıcalıksız nginx varyantı ya da tek ikili) + gerekli yollara tmpfs; resmi nginx imajının `cap_drop: ALL` + `read_only` ile açılışta çökmesi beklenir (doğrulanmadı) |
| Canvas oyunu | Gerçek zamanlı oyun | Statik sunum + `masaustu-motor.md` test kancaları ZORUNLU |
Compose: `build.dockerfile: Containerfile` açık yaz; port yalnız `127.0.0.1:<port>:<port>` (tek istisna: `mobil.md` "Cihazda test" (b), kullanıcı ISTISNA'sıyla geçici `run.ps1 -Lan`, varsayılan kapalı); `read_only: true`, `cap_drop: [ALL]`, `no-new-privileges`, `tmpfs: /tmp`, `mem_limit`/`pids_limit`; kalıcı veri `./data:/app/data:Z`. Kullanıcı kodu çalıştıran ürün (C-GUV): kaynak sınırı yetmez; `guvenlik-sertlestirme.md` GS-05'in beş özelliği sağlanır ve düşmanca denemeleri `run.ps1 -Test`'te koşar; bu projede yazılabilir `./data` dizini kullanıcı kodundan yalıtılmalıdır (okuyamaz, yazamaz; GS-05; mekanizma A3'te ADR'de) (kodu uygulamayla aynı konteynerde derleyip ağı kapatmayan tasarım GS-05'i geçmeyebilir; doğrulanmadı).
Görsel/ses KODLA: SVG, CSS, canvas, WebAudio sentezi; raster görsel ve kayıtlı ses yok. Tasarım belirteçleri tek CSS değişken dosyasında.

## run.ps1 eşlemesi
Standart anahtarlar; başarı exit 0; her `podman` çağrısından sonra `$LASTEXITCODE` denetlenir. Anahtarsız = `-Build -Up`. Komutları tester koşar; playtester yalnız `-Up`/`-Down`/`-Logs`.
| Anahtar | Komut (örüntü) |
|---|---|
| `-Build` | `podman build -f Containerfile -t <ad>:latest .` |
| `-Up` | imaj yoksa build; `podman compose up -d`; adresi yazdır (`podman-compose` yedeği) |
| `-Down` | `podman compose down` |
| `-Test` | çalışma imajında DEĞİL: `Containerfile`'da ayrı `test` aşaması (`podman build --target test` + `podman run --rm`) ya da ayrı test servisi/imajı; sebep: çalışma imajı yalnız ikili/içerik taşır, kök `read_only`. Doğrulanmadı; ADR'ye yaz (Ü/hafif: ARCHITECTURE §1) |
| `-Check` | `podman compose run --rm <servis> <içerik doğrulama komutu>` |
| `-E2E` | kendisi `-Up` çağırır, HTTP senaryosunu koşar; `-Up` sonrası sağlık ucu 200 dönmezse exit 1 + mesaj; kendi başlattığını tester durdurur |
| `-Logs` | `podman compose logs -f <servis>` |
`-Test` ve `-E2E` her yeni projede A3'te yazılır; servis adı, port, test/check komutu ARCHITECTURE'da tanımlanır.

## Test kancaları
- Sağlık ucu (200 + kısa gövde) ve `-Check` iskelette zorunlu.
- E2E Playwright'sız: Windows yerleşik `curl.exe` (PS 5.1'de `curl` takma adı değil) ile senaryo: ana sayfa 200 → çerez kavanozlu (`-c/-b`) oturum → görev/ilerleme POST'u → beklenen metin. Her adımda durum kodu + gövdede anahtar metin. `Invoke-WebRequest` kullanılırsa `-UseBasicParsing`.
- HTMX POST'a `HX-Request: true` ekle (CSRF koruması bu başlığı zorunlu tutar; `Origin` varsa `Host` ile aynı).
- Canvas oyunu: `?debug=1&seed=N`, `window.__game.getState()` (`masaustu-motor.md`).

## Playtest yöntemi
Sıra: TARAYICI → HTTP → MANUEL (kullanıcı gözlemi); `YONTEM:` raporda yazılır.
1. TARAYICI: tarayıcı paneli araçları alt ajanda ÇALIŞIR (smoke doğruladı: navigate, read_page, get_page_text, read_console_messages, read_network_requests, resize_window, javascript_tool). önce çalışıyor mu bak, çalışmıyorsa `run.ps1 -Up` → yerel adres; `Oturum: acik-birak` ise ürünü açık bırak, `kapat` ise YALNIZ kendi başlattığını `-Down` (başkasının açtığına dokunma); her ekran masaüstü + 375×812 (`resize_window`); konsol hataları, 4xx/5xx, erişilebilirlik ağacı (etiket, başlık sırası, odak); yatay taşma `javascript_tool` ile ölçülür (salt-okunur).
2. Ekran görüntüsü DOSYAYA kaydedilemez; panel gizliyken 5 sn zaman aşımı olur → lider kullanıcıdan Browser panelini görünür tutmasını ister. `GORSEL: KONTROL EDILDI` yalnız ajan o ekran × görünümün görüntüsünü GERÇEKTEN gördüyse; kanıt = görüntünün metin betimi + ağaç alıntısı + gerekirse JS ölçümü (boyut, taşma, renk). 2 yeniden denemeden sonra alınamazsa hücre `DOGRULANMADI`. `reports/shots/` isteğe bağlıdır, hiçbir kapı ona bağlı değil.
3. HTTP: çerezli `curl.exe`, HTMX için `HX-Request: true`; `GORSEL: DOGRULANMADI` (bilgi); K3/K4'te kullanıcının görsel onayı her zaman alınır; aşama K3/K4 ile bitmiyorsa (tam modda P-A5; K3'süz Ü/A4) kullanıcı görsel onayı + kapı kaydı ISTISNA.
4. MANUEL: kullanıcı gözlemi; iki çağrılı akış (`agents/playtester.md`, `a6-dogrulama.md` adım 4; P: `a6-dogrulama-p.md` adım 2: form → kullanıcı yanıtı `state/MANUEL-<p>.md` → değerlendirme); `GORSEL: DOGRULANMADI`; form K3/K4 görsel onayının yerini tutmaz; aşama K3/K4 ile bitmiyorsa kullanıcının formu görsel onay sayılır (ISTISNA).
Ses, animasyon hissi, refleks ölçülemez ("doğrulanmadı" yaz).

## Sınırlar
Bilinen tuzaklar:
- `dockerfile: Containerfile` açık yazılı; açık yazmak her durumda güvenli (varsayılan aramanın sağlayıcıya göre değiştiği doğrulanmadı).
- Port yalnız `127.0.0.1`'e bağlı (`compose.yaml`); `0.0.0.0` yapma (tek istisna: `mobil.md` "Cihazda test" (b), kullanıcı ISTISNA'sıyla geçici `run.ps1 -Lan`, varsayılan kapalı).
- CSRF: POST'ta `HX-Request` yoksa istek reddedilir; test istemcisi de göndermeli.
- PS 5.1 BOM'suz UTF-8 betiği ANSI okur (`run.ps1` BOM'suz, ASCII): `run.ps1` ve mesajlar ASCII; Türkçe karakter yalnız `.md`/içerikte.
- `restart: unless-stopped` + açılışta çöken uygulama = sessiz restart döngüsü; `-Up` sonrası `podman ps` + `-Logs` bak (genel davranış; doğrulanmadı).
- `-Up` yalnız imaj yoksa build eder; kod değişince `-Build` şart (temiz klon testi `-Build -Up`).

## Yayın paketi
`README.md` (tek komut `run.ps1 -Build -Up`, adres, `-Down`) + `CHANGELOG.md` + git etiketi `vX.Y.Z`. Doğrulama: temiz klon → `run.ps1 -Build -Up` → `-E2E` PASS (T-A7). Yükleme kullanıcıda.

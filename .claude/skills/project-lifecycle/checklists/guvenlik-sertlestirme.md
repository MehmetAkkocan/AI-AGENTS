# Kontrol listesi: Güvenlik sertleştirme (GS)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir. Komut denemeleri (`curl.exe`, `podman inspect`, tarama, sandbox denemesi) tester'ın çıktısıyla kanıtlanır; critic kod/yapılandırmayı okur.

- **Kapı:** C-GUV · **Tetikleyici:** hat = urun; P'de kullanıcı girdisi çalıştırma / hesap / ağ varsa temel · **Denetleyen:** critic + global skill `security-and-hardening`
- **[temel]** (P hattı için zorunlu alt küme): GS-01, 02, 05, 06, 08. Ü hattında tümü.
- **A3'te bakılır (sözleşme ve tasarım: ARCHITECTURE, API.md, Containerfile/compose):** GS-01, 03, 04, 05, 06, 07, 09, 16. **A6'da bakılır:** tümü (tester denemeleri, `run.ps1 -Up` sürümünde).
- Özelliği olmayan madde (hesap yok, kullanıcı kodu yok) = UYGULANMAZ + tek satır gerekçe.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| GS-01 | Girdi doğrulaması sunucuda: tip, uzunluk, aralık, izinli değer sözleşmede ve kodda; geçersiz girdi 4xx. | A3: API.md alan kuralları. A6: tester `curl.exe` ile bozuk tip ve aşırı uzun girdi → 4xx (5xx = HAYIR). | ENGEL |
| GS-02 | Çıktı kaçışlama: şablon otomatik kaçışı açık; ham HTML basma (Jinja `safe` filtresi, `innerHTML`) yok ya da gerekçeli. | Grep: `innerHTML`, `v-html`, `autoescape`, `Markup(`, `safe` (filtre); isabet gerekçeli. A6: tester girdiye betik metni yazar, ekranda düz metin (playtester raporu). | ENGEL |
| GS-03 | CSRF: durum değiştiren istekler jeton ya da SameSite çerez + Origin denetimiyle korunur; GET durum değiştirmez. | A6: tester jetonsuz/yabancı Origin'li `curl.exe -X POST` → 403/4xx. Grep: GET yollarında yazma işlemi yok. | ENGEL |
| GS-04 | Hesap varsa: parola adaptif özetle (argon2, bcrypt, scrypt) saklanır; oturum çerezi HttpOnly + SameSite. | Kod Grep: `argon2`, `bcrypt`, `scrypt`; düz `password` saklama yok. Tester `curl.exe -i` çerez bayrakları. Hesap yoksa UYGULANMAZ. | ENGEL |
| GS-15 | Hesap varsa: çıkışta oturum geçersiz olur; giriş denemesi sınırlıdır. | Tester: çıkış sonrası eski çerezle istek reddedilir; ardışık hatalı giriş engellenir (çıktı). | BUYUK |
| GS-05 | Kullanıcı kodu/girdisi çalıştırılıyorsa yalıtım ÖZELLİKLERİ sağlanır (mekanizma serbest; ana sunucu sürecinde `eval/exec` yok). Kullanıcı kodu: (1) sunucunun veri dizinini (ör. `./data`, ilerleme kayıtları) okuyamaz ve yazamaz; (2) sunucu sırlarını ve sunucu sürecinin ortam değişkenlerini göremez; (3) kök dosya sistemine yazamaz (yalnız kendine ayrılmış geçici alana yazar); (4) ağa çıkamaz; (5) süre ve bellek/süreç sayısı sınırı vardır (sonsuz döngü, çatallanma bombası sunucuyu düşürmez). Mekanizma A3'te ADR'de seçilir (ör. ayrı kullanıcı, ayrı yalıtılmış süreç/konteyner, seccomp/Landlock, ya da kodu sunucuda hiç çalıştırmamak — hiçbiri bu ekipte doğrulanmadı; seçim ADR'de). GS-09'un bir maddesini gevşetmeyi gerektiren mekanizma yalnız kullanıcı kararıyla PHASE'e ISTISNA olarak yazılır. | A3: `docs/adr/` altında tehdit modeli + mekanizmayı, gerekçesini ve beş özelliğin nasıl sağlandığını yazan ADR var; critic Grep ile test dosyasının yolunu ve beş düşmanca denemenin varlığını gösterir: veri dizinini okuma/yazma, `env`/sır okuma, kök dosya sistemine yazma, dış adrese bağlantı, sonsuz döngü + büyük bellek/çatallanma. A6: bu denemeler `run.ps1 -Test` içinde koşar, her biri reddedilir; kanıt tester raporundaki PASS (rapor yolu). `/etc/passwd` gibi herkesin okuyabildiği dosyayı okuma ölçüt değildir. Kod yalnız tarayıcıda çalışıyorsa ADR bunu yazar ve Grep sunucuda kullanıcı kodunu çalıştıran çağrı (`eval`, `exec`, `subprocess`, derleyici çağrısı) olmadığını gösterir; düşmanca deneme gerekmez. Kullanıcı kodu yoksa UYGULANMAZ. | ENGEL |
| GS-16 | Kullanıcı kodunun çalıştığı süreçten dış ağ erişimi yok; sağlanamıyorsa ADR'de gerekçeli kalan risk. | A3: ADR. A6: tester çalıştırma sürecinden dış adrese bağlantı denemesi → başarısız (çıktı). | BUYUK |
| GS-06 | Yalnız 127.0.0.1'e bağlanır: port yayını `127.0.0.1:<port>:<port>`, `0.0.0.0` yok. Not: ISTISNA ile geçici `-Lan` — `0.0.0.0` yalnız isteğe bağlı `run.ps1 -Lan` yolunda, varsayılan kapalı, yalnız test süresince ve PHASE'te kullanıcı ISTISNA kaydı varsa (`mobil.md` "Cihazda test"); varsayılan `-Up` yine 127.0.0.1. | Grep compose/`run.ps1`: `0.0.0.0`, `ports`; tester `podman port <kapsayıcı>` çıktısı. | ENGEL |
| GS-07 | Bağımlılıklar sabit (tam sürüm/kilit dosyası); taban imaj etiketi sabit (`latest` yok); bilinen açık taraması çalıştırılmış, yüksek bulgu 0 ya da gerekçeli. Tarama komutu yığına göre ARCHITECTURE'da yazılı; çalıştırılamazsa KUCUK + BACKLOG. | Kilit dosyası ve `FROM` satırı; tester tarama çıktısı (araç adı rapora; araç ve komut örnekleri doğrulanmadı: ör. `pip-audit`, `cargo audit`, `npm audit`). | BUYUK |
| GS-08 | Kaynakta, imajda, günlükte gizli bilgi yok; `.env` izlenmiyor. | Grep: `secret`, `password`, `api_key`, `apikey`, `token` (isabette değer mi ad mı bakılır); `.gitignore` satırı; tester `git log -S` çıktısı. | ENGEL |
| GS-09 | Konteyner ayrıcalıksız (tek konteynerle uyumlu): root olmayan `USER`, `privileged` yok, `cap_drop: ALL` (gerekli yetenek tek tek ADR'de gerekçeli), `no-new-privileges`, host/podman soketi bağlı değil (kardeş konteyner tasarımı yok), salt okunur kök + tmpfs. | A3: Containerfile/compose Grep: `USER`, `privileged`, `cap_drop`, `no-new-privileges`, `docker.sock`, `podman.sock`. A6: tester `podman inspect` çıktısı. | BUYUK |
| GS-10 | Güvenlik başlıkları: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, çerçeveleme engeli. | Tester `curl.exe -I http://127.0.0.1:<port>/` çıktısı; eksik başlık listesi. | BUYUK |
| GS-11 | Hata ayıklama kapalı; hata yanıtı yığın izi ve iç yol vermez (YO-09 buna atıf yapar). | Tester: olmayan yola ve bozuk gövdeye `curl.exe`, yanıtta iz yok. Grep: `debug=True`, `--reload`, `DEBUG`. | BUYUK |
| GS-12 | SQL parametreli; dize birleştirmeyle sorgu yok. | Grep: `execute(`, `query(`; her çağrıda parametre bağlama kullanıldığı okunur. | BUYUK |
| GS-13 | Dosya yolu girdiden kurulmaz ya da izinli dizinde kanonikleştirilir. | Tester `../` ve mutlak yollu istek → 4xx; Grep: `open(`, `File::open`, `readFile`. | BUYUK |
| GS-14 | İstek gövdesi boyutu sınırlı; günlük kişisel veri içermez. | Yapılandırma satırı; tester aşırı büyük gövde → 413/4xx; günlük örneği. | KUCUK |

## Sonuç kuralı
ENGEL maddesi HAYIR ise C-GUV kapalıdır (REVISE). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, tester çıktısı yolu) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>`.

## Kaynaklar
- OWASP ASVS: https://asvs.owasp.org
- OWASP Cheat Sheet — ASVS dizini: https://cheatsheetseries.owasp.org/IndexASVS.html
- OWASP, CSRF önleme: https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html
- OWASP, Docker güvenliği: https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html

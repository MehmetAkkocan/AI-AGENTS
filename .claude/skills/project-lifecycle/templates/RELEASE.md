<!-- A7 | sahip: writer (coder paketler, tester temiz klonu doğrular) | hedef: docs/RELEASE.md | kapı: T-A7 (temiz klondan tek komutla kurulup çalışır) -->
<!-- Ü/hafif'te RELEASE.md YOKTUR: README'nin kurulum bölümü + CHANGELOG + etiket yeter (yayin-oncesi maddeleri README ile karşılanır). Orta: tüm bölümler. Tam: geri alma ayrıntılı. P hattında A7 yoktur. Yer tutucu adı: <ad>. -->
# RELEASE <ad> <vX.Y.Z>

## Sürüm
<!-- doldurma talimatı: SemVer sürüm, git etiketi vX.Y.Z, tarih (yyyy-MM-dd), karşılık gelen VERIFICATION yayın adayı satırı. -->
vX.Y.Z / <yyyy-MM-dd> / doğrulama: docs/VERIFICATION.md

## Paket içeriği
<!-- doldurma talimatı: pakette ne var (kaynak, içerik, run.ps1, README.md, CHANGELOG.md); ne yok (ör. test raporları). 5-10 satır. -->
- <öğe>

## Temiz kurulum
<!-- doldurma talimatı: sıfır makinede TEK komutla kurulup çalışan adım (önkoşul: git, Podman, PowerShell 5.1). Komutu temiz klonda gerçekten çalıştır; -Up derlemeyi içermiyorsa komutu "-Build; -Up" sırasıyla yaz. -->
```
git clone <depo-yolu> <klasör>
cd <klasör>; powershell -NoProfile -ExecutionPolicy Bypass -File run.ps1 -Up
```
Adres: <http://localhost:...>

## Doğrulama
<!-- doldurma talimatı: tester'ın temiz klonda kurulum + smoke sonucu: PASS/FAIL + rapor yolu. -->
T-A7: <PASS/FAIL> / rapor: <projects/<ad>/reports/...>

## Bilinen sorunlar
<!-- doldurma talimatı: VERIFICATION "Bilinen sorunlar" (≤3) kullanıcı diliyle + geçici çözüm; kopyala, yeni sorun ekleme. -->
- <sorun - çözüm>

## Geri alma
<!-- doldurma talimatı: kaynağı VERIFICATION "Geri alma" bölümü; burada tam adımlar: önceki etiket, konteyner/imaj temizliği, veri uyumluluğu. Tam modda ayrıntılı. -->
1. <adım>

## Lisans ve atıf
<!-- doldurma talimatı: proje lisansı (kullanıcıya sor, uydurma), üçüncü taraf kütüphane/font/içerik atıfları; yoksa "yok". -->
<lisans> / atıf: <liste>

## Dışarıya yükleme
<!-- doldurma talimatı: bu notu aynen koru. -->
Dışarıya yükleme (depo, mağaza, barındırma) kullanıcıya aittir; ekip yalnız yerel paket, etiket ve sürüm notu üretir.

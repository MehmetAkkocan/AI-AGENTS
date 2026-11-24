# Kontrol listesi: Yayın öncesi (YO)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir. Komut çıktıları (`run.ps1`, `git`, `curl.exe`) tester raporundan gelir.

- **Kapı:** E-A6 (K4 öncesi; yalnız yayın ADAYI maddeleri) · A7: critic + T-A7 (belge, etiket, temiz klon). T-A6 tester bu listeyi koşmaz; tester dönüşü PASS/FAIL, critic tablosuna girdi olur.
- **A6'da bakılır (yayın adayı):** YO-07, YO-09, YO-10, YO-14.
- **A7'de bakılır (critic + T-A7):** YO-01 … YO-06, YO-08, YO-11, YO-12, YO-13 (+ A6 maddelerinin son hali).
- **Ü/hafif:** RELEASE.md yoktur; RELEASE'e bağlı maddeler (YO-05, 07, 11) README'nin kurulum ve bilinen sorunlar bölümüyle karşılanır; geri alma (YO-11) UYGULANMAZ + gerekçe.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| YO-01 | Temiz klondan tek komutla kurulum ve çalışma: README'deki tek komut exit 0 verir, adres yanıt verir. | Tester: boş dizine `git clone`; `.\run.ps1 -Build -Up` (eski imaj tuzağı: `-Up` tek başına var olan imajı kullanır); `curl.exe -s -o NUL -w "%{http_code}" http://127.0.0.1:<port>/` = 200; çıktılar rapora. | ENGEL |
| YO-02 | Temiz klonda `run.ps1 -Test`, `-Check`, `-E2E` hepsi exit 0. | Tester: üç komutun çıktısı ve exit kodu. | ENGEL |
| YO-03 | README tam: ne olduğu, önkoşullar, tek komut kurulum, durdurma (`-Down`), adres, sorun giderme. | README başlık listesi; her kod bloğu klonda çalıştırılmış (YO-01 çıktısı). | BUYUK |
| YO-04 | CHANGELOG'da bu sürüm için tarihli giriş var (Eklendi / Değişti / Düzeltildi). | `CHANGELOG.md` sürüm başlığı ve tarih satırı. | BUYUK |
| YO-05 | RELEASE.md eksiksiz: sürüm, kapsam, doğrulama özeti (VERIFICATION.md bağlantısı), kurulum, geri alma; boş bölüm ve "TODO" yok. Ü/hafif: README kurulum bölümü. | Bölüm listesi; Grep: `TODO`, `TBD`, `XXX`; sonuç 0. | BUYUK |
| YO-06 | Sürüm etiketi `vX.Y.Z` (SemVer) yayın commit'ini gösterir ve CHANGELOG/RELEASE sürümüyle aynı (A7 sırası: `vX.Y.Z`, sonra `u-asama-A7`). | Tester: `git tag -l` ve `git describe --tags` çıktısı; belgelerdeki sürümle karşılaştırma. | ENGEL |
| YO-07 | Bilinen sorunlar yazılı: A6'da VERIFICATION.md/BACKLOG'da, A7'de RELEASE.md'de (Ü/hafif: README); en çok 3, fazlası K4 sunumunda gerekçeli; her biri BACKLOG kimliğine bağlı. | VERIFICATION.md bölümü; Grep: `ENGEL: 0` (VERIFICATION.md); A7'de RELEASE/README bölümü aynı liste. | BUYUK |
| YO-08 | Lisans ve atıf: LICENSE var (ya da "lisanssız, tüm hakları saklı" bilinçli yazılı); üçüncü taraf bağımlılık, yazı tipi, içerik atıfları listede. | LICENSE yolu; README/NOTICE atıf bölümü; bağımlılık listesiyle karşılaştırma notu. | BUYUK |
| YO-09 | Test kancası (`window.__game`, vb.) yalnız `?debug=1` modunda açılır; yayın adayında varsayılan kapalı ve ayrıcalıklı etki (ölümsüzlük, puan yazma) vermez. (Hata ayıklama kipi/yığın izi: GS-11.) | Grep: `__game`, `debug`; kanıt: playtester raporu (`javascript_tool`: debug'sız `typeof window.__game`). Kanca yoksa UYGULANMAZ. | BUYUK |
| YO-10 | Kaynakta, geçmişte, pakette gizli bilgi yok. | GS-08 kanıtı geçerli (atıf) + paket dosya listesinde `.env`, anahtar, veri tabanı dosyası yok. | ENGEL |
| YO-11 | Geri alma adımı yazılı ve denenmiş (önceki etikete dönüş + varsa veri yedeği/geri yükleme); Ü/orta ve tam. | Komutlar RELEASE.md'de; tester deneme çıktısı. Ü/hafifte UYGULANMAZ + gerekçe. | BUYUK |
| YO-12 | Yayın commit'inde çalışma ağacı temiz; geçici dosya, günlük, yerel veri yok. | Tester: `git status --porcelain` boş; `git ls-files` içinde günlük/veri dosyası yok. | BUYUK |
| YO-13 | Çalışan üründe sürüm numarası görülebilir ve etiketle aynı. | Ekran/yanıt kanıtı: playtester raporu ya da tester `curl.exe` çıktısı. Görünür yer yoksa KUCUK HAYIR. | KUCUK |
| YO-14 | PHASE `kosullu:` satırındaki her C-* kapısının son kaydı APPROVE ya da `ISTISNA`; VERIFICATION.md'de `ENGEL: 0`. | PHASE.md `Kapi kayitlari` satırları (kapı, sonuç, rapor yolu); Grep: `ENGEL: 0`. | ENGEL |

## Sonuç kuralı
ENGEL maddesi HAYIR ise E-A6 (K4 sunumu) ya da T-A7 kapalıdır (REVISE / FAIL). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, tester çıktısı yolu) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>` (tester: `SONUC: PASS | FAIL`).

## Kaynaklar
- Semantic Versioning: https://semver.org
- Keep a Changelog: https://keepachangelog.com
- Git etiketleme: https://git-scm.com/docs/git-tag
- Lisans seçimi (bilgilendirme): https://choosealicense.com

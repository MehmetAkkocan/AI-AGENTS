# Profil: masaustu-motor
UYARI: Bu profil henüz gerçek bir projeyle SINANMADI. "Doğrulanmadı" işaretliler ilk kullanımda sınanıp geri yazılır.
Okuyucu: planner, coder, tester, playtester. Ortam: host'ta yalnız git, podman, PowerShell 5.1; Godot/Unity/Node/Python YOK.

## Kapsam
Masaüstü oyunları ve motor gerektiren ürünler. ÖNCELİK: tarayıcı tabanlı oyun (canvas + JS, `web.md` altyapısı). Motor (Godot/Unity) yalnız SPEC'te gerekçeli ve K1'de kullanıcı onaylıysa.

## Konteyner ve teknoloji varsayılanları
- Tarayıcı oyunu: `index.html` + modüler JS, canvas 2B, statik sunum (`web.md` canvas satırı). Sabit zaman adımı: `requestAnimationFrame` yalnız çizim; simülasyon sabit `dt` (ör. 1/60 sn) biriktiricide; oyun mantığında `Date.now()`/`Math.random()` yasak.
- Tohumlanabilir rastgelelik: tek PRNG (ör. mulberry32), tohum `?seed=N`; aynı tohum + aynı girdi dizisi = aynı durum.
- Görsel/ses kodla: canvas/SVG, parçacık, WebAudio osilatör/gürültü sentezi; raster ve kayıtlı ses yok.
- JS mantık testleri statik sunucu imajında koşmaz: ayrı test imajı/aşaması (ör. node slim; sürüm A3'te sabitlenir; doğrulanmadı).
- Motor gerekirse: Godot başsız dışa aktarma konteynerde kuramsal (imaj kaynağı, şablonlar, web dışa aktarımı doğrulanmadı); Unity lisans/editör nedeniyle doğrulanmadı, önerilmez. Başsız derleme oyunu OYNAMAZ/GÖRMEZ.

## run.ps1 eşlemesi
Anahtarlar `web.md` ile aynı (`-Build -Up -Down -Test -Check -E2E -Logs`; başarı exit 0). Komutları tester koşar.
| Anahtar | Bu profilde |
|---|---|
| `-Build` | statik imaj (ya da motor dışa aktarımı, doğrulanmadı) |
| `-Up` / `-Down` / `-Logs` | `web.md` gibi; adres `http://localhost:<port>/?debug=1&seed=1` (yalnız geliştirme/playtest adresi) |
| `-Test` | oyun mantığı birim testleri ayrı test imajında (saf fonksiyonlar, DOM'suz; aynı tohum → aynı durum) |
| `-Check` | seviye/denge tablosu gibi içerik/ayar doğrulaması |
| `-E2E` | HTTP smoke (sayfa ve betikler 200) + tarayıcısız mantık testini yeniden koşar |

## Test kancaları
ZORUNLU (yoksa A3 çıkamaz):
- `?debug=1&seed=N`: debug kipi + sabit tohum. Hile kipleri (ölümsüzlük vb.) varsayılan kapalı.
- `window.__game.getState()`: JSON'a çevrilebilir durum (konum, puan, can, sahne, adım sayacı, tohum).
- Önerilen: `__game.step(n)` (n sabit adım), `__game.input(dizi)`, `__game.reset(seed)`.
- Kancalar yalnız `debug=1` ile var olur; yayın adayında varsayılan KAPALI (debug'sız `typeof window.__game` = `undefined`; `javascript_tool` ile doğrulanır, `yayin-oncesi.md` YO-09). Kanca ayrıcalıklı etki (kalıcı kayıt/puan yazma) vermez.
- Playtester `javascript_tool`'u yalnız inceleme ve BU kancalar için kullanır (`getState`, `step`, `input`); uygulama durumunu başka yolla değiştirmez.

## Playtest yöntemi
Sıra: TARAYICI → HTTP → MANUEL; `YONTEM:` raporda yazılır. Görsel kanıt: `web.md` kuralları (panel görünür tutulur; görüntü dosyaya kaydedilmez; `GORSEL: KONTROL EDILDI` yalnız gerçekten görüldüyse, metin betimi + ağaç + JS ölçümü; aksi `DOGRULANMADI`).
1. TARAYICI: panelde `?debug=1&seed=N` ile aç; `getState()` oku, `step`/`input` ile senaryo yürüt (görev tamamlanır mı, kilitlenme, sayı taşması, geçersiz durum), konsol hataları, 4xx/5xx, masaüstü + 375×812 yerleşim. Motorun web dışa aktarımı çalışırsa bu yöntem; çalışmazsa MANUEL.
2. HTTP: yalnız sunumun ayakta olduğunu kanıtlar; `GORSEL: DOGRULANMADI`.
3. MANUEL: motor çıktısı ya da kancasız oyun: iki çağrılı akış (`agents/playtester.md`, `a6-dogrulama.md` adım 4; P: `a6-dogrulama-p.md` adım 2): (1) playtester elle test senaryosu + gözlem formu hazırlar, SONUC vermez; kullanıcı oynar, lider yanıtı `state/MANUEL-<p>.md`'ye yazar; (2) playtester değerlendirip SONUC döner; `YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`; form K3/K4 görsel onayının yerini tutmaz; aşama K3/K4 ile bitmiyorsa kullanıcının formu görsel onay sayılır (GECER ise kayıt `ISTISNA`, `kullanici: gorsel onay (MANUEL form); <rapor yolları>`).
Playtester ÖLÇEMEZ: refleks/tepki süresi, oyun hissi (zorluk algısı, eğlence), FPS/takılma, ses ve müzik. Bu yüzden K3'te kullanıcının OYNAMASI ZORUNLUDUR (adres + `run.ps1 -Up` sunumda); K3 ve K4'te kullanıcının görsel onayı her zaman alınır (`GORSEL:` satırı bilgidir).

## Sınırlar
- Gerçek zamanlı performans ve ses için ölçüm aracı yok; C-PERF yalnız tester'ın sayılabilir ölçütleriyle (nesne sayısı, sabit adım süresi) sınırlı.
- Gamepad/klavye gerçek donanım davranışı ölçülemez.
- Motor yolu: host'ta motor yok; başsız derleme doğrulanmadı; web dışa aktarımı yoksa playtest MANUEL.
- Profil gerçek projeyle sınanmadan yazıldı.

## Yayın paketi
Tarayıcı oyunu: `web.md` paketi (README tek komut, `CHANGELOG.md`, `vX.Y.Z`; temiz klondan `run.ps1 -Build -Up`); yayın adayında debug kancaları kapalı. Motor ikilisi üretilirse konteynerde derlenmiş yerel paket (zip) + sürüm notu; çalıştığı doğrulanmadı. Yükleme kullanıcıda.

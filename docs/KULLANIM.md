# AI Agent Team Kullanım Kılavuzu

Bu kılavuz ekibi kullanan kişi (siz) içindir. Ekip liderinin kuralları `CLAUDE.md` dosyasındadır.

## 1. Kısaca nasıl çalışır

Claude Code'daki ana oturum **ekip lideridir**. Lider iş yapmaz; işi parçalar, doğru uzman ajana verir, kısa raporları okur, karar verir. Ajanlar (araştırmacı, planlayıcı, tasarımcılar, kodlayıcı, yazar) işi üretir. Denetim ayrı ajanlardadır: `critic` çıktıyı eleştirir (APPROVE = uygun, REVISE = düzelt), `tester` komutları koşup PASS/FAIL döner, `playtester` ürünü gerçekten çalıştırıp bir kullanıcı gibi dener. Her ajan tam çıktısını bir rapor dosyasına yazar; lidere en çok 10 satır döner. Siz yalnızca belirli noktalarda (kapılarda) karar verirsiniz.

## 2. Yeni proje başlatma

```
/proje yeni <ad> "<fikir>"
```

`<ad>` küçük harf, rakam ve tire içerir (örn. `rust-ogren`). Lider projeyi kurdurur ve **keşif görüşmesi** başlatır: en çok 7 soru. Ağırlıkla şunlar sorulur: ne tür bir iş (oyun, eğitim, öğrenme, kişisel gelişim), kitle kim (çocuk 13 yaş altı, genç, yetişkin), hangi platform (web, mobil, masaüstü/oyun motoru). Cevaplarınız projenin etiketlerini belirler; kitle ve alan, ek kontrolleri tetikler (bölüm 6).

## 3. İki hat, üç mod

Her proje önce **prototip hattında** başlar (hızlı, hafif; amaç fikrin işe yarayıp yaramadığını görmek). Prototip K3 kapısında (A6 sonu) sizin kararınıza bağlanır; beğenirseniz **ürün hattına** terfi eder. Konsepti zaten onaylı bir proje doğrudan ürün hattına girebilir: bunun için konseptin onaylı olduğunu ve konsept dosyasının yolunu söyleyin; lider projeyi ürün hattıyla kurdurur ve K1 sizden yeniden onay istemeden kayda geçer.

| Durum | Hat / mod | Ne demek |
|---|---|---|
| Fikri denemek istiyorsunuz | prototip | Tek sayfa özet, çalışan küçük dilim, hafif doğrulama, K3'te karar |
| Küçük ürün, tek platform (~12 parçaya kadar) | ürün / hafif | Kısa belgeler, kısa test, yalnız K1 ve K4 |
| İçerik hattı olan ürün (12-40 parça) | ürün / orta | Ayrı tasarım belgeleri, güvenlik, 3 persona; K1, K2, K4 (K3 yalnız doğrudan girişte) |
| Büyük ürün (40+ parça, çoklu platform, hesap/veri) | ürün / tam | Orta + performans, geri alma planı, 4+ persona; K1, K2, K4 (K3 yalnız doğrudan girişte) |

## 4. Dokuz aşama

- **A0 Keşif:** fikir sorulur, kitle/tür/platform belirlenir.
- **A1 Konsept:** ne yapılacağı ve yapılmayacağı yazılır (özet ya da gereksinim belgesi).
- **A2 Tasarım:** oyun/öğrenme tasarımı, ekranlar, görsel ve ses yönü.
- **A3 Mimari ve iskelet:** teknik plan, sözleşmeler, boş ama çalışan iskelet ve test düzeneği.
- **A4 Dikey dilim:** ürünün küçük ama uçtan uca çalışan bir parçası; ürün hattında playtest burada yapılır (prototipte playtest A6'dadır).
- **A5 Üretim:** dilim dilim kod ve içerik üretimi; her dilimde denetim ve kayıt noktası.
- **A6 Doğrulama:** testler, playtest, güvenlik/erişilebilirlik kontrolleri; bulgular toplanır.
- **A7 Yayın:** yerel paket, sürüm etiketi, sürüm notu, temiz kurulum testi.
- **A8 Retro:** neyin iyi/kötü gittiği yazılır; süreç değişikliği yalnız sizin onayınızla.

Prototip hattı A0-A4, ardından hafif A6 doğrulamasını ve K3 kararından sonra A8'i (kısa retro notu) yürür; A5 ve A7 yoktur.

## 5. Sizden ne istenir: kullanıcı kapıları K1-K4

Her aşamanın çıkışında önce ekip kendi denetimini (critic, tester, playtester) bitirir; kapı kararları 4 yerde size gelir; ayrıca istisna, görsel onay ve tıkanma sorularında da sizden karar istenir (bölüm 6, 7). Lider en çok 15 satırlık bir sunum yapar. Kararı sohbette kendi cümlenizle yazarsınız; belirsiz cevap karar sayılmaz, seçenekler yeniden sorulur.

**K1 Konsept** (A1 sonu, tüm projeler): ürün tek cümle, tür/kitle/profil, kapsam, yapılmayacaklar, tetiklenen koşullu kapılar, iki risk ve belge yolu sunulur. Konsepti önceden onaylı doğrudan ürün girişinde K1 sunulmaz, `ONAY-ONCEDEN` olarak kayda geçer.
- `ONAY`: A2'ye geçilir. `DUZELT <ne>`: notunuz işlenir, K1 yeniden sunulur. `DURDUR`: proje rafa kalkar (depo korunur).

**K2 Tasarım** (A2 sonu; yalnız ürün/orta ve tam): döngü ya da müfredat özeti, ekran sayısı, zorluk modeli, görsel/ses yönü, koşullu kontrol sonuçları ve açık risk sunulur.
- `ONAY`: A3'e geçilir. `DUZELT <ne>`: ilgili tasarımcı düzeltir, yeniden sunulur. `KUCULT <neyi>`: kapsam daraltılır ama kapı **geçmez**; tasarım küçülür ve K2 yeniden sunulur.

**K3 Dilim** (prototipte A6 sonu, hattın karar kapısı; üründe A4 sonu, yalnız orta/tam doğrudan girişte): **ürünü kendiniz denersiniz.** Size çalıştırma komutu, adres ve bakılacak ekranların listesi verilir (Görsel onay satırı); playtest sonucu, hipotez sonucu (DOGRULANDI / KISMEN / CURUTULDU), bilinen sorunlar sunulur. Ürüne kendiniz bakmadan ilerleten karar (TERFI, DEVAM) alınmaz.
- Prototipte: `TERFI <mod>` ürün hattına geçer (A8'de kısa retro notu yazılır, sonra A1'e dönülür; belgeler ürün belgelerine genişler ve K1 ürün belgesiyle yeniden sunulur; prototip kodunu koruma/yeniden yazma önerisi A3'te kesinleşir). `YINELE` (en çok 2 kez) dilime (A4) döner, iyileştirir ve A6 doğrulamasıyla yeniden sunar. `RAFA-KALDIR` projeyi rafa koyar.
- Üründe: `DEVAM` A5'e geçer. `DUZELT <ne>` düzeltir ve yeniden sunar. `DURDUR` rafa kaldırır.

**K4 Yayın** (A6 sonu; yalnız ürün hattı): doğrulama matrisi, `ENGEL: 0` bilgisi, bilinen sorunlar (≤3), geri alma planı, sürüm önerisi sunulur. K3 gibi burada da **ürüne kendiniz bakarsınız**: çalıştırma komutu, adres ve bakılacak ekranlar verilir; bakmadan `YAYINLA` kararı alınmaz.
- `YAYINLA`: A7'de yerel paket hazırlanır. `DUZELT <ne>`: A6'da düzeltilip yeniden sunulur. `ERTELE`: proje bekletilir (BLOKE); döndüğünüzde kapı yeniden sunulur.

Anlamlar: ONAY/DEVAM/YAYINLA = ilerle; DUZELT = notunla geri gönder; DURDUR/RAFA-KALDIR = projeyi rafa kaldır, depo silinmez; ERTELE = şimdilik bekle.

## 6. Koşullu kapılar

Bazı kontroller yalnızca belirli koşullarda devreye girer; modu küçültmek bunları kaldırmaz. Ekip tetiklenenleri proje durum dosyasına yazar.

| Kapı | Ne zaman | Ne kontrol eder |
|---|---|---|
| C-COCUK | kitle çocuk | çocuk güvenliği ve gizlilik |
| C-YAS | kitle çocuk veya genç | yaşa uygun içerik |
| C-ALAN | sağlık, ruh sağlığı, finans, güvenlik teknikleri | hassas alan kuralları |
| C-GUV | ürün hattı (prototipte kullanıcı kodu/hesap/ağ varsa) | güvenlik sertleştirme |
| C-ERISIM | ürün hattı (prototipte çocuk kitlesi) | erişilebilirlik |
| C-PERF | tam mod ya da gerçek zamanlı oyun | performans bütçesi |

Size etkisi: bir kontrolde **ENGEL** (ciddi bulgu) varsa K2/K4 açılmaz; önce düzeltilir. Bir engeli bilerek kabul etmek isterseniz bunu açıkça yazarsınız (ISTISNA); istisna yalnızca sizin kararınızla kaydedilir, ekip kendiliğinden vermez.

**Tıkanma:** eleştirmen bir parçaya 2 tur REVISE (düzelt) derse üçüncü tur daha güçlü modelle (opus) denenir; hâlâ olumsuzsa ya da bir kapı (aşama denetimi) 2 tur REVISE alırsa proje `BLOKE` (bloke) olur. Limit dar (`tight`) iken terfi yoktur, 2 tur sonra bloke olur. Size tek soru gelir: sorun, denenenler ve seçenekler `DUZELT <yön>` / `DURDUR` / `ISTISNA`.

## 7. Bilmeniz ve yapmanız gerekenler

- Playtest ve ekran karşılaştırması sırasında Claude desktop **Browser panelini görünür tutun**; gizliyse ölçüm zaman aşımına uğrayabilir.
- **K3 ve K4'te görsel onay her zaman sizden alınır** (ürünü kendiniz açıp bakarsınız; "bakmadım" yanıtı karar sayılmaz, kararı geçirmeyen seçenekler hariç). Kullanıcı kapısıyla bitmeyen bir playtestte ekranlar doğrulanamazsa (`GORSEL: DOGRULANMADI`, yani ajan ekranı göremedi) o ekranlar için ayrıca görsel onayınız istenir; onayınız kayda geçer.
- Yapay playtester gerçek kullanıcı değildir. Özellikle çocuk kitlesinde gerçek çocuk denemesinin yerini tutmaz.
- Yayın **yerel pakettir**: etiket ve sürüm notu hazırlanır; dışarı (mağaza, sunucu, depo) yüklemeyi siz yaparsınız.
- Kontrol listeleri (çocuk güvenliği, hassas alan, güvenlik vb.) hukuki görüş değildir.
- Bu kılavuzdaki komutlar ekip kökünde (`D:\AI Agent Team`) çalıştırılır.
- Limit uyarısı (Claude ya da Gemini) görürseniz durumu kendiniz kaydedin (ya da tester'a yaptırın); lider bu scripti çalıştırmaz:

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Claude tight
```

`-Gemini <ok|tight|exhausted>` Gemini için; parametresiz çalıştırırsanız durumu gösterir; `-Reset` sıfırlar. `tight` iken planlama, tasarım ve kapı eleştirisi sonnet'e iner (parça eleştirisi zaten sonnet'tir) ve tıkanmada üst modele terfi yapılmaz; `exhausted` iken ekip durur.

## 8. Günlük komutlar

```
/proje durum
/proje ilerle
/proje sec <ad>
/proje liste
```
- `durum`: aktif projenin kısa özeti. `ilerle` (`devam` aynıdır): sıradaki adım ya da bekleyen kapı. `sec <ad>`: aktif projeyi değiştirir. `liste`: tüm projeler.
- Oturum kesildi ya da sıkıştırıldıysa (compaction): `/proje ilerle`. Bütün proje işi `/proje` ile yürür; aktif proje yoksa lider `/proje yeni` ya da `/proje sec` ister.
- Raporları listelemek için (isteğe bağlı `-Role`, `-Since YYYYMMDD`):

```
powershell -ExecutionPolicy Bypass -File team/scripts/list-reports.ps1 -Project <ad>
```

## 9. Dosyalar nerede

- `projects/<ad>/docs/`: belgeler (özet, tasarım, mimari, doğrulama, sürüm notu).
- `projects/<ad>/state/`: durum (PHASE, TASKS, TASKS-ARSIV, HANDOFF, INTAKE, LESSONS). Dersler projeye özeldir; projeler yalıtıktır, yeni proje öncekilerin derslerini okumaz.
- `projects/<ad>/reports/`: ajan raporları, `YYYYMMDD-HHmm-<rol>-<konu>[-t<N>].md` adıyla (`-t<N>` tekrar turu eki).
- `projects/PROJECTS.md`: kayıt defteri + aktif proje. Bir projeyle ilgili her bilgi `projects/` içinde kalır; merkeze proje bilgisi yazılmaz. Proje dışında verdiğiniz kaynak/konsept dosyası kurulumdan hemen sonra `projects/<ad>/docs/kaynak/` altına ASCII adla kopyalanır (coder; özgün ad ve konum projenin INTAKE kaydında tutulur). Kapı kayıtlarındaki Rapor hücresindeki her dosya yolu `projects/<ad>/` içinde kalmalı ve dosya var olmalıdır (aksi halde kapı denetimi FAIL verir).
- `team/state/`: yalnız `HANDOFF.md` (merkezin durumu). `team/reports/`: boş; yalnız merkez bakımı raporları (README'ye bakın).
- Merkez süreç dosyaları yalnız sizin açık isteğinizle ya da kabul ettiğiniz bir süreç önerisiyle değişir.

## 10. Bilinen sınırlar

- Mobil ve oyun motoru profilleri henüz gerçek bir projeyle sınanmadı.
- Ekran görüntüsü dosyaya kaydedilemiyor; görsel kanıt metin betimi ve ölçümle verilir.
- Gemini yalnızca öneri/plan modunda çalışır, dosya yazmaz; ekip onsuz da sürer.
- Ekip klasörünün kendisi sürüm denetimsizdir; yalnız `projects/<ad>/` kendi git deposudur.
- Görsel ve ses kodla üretilir (hazır görsel/kayıtlı ses yok). Otomatik görsel regresyon (Playwright) yoktur; ses, animasyon ve oyun hissi ölçülemez, bunu siz denersiniz.
- Oturum başına tek aktif proje vardır (`/proje sec <ad>` ile değiştirilir).

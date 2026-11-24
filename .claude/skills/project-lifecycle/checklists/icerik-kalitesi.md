# Kontrol listesi: İçerik kalitesi (IK)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir. Komut çıktıları (`run.ps1 -Check`, `-Test`) tester ya da writer'ın (yalnız `-Check`) raporundan gelir.

- **Kapı:** E-A4 (altın örnek) · E-A5 (içerik incelemesi) · E-A6 — koşullu kapı değil; içerik taşıyan her projede bakılır. **Denetleyen:** critic + learning-designer (içerik incelemesi raporu critic'e girdi).
- **A4'te bakılır (altın örnek, tümü):** IK-01 … IK-05, 07, 08, 10, 11. Altın örnek onaylanmadan çoklu writer başlamaz.
- **A5'te bakılır (her dalga, örneklem):** tümü; IK-06 altın örneğe karşı. **A6'da bakılır (yeni/değişen tüm içerik + bütün müfredat):** tümü; IK-09 ve IK-12 bütün müfredatta.
- Örneklem (sözlük kuralı): en az 5 birim ya da %20, hangisi büyükse; toplam 5'ten azsa tümü.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| IK-01 | Her içerik birimi LEARNING_DESIGN'daki (P: BRIEF'teki; Ü/hafif: DESIGN'daki) bir öğrenme hedefine (`LH-nn`) bağlı; hedefsiz birim yok. | Müfredat haritası ↔ içerik dosyaları eşleme tablosu; hedefsiz birim sayısı = 0. | ENGEL |
| IK-02 | Her hedefin en az bir ölçme etkinliği var; ölçme hedefin eylem fiiliyle aynı türde ("uygula" hedefi uygulama görevi ile ölçülür, yalnız bilgi sorusuyla değil). | LH → etkinlik → ölçme tablosu; ölçmesiz hedef 0; tür uyumsuzluğu listesi boş. | ENGEL |
| IK-03 | Ölçme yalnız öğretilen içeriği sorar; öğretilmemiş bilgi sorusu yok. | Örneklemde her soru → öğreten birim bağlantısı tablosu. | BUYUK |
| IK-04 | Olgusal doğruluk: örneklemdeki her teknik/olgusal iddia bağımsız kaynakla doğrulanmış; yanlış iddia 0. | İddia → kaynak (bağlantı/belge, erişim tarihi) tablosu; learning-designer incelemesi rapora bağlı. | ENGEL |
| IK-05 | Şemaya uygunluk: `run.ps1 -Check` başarılı. | Komut çıktısı ve exit 0 rapora yapıştırılır; çıktı yoksa HAYIR. | ENGEL |
| IK-06 | Altın örnekle tutarlı: alan sırası, bölüm başlıkları, ton, ipucu kademesi sayısı aynı. | Yeni birim ↔ altın örnek yan yana tablosu; sapma listesi boş. | BUYUK |
| IK-07 | Doğru cevap/çözüm gerçekten çalışır; yanlış seçenekler gerçekten yanlış; tek doğru cevap var (yanlış anahtar yanlış öğretir). | `run.ps1 -Test` ya da `-Check` çözüm anahtarı sonucu (tester çıktısı); örneklemde seçenek tablosu. | ENGEL |
| IK-08 | LEARNING_DESIGN'da ipucu kademesi tanımlıysa her görevde o sayıda kademe var; son kademe çözümü vermeden yönlendirir. | Örneklemde görev → kademe sayısı; son kademe metni alıntıları. | BUYUK |
| IK-09 | Zorluk sırası önkoşul grafiğine uygun: birim, kendinden önceki birimlerin öğretmediği kavramı kullanmaz. | Önkoşul grafiği ↔ birim sırası tablosu; öne alınmış kavram listesi boş. | BUYUK |
| IK-10 | Dil: Türkçe imla hatası 0; hitap tek biçim (sen/siz); aynı kavram tek terimle anılır. | Örneklemde okuma; terim tutarlılık listesi (Grep ile varyant yazımlar); hata satırları. | BUYUK |
| IK-11 | Geri bildirim yanlışta nedenini açıklar ve yeniden denemeye yönlendirir, doğruda pekiştirir; boş ya da yalnız "Doğru"/"Yanlış" geri bildirimi yok. | Geri bildirim alanlarında 5 kelimeden kısa ya da yalnız "Doğru"/"Yanlış" olan sayısı (Grep ya da okuma); 0. | BUYUK |
| IK-12 | Birim süre tahminlerinin toplamı LEARNING_DESIGN'daki hedef süreyle uyumlu. | Süre toplamı, hedef değer, fark tablosu. | KUCUK |
| IK-13 | Aynı soru/paragraf iki birimde tekrarlanmaz. | Başlık ve ilk cümle yinelemeleri için Grep/okuma; yinelenen sayısı 0. | KUCUK |

## Sonuç kuralı
ENGEL maddesi HAYIR ise ilgili E-kapısı (E-A4, E-A5 ya da E-A6) kapalıdır (REVISE); altın örnekte ENGEL varsa çoklu writer başlamaz. BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, örneklem birimi, komut çıktısı) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>`; aşama (A4/A5/A6) ve örneklem büyüklüğü yazılır.

## Kaynaklar
- ASCD, Understanding by Design (ters tasarım: hedef → kanıt → etkinlik): https://www.ascd.org/books/understanding-by-design-expanded-2nd-edition
- TDK, güncel Türkçe sözlük (terim ve imla): https://sozluk.gov.tr
- TDK ana sayfa (yazım kılavuzu): https://www.tdk.gov.tr

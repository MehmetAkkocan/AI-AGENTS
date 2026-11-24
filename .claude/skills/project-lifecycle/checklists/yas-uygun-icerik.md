# Kontrol listesi: Yaşa uygun içerik (YU)

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir ("kanıt: playtester raporu"). Ses/emülasyon gibi ekibin doğrulayamadığı madde "kullanıcı gözlemi" sayılır (en çok BUYUK).

- **Kapı:** C-YAS (A5, A6; P: A6 hafif) · **Tetikleyici:** kitle = cocuk / genc · **Denetleyen:** learning-designer + critic (karar: critic)
- **A5'te bakılır (içerik incelemesi, örneklem):** YU-01 … YU-06, YU-08 … YU-10, YU-12. **A6'da bakılır:** tümü (YU-07, YU-11 yalnız A6). **P/A6'da bakılır (yalnız P + kitle cocuk/genc, hafif: altın örnek + dilim metni; learning-designer incelemesi, karar critic):** YU-03, 04, 05, 10.
- Örneklem (sözlük kuralı): en az 5 birim ya da %20, hangisi büyükse; toplam 5'ten azsa tümü. Örnek listesi rapora yazılır.
- Aynı ölçüt tek listede: yanıp sönme → ER-09; otomatik sonsuz devam → CG-08; imla/hitap tutarlılığı ve "yanlışta neden + yeniden deneme" → IK-10, IK-11. Bu liste onlara atıf yapar.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| YU-01 | Hedef yaş aralığı BRIEF/LEARNING_DESIGN'da yazılı; ortalama cümle uzunluğu LEARNING_DESIGN'daki üst sınırı aşmıyor. Yoksa ekip varsayımı (doğrulanmadı; Türkçe eklemeli dildir): cocuk ≤12, genc ≤18 kelime. | Örneklemde kelime/cümle tablosu (birim, ortalama); aşan birimler listelenir. | BUYUK |
| YU-02 | Terim ilk kullanımında açıklanır; açıklamasız jargon yok. | Örneklemde her yeni terim için tanım satırı. | BUYUK |
| YU-03 | Grafik şiddet, kan, ani korkutma, cinsel içerik, alkol/uyuşturucu/kumar özendirmesi, nefret söylemi yok. | İçerik klasöründe Grep: `\bkan\b`, `öldür`, `silah`, `uyuşturucu`, `alkol`, `kumar`, `cinsel`; her isabet bağlamla; ekran kanıtı: playtester raporu. | ENGEL |
| YU-04 | Kaybetme/hata yumuşak, yeniden deneme tek adımda. Kitleye göre: cocuk = ölüm/yaralanma tasviri yok; genc = grafik olmayan çizgi tasvir serbest. | A5: UX/GDD hata durumu metni. A6: kanıt: playtester raporu (yanlış cevap ve kaybetme anı). | BUYUK |
| YU-05 | Aşağılayıcı etiket yok. (Yanlışta neden + yeniden deneme: IK-11.) | Geri bildirim metinlerinde Grep: `aptal`, `salak`, `beceriksiz`, `başarısız` (nötr sistem mesajıysa bağlamla geçer); sonuç 0. | ENGEL |
| YU-06 | Başkalarıyla kıyaslayarak utandıran sıralama yok; kıyas kendi geçmişiyle. | Ekran envanteri; Grep: `leaderboard`, `sıralama`, `puan tablosu`; 0 ya da yalnız kendi ilerleme. | BUYUK |
| YU-07 | Kültürel uygunluk: isim, para birimi, tarih biçimi, gündelik bağlam Türkiye'ye uygun ya da nötr; cinsiyet/din/etnik klişe yok. | Örneklemde isim ve bağlam tablosu; klişe bulgusu satırla ya da 0. | BUYUK |
| YU-08 | Süre: oturum LEARNING_DESIGN'daki süreye sığar; doğal mola noktası var (otomatik sonsuz devam: CG-08). | İçerikten tahmin: kelime sayısı ÷ okuma hızı varsayımı + etkinlik sayısı, tablo; gerçek çocuk süresi: kullanıcı gözlemi (yapay playtester süresi çocuğu temsil etmez). | BUYUK |
| YU-09 | Ekran başına tek ana görev; yönerge ≤2 cümle. | Örneklem ekran listesi: görev sayısı ve yönerge cümle sayısı. | BUYUK |
| YU-10 | Hitap kitleye uygun: cocuk/genc için tek biçim "sen", buyurgan/azarlayıcı ton yok (imla ve terim tutarlılığı: IK-10). | Örneklemde okuma; sapma satırları ya da 0. | BUYUK |
| YU-11 | Ani yüksek ses yok; sesi kapatma var (yanıp sönme: ER-09). | Kod/ART_AUDIO: Grep `gain`, `setValueAtTime`, `mute`, `sessiz`; kazanç ve zarf değerleri tabloda. Gerçek duyuş: kullanıcı gözlemi. | BUYUK |
| YU-12 | Başarı kutlaması abartısız ve çeşitli. | Örneklemde kutlama metinleri; ≥3 farklı ifade. | KUCUK |

## Sonuç kuralı
ENGEL maddesi HAYIR ise C-YAS kapalıdır (REVISE). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, örneklem birimi, playtester raporu yolu) |
|---|---|---|
learning-designer raporu girdi olur; critic birleştirir. Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n>`.

## Kaynaklar
- ICO, Children's code (doğrulanmadı; bot engeli): https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/childrens-information/childrens-code-guidance-and-resources/
- PEGI yaş derecelendirme: https://pegi.info/page/pegi-age-ratings
- W3C, Üç yanıp sönme ölçütü: https://www.w3.org/WAI/WCAG21/Understanding/three-flashes-or-below-threshold.html

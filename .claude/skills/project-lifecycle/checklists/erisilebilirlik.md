# Kontrol listesi: Erişilebilirlik (ER) — WCAG 2.1 temel ölçütlerden seçilmiş alt küme

> Bu liste hukuki görüş değildir; genel dağıtımda uyum sorumluluğu kullanıcıdadır.
> Tablodaki `\|` yalnız Markdown kaçışıdır; Grep/ripgrep deseninde düz `|` yazılır. Desenler virgülle ayrı verilir: her biri ayrı, büyük/küçük harf duyarsız (`-i`) aranır. "Sonuç 0" = gerekçesiz kabul edilmeyen isabet 0; her isabet bağlamıyla değerlendirilir.
> critic'in tarayıcı aracı yoktur: tarayıcı gerektiren maddenin kanıtı playtester raporundan gelir ("kanıt: playtester raporu"). Ses/emülasyon gibi ekibin doğrulayamadığı madde "kullanıcı gözlemi" sayılır (en çok BUYUK).

- **Kapı:** C-ERISIM · **Tetikleyici:** hat = urun; kitle = cocuk ise P'de temel · **Denetleyen:** A2: critic (belge düzeyi) · A6: playtester (erişilebilirlik personası + ağaç) + critic (karar: critic)
- Bu liste seçilmiş bir alt kümedir; WCAG 2.1 AA uyum iddiası değildir (eksik: 1.3.4, 1.4.12, 1.4.13, 2.5.3, 3.2.3, 3.2.4, 3.3.3 vb.).
- **Kapsam:** [temel] = Ü/hafif ve kitle=cocuk P için zorunlu alt küme · [tam] = Ü/orta ve tam; temel + tam hepsi bakılır. Bakılan kapsam rapora yazılır.
- **A2'de bakılır (belge: UX.md, ART_AUDIO, tasarım belirteçleri; P: docs/BRIEF.md hafif tasarım bölümü):** ER-01, 02, 03, 04, 06, 07, 08, 09, 10, 12, 15 ("A2:" yöntemiyle). **A6'da bakılır:** tümü; masaüstü + mobil (375×812).
- **AĞAÇ** = playtester raporundaki erişilebilirlik ağacı çıktısı (kanıt: playtester raporu); yedek yöntemde (HTTP/Grep) rapor `GORSEL: DOGRULANMADI` der.
- Önem: ENGEL (kapıyı kapatır) · BUYUK (kapıdan önce düzelt ya da gerekçeli BACKLOG) · KUCUK (BACKLOG). Kanıtsız madde = HAYIR.

| # | Madde | Nasıl doğrulanır | Önem |
|---|---|---|---|
| ER-01 | [temel] Metin kontrastı ≥4.5:1 (büyük metin ≥3:1) — 1.4.3. | A2: UX.md renk çiftleri için oranlar tabloda. A6: aynı tablo + ölçüm: kanıt: playtester raporu; başarısız çift listesi. | ENGEL |
| ER-02 | [temel] Düğme, alan kenarlığı, odak halkası, anlamlı grafik kontrastı ≥3:1 — 1.4.11. | ER-01 tablosunda bileşen satırları (A2 ve A6). | BUYUK |
| ER-03 | [temel] Tüm işlevler klavyeyle (Tab, Shift+Tab, Enter, Boşluk, Esc); klavye tuzağı yok — 2.1.1, 2.1.2. | A2: UX akışında klavye yolu yazılı. A6: kanıt: playtester raporu (ana görevler yalnız klavyeyle); takılan ekran listesi boş. | ENGEL |
| ER-04 | [temel] Odak görünür, sıra görsel sırayla uyumlu — 2.4.7, 2.4.3. | A2: UX.md odak stili ve sırası. A6: AĞAÇ odak sırası; odaklı öğe görüntüsü betimi. | ENGEL |
| ER-05 | [temel] Anlamlı görsel/SVG/ikonun metin karşılığı var; süs görseli boş alt — 1.1.1. | AĞAÇ: adsız görsel 0. Grep: `<img` satırlarında `alt=` olmayan 0; `<svg` için `aria-label`, `<title`. | ENGEL |
| ER-06 | [temel] Başlık yapısı: ekranda bir h1, düzey atlama yok (iyi uygulama; 1.3.1/2.4.6 ile ilişkili, tek başına zorunluluk değil). | A2: UX.md ekran başına başlık listesi. A6: AĞAÇ başlık hiyerarşisi. | BUYUK |
| ER-07 | [temel] Her form alanının etiketi var; hata metni alanla ilişkili ve yalnız renkle verilmez — 1.3.1, 3.3.1, 3.3.2, 1.4.1. | A2: UX form/hata durumu. A6: AĞAÇ alan adları; bilerek hatalı giriş: kanıt: playtester raporu. | ENGEL |
| ER-08 | [temel] Dokunma/tıklama hedefi ≥44×44 CSS px; kitle=cocuk ≥48 (UX.md şablonuyla aynı). 2.5.5 AAA'dır; proje hedefi. | A2: UX.md belirteç tablosunda hedef boyut. A6: `javascript_tool` ölçümü (mobil), küçük hedef listesi: kanıt: playtester raporu. | BUYUK |
| ER-09 | [temel] Saniyede 3'ten fazla yanıp sönen öğe yok (2.3.1'den sıkı: eşik altı muafiyeti yok; bilinçli). YU-11 buna atıf yapar. | A2: ART_AUDIO animasyon listesi. A6: Grep `@keyframes`, `animation`, `blink`, `flash`; her isabetin hızı tabloda. | ENGEL |
| ER-10 | [tam] (a) 5 sn'den uzun otomatik hareket durdurulabilir — 2.2.2 (A). (b) `prefers-reduced-motion` ile animasyon kapanır — 2.3.3 (AAA; proje hedefi). | A2: UX.md hareket ilkesi. A6: Grep `prefers-reduced-motion`; kuralın animasyonları kapattığı CSS okunur (emülasyon gerekmez). | BUYUK |
| ER-11 | [tam] 640 px (≈%200 yakınlaştırma) ve 320 CSS px genişlikte içerik kaybı ve yatay kaydırma yok — 1.4.4, 1.4.10. | A6: `resize_window` 640 ve 320 px ekran listesi: kanıt: playtester raporu. | BUYUK |
| ER-12 | [tam] `lang="tr"` ve ekran başına benzersiz `<title>` — 3.1.1, 2.4.2. | A2: UX.md ekran başlıkları listesi. A6: Grep `lang=`; AĞAÇ sayfa başlıkları. | BUYUK |
| ER-13 | [tam] Durum mesajları (doğru/yanlış, ilerleme, hata) yardımcı teknolojiye bildirilir — 4.1.3. | AĞAÇ: `status`/`alert` rolü; Grep: `aria-live`, `role="status"`, `role="alert"`. | BUYUK |
| ER-14 | [tam] Ses/video varsa metin karşılığı var; bilgi yalnız sesle verilmez; 3 sn'den uzun otomatik ses durdurulabilir — 1.2.1, 1.4.2. | ART_AUDIO envanteri: her ses için metin karşılığı satırı. Ses yoksa UYGULANMAZ. | BUYUK |
| ER-15 | [temel] Zaman sınırı yok ya da kapatılabilir/uzatılabilir — 2.2.1 (çocukta temel risk). | A2: UX/GDD zamanlayıcı listesi, her biri için ayar. A6: kanıt: playtester raporu. | BUYUK |
| ER-16 | [tam] Ana bölge işaretleri ve "içeriğe atla" bağlantısı — 2.4.1, 1.3.1. | AĞAÇ: landmark listesi. | KUCUK |
| ER-17 | [tam] Bağlantı/düğme amacı kendi metninden anlaşılır — 2.4.4. | AĞAÇ: bağlantı adları; belirsiz ad ("buraya tıkla") 0. | KUCUK |
| ER-18 | [temel] Özel bileşenin (sahte terminal, canvas, sekme, açılır liste) adı, rolü, durumu programatik bulunur — 4.1.2. | AĞAÇ: bileşen ad/rol/değer satırları; adsız ya da rolsüz etkileşimli öğe 0. | ENGEL |

## Sonuç kuralı
ENGEL maddesi HAYIR ise C-ERISIM kapalıdır (REVISE). BUYUK HAYIR ise kapıdan önce düzeltilir ya da gerekçeli BACKLOG satırı verilir. İstisna yalnız kullanıcı kararıyla PHASE'e `ISTISNA` yazılır. UYGULANMAZ yalnız gerekçeyle geçerlidir.

## Denetçinin rapor tablosu
| Madde | Sonuç (EVET / HAYIR / UYGULANMAZ) | Kanıt (dosya:satır, AĞAÇ alıntısı, playtester raporu yolu) |
|---|---|---|
Son satır: `SONUC: APPROVE | REVISE — ENGEL: <n> · BUYUK: <n> · KUCUK: <n> · KAPSAM: temel | tam`.

## Kaynaklar
- W3C, WCAG 2.1: https://www.w3.org/TR/WCAG21/
- W3C, How to Meet WCAG (hızlı başvuru; 2.1 süzgeci için `?versions=2.1`): https://www.w3.org/WAI/WCAG22/quickref/
- W3C, Understanding WCAG 2.1: https://www.w3.org/WAI/WCAG21/Understanding/

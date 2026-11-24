<!-- A2 Tasarım | sahip: learning-designer doldurur | hedef: docs/LEARNING_DESIGN.md | kapı: E-A2 (+ K2 orta/tam; C-COCUK/C-ALAN tetiklenirse). Hafif mod: Ü/hafif'te ayrı belge yok, §2-4 ve kisisel-gelisim ise §8 docs/DESIGN.md'ye yazılır (aynı başlıklar); P'de BRIEF'e tek öğrenme hedefi. -->
# LEARNING_DESIGN: <ad>
Etiketler: tur=<egitim|ogrenme|kisisel-gelisim|oyun>[+oyun] | kitle=<cocuk|genc|yetiskin>

## 1. Hedef kitle ve ön bilgi
<!-- BRIEF kitlesinden: yaş, okuma düzeyi, mevcut bilgi, motivasyon, bağlam (okul/ev/mobil). -->
<Kitle ve ön bilgi özeti>

## 2. Öğrenme hedefleri
<!-- Kimlik LH-01, LH-02... Ölçülebilir, eylem fiiliyle ("listeler", "çözer", "ayırt eder"). "Anlar/bilir" yasak. Her hedef bir ölçme biçimine bağlanabilmeli. -->
- LH-01: <Öğrenci ... eylem fiili ... ölçüt>

## 3. Önkoşul grafiği
<!-- Metin okla: LH-01 -> LH-02. Döngü yok; kök hedefler ön bilgiyle karşılanır. -->
<LH-01 -> LH-02 -> LH-04>

## 4. Müfredat haritası
<!-- Her birim en az bir LH'ye, her LH en az bir birime bağlı. İçerik sayıları SPEC ile uyumlu. -->
| Birim | Hedef (LH-xx) | Etkinlik | Ölçme |
|---|---|---|---|
| <U1> | LH-01 | <etkinlik> | <ölçüt/eşik> |

## 5. Geri bildirim ilkeleri
<!-- Utandırmayan, düzeltici: neyin doğru olduğunu söyle, hatayı nedene bağla, sonraki adımı ver. Etiketleme ("aptal", "yanlış cevap!") yok. -->
<İlkeler ve örnek doğru/yanlış cümle çifti>

## 6. Tekrar ve pekiştirme
<!-- Aralıklı tekrar, karışık alıştırma, ipucu kademeleri; aralıklar ve eşikler sayıyla. -->
<Strateji>

## 7. Yaşa uygun dil rehberi
<!-- Cümle uzunluğu, kelime düzeyi, ton, yasak ifade; kitle cocuk/genc ise yas-uygun-icerik listesine uyum. -->
<Rehber>

## 8. Davranış ve alışkanlık tasarımı (yalnız kisisel-gelisim; diğerlerinde "uygulanmaz" yaz)
<!-- Tetikleyici, küçük adım, izleme; geri dönüş planı (kaçırılan günden sonra suçlamadan yeniden başlama). Manipülatif desen yasağı: sahte aciliyet, suçluluk, kayıp korkusu, bağımlılık döngüsü (seri kaybı cezası dahil). -->
- Tetikleyici: <hatırlatma bağlamı> · Küçük adım: <≤2 dk eylem> · İzleme: <ölçüt, ceza yok>

## 9. İçerik iş emri biçimi
<!-- writer'a verilecek birim tanımı; her alan zorunlu. -->
`Birim: <ad> | Hedef: LH-xx | Tür: <görev tipi> | Zorluk: <1-5> | Dil: <rehber §7> | Çıktı yolu: <içerik yolu> | Doğrulama: run.ps1 -Check`

## 10. Altın örnek ölçütleri
<!-- A4'te onaylanacak tek örnek; sonraki writer'lar bunu kopyalar. Doğrulanabilir maddeler. -->
- <şemaya uyar; hedefe bağlı; geri bildirim ilkelerine uyar; dil rehberine uyar>

## 11. SPEC eşlemesi
<!-- Her SPEC özelliği (F-xx) en az bir LH'ye bağlanır; LH'si olmayan F-xx için gerekçe yaz. -->
| SPEC kimliği (F-xx) | Hedef (LH-xx) / birim | Not |
|---|---|---|
| F-01 | LH-01 / <U1> | <not> |

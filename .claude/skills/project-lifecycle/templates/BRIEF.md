<!-- A0 taslak, A1 son hali (P hattında A2'de çekirdek döngü / öğrenme hedefi bölümünü game-/learning-designer ekler) | sahip: planner | hedef: docs/BRIEF.md | kapı: E-A0 (taslak), E-A1 -> K1 (P: K1 sunumu bu belgeden) -->
<!-- P hattında: tek sayfa; tüm bölümler 1-3 satır. Ü hattında asıl belge SPEC'tir; BRIEF A0 girdisi olarak kalır, Ü K1 sunumu SPEC'ten çıkar. Yer tutucu adı: <ad>. -->
# BRIEF <ad>

## Ürün tanımı
<!-- doldurma talimatı: TEK cümle: "<kimin için> <ne yapan> <ürün türü>". Kaynak: state/INTAKE.md. -->
<tek cümle>

## Problem ve kitle
<!-- doldurma talimatı: 2-4 cümle: çözülen problem, kimin yaşadığı. Kaynak: INTAKE.md; bilinmeyen varsayımı Açık sorulara taşı. -->
<problem> / <kime>

## Etiketler
<!-- doldurma talimatı: sözlük değerleri aynen. mod yalnız Ü hattında; P'de "-". tur'da oyunlaştırma varsa +oyun eki (ör. egitim+oyun). -->
tur: <oyun/egitim/ogrenme/kisisel-gelisim>[+oyun] | kitle: <cocuk/genc/yetiskin> | profil: <web/mobil/masaustu-motor> | hat: <prototip/urun> | mod: <hafif/orta/tam/->

## Çekirdek döngü / öğrenme vaadi
<!-- doldurma talimatı: oyun/oyunlaştırma için 1 cümle çekirdek döngü (eylem -> geri bildirim -> ödül); eğitim/öğrenme için 1 cümle vaat ("... sonunda ... yapabilir"). P'de A2'de tasarımcı bu bölümü genişletir. -->
<döngü veya vaat>

## Kapsam
<!-- doldurma talimatı: 3-5 madde; her biri özellik kimliği (F-01, F-02...) ve doğrulanabilir tek satır. Ü'de bu kimlikler SPEC'e aynen taşınır. -->
- F-01: <kapsam 1>

## Yapılmayacaklar
<!-- doldurma talimatı: en az 3 madde; INTAKE'teki "yapılmayacaklar" ve kapsam kaymasına açık konular. -->
- <yapılmayacak 1>

## Başarı sinyali
<!-- doldurma talimatı: 1-3 gözlenebilir sinyal (sayı ya da evet/hayır); P'de hipotezi sınar. -->
- <sinyal>

## Prototip hipotezi ve hafif tasarım (yalnız P hattı)
<!-- doldurma talimatı: hipotez 1 cümle ("X olursa Y beğenilir"); çekirdek döngü / öğrenme hedefi (LH-01...) 2-3 cümle; 1 akış (≤8 adım); görsel/ses yönü 1 satır; kitle cocuk: + erişilebilirlik ve çocuk güvenliği notu (≤6 satır: renk çifti + oran, klavye yolu, odak, dokunma hedefi ≥48 px, zaman sınırı yok, veri toplanmaz); oyunsa: test kancası gereksinimi 1 satır (`?debug=1&seed=N`, `window.__game.getState()`). P'de UX.md/ART_AUDIO.md yoktur, her şey burada. Doğrudan Ü'de bölümü sil; terfide KORU (A2 girdisi). -->
Hipotez: <hipotez>
Akış: <1 -> 2 -> 3>

## Tetiklenen koşullu kapılar
<!-- doldurma talimatı: SKILL.md tetikleyici tablosuna göre C-COCUK, C-YAS, C-ALAN, C-GUV, C-ERISIM, C-PERF; her biri tek satır gerekçe. Yoksa "yok". PHASE kosullu: satırı bununla aynı olur. -->
<C-... : gerekçe>

## Riskler
<!-- doldurma talimatı: en çok 5; her biri "risk -> önlem". K1 sunumunda ilk 2'si kullanılır. -->
- <risk -> önlem>

## Açık sorular
<!-- doldurma talimatı: kullanıcıya sorulacaklar; yoksa "-". -->
- <soru>

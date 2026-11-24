---
name: model-router
description: Seviye 5 — Görev tipi ve team/budget.json'daki limit durumuna göre hangi ajanın hangi modelle (opus/sonnet/haiku/gemini) çalışacağını seçer. Lider her delegasyondan önce uygular. "Üstte akıllı, altta ucuz" ilkesi.
---

# Model yönlendirici

Videodaki CodexBar (macOS menü çubuğu limit göstergesi) Windows'ta yok. Yerine kullanıcı limit
uyarısı gördüğünde `team/budget.json`'ı elle günceller; lider her delegasyonda bu dosyaya bakar.

## Bütçe durumunu oku / güncelle

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1"
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Claude tight
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Reset
```

Değerler: `ok` (normal), `tight` (uyarı geldi, %20'den az kaldı), `exhausted` (limit doldu).

Lider bu scripti çalıştırmaz: `team/budget.json`'ı Read ile okur. Scripti kullanıcı elle çalıştırır
veya lider bir ajana (genelde tester) çalıştırtır.

## Karar tablosu

| Görev tipi | claude=ok | claude=tight | claude=exhausted |
|---|---|---|---|
| Planlama (planner) | opus | sonnet | DUR |
| Eleştiri, tekil parça incelemesi (critic; `Kapı: yok`, A7 danışma dahil) | sonnet | sonnet | DUR |
| Eleştiri, aşama kapısı `E-A<n>` / koşullu `C-*` / kullanıcı kapısı öncesi son inceleme (critic) | opus | sonnet | DUR |
| Eleştiri, aynı parçada 2. REVISE'dan sonraki 3. tur (critic + üretici ajan bir üst modele) | opus | terfi yok (BLOKE) | DUR |
| Oyun / öğrenme tasarımı (game-designer, learning-designer) | opus | sonnet | DUR |
| UX tasarımı (ux-designer) | sonnet | sonnet | DUR |
| Kod, görsel/ses uygulaması (coder) | sonnet | sonnet | DUR |
| İçerik (writer) | sonnet | sonnet | DUR |
| Playtest (playtester) | sonnet | sonnet (az persona) | DUR |
| Araştırma (researcher) | haiku | haiku | DUR |
| Test koşma (tester) | haiku | haiku | DUR |
| Görsel/ses yön önerisi, uzun doküman, ikinci görüş | gemini plan (isteğe bağlı; tester koşturur) | gemini plan (isteğe bağlı; tester koşturur) | kullanıcı elle |

Not: tablodaki tüm roller (game-designer, learning-designer, ux-designer, playtester dahil) `.claude/agents/`
altında tanımlıdır.

claude=exhausted: ekip durur; lider son iş olarak proje durumunu proje HANDOFF'una, bütçe durumunu küresel HANDOFF'a yazar ve kullanıcıya bildirir.
Kullanıcı isterse `agy-run.ps1`'i elle `-Mode plan` ile (`-Project <ad>` ya da `-Merkez`, tam biri) çalıştırıp taslak/öneri alabilir; çıktı limit
açılınca coder/writer tarafından uygulanır.

Gemini bu host'ta dosya yazamaz (yalnız plan/öneri modunda metin üretir). `gemini` de `exhausted` ise
yalnız ikinci görüş kaybolur; ekip Claude ile sürer.

Görsel/ses kodla üretilir (coder: SVG/CSS/prosedürel/sentez ses); Gemini yalnız isteğe bağlı ikinci görüş/öneri verir.

## Nasıl uygulanır

1. Ajan dosyalarındaki `model:` alanı `claude=ok` durumunun varsayılanıdır.
2. Tablo farklı bir model gerektiriyorsa Agent aracına `model` parametresiyle override ver
   (örn. `tight` iken planner'ı `model: sonnet` ile çağır). Kademeli critic: `critic.md` varsayılanı opus'tur;
   tekil parça incelemesinde (`Kapı: yok`) `model: sonnet` ver, kapı çağrısında (`E-A<n>`, `C-*`, kullanıcı
   kapısı öncesi son inceleme) `ok` iken verme, `tight` iken `model: sonnet` ver. `budget.ps1` da aynı ayrımı
   basar: "elestiri (parca)=sonnet, elestiri (kapi)=<opus|sonnet>".
3. `gemini plan` seçildiyse Agent yerine `antigravity` skill'ini `-Mode plan` ile kullan; rol talimatını
   (planner/critic dosyasının gövdesini) prompt'a kopyala ki Gemini aynı formatta cevap versin.
   Gemini çıktısı öneridir; dosyaya yazmaz. Uygulamayı coder/writer yapar, ardından critic.
4. Seçimi `projects/<ad>/state/TASKS.md`'deki Model sütununa yaz; böylece ne zaman hangi model kullanıldı izlenir.

## İlkeler

- Üstte akıllı, altta ucuz: karar veren (planner, kapı critic'i) en iyi modeli alır; mekanik iş (tarama, test) en ucuzunu.
- Aynı parça 2 kez REVISE yerse 3. turda critic opus olur ve üretici ajan bir üst modele çıkar (haiku→sonnet→opus; zaten opus ise aynı). Hâlâ REVISE ise `BLOKE`, kullanıcıya sorulur. Kapı critic'i zaten opus'tur: 2 tur REVISE → terfi yok → `BLOKE`. `tight` iken terfi yok: 2 tur sonra `BLOKE`.
- Aynı modelde ardışık turlar aynı ajanla (SendMessage) sürer; model değişen turda yeni Agent çağrısı yapılır ve önceki rapor yolları verilir.
- Limiti korumak için önce ucuz model dene; kalite yetmezse yükselt. Tersi israf.

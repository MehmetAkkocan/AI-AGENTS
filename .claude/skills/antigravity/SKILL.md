---
name: antigravity
description: Seviye 4 — Antigravity (Gemini) CLI'ını alt ajan olarak çağırır. Bu host'ta yalnız plan/öneri modu çalışır (dosya yazamaz). İkinci görüş, görsel/ses yön önerisi, uzun doküman okuma veya Claude limiti dolunca planlama/eleştiri/araştırma taslağı için kullan. Çıktı rapor klasörüne yazılır, lider'e sadece özet döner.
---

# Antigravity (Gemini) alt ajan köprüsü

Claude yönetir ve üretir, Gemini öneri verir. Bu skill `agy.exe`'yi non-interaktif `plan` modunda çağırır.
Bu host'ta `auto` mod çalışmıyor (headless izin reddi): Gemini dosyaya yazamaz, yalnız metin üretir.

## Ne zaman kullan

1. İkinci görüş: critic'in kararından emin değilsen aynı soruyu Gemini'ye sor, iki cevabı karşılaştır.
2. Görsel/ses yön önerisi (renk, kompozisyon, ses karakteri). Üretimi coder kodla yapar (SVG/CSS/prosedürel/sentez ses).
3. Çok uzun doküman/kod tabanı okuma ve özetleme (geniş context).
4. `team/budget.json` içinde `claude` değeri `exhausted` ise planlama/eleştiri/araştırma taslağı. Not: claude=exhausted iken tester da durur; `agy-run.ps1`'i kullanıcı elle çalıştırır.

Gemini çıktısını dosyalara coder (veya writer) uygular, ardından critic'ten geçer.

## Nasıl çağır

Lider `agy-run.ps1`'i kendisi çalıştırmaz; tester ajanına komutu aynen koşturur ve özetini alır.

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/antigravity/scripts/agy-run.ps1" -Prompt "<görev>" -Topic "<kısa-konu>" -Mode plan -Project "<ad>"
powershell -ExecutionPolicy Bypass -File ".claude/skills/antigravity/scripts/agy-run.ps1" -Prompt "<görev>" -Topic "<kısa-konu>" -Mode plan -Merkez
```

Parametreler:
- `-Prompt` (zorunlu): Gemini'ye verilecek görev. Dosya yollarını mutlak yaz.
- `-Topic`: rapor dosya adı için kısa etiket (örn. `ui-yon`).
- `-Mode`: varsayılan `plan` (salt okunur, öneri). `auto` / `accept-edits` bu host'ta desteklenmiyor; seçilirse script uyarı basar.
- `-Model`: boş bırakılırsa agy varsayılanı. Mevcut modeller için `agy models` (ağ gerektirir).
- `-Effort`: low|medium|high|xhigh|max (varsayılan medium).
- `-WorkDir`: Gemini'nin erişeceği klasör (varsayılan: mevcut dizin).
- Proje işinde `-Project <ad>` zorunlu (rapor `projects/<ad>/reports`; proje yoksa klasör yaratılmaz, hata); `-Merkez` yalnız merkez bakımında (`team/reports`). İkisinden TAM OLARAK biri verilir; ikisi birden ya da hiçbiri hata.

## Çıktı

Script stdout'a en fazla ~20 satır basar:
```
DURUM: DONE | FAILED
RAPOR: <rapor klasörü>/<tarih>-gemini-<konu>.md
SURE: 42s
ÖZET (ilk 15 satir): ...
```
Lider tam raporu okumaz. Gerekirse `critic` ajanına rapor yolunu verip değerlendirtir.

## Hata durumları

- `agy.exe bulunamadi`: `<USERPROFILE>\.gemini\bin\agy.exe` yok; Antigravity yeniden kurulmalı.
- `Eligibility check failed` / auth hatası: kullanıcı bir kez terminalde `agy` çalıştırıp giriş yapmalı.
- `tls: server did not echo the legacy session ID`: ağ/proxy/VPN sorunu; kullanıcıya bildir, Claude ile devam et.
- auto mod: bu host'ta desteklenmiyor (headless izin reddi); `-Mode plan` kullan.
- Zaman aşımı: `-TimeoutSec` artır veya görevi küçült.

## Kurallar

- Gemini ile Claude ajanlarını aynı dosyaya aynı anda yazdırma.
- Gemini çıktısı öneridir; dosyalara coder/writer uygular, sonra mutlaka `critic`'ten geçir.
- Bu skill'i Codex/Kimi/DeepSeek için şablon olarak kopyalayabilirsin: sadece exe yolu ve argümanlar değişir.

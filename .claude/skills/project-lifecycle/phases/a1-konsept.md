# A1 Konsept / Tanım

## Amaç
Ne yapılacağını test edilebilir kabul ölçütleriyle sabitle (P: tek sayfa BRIEF; Ü: SPEC, orta/tam'da + CONSTRAINTS) ve kullanıcıdan K1 onayını al.

## Girdiler
`state/INTAKE.md`, `docs/BRIEF.md` taslağı, PHASE etiketleri. Terfi: P'nin BRIEF'i + `docs/PROTOTYPE_REVIEW.md` (ADR-000 önerisi dahil) + `state/LESSONS.md` (aynı projenin dersi; lider okur). Doğrudan Ü: hazır konsept dosyasının `docs/kaynak/` kopyası (A0 adım 0'da coder kopyaladı, INTAKE'e yazıldı; `onceden-onay:` satırı varsa K1 `ONAY-ONCEDEN`).

## Adımlar
`<PL>` = `.claude/skills/project-lifecycle`. Her prompt'a eklenir: `Tur: <N>` (yalnız revizyonda) ve `Rapor yolunu şu komutla üret: powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` + `Cevabın ≤10 satır, RAPOR: <yol> zorunlu.` Ajan skill'i `<USERPROFILE>\.claude\skills\<skill>\SKILL.md` yolundan Read ile okur.
1. **researcher** (haiku) — yalnız terfi + Ü/tam: referans taraması (kapsam ve kabul: `a0-kesif.md` adım 3 ile aynı; `Aşama: A1`, Konu `a1-referans`, Oku: `docs/PROTOTYPE_REVIEW.md`). **2 ile paralel**.
2. **planner** (opus, planlama) — P: BRIEF'i bitir; Ü: SPEC yaz (skill: spec-driven-development). Özellikler `F-01`…, kabul ölçütleri `F-01.a` (sayılabilir, test edilebilir); Kısıtlar ve Yapılmayacaklar zorunlu:
```
Rol: planner | Proje: <ad> | Aşama: A1 | Kapı: yok | Parça #<n>: <P: BRIEF | Ü: SPEC | doğrudan Ü: BRIEF + SPEC>
Oku: <PL>/templates/<BRIEF|SPEC>.md, state/INTAKE.md, docs/BRIEF.md [terfi/doğrudan Ü: + PROTOTYPE_REVIEW.md / docs/kaynak/<kopya>] [Ü: + <PL>/profiles/<profil>.md (Kapsam, Sınırlar)]
Kabul kriteri: P: hipotez, kapsam (3-5, F-kimlikli), başarı sinyali · Ü: her F-NN için ölçülebilir F-NN.x ölçütü; tetiklenen C-* maddeleri; Kısıtlar'da platform seçeneği profil önceliğiyle gerekçeli (mobil: web/PWA yetmiyorsa yerel gerekçe); terfide ADR-000 önerisi korunur
Dosyalar: projects/<ad>/docs/<BRIEF|SPEC>.md [doğrudan Ü: ikisi] | Konu: a1-<brief|spec> | Doğrulama komutu: yok | Kontrol listesi: yok
```
3. **planner** — yalnız Ü/orta-tam, adım 2'den sonra (SPEC'e bağımlı; skill: constraint-driven-development):
```
Rol: planner | Proje: <ad> | Aşama: A1 | Kapı: yok | Parça #<n>: CONSTRAINTS
Oku: projects/<ad>/docs/SPEC.md
Kabul kriteri: SPEC "Kısıtlar" içeriği CONSTRAINTS'e taşındı (SPEC'te tek satır atıf kaldı), her kısıt doğrulanabilir; tam modda SPEC'te kilometre taşları
Dosyalar: projects/<ad>/docs/CONSTRAINTS.md, docs/SPEC.md | Konu: a1-constraints | Doğrulama komutu: yok | Kontrol listesi: yok
```
4. **critic** (opus; kapı) — E-A1; K1 sunumunun girdisi de bu rapordur:
```
Rol: critic | Proje: <ad> | Aşama: A1 | Kapı: E-A1 | Parça #<n>: konsept denetimi
Oku: docs/<BRIEF|SPEC>.md, state/INTAKE.md
Kabul kriteri: ölçütler test edilebilir; INTAKE ile tutarlı; P: kapsam ≤5 madde, Ü: K1 sunumunda ≤5 ana başlıkta özetlenebilir; `kosullu:` listesi tetikleyicilerle uyumlu (eksik/fazla C-* yaz); 2 risk; APPROVE/REVISE + 3 madde
Dosyalar: yalnız rapor | Konu: a1-e-a1 | Doğrulama komutu: yok | Kontrol listesi: yok
```
5. **Lider**: critic'in bulduğu eksik C-* tetikleyicilerini PHASE `kosullu:`'ya işle; K1 sunumu için `gates.md` K1 bölümü.

## Mod farkları
- P: adım 2 BRIEF (tek sayfa); 3 atlanır; çekirdek döngü / öğrenme hedefi A2'de BRIEF'e eklenir. Ü/hafif: kısa SPEC; 3 atlanır. Ü/orta: 2 + 3. Ü/tam: 2 + 3 + kilometre taşları.
- Terfi (A1'e dönüş): adım 2 mevcut BRIEF'i SPEC'e genişletir; terfi + tam: adım 1 zorunlu.
- Doğrudan Ü (kural: `a0-kesif.md` Mod farkları): adım 2 planner BRIEF + SPEC'i mevcut konseptten yazar (planner raporu = içeri alma raporu); E-A1 yine koşar. INTAKE'te `onceden-onay:` kanıtı varsa K1 `ONAY-ONCEDEN`, Rapor = bu planner raporu (sunulmaz); kanıt yoksa (kullanıcı açıkça "onaylı" demediyse) K1 normal sunulur (`gates.md` K1).

## Çıkış kriterleri
| Kriter | Yol |
|---|---|
| P: BRIEF (hipotez, kapsam, başarı sinyali) | docs/BRIEF.md |
| Ü: SPEC (kabul ölçütleri) | docs/SPEC.md |
| Ü/orta-tam: CONSTRAINTS | docs/CONSTRAINTS.md |
| E-A1 critic APPROVE | - |

## Kapı
BEKLIYOR olarak yaz: `E-A1` (critic) ve `K1` (kullanici; doğrudan Ü'de yalnız INTAKE `onceden-onay:` kanıtıyla `ONAY-ONCEDEN`). Sıra: E-A1 APPROVE → tester `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/phase-gate.ps1 -Project <ad> -SkipUserGates` → PASS ise K1 sun (`gates.md` K1 bölümü), `KULLANICI_BEKLIYOR` → karar → tam `phase-gate.ps1` (SkipUserGates'siz) → PHASE/PROJECTS/proje HANDOFF/TASKS arşivi → coder `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/checkpoint.ps1 -Project <ad> -Message "A1: konsept" -Tag <p|u>-asama-A1`. DUZELT: `CALISIYOR`, adım 2'ye geri. DURDUR: `RAFTA`. Yeniden koşma kuralı: olumsuz karardan sonra yeniden koşacak her kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı (eski geçer satır kapıyı açık bırakamaz); K1 olumsuzsa `E-A1` ve `K1`. Karar yalnız kullanıcının sohbet mesajından.

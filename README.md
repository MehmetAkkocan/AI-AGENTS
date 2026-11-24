# AI Agent Team — 6 Seviye + Proje Yaşam Döngüsü

Avenox'un ["Tek Ajandan Yapay Zeka Ekibine: 6 Seviye"](https://www.youtube.com/watch?v=zE_ggoUn7ao) videosundaki
yapının Claude Code (+ isteğe bağlı Antigravity/Gemini) ile Windows üzerinde kurulumu. Üstüne bir proje yaşam
döngüsü eklidir: fikirden yayına ve retroya dokuz aşama (A0-A8), dört kullanıcı kapısı (K1-K4).

Ana oturum **ekip lideridir**: yönetir, yalnız durum (state) dosyalarını yazar, script çalıştırmaz. Ajanlar üretir; critic, tester ve playtester denetler.

## Hızlı başlangıç

```
/proje yeni <ad> "<fikir>"
```
Keşif görüşmesini başlatır (≤7 soru). Sonrası:

```
/proje durum
/proje ilerle
```
- `/proje durum`: aktif projenin özeti. `/proje ilerle`: sıradaki adımı yürütür, kapıda size sorar; oturum kesilirse de aynı komutla sürer.
- Bütün proje işi `/proje` ile yürür (tek istisna: merkez bakımı, `CLAUDE.md`); bu klasör genel bir merkezdir, projeye özel her şey `projects/<ad>/` altındadır.
- Ayrıntılı kullanıcı kılavuzu: [docs/KULLANIM.md](docs/KULLANIM.md). Lider anayasası: `CLAUDE.md`.

## Seviyeler

| Seviye | Fikir | Nerede |
|---|---|---|
| 1 | Tek ajan | Normal Claude Code oturumu |
| 2 | Paralel alt ajanlar | Aynı mesajda çoklu Agent çağrısı (Workflow yalnız siz isterseniz) |
| 3 | Roller + role göre model | `.claude/agents/` (10 ajan) |
| 4 | Karma ekip | `.claude/skills/antigravity/` (Gemini yalnız plan/öneri modu) |
| 5 | Limite göre model seçimi | `team/budget.json` + `model-router` |
| 6 | Hiç iş yapmayan lider | `/proje` + `project-lifecycle` (dış döngü) + `team-lead` (iç döngü) |

## Klasör yapısı

```
CLAUDE.md                     Lider anayasası (her oturumda yüklenir)
docs/KULLANIM.md              Kullanıcı kılavuzu
.claude/agents/               10 ajan: researcher planner game-designer learning-designer
                              ux-designer coder writer critic tester playtester
.claude/commands/             /proje
.claude/skills/
  team-lead/                  iç döngü (parça akışı)
  model-router/               bütçe + model tablosu (scripts/budget.ps1)
  antigravity/                Gemini köprüsü (scripts/agy-run.ps1)
  project-lifecycle/          dış döngü: SKILL.md, sozluk.md, gates.md
    phases/ templates/ checklists/ profiles/
team/
  state/                      HANDOFF (yalnız merkezin durumu)
  scripts/ (+ tests/)         ekip scriptleri
  reports/                    boş + README (yalnız merkez bakımı raporları)
  budget.json                 limit durumu (ok|tight|exhausted)
projects/PROJECTS.md          kayıt defteri + Aktif proje
projects/<ad>/                (/proje yeni ile oluşur) her proje kendi git deposu
  state/                      PHASE, TASKS, TASKS-ARSIV, HANDOFF, INTAKE, LESSONS
  docs/ reports/ ...          belgeler, ajan raporları, kaynak
```

## Gereksinimler

- Claude Code ve Claude desktop Browser paneli (playtest sırasında görünür tutulur).
- git, podman, Windows PowerShell 5.1 (host'ta başka bir şey gerekmez; Node/Python yok).
- İsteğe bağlı: Antigravity CLI `<USERPROFILE>\.gemini\bin\agy.exe` (ilk kullanımda bir kez `agy` ile giriş).

## Scriptler

| Script | Ne yapar | Kim çalıştırır |
|---|---|---|
| `team/scripts/stamp.ps1` | Rapor yolunu (damgalı ad) üretir | her ajan kendi |
| `team/scripts/new-project.ps1` | Yeni proje iskeleti + ilk commit | coder |
| `team/scripts/checkpoint.ps1` | Proje deposunda commit + etiket | coder |
| `team/scripts/phase-gate.ps1` | Aşama çıkış kapısı denetimi | tester |
| `team/scripts/list-reports.ps1` | Raporları listeler (`-Role`, `-Since`, `-Project`) | kullanıcı / ajan |
| `.claude/skills/model-router/scripts/budget.ps1` | `team/budget.json` durumunu yazar/okur | kullanıcı ya da tester |
| `.claude/skills/antigravity/scripts/agy-run.ps1` | Gemini'ye plan/öneri sorusu | tester |
| `team/scripts/tests/phase-gate.tests.ps1` | phase-gate testleri | tester |
| `team/scripts/tests/stamp.tests.ps1` | stamp testleri | tester |

## Kapsam dışı (ileride)

Codex, Kimi, DeepSeek skill'leri: `antigravity` skill'i şablon olarak kopyalanıp aynı kalıpla eklenebilir.

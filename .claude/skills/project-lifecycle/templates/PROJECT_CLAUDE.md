<!-- A3, planner doldurur, hedef: CLAUDE.md (proje koku), <=25 satir; henuz olmayan belgeyi listeden cikar -->
# <ad> — proje karti
<tek cumle urun tanimi>. Etiketler: tur <tur>, kitle <kitle>, profil <profil>, hat <hat>, mod <mod>.

## Yigin
<dil + framework + veri; <gerekce>>. Host'ta yalniz git, podman, PowerShell 5.1 var; her sey konteynerde calisir.

## Komutlar (`run.ps1`, basari = exit 0)
`-Build` · `-Up` (<adres:port>) · `-Down` · `-Test` · `-Check` (icerik dogrulama) · `-E2E` (smoke) · `-Logs`

## Sozlesmeler ve belgeler
`docs/contracts/CONTENT_SCHEMA.md`, `docs/contracts/API.md`, `docs/ARCHITECTURE.md`, `docs/TEST_PLAN.md`, `docs/SPEC.md`. Kod sozlesmeden sapmaz; sapma gerekiyorsa lidere sor.

## Klasor kurallari
`state/` yalniz lider · `docs/` belgeler · `reports/` ajan raporlari, `reports/shots/` ekran goruntuleri · `<kaynak>/`, `<icerik>/`, `<testler>/`

## Yasaklar
- Ajanlar commit atmaz (`checkpoint.ps1` tek coder parcasi olarak, lider istediginde).
- Yalniz gorevde adi gecen dosyalara dokun; ayni dosyaya iki ajan yazmaz.
- `state/` dosyalarini yalniz lider yazar. Playwright kullanilmaz.

## Rapor yolu
Her ajan raporunu `powershell -NoProfile -ExecutionPolicy Bypass -File team/scripts/stamp.ps1 -Role <rol> -Topic <konu> -Project <ad> [-Round <N>]` ciktisina yazar; donus <=10 satir.

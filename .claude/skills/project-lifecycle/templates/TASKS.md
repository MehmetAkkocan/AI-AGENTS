# TASKS <ad> — <hat> A<N> <Asama adi>
<!-- Ilk baslik satirini lider doldurur (new-project.ps1 dokunmaz); scriptler bu satira bagli degildir. Ilk tablo satirlarini planner yazar, sonra yalniz lider gunceller. -->

Dosyada TEK tablo, sabit 6 sutun; ikinci tablo ya da yeni baslik acilmaz. Satir TASINMAZ, silinmez.
Gorev hucresi: `<tanim>; Kabul: <olcut>; Dosyalar: <yollar>; Dogrulama: <komut ya da ->`. A5'te `#` = `D<k>-<n>` (ornek `D2-3`).
Durum: PENDING · RUNNING · NEEDS_REVIEW · DONE · FAILED. Hucrede `|` kullanma.
Rapor = `stamp.ps1` ciktisi (`projects/<ad>/reports/...`; yol kurali sozluk.md phase-gate Denetim 7). DONE satirinin Rapor hucresi dolu olmali; raporu olmayan parca DONE sayilmaz.
phase-gate: PENDING / RUNNING / NEEDS_REVIEW satiri acik sayilir ve FAIL verir; FAILED satiri yeni satirla yeniden acilir ya da nedeni proje HANDOFF'una (`projects/<ad>/state/HANDOFF.md`) yazilir.

| # | Gorev | Rol | Model | Durum | Rapor |
|---|---|---|---|---|---|

## Arsiv
Asama sonunda (phase-gate PASS sonrasi) lider tablonun tamamini `state/TASKS-ARSIV.md` dosyasina `## <hat> A<N>` basligiyla ekler ve bu tabloyu bosaltir.
Dilim kapilari (A5) yalniz burada izlenir; PHASE.md'ye yalniz asama sonu kapilari yazilir.

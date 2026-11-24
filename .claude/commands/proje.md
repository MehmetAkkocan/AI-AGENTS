---
description: Proje yaşam döngüsünü yönetir (fikirden yayına ve retroya). Alt komutlar - yeni, durum, ilerle (devam), sec, liste.
argument-hint: yeni <ad> "<fikir>" | durum [ad] | ilerle [ad] | devam [ad] | sec <ad> | liste
---

`project-lifecycle` (dış döngü: aşama, kapı) ve `team-lead` (iç döngü: parça akışı) skill'lerini yükle ve uygula. Sen ekip liderisin; yalnız `team/state/**`, `projects/PROJECTS.md` ve `projects/<ad>/state/**` yazarsın (proje bilgisi `projects/` dışına yazılmaz), script çalıştırmazsın.

Girdi: $ARGUMENTS

Aktif proje çözümleme (ad verilmeyen alt komutlarda): 1) argüman → 2) `projects/PROJECTS.md` `Aktif proje:` işaretçisi → 3) tabloda tek `CALISIYOR` proje → 4) birden çoksa kullanıcıya tek soru.

## yeni <ad> "<fikir>"
1. Ad `^[a-z0-9]+(-[a-z0-9]+)*$` kuralına uymuyorsa düzeltmesini iste; `projects/<ad>/` varsa dur ve bildir.
2. `team/budget.json`, `team/state/HANDOFF.md` oku (yeni proje yalıtıktır; önceki projelerin dersleri okunmaz).
3. `coder`'a `new-project.ps1 -Name <ad>` çalıştırt (tek parça; hazır konseptle doğrudan Ü'ye giren proje için `-Hat urun -Mod <hafif|orta|tam>`). Kullanıcı proje dışında kaynak dosya verdiyse aynı parçada coder dosyayı kurulumdan hemen sonra `projects/<ad>/docs/kaynak/<ascii-ad>` olarak kopyalar (özgün ad/konum INTAKE `kaynak:` satırına bir kez yazılır) (sonradan çıkarsa ayrı tek coder parçası). Coder raporu script başarılı olduktan sonra yazar; başarısızsa rapor yazmaz, hata metnini dönüşte verir. Lider script çalıştırmaz.
4. Script işaretçiye ve TASKS başlığına dokunmaz; lider yapar: `projects/PROJECTS.md` `Aktif proje:` işaretçisini yeni ada çevir (önce mevcut aktifin proje HANDOFF'unu güncelle), projenin `state/TASKS.md` ilk başlık satırını (`# TASKS …`) doldur. Küresel HANDOFF'a proje bilgisi yazılmaz.
5. `project-lifecycle/phases/a0-kesif.md` oku; `<fikir>` ile ≤7 soruluk keşif görüşmesini başlat.
Hazır konseptle gelen proje (doğrudan Ü): Ü hattıyla kur; A0 kısa yürür, K1 `ONAY-ONCEDEN` yalnız kullanıcı konsepti sohbette açıkça onayladıysa. Kural tek yerde: `phases/a0-kesif.md` Mod farkları (oradan devam).
## durum [ad]
`projects/PROJECTS.md` satırı + projenin `state/PHASE.md`, `state/HANDOFF.md` ve `state/TASKS.md` dosyalarından ≤12 satır özet: hat/mod/aşama/durum, bekleyen kapı, açık parça sayısı (tek TASKS tablosunda Durum'u DONE olmayan satırlar), sıradaki adım.

## ilerle [ad]  (`devam` aynıdır)
Projeyi çöz; `state/PHASE.md`, `HANDOFF.md`, `TASKS.md` oku.
- `durum: KULLANICI_BEKLIYOR` → bekleyen kapıyı `gates.md`'nin ilgili K bölümüyle yeniden sun (≤15 satır); karar yalnız kullanıcının sohbet mesajından alınır.
- Değilse → aktif aşamanın `phases/a<N>-*.md` dosyasını oku, aşama geçiş prosedürünü (SKILL.md) yürüt; parçalar `team-lead` iç döngüsüyle ilerler.

## sec <ad>
`projects/PROJECTS.md`'de `<ad>` yoksa dur. Önce mevcut aktif projenin `state/HANDOFF.md`'sini güncelle, sonra `Aktif proje:` işaretçisini `<ad>` yap (oturum başına tek aktif proje); küresel HANDOFF'a proje bilgisi yazılmaz.

## liste
`projects/PROJECTS.md` tablosunu göster; aktif projeyi işaretle.

Aktif proje yoksa `yeni` ya da `sec` iste. Her alt komutun sonunda kullanıcıya kısa durum ver.

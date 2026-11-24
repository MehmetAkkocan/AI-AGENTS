<!-- A3, planner doldurur (learning-designer pedagojik girdiyi rapor olarak verir), hedef: docs/contracts/CONTENT_SCHEMA.md. P: asgari · hafif+: tam. Writer'lar bu sozlesmeye gore uretir. Hedef kimligi LH-01 (LEARNING_DESIGN) -->
<!-- Duzen: gercek klasor adlarini yaz. Alanlar: her icerik turu icin ayri tablo. Ornek: -Check'ten GECEN tam bir birim. Surumleme: degisiklik politikasini tek satirda yaz -->

# Icerik Semasi — <ad>

Biçim: <TOML | YAML | Markdown + on yazi>, UTF-8. <cok satirli alan kurali, kacis tuzaklari>.

## Dosya / klasor duzeni
```
content/
  <grup-1>/          # <ornek: seviye / modul / bolum>
    <grup>.<uzanti>  # grup meta dosyasi
    NN-<slug>.<uzanti>  # birimler, dosya adina gore siralanir
  _fixture/          # test icerigi; oynanabilir listede gorunmez
```

## Kimlik kurallari
<!-- Yalniz ASCII kucuk harf, rakam, tire. Yayindan sonra kimlik DEGISMEZ (ilerleme kaydi buna baglidir). -->
- Birim: `<grup>-<NN>` (NN dosya adindaki NN ile ayni) · Soru: `<grup>-q<K>` · <diger>

## Birim alanlari
| Alan | Tur | Zorunlu | Kural |
|---|---|---|---|
| id | string | evet | kimlik kurali; tekil |
| title | string | evet | <uzunluk> |
| objective | string | evet | LEARNING_DESIGN hedef kimligi (LH-01 biçimi) |
| body_md | string | evet | <kelime araligi>; `#` (h1) yok; bolumler: <sira> |
| <alan> | <tur> | <evet/hayir> | <kural> |

## Dogrulama kurallari (`run.ps1 -Check`, ihlal = exit 1)
- Klasor numarasi/meta id uyumu; tekrar eden id; id bicimi ve on eki
- Zorunlu alan eksigi, bos alan; <tur kisiti, secenek sayisi, aralik>
- Referanslar (hedef kimligi, onkosul) gercek bir kayda isaret eder
- <projeye ozgu: ornek kodun derlenmesi, cozumun testleri gecmesi>

## Ornek birim
```<uzanti>
id = "<grup>-01"
title = "<baslik>"
objective = "LH-01"
body_md = '''<metin>'''
```
Altin ornek: `<content/.../NN-slug.uzanti>` (A4'te onaylanir; writer'lar bunu kalip alir).

## Surumleme
`schema_version = <N>` meta dosyada; alan ekleme geriye uyumlu, silme/yeniden adlandirma surum artisi ve gocmen notu ister.

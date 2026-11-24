<!-- A3, planner doldurur (coder iskeleti kurarken gunceller), hedef: docs/ARCHITECTURE.md. P: yuruyen iskelet, yalniz §1, §4 · hafif: §1-5 · orta: + §8 · tam: + §6, §7. C-GUV kosullu ise §6, C-PERF kosullu ise §7 (gercek zamanli oyun) modu ne olursa olsun doldurulur -->
# Mimari — <ad>

## 1. Yigin ve gerekce
<!-- Her secim icin tek satir gerekce. Host kisiti: yalniz git, podman, PowerShell 5.1; her sey konteynerde derlenir ve calisir. -->
| Katman | Secim | Gerekce |
|---|---|---|
| Calisma ortami | podman, <imaj> | host'ta arac zinciri yok |
| <backend / motor> | <secim> | <gerekce> |
| <on yuz / istemci> | <secim> | <gerekce> |
| <veri> | <secim> | <gerekce> |

## 2. Modul haritasi ve sinirlar
<!-- Her modul: sorumluluk, bagimli oldugu moduller, DOKUNULMAYACAK sinir. Dongusel bagimlilik yok. -->
| Modul | Yol | Sorumluluk | Bagimlilik |
|---|---|---|---|
| <modul> | <src/...> | <tek cumle> | <modul listesi ya da yok> |

## 3. Veri modeli
<!-- Varliklar, alanlar, iliskiler; kalici veri ile icerik dosyasi ayrimi. -->
- <varlik>: <alanlar>; <iliski>

## 4. Sozlesmeler ve calistirma
<!-- API.md icerigi: uc nokta/rota, istek-yanit bicimi, hata kodlari (arayuz parcalari dahil). Kod sozlesmeye uyar, tersi degil. -->
- Sozlesmeler: `docs/contracts/CONTENT_SCHEMA.md` (icerik), `docs/contracts/API.md` (arayuz).
- `run.ps1`: `-Build` imaj · `-Up` <adres> · `-Down` · `-Test` · `-Check` icerik dogrulama · `-E2E` smoke · `-Logs`
- Calistirma alanlari (coder `run.ps1`'i yalniz profil + bu alanlarla yazar): Servis adi: <ad> · Port: <host:konteyner> · Test hedefi: <ayri test asamasi/imaji + komut> · Icerik dogrulama (`-Check`): <komut> · E2E senaryosu: <adim ozeti>

## 5. Stub / kablo plani
<!-- Paylasilan module dokunan paralel gruptan ONCE tek coder stub + kablolama yapar. Sirayla yaz. -->
1. <modul>: <stub icerigi, kablo noktasi> -> sonra paralel: <modul A>, <modul B>

## 6. Guvenlik notlari / tehdit modeli (tam; C-GUV)
<!-- Kullanici girdisi, hesap, ag, calistirilan kod icin tehdit + onlem; kontrol listesi guvenlik-sertlestirme.md. -->
| Varlik / giris | Tehdit | Onlem | Kalan risk |
|---|---|---|---|
| <kullanici girdisi, hesap, ag, calistirilan kod> | <tehdit> | <onlem> | <risk> |

## 7. Performans butcesi (tam; C-PERF)
<!-- Olculebilir hedefler; tester bu komutlarla T-A6'da dogrular. -->
| Olcut | Hedef | Olcum komutu |
|---|---|---|
| <ilk yukleme, yanit suresi, bellek, FPS> | <sayi + birim> | <komut> |

## 8. ADR listesi
<!-- Her onemli secim icin docs/adr/ dosyasi; buraya tek satir ozet. -->
`docs/adr/000-prototip-kodu.md` (P'den terfide) · `<NNN>-<konu>.md`: <tek satir karar>

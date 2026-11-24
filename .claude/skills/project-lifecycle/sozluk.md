# Adlandırma sözlüğü (project-lifecycle)

Tüm ajanlar dosya, alan, kimlik ve değer adlarını BURADAN alır; yeni ad üretme. Dosya/alan/kimlik adları ASCII. Matris yalnız `SKILL.md`'de. Lider bu dosyayı okumaz; ihtiyaç duyduğu değerler `PHASE.md` lejantında durur. Bu dosya + skill dosyaları kalıcı tek doğruluk kaynağıdır; plan ile ayrışırsa bu dosya geçerlidir. Merkez (`D:\AI Agent Team`) genel süreçtir; projeye özel her şey `projects/<ad>/` altındadır; merkezde `team/state/` yalnız `HANDOFF.md` (merkez durumu + `projects/PROJECTS.md` işaretçisi; proje adı/aşaması/kararı/açık sorusu YAZILMAZ) tutar; kayıt defteri + `Aktif proje:` `projects/PROJECTS.md`'dedir. Proje işinde "HANDOFF" = `projects/<ad>/state/HANDOFF.md`. Sabit kullanıcı kararları: Playwright yok (playtest: tarayıcı paneli → HTTP → kullanıcı gözlemi) · ekip klasörü git deposu değil, git yalnız `projects/<ad>/` içinde · Gemini yalnız plan modunda, dosya yazmaz · dışarıya yükleme kullanıcıda.

## Satır bütçeleri
SKILL.md ≤100 (kesin) · sozluk.md ≤210 · `hat-gecisleri.md` ≤60 · aşama dosyaları ≤70 (`a6-dogrulama-p.md` dahil) · gates.md ≤190 · şablonlar 20-55 (TASKS, ADR, LESSONS daha kısa olabilir) · kontrol listeleri ≤65 · profiller ≤75 · ajan dosyaları ≤65 (playtester ≤75) · team-lead SKILL ≤110 · `commands/proje.md` ≤45 · proje `CLAUDE.md` ≤25.

## Aşama dosyaları (`phases/`)
A0 Keşif `a0-kesif.md` · A1 Konsept / Tanım `a1-konsept.md` · A2 Tasarım `a2-tasarim.md` · A3 Mimari, sözleşme, iskelet `a3-mimari.md` · A4 Dikey dilim `a4-dikey-dilim.md` · A5 Üretim `a5-uretim.md` · A6 Doğrulama `a6-dogrulama.md` (yalnız Ü) · A6 Doğrulama (P) `a6-dogrulama-p.md` (yalnız `hat = prototip`; lider P/A6'da yalnız bunu okur) · A7 Yayın `a7-yayin.md` · A8 Retro `a8-retro.md`.
Sabit iskelet (bu sırayla, başka `##` yok): `# A<N> <Aşama adı>` · `## Amaç` · `## Girdiler` · `## Adımlar` · `## Mod farkları` (matrise atıf; matrisi kopyalama) · `## Çıkış kriterleri` (PHASE `Cikis kriterleri` tablosuna aynen yazılacak satırlar: Kriter + Yol; Yol backtick'siz) · `## Kapı` (beklenen kapı kimlikleri, hat/moda göre).
Her ajan adımında hazır prompt KOD BLOĞU içinde, team-lead çağrı şablonu alanlarıyla: `Rol / Proje / Aşama / Parça / Kabul kriteri / Dosyalar / Konu / Doğrulama komutu / Kontrol listesi / Kapı`. `Kapı:` = kapı kimliği ya da `yok` (dilim critic'i için `yok`). P hattında var olmayan dokümanlara (UX.md, ART_AUDIO.md) atıf yapılmaz; P'de tasarım BRIEF içindedir. Kademeli critic: critic adım başlığı modeli parantezle yazar — `(sonnet; parça)` (`Kapı: yok`, A7 danışma incelemesi dahil) / `(opus; kapı)` (`E-A<n>`, `C-*`, kullanıcı kapısı öncesi son inceleme); `agents/critic.md` `model: opus` kalır, parça incelemesinde lider Agent çağrısına `model: sonnet` verir; `tight` iken hepsi sonnet. Tıkanma: parça critic'i 2 tur REVISE → 3. tur critic opus + üretici ajan bir üst model (zaten opus ise aynı) → hâlâ REVISE → `durum: BLOKE`; kapı critic'i 2 tur REVISE → model terfisi YOK → `BLOKE`; `tight` iken terfi yok (2 tur sonra `BLOKE`). Aynı modelde ardışık turlar aynı ajanla (SendMessage); model değişen turda yeni Agent çağrısı + önceki rapor yolları. Tablo ve `budget.ps1` yönlendirmesi: `model-router`.

## Kimlikler ve izlenebilirlik
Özellik `F-01`, `F-02`… (SPEC; P'de BRIEF kapsamı) · kabul ölçütü özelliğin alt maddesi `F-01.a` · öğrenme hedefi `LH-01`… (LEARNING_DESIGN). Başka biçim (`SPEC-xx`, `AC-01`, `H-NN`) yok.
Zincir: SPEC (F) → GDD / LEARNING_DESIGN (LH) / UX eşleme alanı → TEST_PLAN eşlemesi → VERIFICATION kapsama satırı. Her halka bir önceki kimliği aynen anar. ADR: `docs/adr/<NNN>-<konu>.md`, NNN üç hane; `000-prototip-kodu.md` terfiye ayrılmıştır.

## Şablonlar (`templates/`, 22 dosya) ve doküman sahipliği (tek sahip)
| Şablon | Projedeki hedef yol | Sahip |
|---|---|---|
| `BRIEF.md` | `docs/BRIEF.md` (P ve Ü) | planner; P'de çekirdek döngü / öğrenme hedefi bölümünü A2'de game-/learning-designer ekler |
| `SPEC.md` | `docs/SPEC.md` | planner |
| `DESIGN.md` | `docs/DESIGN.md` (yalnız Ü/hafif) | game-designer veya learning-designer (türe göre); UX bölümünü ux-designer SONRA ekler |
| `GDD.md` | `docs/GDD.md` | game-designer |
| `LEARNING_DESIGN.md` | `docs/LEARNING_DESIGN.md` | learning-designer |
| `UX.md` · `ART_AUDIO.md` | `docs/UX.md` · `docs/ART_AUDIO.md` | ux-designer |
| `ARCHITECTURE.md` · `ADR.md` · `TEST_PLAN.md` | `docs/ARCHITECTURE.md` · `docs/adr/<NNN>-<konu>.md` · `docs/TEST_PLAN.md` | planner |
| `CONTENT_SCHEMA.md` | `docs/contracts/CONTENT_SCHEMA.md` | planner (learning-designer pedagojik girdiyi rapor olarak verir) |
| `PERSONAS.md` | `docs/PERSONAS.md` (BRIEF kitlesinden; Ü: A4 playtest başında · P: A6 playtest başında) | playtester |
| `PLAYTEST_REPORT.md` | `reports/<damga>-playtester-<konu>.md` | playtester |
| (aynı şablon, derleme) | `docs/PLAYTEST.md` (yalnız Ü, A6 özeti) | writer |
| `PROTOTYPE_REVIEW.md` · `VERIFICATION.md` · `RETRO.md` | `docs/PROTOTYPE_REVIEW.md` (yalnız P: A6'da derlenir, A8'de "Retro notu" bölümü eklenir) · `docs/VERIFICATION.md` (yalnız Ü, A6) · `docs/RETRO.md` (yalnız Ü, A8) | writer |
| `RELEASE.md` | `docs/RELEASE.md` (Ü/hafif'te yok; README kurulum bölümü) | writer |
| `PHASE.md` · `HANDOFF.md` · `LESSONS.md` | `state/PHASE.md` · `state/HANDOFF.md` · `state/LESSONS.md` | lider (LESSONS iskeletini `new-project.ps1` şablondan kurar) |
| `TASKS.md` | `state/TASKS.md` | lider (ilk tablo satırlarını planner yazar) |
| `PROJECT_CLAUDE.md` | `CLAUDE.md` (proje kökü) | planner |

Şablonsuz artefaktlar ve sahipleri: `state/INTAKE.md` lider (biçim `a0-kesif.md`'de; doğrudan Ü'de açık onay kanıtı `onceden-onay: <gün>; kaynak: <projects/<ad>/docs/kaynak/<ascii-ad>>` satırı) · `docs/kaynak/<ascii-ad>` coder (dış kaynak dosyasının birebir kopyası; ad ASCII: Türkçe harf karşılığına, boşluk `-`, uzantı korunur; özgün ad/konum INTAKE `kaynak:` satırında bir kez; A0 adım 0) · `state/MANUEL-<p>.md` lider (kullanıcının MANUEL form yanıtı, sohbetten aynen) · `state/TASKS-ARSIV.md` lider (boş açılır, başlık `## <hat> A<N>`) · `docs/CONSTRAINTS.md` planner (SPEC'in Kısıtlar bölümü orta/tam'da buraya taşınır) · `docs/contracts/API.md` planner (ARCHITECTURE'daki sözleşme bölümüne göre: uç nokta, istek/yanıt, hata) · `docs/ux/wireframes/NN-<ekran>.html` (ör. `01-ana-ekran.html`) ux-designer (yalnız tam mod) · `docs/BACKLOG.md`, `README.md`, `CHANGELOG.md` writer · içerik birimleri writer · kaynak kod, `run.ps1`, görsel/ses varlıkları coder. Yollar `projects/<ad>/` köküne göredir. Sahip dışında kimse yazmaz; ortak dokümanda (DESIGN) yazarlar sırayla çalışır. writer'lar raporlardan derler, karar üretmez.
Zorunlu şablon içerikleri: `PHASE.md` sonunda `## Izinli degerler` lejantı · `TASKS.md` sabit tablo başlığı · `VERIFICATION.md` tek başına `ENGEL: <n>` satırı, kapsama satırları (F/LH) ve "Geri alma" bölümü (K4 bunu sunar).
LESSONS (`state/LESSONS.md`, PROJEYE ÖZEL; iki tablo: "Süreç önerileri" ve "Dersler"; yeni proje önceki projelerin derslerini okumaz, aynı proje içinde terfi sonrası A1'de lider okur; ders başka projelerde de geçerli olacaksa yol süreç dosyası değişikliğidir, yalnız kullanıcı onayıyla) öneri durumu: `ONERI` → `KABUL` · `RED` (ASCII) · PROTOTYPE_REVIEW hipotez sonucu: `DOGRULANDI` · `KISMEN` · `CURUTULDU`.

## Kontrol listeleri (`checklists/`, 7 dosya)
| Dosya | Madde öneki | Kullanıldığı kapı |
|---|---|---|
| `cocuk-guvenligi-gizlilik.md` | CG | C-COCUK (A2, A6; P: A2, A6'da yalnız CG-03, 04, 08, 09 E-A6 içinde) |
| `yas-uygun-icerik.md` | YU | C-YAS (A5, A6; P: A6 hafif, YU-03, 04, 05, 10) |
| `hassas-alan.md` | HA | C-ALAN (A2, A6) |
| `guvenlik-sertlestirme.md` | GS | C-GUV (A3, A6) |
| `erisilebilirlik.md` | ER | C-ERISIM (A2, A6) |
| `icerik-kalitesi.md` | IK | E-A4 (altın örnek), E-A5 (içerik incelemesi), E-A6 |
| `yayin-oncesi.md` | YO | Ü E-A6 (yalnız yayın ADAYI maddeleri: hata ayıklama kancaları kapalı, gizli bilgi yok, bilinen sorunlar yazılı) · A7 critic + T-A7 (README / CHANGELOG / RELEASE / etiket maddeleri; Ü/hafif'te RELEASE yerine README kurulum bölümü) |

C-PERF'in listesi yoktur (ölçüt `docs/ARCHITECTURE.md` performans bütçesi). Madde biçimi TABLO: `| # | Madde | Nasil dogrulanir | Onem |`; `#` = `CG-01` biçimi (iki hane, dosya içinde tekil); Onem = ENGEL · BUYUK · KUCUK.
Önem sınıfları (yalnız bu üç yazım): **ENGEL** (kapıyı kapatır) · **BUYUK** (kapıdan önce düzeltilir ya da BACKLOG'a gerekçeli) · **KUCUK** (BACKLOG). Rapor ve dönüşlerde de aynı yazım.
Her listenin üst bloğu: "hukuki görüş değildir" uyarısı + "Tablodaki `\|` yalnız Markdown kaçışıdır; Grep / ripgrep deseninde düz `|` yazılır."
Kanıt türleri (`Nasil dogrulanir` hücresi): belge/kod incelemesi (critic) · `kanıt: playtester raporu` (tarayıcı gerektiren madde; critic'in tarayıcı aracı yok) · `kullanıcı gözlemi` (ses, emülasyon vb. ekibin doğrulayamadığı madde; ENGEL olamaz, en çok BUYUK).
Aynı ölçüt iki listede geçmez: tek listede kalır, diğeri atıf yapar; önem çelişkisinde sıkı olan geçerli. Örneklem kuralı (yazar kararı, tüm listeler ve `a5-uretim.md`): en az 5 birim ya da %20, hangisi büyükse; toplam 5'ten azsa tümü.
Kaynaklar: ölü bağlantı kaldırılır; doğrulanamayan `(doğrulanmadı)` diye işaretlenir ya da resmi ana sayfayla değiştirilir.

## Profiller (`profiles/`, 3 dosya)
`web.md` · `mobil.md` · `masaustu-motor.md`. Sabit başlıklar (sırayla): `## Kapsam` · `## Konteyner ve teknoloji varsayılanları` · `## run.ps1 eşlemesi` · `## Test kancaları` · `## Playtest yöntemi` (TARAYICI / HTTP / MANUEL; Playwright yok) · `## Sınırlar` · `## Yayın paketi`.

## Kapı kimlikleri
Kullanıcı (`kullanici`): K1 (A1) · K2 (A2) · K3 (P: A6 · Ü: A4) · K4 (A6). Aşama çıkışı: critic `E-A0` … `E-A8` (P'de E-A8 yok) · tester `T-A3` … `T-A7` · playtester `P-A4` (yalnız Ü), `P-A5` (yalnız tam), `P-A6`.
Koşullu kapılar (tetikleyici: `gates.md` "Koşullu kapılar" tablosu; izinli aşamanın TEK kaynağı aşağıdaki "phase-gate kuralları" tablosudur, `gates.md` aşama sütunu onunla aynen aynı yazılır):
| Kapı | Denetleyen + kontrol listesi |
|---|---|
| C-COCUK | critic + `cocuk-guvenligi-gizlilik.md` |
| C-YAS | learning-designer + critic + `yas-uygun-icerik.md` (P + kitle cocuk/genc: A6'da hafif; learning-designer `a6-yas` altın örnek + dilim metni, karar critic `a6-c-yas`) |
| C-ALAN | critic + `hassas-alan.md` |
| C-GUV | critic + global skill `security-and-hardening` + `guvenlik-sertlestirme.md` |
| C-ERISIM | A2: critic (belge düzeyi) · A6: playtester (erişilebilirlik personası + ağaç) + critic + `erisilebilirlik.md` |
| C-PERF | tester + critic |

Birden çok denetleyenli kapıda PHASE'e kararı veren son denetleyen (critic) yazılır; diğerlerinin raporu critic'e girdi olur. P-A<n>: birden çok persona/tur varsa kapı sonucu EN KÖTÜ sonuçtur (ENGEL > DUZELTILMELI > GECER); lider bu tek sonucu yazar.
Beklenen kapılar — Ü: A0 E · A1 E, K1 · A2 E, C, K2 · A3 E, T, C · A4 E, T, P, K3 · A5 E, T, C (+P tam) · A6 E, T, P, tüm C, K4 · A7 T · A8 E. P (aşama sırası A0, A1, A2, A3, A4, A6, A8; A5 ve A7 yok): A0 E · A1 E, K1 · A2 E, C · A3 E, T, C · A4 E, T · A6 T, P, E, (C-YAS: kitle cocuk/genc), K3 · A8 kapı yok (çıkış kriteri: `PROTOTYPE_REVIEW.md` "Retro notu"). Kullanıcı kapısı matriste o hat/modda yoksa satır yazılmaz (Ü/hafif'te K2, K3 yok; Ü/orta-tam'da K3 yalnız doğrudan girişte, A4 sonunda; sunum kaynağı = A4 playtester raporu + tester raporu). P akışı, YINELE / TERFI / RAFA-KALDIR sırası: `hat-gecisleri.md` (kesin). Koşullu kapı aşama başına ayrı satırdır (`C-GUV`, `A3`). A5 dilim kapıları yalnız TASKS'ta; PHASE'e yalnız aşama sonu E-A5/T-A5.

## Kullanıcı kapıları (gates.md kuralları)
Lider kapı sunarken gates.md'nin YALNIZ ilgili K bölümünü okur → her K bölümü kendi başına yeterli (sunum şablonu, seçenekler, durum etkisi, kayıt satırı); başka bölüme gönderme yok.
K2 = KUCULT kapıyı geçirmez (tasarım daraltılır, K2 yeniden sunulur). Terfi içerik adımları K3 bölümünün İÇİNDEDİR; sıra, kimlik ve etiketler `hat-gecisleri.md`'de kesindir (K3 bölümü ona uyar). ADR-000 "koru / yeniden yaz" önerisi K3 sunumunda yer alır, A3'te mimari critic'iyle kesinleşir (ayrı soru yok). K4'ün "geri alma" bilgisi VERIFICATION.md bölümünden gelir (RELEASE A7'de, K4'ten sonra yazılır). Doğrudan Ü girişi: koşul `phases/a0-kesif.md` Mod farkları (`commands/proje.md` ona işaret eder), akış ve `ONAY-ONCEDEN` kaydı `hat-gecisleri.md`; yeni karar değeri uydurulmaz.
Görsel onay (K3 ve K4; her hat, her mod): sunum şablonunda "Görsel onay" satırı (çalıştırma komutu + adres + bakılacak ekranlar). Geçiren karar (K3: TERFI / DEVAM; K4: YAYINLA) yalnız kullanıcı ürünü kendisi açıp baktıktan sonra alınır; "bakmadım" ya da belirsiz yanıt karar değildir. Geçirmeyen kararlar (YINELE, RAFA-KALDIR, DUZELT, DURDUR, ERTELE) görsel onay istemez. Geçer sonuçlu (ISTISNA dahil) K3/K4 satırının Rapor hücresi KESİN: `kullanici: gorsel onay; <sunum raporu yolu ya da ->` (ISTISNA'da `-` yerine gerekçe). Yeni kapı kimliği yok.
K sunumunu lider hazırlar: kaynak ajan dönüşleri + writer'ın derlediği belge (P'de K3: `PROTOTYPE_REVIEW.md`; K4: `VERIFICATION.md`); alan eksikse writer'a "K<n> sunum özeti" parçası (≤15 satırlık rapor; Konu P `a6-k3-sunum` · Ü `a4-k3-sunum` · `a6-k4-sunum`); lider bu TEK raporu tamamen okuyabilir (rapor okumama kuralının istisnası); K satırının Rapor hücresi bu rapor (geçer K3/K4'te yukarıdaki önekle). PROTOTYPE_REVIEW'un kaba boyut, mod ve ADR-000 önerisi planner'ın P/A6 `a6-k3-oneri` raporundan gelir; writer `a6-review` ile derler.
Yeniden koşma kuralı: olumsuz karardan (REVISE, FAIL, DUZELT, KUCULT, YINELE, DUZELTILMELI, ENGEL) sonra yeniden koşacak HER kapı için aynı (Kapi, Hat, Asama) anahtarıyla hemen yeni `BEKLIYOR` satırı; eski geçer satır kapıyı açık bırakamaz. Kullanıcı kapısında olumsuz karar: o aşamanın E-A<n>'i, etkilenen C-*'lar ve K<n> yeniden BEKLIYOR. İstisna P/K3 YINELE: hemen `E-A4`, `T-A4`; A6'ya yeniden girişte `T-A6`, `P-A6`, `E-A6`, (varsa) `C-YAS`, `K3` (`hat-gecisleri.md`).

## Karar sözcükleri (PHASE `Kapi kayitlari` → `Sonuc`, aynen)
| Kapı türü | Değerler |
|---|---|
| critic (E-*, C-*) | APPROVE · REVISE |
| tester (T-*) | PASS · FAIL |
| playtester (P-*) | GECER · DUZELTILMELI · ENGEL |
| K1 | ONAY · DUZELT · DURDUR · ONAY-ONCEDEN (doğrudan Ü; yalnız sohbette açık onay kanıtıyla) |
| K2 | ONAY · DUZELT · KUCULT (geçmez) |
| K3 (P) | TERFI · YINELE (≤2) · RAFA-KALDIR |
| K3 (Ü) | DEVAM · DUZELT · DURDUR |
| K4 | YAYINLA · DUZELT · ERTELE |
| her kapı | BEKLIYOR (henüz sonuç yok) · ISTISNA (yalnız kullanıcı kararıyla; `Rapor` hücresine `kullanici: <gerekçe>`) |

**Geçer sayılan değerler:** `APPROVE, PASS, GECER, ONAY, ONAY-ONCEDEN, TERFI, DEVAM, YAYINLA, ISTISNA`. Diğer her değer (BEKLIYOR dahil) kapıyı açık bırakır.
Durum etkisi: DURDUR → `durum: RAFTA` · RAFA-KALDIR → P/A8 retro notundan sonra `RAFTA` (`hat-gecisleri.md`) · ERTELE → `BLOKE` · YINELE (P/K3) → `asama: A4`, `CALISIYOR` · DUZELT, KUCULT, REVISE, FAIL, DUZELTILMELI, ENGEL → aynı aşamada `CALISIYOR`.
Playtester dönüş alanları (ASCII): `SONUC: GECER / DUZELTILMELI / ENGEL` · `YONTEM: TARAYICI / HTTP / MANUEL` · `GORSEL: KONTROL EDILDI / DOGRULANMADI` · görev sonucu `BASARDI / ZORLANDI / BASARAMADI`. Eski `DOGRULANDI` değeri kullanılmaz.
MANUEL iki çağrılıdır: (1) playtester (`Parça: MANUEL form <p>`) elle test senaryosu + gözlem formunu raporunun `## MANUEL gözlem formu` bölümüne yazar, SONUC vermez, `DURUM: NEEDS_REVIEW` + "kullanıcı bekleniyor" döner (kapı satırı BEKLIYOR kalır); lider formu (yalnız o bölüm) kullanıcıya sunar, kullanıcının sohbetteki yanıtını aynen `state/MANUEL-<p>.md`'ye yazar; (2) playtester (`Parça: MANUEL değerlendirme <p>`, `Oku: state/MANUEL-<p>.md`) yanıtı değerlendirip SONUC döner (`YONTEM: MANUEL`, `GORSEL: DOGRULANMADI`). Aşama görsel onaylı K3/K4 ile bitiyorsa (aşağıda) SONUC GECER → kapı `GECER`; form K3/K4 görsel onayının yerini tutmaz (kapıda tek cümlelik teyit yine istenir). Bitmiyorsa form o ekranlar için görsel onay sayılır: SONUC GECER ise kapı kaydı `ISTISNA`, Rapor `kullanici: gorsel onay (MANUEL form); <playtester rapor yolları>`.

## Playtest ve görsel kanıt
`GORSEL: KONTROL EDILDI` yalnız ajan o ekran × görünümün görüntüsünü GERÇEKTEN gördüyse yazılır; dosya şart değil. Kanıt: görüntünün metin betimi + erişilebilirlik ağacı alıntısı + gerekiyorsa `javascript_tool` ölçümü (boyut, taşma, renk). 2 yeniden denemeden sonra görüntü alınamazsa hücre `DOGRULANMADI`; `GORSEL:` satırı BİLGİDİR. Aşama görsel onaylı kullanıcı kapısıyla bitiyorsa (P/A6 → K3 · doğrudan girişli Ü/A4 orta-tam → K3 · Ü/A6 → K4) `DOGRULANMADI` ayrı ön-onay / P-A<n> ISTISNA gerektirmez: SONUC GECER ise P-A<n> = GECER, onay kapıda alınır. Bitmiyorsa (tam modda P-A5; K3'süz Ü/A4: hafif ya da terfi etmiş proje) `DOGRULANMADI` P-A<n>'i tek başına geçirmez → kullanıcı görsel onayı, kapı kaydına ISTISNA (`kullanici: gorsel onay`).
Cihazda test (yalnız profil mobil): varsayılan YOK (port yalnız 127.0.0.1). P hattında yalnız (a) vardır: tarayıcıda 375×812 emülasyon, cihaza özgü maddeler playtester raporunda "kullanıcı gözlemi — yapılamadı" (P'de BACKLOG yok); (b) geçici `-Lan` yalnız Ü'de sunulur. Ü'de lider kullanıcıya iki seçenek sunar: (a) tarayıcıda 375×812 emülasyonla yetin; cihaza/PWA'ya özgü maddeler "kullanıcı gözlemi — yapılamadı" olarak BACKLOG'a; (b) kullanıcı kararıyla (ISTISNA) yalnız test süresince geçici yerel ağ erişimi: tester `run.ps1 -Up -Lan` (isteğe bağlı anahtar, varsayılan kapalı), kayıt `C-GUV | urun | A6 | kullanici | ISTISNA | kullanici: gecici -Lan cihaz testi (GS-06) | <gün>` ve hemen ardından aynı anahtarla `BEKLIYOR` (C-GUV denetimi yine koşar), test bitince tester `-Down`. HTTPS gerektiren PWA özellikleri (kurulum, service worker, bildirim) yerel ağda test edilemez → BACKLOG.
`reports/shots/` iskelette durur ama İSTEĞE BAĞLIDIR; hiçbir kapı dosya varlığına bağlı değildir (ekran görüntüsü dosyaya kaydedilemeyebilir).
ux-designer salt-görüntüleme tarayıcı araçları: navigate, computer (yalnız screenshot / scroll / zoom), read_page, get_page_text, resize_window, tabs_context. A4/A6'da UX.md karşılaştırmasını kendi görerek yapar; panel yoksa playtester raporunun Görsel kontrol tablosunu kullanır. Yalnız yerel adres; tıklama / form yok. Playtester çağrısında `Oturum: acik-birak | kapat` (varsayılan kapat): ux karşılaştırması gelecekse acik-birak → ürün açık kalır, ux sonrası lider tester'a `run.ps1 -Down` verir; kapat → playtester YALNIZ kendi başlattığını durdurur.
`javascript_tool`: yalnız inceleme ve projenin KENDİ test kancası (`window.__game` step/input, yalnız `?debug=1`); uygulama durumunu başka yolla değiştirmez. Playtest ve ux karşılaştırması sırasında lider kullanıcıdan Browser panelini görünür tutmasını ister (panel gizliyken zaman aşımı olabilir).

## PHASE.md kesin biçimi (`state/PHASE.md`; script ayrıştırır)
```
# PHASE <ad>
proje: <ad> | tur: <tur> | kitle: <kitle> | profil: <profil>
hat: <hat> | mod: <mod> | asama: A<N> | durum: <durum>
kosullu: <C-..., C-... ya da yok>

## Cikis kriterleri
| # | Hat | Asama | Kriter | Yol | Durum |
|---|---|---|---|---|---|

## Kapi kayitlari
| Kapi | Hat | Asama | Denetleyen | Sonuc | Rapor | Tarih |
|---|---|---|---|---|---|---|

## Asama gecmisi
| Hat | Asama | Baslangic | Bitis | Sonuc | Etiket |
|---|---|---|---|---|---|

## Izinli degerler
```
Kurallar: başlık satırları yalnız ilk `##`'den önce aranır; `anahtar: deger` çiftleri ` | ` ile ayrılır, script boşlukları kırpar. `kosullu` ayıracı `, `. Hücre içinde `|` yasak. Satırlar tablo sonuna eklenir, silinmez. Her `##` bölüm başlığı bir kez geçer.
`## Izinli degerler` lejantı (script okumaz; satırlar `- ` ile başlar) en az şunları listeler: durum değerleri, kapı kimlikleri, kapı türüne göre karar sözcükleri, geçer değerler, durum etkisi, hat/mod/tur/kitle/profil değerleri, Denetleyen (`kullanici` dahil), K satırında Rapor `-`, geçer K3/K4 Rapor biçimi (`kullanici: gorsel onay; ...`), ISTISNA biçimi, Cikis kriterleri Yol/Durum, Asama gecmisi Sonuc/Etiket, Tarih biçimi.

| Alan / sütun | İzinli değerler |
|---|---|
| proje | proje adı; klasör adıyla aynı |
| tur | `oyun` (öğrenme hedefi yoksa) · `egitim` · `ogrenme` · `kisisel-gelisim`; oyunlaştırma ya da öğretme hedefi olan oyun eki `+oyun` (ör. `egitim+oyun`) · `?` yalnız A0 |
| kitle | `cocuk` · `genc` · `yetiskin` · `?` yalnız A0 |
| profil | `web` · `mobil` · `masaustu-motor` · `?` yalnız A0 |
| hat / Hat | `prototip` · `urun` |
| mod | `hafif` · `orta` · `tam` · `-` (`hat: prototip` iken zorunlu `-`) |
| asama / Asama | `A0` … `A8` |
| durum | `CALISIYOR` · `KAPI_BEKLIYOR` (ajan kapısı bekleniyor) · `KULLANICI_BEKLIYOR` · `BLOKE` · `TAMAM` · `RAFTA` |
| kosullu | `C-...` kimlikleri ya da `yok` |
| Cikis kriterleri → Yol | proje köküne göre tek dosya yolu (backtick'siz) ya da `-` (dosyasız kriter; kapı kaydıyla kanıtlanır) |
| Cikis kriterleri → Durum | `ACIK` · `TAMAM` (lider, ilgili ajan raporu gelince çevirir) |
| Kapi kayitlari → Kapi | `K1`-`K4` · `E-A0`…`E-A8` · `T-A3`…`T-A7` · `P-A4`…`P-A6` · `C-COCUK` · `C-YAS` · `C-ALAN` · `C-GUV` · `C-ERISIM` · `C-PERF` |
| Kapi kayitlari → Denetleyen | rol adı (aşağıda) ya da `kullanici` |
| Kapi kayitlari → Rapor | `;` ile ayrılmış parçalar; yol kuralı phase-gate Denetim 7; K satırında sunumu hazırlayan rapor ya da `-`; geçer K3/K4 satırında `kullanici: gorsel onay; <sunum raporu ya da ->` |
| Tarih, Baslangic, Bitis | gün `yyyy-MM-dd` (lider oturum tarihini yazar; dakika gerekiyorsa rapor adındaki damga yeterli) |
| Asama gecmisi → Sonuc | `TAMAM` · `TERFI` · `RAFTA` · `BLOKE` |
| Asama gecmisi → Etiket | git etiketi ya da `-` |

Proje adı: `^[a-z0-9]+(-[a-z0-9]+)*$` (ör. `ornek-proje`). Rapor konusu (`-Topic`) aynı kurala uyar. `projects/PROJECTS.md`: ilk satır `Aktif proje: <ad>` (yalnız lider değiştirir); tablo `| ad | tur | kitle | profil | hat | mod | asama | durum |`; bilinmeyen değer `?`.

## TASKS.md (proje: `state/TASKS.md`)
Dosyada TEK tablo, sabit 6 sütun: `| # | Gorev | Rol | Model | Durum | Rapor |`. Yeni başlık veya ikinci tablo açılmaz.
Gorev hücresi: `<tanım>; Kabul: <ölçüt>; Dosyalar: <yollar>; Dogrulama: <komut veya ->`. A5 dilimleri `#` hücresinde `D<k>-<n>` önekiyle (ör. `D2-3`); ayrı tablo yok.
Durum: `PENDING` · `RUNNING` · `NEEDS_REVIEW` · `DONE` · `FAILED`. Rapor = yol (kural: phase-gate Denetim 7). FAILED satırı kapıyı açık bırakmaz; lider FAILED parçayı yeni satırla yeniden açar ya da nedenini proje HANDOFF'una yazar (yazar kararı, script davranışıyla aynı).
Satır TAŞINMAZ, silinmez. Aşama sonunda (phase-gate PASS sonrası) lider tablonun tamamını `state/TASKS-ARSIV.md`'ye `## <hat> A<N>` başlığıyla ekler ve TASKS tablosunu boşaltır.
İlk başlık satırını (`# TASKS …`) lider doldurur; new-project doldurmaz; scriptler bu satıra bağlı değildir. Tablo satırlarını ilk kez planner yazar, sonra lider günceller.
Merkezde TASKS yoktur; phase-gate yalnız proje TASKS'ını okur.

## phase-gate kuralları (`phase-gate.ps1`, salt okunur)
Aktif (hat, asama) = PHASE başlık satırındaki `hat` ve `asama`.
Doğrulama (geçersiz / yanlış yazımlı değer → exit 2, sessiz atlama yok): başlık alanları izinli değerde; `proje` = klasör adı; `tur/kitle/profil = ?` yalnız `asama: A0`'da; `hat: prototip` iken `mod: -`; Kapi kayitlari satırlarında Kapi / Hat / Asama / Sonuc ve Cikis kriterleri satırlarında Hat / Asama / Durum izinli değerde; aynı `##` bölüm başlığı iki kez → exit 2. Kapı–aşama tutarlılığı (TEK doğruluk kaynağı; script ve test buna göre): HER Kapi kayitlari satırının (yalnız aktif olanlar değil) Asama'sı, (Kapi, Hat) için aşağıdaki tabloda izinli değilse → exit 2 (`—` = kimlik o hatta yok, her aşamada exit 2):
| Kapi | Hat = urun | Hat = prototip |
|---|---|---|
| `E-A<n>` · `T-A<n>` · `P-A<n>` | yalnız `A<n>` | yalnız `A<n>`; yalnız E-A0…E-A4, E-A6 · T-A3, T-A4, T-A6 · P-A6 (diğerleri —) |
| `K1` · `K2` · `K3` · `K4` | A1 · A2 · A4 · A6 | A1 · — · A6 · — |
| `C-COCUK` · `C-ALAN` · `C-ERISIM` | A2, A6 | A2 |
| `C-GUV` · `C-PERF` | A3, A6 | A3 |
| `C-YAS` | A5, A6 | A6 |

Denetim (biri tutmazsa FAIL, exit 1):
1. Beklenen kapıları TÜRETMEZ. Aktif (hat, asama)'ya ait en az bir Kapi kayitlari satırı var (istisna: aktif (prototip, A8)'de kapı satırı aranmaz, yalnız Cikis kriterleri); aktif (hat, asama)'ya ait her (Kapi, Hat, Asama) anahtarının SON satırı geçer değerde; hiçbiri `BEKLIYOR` değil. `-SkipUserGates` ile `K*` satırları atlanır (kullanıcı kapısından önceki ön denetim).
2. Geçer sonuçlu E/T/P/C satırlarında `Rapor` dosyası mevcut (`ISTISNA` satırı hariç).
3. Aktif (hat, asama) Cikis kriterlerinde `Durum` sütununa güvenmez: `Yol` (backtick soyulur) `-` değilse dosya var ve dolu (en az 5 boş olmayan satır; istisna `docs/kaynak/**`: yalnız var + boş değil, 0 bayttan büyük).
4. TASKS.md'de sabit başlıklı TÜM tablolar taranır: PENDING / RUNNING / NEEDS_REVIEW satırı varsa FAIL; DONE satırının Rapor hücresi dolu ve dosyası mevcut.
5. Aktif (hat, asama) = (urun, A6) ise (PHASE başlık değerleri) `docs/VERIFICATION.md` içinde `ENGEL: <n>` satırı var ve n = 0 (P/A6'da VERIFICATION aranmaz).
6. Görsel onay (`-SkipUserGates` yokken): aktif (hat, asama)'da `K3` ya da `K4` anahtarının SON satırı geçer değerdeyse (TERFI, DEVAM, YAYINLA, ISTISNA) Rapor hücresi `kullanici: gorsel onay` ile başlar (regex `^kullanici: gorsel onay(;|$)`); değilse FAIL. Geçirmeyen K3/K4 kararı denetlenmez.
7. Rapor yolu kuralı (Kapi kayitlari Rapor hücresi; TASKS DONE Rapor hücresi aynı): Rapor hücresi `;` ya da `,` ile parçalara ayrılır; parçalar kırpılır. `kullanici:` ile başlayan parça ve `-` yol değildir (ifade içinde `,` ve `/` KULLANILMAZ; ifadeyi `;` kapatır; geçer K3/K4'te `kullanici: gorsel onay` sonrası `;` ZORUNLU); ISTISNA satırında yol taranmaz, yine de yalnız proje içi yol yazılır; `/` ya da `\` içeren her parça dosya yoludur (eğik çizgisiz parça yol sayılmaz; boşlukla bölünmez; çoklu rapor yazarken `; ` kullan). Her yol çözüldüğünde projenin kendi klasörü (`projects/<ad>/`) içinde kalmalı ve dosya var olmalıdır; aksi FAIL (exit 1). Kanonik biçim `stamp.ps1` çıktısıdır (`projects/<ad>/reports/…`); proje köküne göreli biçim (`reports/…`, `docs/…`, `state/…`) ve proje klasörünün içini gösteren mutlak yol da kabul edilir. Merkez yolu (`team/…`), başka proje, `..` ile dışarı çıkan yol FAIL. Hangi kapıda rapor ZORUNLU olduğu 2. ve 4. kuralda (TASKS DONE satırında en az bir yol parçası şart).
Çıktı ≤10 satır: İLK satır `SONUC: PASS` ya da `SONUC: FAIL`, ardından nedenler birer satır. Exit: 0 = PASS · 1 = FAIL · 2 = biçim / değer hatası.

## Proje iskeleti (`projects/<ad>/`, kendi git deposu)
`state/` (PHASE, TASKS, TASKS-ARSIV, HANDOFF, INTAKE, LESSONS; lider, TASKS'ta planner istisnası) · `docs/` · `docs/adr/` · `docs/contracts/` · `docs/ux/wireframes/` (yalnız tam) · `reports/` · `reports/shots/` (isteğe bağlı; ad `<damga>-<konu>-<ekran>.png`) · `CLAUDE.md` · `run.ps1`.
`run.ps1` standart anahtarları: `-Build` · `-Up` · `-Down` · `-Test` · `-Check` (içerik doğrulama) · `-E2E` (smoke) · `-Logs`. İSTEĞE BAĞLI: `-Lan` (yalnız profil mobil, `-Up` ile; "Cihazda test" (b), kullanıcı ISTISNA'sıyla; varsayılan kapalı). Başarı exit 0.
Git etiketleri: `p-asama-A<N>` (P: A0-A4, A6, A8) / `u-asama-A<N>` (aşama çıkışı) · `prototip-v0` (terfi) · `vX.Y.Z` (yayın). A5 dilim checkpoint'leri ve P'de YINELE turunun A4 checkpoint'i etiketsiz (etiket ezilmez). Commit mesajı: `A<N>: <ozet>` (checkpoint denetler, uymazsa exit 1).
Sıra her zaman: lider PHASE / PROJECTS / proje HANDOFF (+ TASKS arşivi) günceller → SONRA coder checkpoint (A8 dahil). Çift etiket: terfide önce `p-asama-A8`, sonra ayrı checkpoint `prototip-v0` (RAFA-KALDIR'da yalnız `p-asama-A8`; tam sıra `hat-gecisleri.md`); A7'de önce `vX.Y.Z`, sonra `u-asama-A7` (Asama gecmisi Etiket = `u-asama-A7`). Proje durumu yalnız proje `HANDOFF.md`'sindedir; küresel `team/state/HANDOFF.md` proje bilgisi taşımaz.

## Scriptler (`team/scripts/`, PS 5.1, ASCII mesaj, exit 0 = başarı)
| Script | Çalıştıran | Parametreler |
|---|---|---|
| `stamp.ps1` (mevcut) | her ajan kendi raporu için (tester'a devredilmez) | `-Role <rol> -Topic <konu> (-Project <ad> | -Merkez) [-Round <N>]` → yol basar, dosya yaratmaz; proje işinde `-Project` ZORUNLU, merkez bakımında `-Merkez`; ikisi de yoksa hata, yol yok. `agy-run.ps1` aynı çifti kullanır (tam olarak biri) |
| `new-project.ps1` | coder | `-Name <ad> [-Hat <prototip/urun>] [-Mod <hafif/orta/tam>] [-Tur] [-Kitle] [-Profil]` (ayrıntı aşağıda) |
| `phase-gate.ps1` | tester | `-Project <ad> [-SkipUserGates]` (kurallar yukarıda) |
| `checkpoint.ps1` | coder (tek parça, sırayla) | `-Project <ad> -Message "<mesaj>" [-Tag <etiket>]` |
| `list-reports.ps1` (mevcut); `budget.ps1`, `agy-run.ps1` (mevcut) | tester / critic; kullanıcı / tester | `[-Project <ad>]`; kendi skill dosyalarında |

`new-project.ps1`: ad kuralı denetlenir; klasör varsa exit 1. Varsayılan `-Hat prototip`; `urun` ise `-Mod` zorunlu, `prototip` ile `-Mod` verilirse exit 1. `-Tur -Kitle -Profil` isteğe bağlı: verilmezse `?`, verilirse izinli değerlerle doğrulanır (exit 1). Yalnız ilk `##`'den önceki PHASE satırlarını doldurur: `asama: A0`, `durum: CALISIYOR`, `mod` = verilen ya da `-`, `kosullu: yok`. Projeyi geçici klasörde kurar (klasörler, 5 şablon (PHASE, TASKS, HANDOFF, LESSONS, PROJECT_CLAUDE), boş `TASKS-ARSIV.md` ve `INTAKE.md`, `git init` + ilk commit), başarılıysa hedef ada taşır; hata olursa geçici klasörü siler. `projects/PROJECTS.md`'ye satır ekler; `Aktif proje:` satırına ve TASKS ilk satırına dokunmaz.
`checkpoint.ps1` ve `new-project.ps1` git'i yalnız `projects/<ad>/` içinde çalıştırır; push / uzak depo / ekip kökünde git yok. Paralel ajanlar commit atmaz.

## Ajan yetkileri (komut koşma)
`run.ps1 -Check` / `-Test` / `-E2E` → tester; writer yalnız kendi içeriği için `-Check` koşabilir. learning-designer, game-designer komut koşmaz (Bash yalnız `stamp.ps1`).
tester phase-gate çıktısını AYNEN aktarır (≤10 satır) + `RAPOR:` satırı; yorum/analiz yapmaz (gerekirse critic ya da writer). `NOT RUN` ayrı sayılır; dönüşte `NOT RUN:` ve `KAPI:` satırları geçerli alanlardır. Ürünü playtest için playtester başlatır: önce çalışıp çalışmadığına bakar, çalışmıyorsa `run.ps1 -Up`, iş bitince YALNIZ kendi başlattığını `-Down` (`Oturum: acik-birak` ise açık bırakır, bkz. Playtest bölümü); tester E2E için başlattığını kendisi durdurur; ux-designer ürünü başlatmaz.
planner Write kapsamı = sahiplik tablosundaki planner satırları + TASKS ilk tablo satırları. Üç tasarımcı ajan Ü/hafif için `docs/DESIGN.md` hedefini anar. Skill aracı olmayan ajan (writer dahil) skill'i uygulamadan önce `<USERPROFILE>\.claude\skills\<skill-adı>\SKILL.md` dosyasını Read ile okur.

## Roller ve rapor adı
Ajanlar (`.claude/agents/<rol>.md`): `researcher` · `planner` · `coder` · `writer` · `critic` · `tester` · `game-designer` · `learning-designer` · `ux-designer` · `playtester`. Ayrıca `gemini` (antigravity skill, yalnız plan modu; dosya yazmaz). Lider bir ajan değildir (`team-lead` skill).
Rapor adı: `<damga>-<rol>-<konu>[-t<N>].md`; damga `yyyyMMdd-HHmm` (`^\d{8}-\d{4}$`); `-t<N>` yalnız 2. ve sonraki turlarda. Konum: proje işinde `projects/<ad>/reports/` (`-Project <ad>`); merkez bakımında `team/reports/` (`-Merkez`).

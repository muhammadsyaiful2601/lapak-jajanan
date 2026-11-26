# Pemindaian & Pemetaan Branch — Lapak Jajanan

**Tanggal:** 26 November 2026
**Status:** SCAN SAJA. **Belum ada merge, commit, push, checkout, reset, maupun stash yang dilakukan** terhadap project ini.
**Tujuan:** Menjadi peta kondisi repository sebelum perintah penggabungan branch dikeluarkan.

---

## 1. Ringkasan temuan

| Item | Hasil pemindaian |
| :--- | :--- |
| Repo utama | `D:\coding kuliah\Lapak jajanan` → remote `https://github.com/muhammadsyaiful2601/lapak-jajanan.git` |
| Branch aktif | `pbl`, tracking `origin/pbl`, **tidak ada ahead/behind** |
| HEAD | `202d041` — "first commit: PRD dan fondasi monorepo Lapak Jajanan (Supabase, Flutter, web QR)" |
| Branch remote | 6 branch: `arum`, `hafiz`, `pbl`, `rahma`, `syaiful`, `tika` — **semuanya masih di `202d041`** |
| Arti penting | Secara Git, **belum ada commit baru di keenam branch remote**, jadi belum ada perubahan yang bisa di-merge dari remote. |
| Pekerjaan nyata | Ada di **working tree repo utama yang belum di-commit**: 13 file modified + 5 path untracked (slicing UI web pelanggan). |
| Repo lain | `D:\coding kuliah\pbl\pbl_mobile` → remote `pbl_mobile.git` (**404 / tidak dapat diakses**), branch `syaiful`, HEAD `78235a0`, **sejarah Git terpisah** dari repo utama. |
| Hubungan kedua repo | Tidak ada objek commit bersama: `202d041` tidak dikenal di `pbl_mobile`, `78235a0` tidak dikenal di repo utama. Menggabungkan keduanya bukan `git merge` biasa, melainkan penggabungan dua histori (mis. `git merge --allow-unrelated-histories` atau ambil file selektif). |

---

## 2. Kondisi kerja repo utama (`pbl`)

Status: `## pbl...origin/pbl`. **Tidak ada perubahan ter-stage**; semua perubahan masih di working tree.

### 2.1 File modified (13)

| File | Garis (+/−) | Catatan |
| :--- | ---: | :--- |
| `README.md` | +6 / −3 | Dokumentasi env `PUBLISHABLE_KEY`, catatan slicing belum di-push |
| `docs/02_checklist_minggu1.md` | +1 | Checklist slicing keranjang |
| `web_qr/README.md` | +9 / −2 | Dokumentasi halaman & slicing UI |
| `web_qr/index.html` | +5 / −3 | `lang="id"`, title, meta description, theme color |
| `web_qr/src/components/Layout.tsx` | +63 / −13 | Header baru, ikon SVG, badge keranjang |
| `web_qr/src/components/SetupNotice.tsx` | +2 / −4 | Teks mode preview |
| `web_qr/src/context/CartContext.tsx` | +11 / −12 | Inisialisasi keranjang dari `localStorage` via `loadCart` |
| `web_qr/src/index.css` | +1030 / −98 | Tema krem–cokelat, katalog, sheet, keranjang, checkout bar |
| `web_qr/src/lib/supabase.ts` | +1 / −1 | `Rp15.000` (tanpa spasi) |
| `web_qr/src/pages/CartPage.tsx` | +413 / −37 | Keranjang lengkap + ubah kustomisasi + upsell |
| `web_qr/src/pages/CheckoutPage.tsx` | +7 / −3 | PB1 10% masuk `total_amount` |
| `web_qr/src/pages/MenuPage.tsx` | +162 / −116 | Katalog, pencarian, filter, urutan, skeleton, mock fallback |
| `web_qr/src/types/index.ts` | +26 | `MenuTone`, `CartMenuSnapshot`, `CartTopping`, field varian/topping di `CartItem` |

### 2.2 Path untracked (5)

- `docs/03_catatan_pekerjaan.md` — catatan lengkap pekerjaan UI (mode preview, PB1, verifikasi, status Git).
- `web_qr/src/components/catalog/MenuCard.tsx`
- `web_qr/src/components/catalog/MenuDetailSheet.tsx`
- `web_qr/src/data/mockCatalog.ts`
- `web_qr/src/lib/pricing.ts`

Total perubahan: **1736 insertions, 292 deletions** pada 13 file terlacak + 5 path baru.

> **Risiko sebelum merge:** selama perubahan ini belum di-commit/di-stash, operasi `git merge`, `git checkout <branch>`, `git reset --hard`, atau `git clean` dapat menimpa/menghilangkan pekerjaan UI ini. Jangan jalankan perintah tersebut sebelum persetujuan.

---

## 3. Peta branch remote (`lapak-jajanan.git`)

Hasil `git ls-remote --heads origin` (semua SHA sama persis):

| Branch | Commit |
| :--- | :--- |
| `arum` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |
| `hafiz` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |
| `pbl` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |
| `rahma` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |
| `syaiful` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |
| `tika` | `202d0413c45db4bc7d2f0c82fa436a1f6b8b3ca8` |

Ref lokal yang tersimpan: `refs/heads/pbl` dan `refs/remotes/origin/pbl` saja. Branch `arum/hafiz/rahma/syaiful/tika` **belum di-fetch ke lokal**. Reflog juga hanya mencatat commit awal + rename `main` → `pbl`; tidak ada stash di repo utama.

---

## 4. Repo kedua (`pbl_mobile`) — sumber branch lain yang perlu diwaspadai

| Item | Nilai |
| :--- | :--- |
| Path | `D:\coding kuliah\pbl\pbl_mobile` |
| Remote | `https://github.com/muhammadsyaiful2601/pbl_mobile.git` → `repository not found` (404) |
| Branch lokal | `pbl`, `syaiful` (aktif: `syaiful`), keduanya di `78235a0` |
| HEAD | `78235a0` — "feat: setup awal monorepo (mobile_app Flutter + web_qr + backend_functions)" |
| Commit sebelumnya | `1922478` — "first commit" |
| Stash | 2 buah (`stash@{0}`, `stash@{1}`), keduanya hasil `cline restore transaction`, isinya snapshot penghapusan |
| Checkpoint lain | `f2c578a`, `11d8287`, `b56f45a` (cline checkpoint) + commit index/stash terkait; semuanya merekam kondisi penghapusan yang sama |
| Working tree | **72 file ter-stage sebagai terhapus (`D`) + 1 file `AD`** (PRD ditambahkan ke index lalu dihapus dari working tree). Total 73 entri: 268 insertions, 1464 deletions. |
| Sisa file fisik | Hanya artefak build/ignored (`.dart_tool/`, `build/`); file sumber sudah tidak ada di disk. |

**PRD:** blob `product_requirements_document_prd_lengkap_lapak_jajanan.md` yang tersimpan di index `pbl_mobile` **identik byte-for-byte** dengan PRD di repo utama (`c0744498061f9567547e0796e7d6cc04d5f2516a`). Jadi tidak perlu mengambil PRD dari sana.

---

## 5. Analisis tumpang tindih file (potensi konflik)

Perbandingan tree `HEAD` repo utama (115 file) vs `HEAD` `pbl_mobile` (72 file):

- **61 path sama persis** (hash blob identik) → tanpa konflik teks jika kedua tree digabung.
- **54 path hanya ada di repo utama** — terutama `database/*.sql`, `docs/01–02`, seluruh `web_qr/src/*.tsx` + konfigurasi TS/Vite, dan `mobile_app/lib/features/**`, `mobile_app/lib/core/**` (scaffold lengkap yang sudah dikembangkan).
- **11 path hanya ada di `pbl_mobile`**:

  | Path | Catatan |
  | :--- | :--- |
  | `backend_functions/README.md` | Dokumentasi edge function; belum ada di repo utama |
  | `prd_pembagian_tugas_tim_pbl_opsi_1_formasi_utama_6_anggota.md` | Dokumen pembagian tugas tim |
  | `mobile_app/web/**` (favicon, 4 ikon, `index.html`, `manifest.json`) | Aset web Flutter |
  | `mobile_app/android/app/src/main/kotlin/com/pbl/umkm/mobile_app/MainActivity.kt` | Paket berbeda dengan repo utama |
  | `web_qr/src/main.js` | Entry JS lama; repo utama memakai `main.tsx` + `App.tsx` |

### Titik rawan konflik saat penggabungan nanti

1. **Kasus nama file:** `README.md` (repo utama) vs `Readme.md` (`pbl_mobile`). Di Windows keduanya dianggap sama → bentrok penimpaan.
2. **`MainActivity.kt`:** dua path berbeda dengan package `com.lapakjajanan.lapak_jajanan` vs `com.pbl.umkm`. Perlu diputuskan packagemana yang dipakai (repo utama memakai namespace Lapak Jajanan).
3. **Entry web:** `main.js` vs `main.tsx`/`App.tsx` — jangan mengambil `main.js` jika stack TypeScript dipertahankan.
4. **Working tree kotor di repo utama** — semua perubahan UI harus diamankan lebih dulu (commit atau stash) sebelum operasi Git apa pun.
5. **Histori tidak berkaitan** — merge lintas repo memerlukan strategi eksplisit; bukan `git pull`/`git merge` standar.

---

## 6. Keputusan teknis yang masih perlu dikonfirmasi saat merge

Berdasarkan `docs/03_catatan_pekerjaan.md`:

- **PB1 Resto 10%** tidak tertulis di PRD, tetapi dipakai di `pricing.ts` dan checkout. Perlu konfirmasi apakah dipertahankan.
- **Varian ukuran Reguler/Jumbo** masih UI-only, belum ada di skema Supabase (`database_schema.sql`).
- **Nama env** berubah dari `VITE_SUPABASE_ANON_KEY` menjadi `VITE_SUPABASE_PUBLISHABLE_KEY` (`README.md`, `web_qr/README.md`, `.env.example`). Pastikan semua branch memakai nama yang sama.
- **Format rupiah** berubah dari `Rp 15.000` menjadi `Rp15.000`; komponen lain yang memformat manual perlu diselaraskan.
- **Snapshot menu di `CartItem`** adalah struktur baru; branch lain yang mengubah `types/index.ts` atau `CartContext.tsx` berpotensi konflik logik.
- Mode preview memakai `mockCatalog.ts`; integrasi Supabase asli belum dilakukan.

---

## 7. Yang sudah diverifikasi sebelumnya (bukan ulangan scan ini)

Menurut catatan pekerjaan: `npm run lint` bersih, `npm run build` sukses, alur katalog/topping/keranjang/checkout konsisten, tanpa error console. **Tidak dijalankan ulang** pada sesi scan ini.

File yang sengaja tidak disentuh: `web_qr/node_modules/`, `web_qr/dist/`, `mobile_app/.dart_tool/`, `mobile_app/build/`, `mobile_app/android/local.properties`, dan `.env` (semuanya sudah diabaikan `.gitignore`).

---

## 8. Rencana saat perintah merge diberikan

1. Amankan dulu perubahan UI di repo utama (commit atau stash — **butuh konfirmasi**).
2. `git fetch --all --prune` lalu cek ulang `git log --all --graph` dan `git diff` antarbranch; jangan asumsikan branch remote masih kosong.
3. Tentukan target branch integrasi dan sumber mana saja yang benar-benar ingin digabung (branch `arum/hafiz/rahma/syaiful/tika` dan/atau file dari `pbl_mobile`).
4. Pilih strategi: `merge` untuk histori yang berkaitan; `merge --allow-unrelated-histories` atau cherry-pick/ekstrak file untuk `pbl_mobile`.
5. Selesaikan konflik dengan prioritas: kode repo utama + pekerjaan UI yang sudah ada sebagai baseline; ambil tambahan dari branch lain hanya untuk file yang memang belum ada.
6. Validasi: `git diff --check`, build/lint web, dan `flutter analyze` bila modul Flutter ikut berubah.
7. Perbarui `README.md`, `docs/02_checklist_minggu1.md`, dan tulis catatan resolusi konflik sebelum push.

---

**Catatan penutup:** Dokumen ini hanya hasil pemindaian. Sampai ada perintah lanjutan, kondisi repository dibiarkan apa adanya.

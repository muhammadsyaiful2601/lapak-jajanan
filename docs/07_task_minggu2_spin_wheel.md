# Rencana Minggu 2 — Task Spin Wheel (6 Anggota)

**Tanggal:** 27 November 2026
**Branch utama:** `pbl` (pemegang: Muhammad Syaiful)
**Cakupan minggu 2 (PRD/checklist):** Katalog, kategori, topping, keranjang, checkout (web) + kelola menu admin (Flutter). FR terkait: **FR-P01–P05, FR-A02–A05**, plus penyelesaian gap minggu 1 (**GPS otomatis FR-P06, tracking realtime FR-P08**).

Dokumen ini dibuat agar tim bisa **spin wheel** untuk membagi 6 task di bawah. Setiap anggota lalu memberi prompt ke AI agent-nya sendiri untuk mengeksekusi task yang didapat.

---

## 0. Aturan kerja (wajib dibaca semua anggota & AI agent)

1. **Branch:** kerja hanya di branch milik sendiri. Jangan commit langsung ke `pbl`.
   - Anggota & branch: `syaiful`, `tika`, `arum`, `rahma`, `hafiz`, `widia` (jika belum ada, buat `git checkout -b widia origin/pbl`).
2. **Sebelum coding:** `git fetch --all --prune` lalu `git checkout <branch>` dan `git pull`.
3. **Lingkup:** kerjakan **hanya task yang ditugaskan**. Jangan menyentuh file task orang lain agar konflik minim.
4. **Validasi wajib sebelum commit:**
   - Web: `npm run lint` dan `npm run build` di `web_qr/`.
   - Flutter: `flutter analyze` di `mobile_app/` (minimal 0 error).
5. **Commit message format:** `feat(<scope>): <deskripsi singkat>` (contoh: `feat(web): gps otomatis di checkout`).
6. **Push & PR:** `git push -u origin <branch>`, lalu buat Pull Request ke `pbl`. Pemegang `pbl` (Syaiful) yang melakukan merge & resolusi konflik.
7. **Jangan commit:** `.env`, `local.properties`, `node_modules/`, `dist/`, `.dart_tool/`, `build/`.

> **Prompt dasar untuk AI agent (salin ke agent masing-masing):**
> "Baca `product_requirements_document_prd_lengkap_lapak_jajanan.md` dan `docs/07_task_minggu2_spin_wheel.md`. Kerjakan HANYA Task [ID] yang ditugaskan. Jangan ubah file di luar daftar file task. Setelah selesai jalankan validasi (lint/build/analyze), lalu commit dengan message yang ditentukan dan push ke branch saya. Jangan merge ke pbl."

---

## 1. Hasil Spin Wheel (isi setelah spin)

| No | Task ID | Judul singkat | PIC (anggota) | Branch | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | T1 | Web: GPS otomatis + tracking realtime | (isi) | (isi) | ☐ |
| 2 | T2 | Web: Integrasi Supabase asli (ganti mock) | (isi) | (isi) | ☐ |
| 3 | T3 | Mobile Admin: Katalog menu CRUD | (isi) | (isi) | ☐ |
| 4 | T4 | Mobile Admin: Kategori & topping/variasi | (isi) | (isi) | ☐ |
| 5 | T5 | Mobile: Supabase service & toggle stok realtime | (isi) | (isi) | ☐ |
| 6 | T6 | Mobile Admin: Lokasi, tarif ongkir, master ojek | (isi) | (isi) | ☐ |
| 7 | T7 | **Web: port UI/UX customer dari mobile (checkout/tracking/riwayat)** | Tika | `tika` | ☐ |

> **Catatan penugasan Tika:** Tika awalnya membuat halaman customer di **mobile** (Flutter), padahal tugasnya web. Agar tidak bingung, dia dialihkan ke **T7** — memindahkan UI/UX hasil buatannya ke **web** (`web_qr`). Kode mobile customer **dihapus hanya setelah web selesai & teruji**. Detail & acceptance criteria ada di `docs/09_porting_customer_mobile_ke_web.md`.

---

## 2. Detail Task

### T1 — Web: GPS Otomatis + Tracking Realtime
- **FR:** FR-P06 (GPS), FR-P08 (tracking real-time)
- **Deskripsi:** Tangkap koordinat GPS otomatis saat checkout (Delivery) dengan `navigator.geolocation` + izin browser, simpan `delivery_lat`/`delivery_lng` ke tabel `orders`. Ubah `TrackingPage` dari fetch sekali menjadi subscription Supabase Realtime agar status berubah tanpa reload. Tampilkan info ojek bila ada.
- **File yang boleh diubah:** `web_qr/src/pages/CheckoutPage.tsx`, `web_qr/src/pages/TrackingPage.tsx`, `web_qr/src/lib/location.ts`, `web_qr/src/types/index.ts`.
- **Acceptance criteria:**
  - Koordinat tersimpan di `orders.delivery_lat/lng` (atau null jika ditolak izin, dengan fallback input manual).
  - Tracking page update status otomatis saat DB berubah.
  - `npm run lint` & `npm run build` lulus.
- **Commit:** `feat(web): gps otomatis dan tracking realtime`
- **Prompt AI agent:**
  > "Implementasikan T1 dari docs/07_task_minggu2_spin_wheel.md. Di CheckoutPage tambahkan capture GPS via navigator.geolocation dengan handling izin (granted/denied) dan simpan delivery_lat/delivery_lng ke insert orders. Di TrackingPage ganti fetch sekali menjadi Supabase realtime subscription pada orders by ticket_code, dan tampilkan info ojek jika field ojek tersedia. Pertahankan UI existing. Jalankan npm run lint && npm run build, commit 'feat(web): gps otomatis dan tracking realtime', push."

### T2 — Web: Integrasi Supabase Asli (ganti mock dengan data real + fallback)
- **FR:** FR-P02, FR-P03, FR-P05
- **Deskripsi:** Pastikan katalog, kategori, topping, dan tarif ongkir diambil dari Supabase; fallback ke `mockCatalog.ts` jika env belum diisi atau query gagal. Tambahkan loading skeleton konsisten dan empty state. Bersihkan duplikasi data hardcode.
- **File yang boleh diubah:** `web_qr/src/pages/MenuPage.tsx`, `web_qr/src/pages/CartPage.tsx`, `web_qr/src/lib/supabase.ts`, `web_qr/src/data/mockCatalog.ts`, `web_qr/src/types/index.ts`.
- **Acceptance criteria:**
  - Dengan `.env` valid → data dari DB; tanpa `.env` → mode preview (mock).
  - Tidak ada error console; lint & build lulus.
- **Commit:** `feat(web): integrasi supabase asli dengan fallback mock`
- **Prompt AI agent:**
  > "Implementasikan T2 dari docs/07_task_minggu2_spin_wheel.md. Pastikan MenuPage/CartPage mengambil kategori, menu, topping, shipping_rates dari Supabase dengan fallback ke mockCatalog bila env/query gagal. Tambahkan loading skeleton dan empty state konsisten. Jalankan npm run lint && npm run build, commit 'feat(web): integrasi supabase asli dengan fallback mock', push."

### T3 — Mobile Admin: Katalog Menu CRUD
- **FR:** FR-A02
- **Deskripsi:** Ganti `CatalogPage` (placeholder) dengan UI daftar menu + form tambah/edit/hapus (nama, deskripsi, harga, kategori, image_url, is_available) terhubung tabel `menus` Supabase.
- **File yang boleh diubah:** `mobile_app/lib/features/admin/catalog_page.dart` (rewrite), boleh tambah widget di `mobile_app/lib/features/admin/widgets/`.
- **Acceptance criteria:** CRUD berfungsi online; error handling; `flutter analyze` 0 error.
- **Commit:** `feat(admin): katalog menu crud`
- **Prompt AI agent:**
  > "Implementasikan T3 dari docs/07_task_minggu2_spin_wheel.md. Rewrite catalog_page.dart menjadi UI CRUD menu (list + form tambah/edit/hapus) terhubung Supabase tabel menus. Tambahkan loading/error state. Jangan ubah file lain. Jalankan flutter analyze, commit 'feat(admin): katalog menu crud', push."

### T4 — Mobile Admin: Kategori & Topping/Variasi
- **FR:** FR-A03, FR-A04
- **Deskripsi:** Buat halaman kelola kategori (CRUD) dan kelola topping/variasi per menu (`menu_toppings`), terhubung Supabase. Daftarkan route di `app_router.dart`.
- **File yang boleh diubah:** tambah `mobile_app/lib/features/admin/categories_page.dart`, `mobile_app/lib/features/admin/toppings_page.dart`; edit minimal `app_router.dart` (tambah route saja).
- **Acceptance criteria:** CRUD kategori & topping berfungsi; route terdaftar; analyze 0 error.
- **Commit:** `feat(admin): kategori dan topping crud`
- **Prompt AI agent:**
  > "Implementasikan T4 dari docs/07_task_minggu2_spin_wheel.md. Buat categories_page.dart dan toppings_page.dart (CRUD) terhubung Supabase (categories, menu_toppings). Daftarkan route di app_router.dart (tambah route, jangan hapus yang ada). Jalankan flutter analyze, commit 'feat(admin): kategori dan topping crud', push."

### T5 — Mobile: Supabase Service & Toggle Stok Realtime
- **FR:** FR-A05 (toggle stok), fondasi untuk T3/T4/T6
- **Deskripsi:** Implementasikan `supabase_service.dart` (init dari `--dart-define`, fetch menus/categories/toppings/shipping_rates/ojek_drivers, realtime subscription pada `menus`), plus toggle `is_available` yang update DB dan broadcast realtime. Sediakan API yang dipakai T3/T4/T6.
- **File yang boleh diubah:** `mobile_app/lib/data/services/supabase_service.dart`, `mobile_app/lib/core/config/app_config.dart`. (Boleh tambah model di `mobile_app/lib/data/models/`.)
- **Acceptance criteria:** Service reusable; toggle stok update DB + realtime; analyze 0 error.
- **Dependensi:** T3/T4/T6 sebaiknya menunggu T5 atau menyepakati interface. Jika paralel, T5 mendefinisikan interface, yang lain mock dulu.
- **Commit:** `feat(core): supabase service dan toggle stok realtime`
- **Prompt AI agent:**
  > "Implementasikan T5 dari docs/07_task_minggu2_spin_wheel.md. Implementasi supabase_service.dart dengan init dari --dart-define, fungsi fetch untuk menus/categories/toppings/shipping_rates/ojek_drivers, realtime subscription menus, dan toggle is_available yang update DB + broadcast. Sediakan API jelas untuk dipakai task lain. Jalankan flutter analyze, commit 'feat(core): supabase service dan toggle stok realtime', push."

### T6 — Mobile Admin: Lokasi, Tarif Ongkir, Master Ojek
- **FR:** FR-A16, FR-A17
- **Deskripsi:** UI kelola lokasi operasional (jam buka/tutup, status buka), zona tarif ongkir (`shipping_rates`), dan master ojek (`ojek_drivers`: nama, WA, plat, online/offline), terhubung Supabase.
- **File yang boleh diubah:** tambah `mobile_app/lib/features/admin/locations_page.dart`, `shipping_rates_page.dart`, `drivers_page.dart`; edit minimal `app_router.dart` (tambah route saja).
- **Acceptance criteria:** CRUD/toggle berfungsi; route terdaftar; analyze 0 error.
- **Commit:** `feat(admin): lokasi, tarif ongkir, master ojek`
- **Prompt AI agent:**
  > "Implementasikan T6 dari docs/07_task_minggu2_spin_wheel.md. Buat locations_page.dart, shipping_rates_page.dart, drivers_page.dart (CRUD/toggle) terhubung Supabase (locations, shipping_rates, ojek_drivers). Daftarkan route di app_router.dart (tambah route, jangan hapus yang ada). Jalankan flutter analyze, commit 'feat(admin): lokasi, tarif ongkir, master ojek', push."

---

### T7 — Web: Port UI/UX Customer dari Mobile (khusus Tika)
- **FR:** FR-P06–P10 (lengkapi checkout, tracking, riwayat web)
- **Deskripsi:** Pindahkan UI/UX & fitur halaman customer yang sudah dibuat di mobile (`mobile_app/lib/features/customer/`) ke web (`web_qr`), pertahankan integrasi Supabase. Setelah web selesai & teruji, kode mobile customer dihapus.
- **Detail & acceptance:** lihat `docs/09_porting_customer_mobile_ke_web.md`.
- **File yang boleh diubah:** `web_qr/src/pages/CheckoutPage.tsx`, `TrackingPage.tsx`, `HistoryPage.tsx`, `web_qr/src/index.css`, `web_qr/src/lib/*`, `web_qr/src/types/index.ts`.
- **Jangan** sentuh `mobile_app/` sampai web lolos uji.
- **Commit:** `feat(web): port ui/ux customer dari mobile`
- **Prompt AI agent:**
  > "Baca docs/09_porting_customer_mobile_ke_web.md. Pindahkan UI/UX halaman customer (checkout, tracking, riwayat) dari mobile_app/lib/features/customer ke web_qr, pertahankan integrasi Supabase. Kerjakan web saja, jangan ubah mobile_app. Setelah selesai jalankan npm run lint && npm run build, commit 'feat(web): port ui/ux customer dari mobile', push."

## 3. Urutan merge (pemegang `pbl`)

1. T5 (Supabase service) sebaiknya merge duluan karena fondasi T3/T4/T6.
2. Lalu merge T3, T4, T6 (admin) — resolusi konflik di `app_router.dart` dengan **menggabungkan route**, bukan menimpa.
3. Terakhir merge T1, T2 (web) — konflik minimal karena file berbeda.
4. Setelah semua merge: jalankan `npm run lint && npm run build` (web) dan `flutter analyze` (mobile), lalu push `pbl`.

---

## 4. Catatan dependensi antar task

- T3/T4/T6 bergantung pada T5 untuk akses data. Jika paralel, sepakati interface `SupabaseService` di awal (nama method + return type) agar tidak konflik.
- T1 (GPS/tracking) dan T2 (integrasi Supabase web) menyentuh `CheckoutPage.tsx`/`MenuPage.tsx` → hindari edit baris yang sama; jika konflik, gabungkan (GPS + fetch real).
- Jangan ada yang mengedit `pubspec.yaml`/`package.json` tanpa koordinasi; jika perlu dependency baru, sebutkan di PR.

---

**Catatan:** Dokumen ini hanya rencana. Eksekusi dilakukan oleh masing-masing anggota dengan AI agent-nya. Pemegang `pbl` (Syaiful) yang melakukan merge akhir.
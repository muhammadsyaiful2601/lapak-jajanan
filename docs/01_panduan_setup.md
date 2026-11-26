# Panduan Setup Lapak Jajanan

Panduan ini untuk menyiapkan seluruh lingkungan kerja (Git, Supabase, Flutter, dan Web) sesuai PRD.

## 1. Prasyarat

| Tool | Versi terpasang di mesin ini | Fungsi |
| :--- | :--- | :--- |
| Git | 2.55 | Version control |
| Flutter | 3.50.1 (stable) | Aplikasi Admin & Owner |
| Dart | 3.14.0 | Bahasa Flutter |
| Node.js | 26.12.1 | Web QR (Vite) |
| npm | 11.20.0 | Package manager web |
| Chrome | 158 | Debug web & Flutter web |

Flutter sudah lolos `flutter doctor` untuk Android, Chrome, dan jaringan. Satu-satunya catatan: **Visual Studio belum terpasang**, jadi build Desktop Windows tidak tersedia (tidak dibutuhkan untuk PRD ini).

## 2. Git & GitHub

Remote: `https://github.com/muhammadsyaiful2601/lapak-jajanan.git`
Branch kerja: `pbl`.

```bash
git init
git add .
git commit -m "first commit: PRD dan fondasi proyek"
git branch -M pbl
git remote add origin https://github.com/muhammadsyaiful2601/lapak-jajanan.git
git push -u origin pbl
```

> Perintah awal `git branch -M main` + `git push ... pbl`tidak cocok. Karena remote masih kosong, branch lokal langsung dinamakan `pbl`.

## 3. Supabase (backend)

1. Buat project baru di https://supabase.com/dashboard (pilih region terdekat, mis. Singapore).
2. Buka **SQL Editor → New query**, jalankan file ini **berurutan**:
   1. `database/database_schema.sql` — 8 tabel: `locations`, `categories`, `menus`, `menu_toppings`, `shipping_rates`, `ojek_drivers`, `orders`, `order_items`.
   2. `database/rls_policies.sql` — kebijakan akses & aktifkan Realtime.
   3. `database/seed.sql` — data contoh (opsional untuk development).
3. Buka **Project Settings → API**, salin `Project URL` dan `publishable key` (project lama bisa pakai `anon key`).
4. Buat Storage bucket `menu-images` (public) lewat **Storage → New bucket** untuk foto menu.

Catatan keamanan:
- Untuk prototyping PBL, anon key dipakai bersama RLS. Jangan pernah menaruh `service_role key` di aplikasi.
- Jika later ingin login admin/owner, aktifkan Supabase Auth lalu ganti policy `admin_write`/`owner_read` dengan pengecekan `auth.jwt()`.

## 4. Web QR (`web_qr/`)

```bash
cd web_qr
npm install
cp .env.example .env
# isi VITE_SUPABASE_URL dan VITE_SUPABASE_PUBLISHABLE_KEY
npm run dev
```

Buka `http://localhost:5173/?location=<uuid-lokasi>` — parameter `location` dipakai untuk mendeteksi Lokasi Utama / Pasar Kuliner dari QR code (FR-P01). Tanpa `.env`, halaman tetap berjalan dalam mode preview.

Perintah lain:

```bash
npm run build     # build produksi ke web_qr/dist
npm run preview   # preview build produksi
npm run lint      # oxlint
```

## 5. Flutter (`mobile_app/`)

```bash
cd mobile_app
flutter pub get
flutter doctor

flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
```

Dependency utama yang sudah ditambahkan: `material_ui` (pengganti `flutter/material.dart` di Flutter 3.50), `supabase_flutter`, `go_router`, `flutter_riverpod`, `intl`, `url_launcher`, `shared_preferences`.

Struktur kode:

```text
mobile_app/lib/
├── main.dart              # entrypoint + inisialisasi Supabase
├── app.dart               # MaterialApp + router
├── core/
│   ├── config/app_config.dart   # baca --dart-define
│   ├── router/app_router.dart   # rute admin / owner / kasir
│   └── theme/app_theme.dart
└── features/
    ├── admin/             # dashboard, menu, pesanan, ojek, lokasi
    ├── pos/               # kasir walk-in
    ├── owner/             # laporan & monitoring
    └── shared/            # widget & model bersama
```

> Menu di Flutter ditampilkan dalam bentuk placeholder di minggu 1. Implementasi UI penuh mengikuti FR-A01 sampai FR-O10.

## 6. Troubleshooting

| Masalah | Solusi |
| :--- | :--- |
| `flutter doctor` complain Android license | `flutter doctor --android-licenses` |
| Web blank setelah build | Cek `.env` dan console browser, pastikan anon key benar |
| `SupabaseException: Supabase URL is required` | Tambahkan `--dart-define=SUPABASE_URL=...` saat `flutter run` |
| Push Git diminta login | Gunakan Personal Access Token sebagai password / siapkan GitHub Credential Manager |
| Realtime tidak jalan | Pastikan tabel `orders` & `menus` sudah masuk `supabase_realtime` publication (lihat `rls_policies.sql`) |

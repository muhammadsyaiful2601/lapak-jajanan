# Lapak Jajanan — Sistem Pemesanan & Kasir Hybrid

Monorepo PBL untuk **Lapak Jajanan**: pemesanan pelanggan lewat web QR, kasir walk-in, dan dashboard admin/owner Flutter, dengan **Supabase** sebagai backend.

Dokumen utama: [`product_requirements_document_prd_lengkap_lapak_jajanan.md`](product_requirements_document_prd_lengkap_lapak_jajanan.md) (PRD final, baseline pengembangan).

## Struktur repository

```text
Lapak jajanan/
├── product_requirements_document_prd_lengkap_lapak_jajanan.md  # PRD (minggu 1)
├── docs/
│   ├── 01_panduan_setup.md        # Panduan instalasi & konfigurasi
│   ├── 02_checklist_minggu1.md    # Deliverable minggu 1
│   └── 03_catatan_pekerjaan.md    # Catatan slicing UI web (belum di-push)
├── database/
│   ├── database_schema.sql        # Skema Supabase (8 tabel)
│   ├── rls_policies.sql           # Row Level Security + Realtime
│   └── seed.sql                   # Data contoh untuk development
├── mobile_app/                    # Flutter: Admin, Kasir POS, Owner
└── web_qr/                        # React + Vite: katalog & pemesanan pelanggan
```

Pemetaan aktor ke modul:

| Aktor | Modul | Teknologi |
| :--- | :--- | :--- |
| Pelanggan | `web_qr/` | React + TypeScript + Vite + Supabase JS |
| Admin (kasir, pesanan, ojek) | `mobile_app/lib/features/admin/` | Flutter + Supabase Flutter |
| Owner (laporan & monitoring) | `mobile_app/lib/features/owner/` | Flutter + Supabase Flutter |

## Quick start

### 1. Backend (Supabase)
1. Buat project di https://supabase.com/dashboard.
2. Jalankan berurutan di **SQL Editor**: `database/database_schema.sql`, `database/rls_policies.sql`, `database/seed.sql`.
3. Salin `Project URL` dan `publishable key` (project lama bisa memakai `anon key`).

### 2. Web pelanggan
```bash
cd web_qr
npm install
cp .env.example .env   # isi VITE_SUPABASE_URL & VITE_SUPABASE_PUBLISHABLE_KEY
npm run dev
```

### 3. Aplikasi Flutter
```bash
cd mobile_app
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
```

Cek kesehatan lingkungan dengan `flutter doctor`. Detail lengkap ada di [`docs/01_panduan_setup.md`](docs/01_panduan_setup.md).

## Git & branch

Branch utama kelompok: **`pbl`**.

```bash
git status
git add .
git commit -m "setup: fondasi monorepo, PRD, schema Supabase, scaffold Flutter & web"
git push -u origin pbl
```

> `pbl` sudah dijadikan branch lokal saat setup. Jangan commit file `.env`, `local.properties`, `node_modules/`, atau `.dart_tool/`.
>
> Slicing UI web pelanggan (katalog, topping, keranjang) saat ini **belum di-commit dan belum di-push**. Rincian pekerjaan ada di [`docs/03_catatan_pekerjaan.md`](docs/03_catatan_pekerjaan.md).

## Status pengembangan

- [x] Minggu 1 — PRD final, struktur repo, skema database, scaffold Flutter & web
- [ ] Minggu 2 — Katalog, topping, keranjang & checkout (web); kelola menu (admin)
- [ ] Minggu 3 — Pesanan online, status realtime, dispatch ojek `wa.me`, kasir POS
- [ ] Minggu 4 — Tracking, struk WhatsApp, laporan owner & monitoring performa
- [ ] Minggu 5 — UAT, perbaikan, ekspor laporan & finalisasi laporan

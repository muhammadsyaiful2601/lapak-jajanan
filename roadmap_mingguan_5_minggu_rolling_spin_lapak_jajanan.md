# Roadmap Mingguan Proyek PBL (Target 5 Minggu — Sistem Rolling Spin)

## Proyek: Sistem Pemesanan & Kasir Hybrid — Lapak Jajanan

*(Multi-Lokasi: Lokasi Utama & Pasar Kuliner | Hybrid Web QR + Aplikasi Mobile Flutter + Supabase)*

## Panduan Kerja Tim & Aturan Rolling Spin Mingguan

1. **Desain UI/UX Sudah Selesai:** Karena tahap desain antarmuka sudah rampung, tim langsung masuk ke tahap *setup* proyek, *slicing* UI ke kode, integrasi database **Supabase**, fitur bisnis, hingga pengujian akhir dalam **5 Minggu**.

2. **Sistem Rolling Spin (6 Slot / Minggu):** Setiap awal minggu, **seluruh 6 anggota tim (termasuk Ketua Tim)** diundi menggunakan *Spin Wheel* untuk menentukan **Slot 1 sampai Slot 6** pada minggu tersebut.

3. **Aturan Serah Terima (*Handoff*) Setiap Akhir Minggu:**

   * Sebelum *spin* minggu berikutnya dilakukan, pemegang slot wajib melakukan `git push` ke *branch* masing-masing dan memastikan kode dapat berjalan tanpa *error* (*build sukses*).

   * Ketua tim melakukan *merge* ke `main` setiap akhir pekan agar pemegang slot berikutnya langsung melanjutkan dari kondisi kode terbaru.

4. **Aturan Penggunaan AI Agent:** Saat memakai AI Agent (*Cursor, Windsurf, Copilot, Gemini, ChatGPT*), wajib arahkan AI untuk **hanya mengerjakan folder/file pada Slot yang didapat minggu tersebut** dan selalu mengacu pada skema tabel di `database/database_schema.sql`.

## Peta Struktur Folder Proyek (`pbl-lapak-jajanan`)

```
pbl-lapak-jajanan/
├── database/
│   └── database_schema.sql           # Skema tabel Supabase (PostgreSQL)
│
├── web_qr/                           # Website Pelanggan (QR Code & Link Pemesanan)
│   └── src/
│       ├── config/                   # Koneksi Supabase & Helper API
│       └── modules/
│           ├── order_catalog/        # Katalog, Detail, Topping, Keranjang, GPS/Ongkir & Checkout
│           └── order_tracking/       # Pelacakan Status, Info Pengantaran/Ojek, Riwayat & Struk WA
│
├── mobile_app/                       # Aplikasi Flutter (Admin & Owner)
│   └── lib/
│       ├── core/                     # Config Supabase, Theme Material 3, Models & Ticket Generator
│       └── modules/
│           ├── admin_master/         # Dashboard Admin, CRUD Menu/Topping/Stok, Lokasi, Ongkir & Ojek
│           ├── admin_pos_orders/     # Kelola Pesanan Online, Dispatch Ojek wa.me & Kasir POS Walk-In
│           └── owner_analytics/      # Dashboard Keuangan, Laporan Lengkap, Performa, Ongkir & Ekspor
│
└── supabase/functions/               # Webhook Payment Gateway QRIS & Struk Otomatis WhatsApp


```

## MINGGU 1 — Setup Infrastruktur, Database Supabase & Slicing UI dari Desain

### Teks Siap Copy-Paste ke Spin Wheel (Minggu 1)

```
Slot 1 (M1): Setup Monorepo, Database Supabase & Bab 1 Laporan
Slot 2 (M1): Slicing UI Web Pelanggan (Katalog, Filter, Detail & Modal Topping) + Bab 2
Slot 3 (M1): Slicing UI Web Pelanggan (Keranjang, Checkout, E-Ticket & Tracking)
Slot 4 (M1): Slicing UI App Admin (Login, Dashboard, Menu/Topping & Lokasi) + UML Bab 3
Slot 5 (M1): Slicing UI App Admin (Layar POS Kasir Walk-In & Daftar Pesanan Online)
Slot 6 (M1): Slicing UI App Owner (Dashboard Keuangan, Kartu KPI & Layout Laporan)


```

### Rincian Tugas Minggu 1

* **Slot 1 — Setup Monorepo, Database Supabase & Bab 1:**

  * Membuat repository Git (`web_qr/` & `mobile_app/`), membuat proyek **Supabase**, menjalankan file `database_schema.sql` (tabel `locations`, `categories`, `menus`, `menu_toppings`, `shipping_rates`, `ojek_drivers`, `orders`, `order_items`), serta menyusun draf **Bab 1 (Pendahuluan)**.

* **Slot 2 — Slicing UI Web Pelanggan (Katalog & Topping) + Bab 2:**

  * Menerjemahkan desain halaman **Katalog Menu, Detail Menu, Pencarian/Filter, dan Modal Kustomisasi Topping** ke kode (`web_qr/src/modules/order_catalog/`) serta menyusun draf **Bab 2 (Tinjauan Pustaka)**.

* **Slot 3 — Slicing UI Web Pelanggan (Checkout & Pelacakan):**

  * Menerjemahkan desain halaman **Keranjang Belanja, Form Checkout (Delivery/Pickup), Kartu E-Ticket, Pelacakan Status, dan Riwayat Pesanan** (`web_qr/src/modules/order_tracking/`).

* **Slot 4 — Slicing UI App Admin (Master & Lokasi) + Diagram UML Bab 3:**

  * Menerjemahkan desain **Login Staf, Dashboard Admin, Kelola Menu/Topping, Kelola Lokasi (Lokasi Utama & Pasar Kuliner), dan Daftar Ojek** (`mobile_app/lib/modules/admin_master/`) serta membuat *Use Case & Activity Diagram* untuk **Bab 3**.

* **Slot 5 — Slicing UI App Admin (POS Kasir & Pesanan Online):**

  * Menerjemahkan desain **Layar Kasir POS Walk-In (Grid Menu, Keranjang, Kalkulator Kembalian)** dan **Daftar Pesanan Online Masuk** (`mobile_app/lib/modules/admin_pos_orders/`).

* **Slot 6 — Slicing UI App Owner (Dashboard & Laporan):**

  * Menerjemahkan desain **Dashboard Owner, Kartu Monitoring Penjualan/Pendapatan, Filter Periode, dan Layout Grafik Laporan** (`mobile_app/lib/modules/owner_analytics/`).

## MINGGU 2 — Models Core, CRUD Master Data, Keranjang & Query Omzet Dasar

### Teks Siap Copy-Paste ke Spin Wheel (Minggu 2)

```
Slot 1 (M2): Core Models, Generator Ticket Code & Bab 3 (Arsitektur & ERD)
Slot 2 (M2): Logika Web Pelanggan (Load Menu/Topping Realtime, Keranjang & GPS Delivery)
Slot 3 (M2): Logika Admin Master (CRUD Menu, Kategori, Topping & Toggle Ketersediaan Stok)
Slot 4 (M2): Logika Admin Lokasi & Ojek (Jam Operasional Lokasi, Tarif Ongkir & Ojek Online)
Slot 5 (M2): Logika Kasir POS Walk-In (Pilih Menu/Topping, Keranjang & Hitung Kembalian)
Slot 6 (M2): Logika Owner Dasar (Monitoring Total Penjualan, Pendapatan & Laporan Periode)


```

### Rincian Tugas Minggu 2

* **Slot 1 — Core Models, Generator Ticket Code & Bab 3:**

  * Membuat file model data (`OrderModel`, `MenuModel`, `LocationModel`, `OjekDriverModel`), koneksi *Supabase Client*, fungsi generator **Ticket Code** otomatis (`TKT-101`, dst.), dan penulisan **Bab 3 (Arsitektur & Skema Database)**.

* **Slot 2 — Logika Web Pelanggan (Katalog, Keranjang & GPS):**

  * Menghubungkan katalog & *topping* ke Supabase, fungsi keranjang belanja, dan fitur pengambilan koordinat **GPS (`latitude`, `longitude`)** saat pelanggan memilih jenis pesanan **Delivery**.

* **Slot 3 — Logika Admin Master (CRUD Menu & Stok):**

  * Mengimplementasikan Tambah/Edit/Hapus **Katalog Menu, Kategori, Variasi & Topping**, serta tombol saklar cepat **Tersedia / Habis** (`admin_master/`).

* **Slot 4 — Logika Admin Lokasi, Ongkir & Ojek Langganan:**

  * Mengimplementasikan pengaturan status & jam buka/tutup **Lokasi Utama & Pasar Kuliner**, pengelolaan **Tarif Ongkir**, serta CRUD kontak **Ojek Langganan** lengkap dengan saklar **Online / Offline**.

* **Slot 5 — Logika Kasir POS Walk-In:**

  * Mengimplementasikan input pesanan langsung (*walk-in*), pemilihan menu & topping, pengelolaan keranjang kasir, serta perhitungan total dan uang kembalian tunai (`admin_pos_orders/`).

* **Slot 6 — Logika Owner Dasar:**

  * Menghubungkan Dashboard Owner ke tabel `orders` untuk menampilkan **Monitoring Total Penjualan & Pendapatan**, **Laporan Periode** (*Hari Ini, Mingguan, Bulanan, Custom*), dan **Laporan Transaksi** (`owner_analytics/`).

## MINGGU 3 — Transaksi End-to-End, Supabase Realtime & Dispatch Ojek `wa.me`

### Teks Siap Copy-Paste ke Spin Wheel (Minggu 3)

```
Slot 1 (M3): Checkout Web Pelanggan (Delivery/Pickup + Ongkir, Input WA & Simpan Order)
Slot 2 (M3): Pelacakan Real-Time Pelanggan (Status Order, Info Ojek & Riwayat Pesanan)
Slot 3 (M3): Kelola Pesanan Online Admin (Konfirmasi, Diproses, Diantar, Selesai + Timestamp)
Slot 4 (M3): Penugasan Ojek Langganan via wa.me (Pilih Ojek Online + Kirim Link Maps)
Slot 5 (M3): Cetak Struk Kasir POS & Riwayat Transaksi Kasir + Bab 4 (Modul Admin/POS)
Slot 6 (M3): Analitik Owner (Laporan Cash vs QRIS, Delivery vs Pickup & Menu Terlaris)


```

### Rincian Tugas Minggu 3

* **Slot 1 — Checkout Web Pelanggan:**

  * Menyelesaikan form checkout (pilihan zona ongkir Admin untuk *Delivery*, input nomor WhatsApp aktif, metode bayar *Cash/QRIS*) dan penyimpanan transaksi ke Supabase.

* **Slot 2 — Pelacakan Real-Time & Info Pengantaran Pelanggan:**

  * Menghubungkan halaman pelacakan ke **Supabase Realtime** agar progres status (`Konfirmasi` $\rightarrow$ `Diproses` $\rightarrow$ `Diantar` $\rightarrow$ `Selesai`) dan informasi **Ojek Langganan** tampil otomatis, beserta halaman **Riwayat Pesanan**.

* **Slot 3 — Kelola Pesanan Online Admin:**

  * Menampilkan daftar pesanan masuk dari Web, tombol perubahan status pesanan secara berurutan, dan pencatatan *timestamp* (`confirmed_at`, `processed_at`, `delivered_at`, `completed_at`).

* **Slot 4 — Penugasan Ojek Langganan via `wa.me`:**

  * Membuat fitur pemilihan **Ojek Langganan yang berstatus Online** pada pesanan *Delivery* dan tombol kirim yang membuka `https://wa.me/628xxx?text=...` berisi rincian pesanan, ongkir, dan tautan Google Maps titik lokasi pelanggan.

* **Slot 5 — Cetak Struk Kasir & Bab 4 (Admin/POS):**

  * Mengimplementasikan fitur **Cetak Struk Transaksi** (thermal/PDF) dan **Riwayat Transaksi Kasir**, serta menulis **Bab 4 (Implementasi Modul Admin & POS Kasir)**.

* **Slot 6 — Analitik Metode Bayar, Jenis Pesanan & Menu Terlaris (Owner):**

  * Mengimplementasikan **Laporan Metode Pembayaran (Cash dan QRIS)**, **Laporan Jenis Pesanan (Delivery dan Pickup)**, dan **Analisis Menu Terlaris**.

## MINGGU 4 — Payment Gateway QRIS, Struk Otomatis WA & Analitik Lanjutan Owner

### Teks Siap Copy-Paste ke Spin Wheel (Minggu 4)

```
Slot 1 (M4): Integrasi Payment Gateway QRIS (Checkout Web Pelanggan & Webhook Lunas)
Slot 2 (M4): Struk Otomatis WhatsApp (Edge Function WA API & Tampilan Struk Pelanggan)
Slot 3 (M4): Pembayaran QRIS pada Kasir POS & Sinkronisasi Stok/Lokasi Real-Time
Slot 4 (M4): Monitoring Performa Operasional & Monitoring Biaya Pengantaran (Owner)
Slot 5 (M4): Fitur Ekspor Laporan Owner (PDF/CSV) + Bab 4 (Web Pelanggan & Owner)
Slot 6 (M4): Penyusunan Buku Panduan Pengguna (User Manual 3 Aktor) & Lampiran Laporan


```

### Rincian Tugas Minggu 4

* **Slot 1 — Integrasi Payment Gateway QRIS (Web Pelanggan):**

  * Menghubungkan pembayaran **QRIS (Sandbox)** pada halaman checkout Web Pelanggan beserta *webhook* verifikasi otomatis agar status pembayaran langsung berubah menjadi `PAID`.

* **Slot 2 — Penerimaan Struk Otomatis melalui WhatsApp:**

  * Membangun *Supabase Edge Function* untuk mengirim **Struk Otomatis melalui WhatsApp** saat pesanan terkonfirmasi lunas, serta menampilkan kartu struk digital di Web Pelanggan.

* **Slot 3 — Pembayaran QRIS Kasir POS & Sinkronisasi Stok/Lokasi:**

  * Menambahkan opsi pembayaran **QRIS Payment Gateway** pada modul POS Kasir Walk-In dan memastikan perubahan status stok menu serta jam operasional **Lokasi Utama / Pasar Kuliner** langsung memblokir/membuka pemesanan di Web.

* **Slot 4 — Monitoring Performa Operasional & Biaya Pengantaran (Owner):**

  * Mengimplementasikan **Monitoring Performa Operasional** (rata-rata kecepatan proses order dari selisih *timestamp*, *completion rate*, perbandingan performa antar lokasi, dan produktivitas ojek) serta **Monitoring Biaya Pengantaran** (rekap akumulasi ongkir per ojek & zona).

* **Slot 5 — Ekspor Laporan Owner & Bab 4 (Web & Owner):**

  * Mengimplementasikan fitur **Ekspor Laporan (PDF & CSV/Excel)** di aplikasi Owner serta menyelesaikan penulisan **Bab 4 bagian Web Pelanggan dan Owner**.

* **Slot 6 — Buku Panduan Pengguna (*User Manual*) & Lampiran:**

  * Menyusun panduan penggunaan lengkap beserta *screenshot* untuk **Pelanggan**, **Admin/Kasir**, dan **Owner**, serta menyiapkan desain *Tent-Card QR Code* untuk **Lokasi Utama** dan **Pasar Kuliner**.

## MINGGU 5 — Pengujian Terpadu (UAT), Perbaikan Bug, Video Demo & Finalisasi PBL

### Teks Siap Copy-Paste ke Spin Wheel (Minggu 5)

```
Slot 1 (M5): Uji End-to-End & Bug Fixing Jalur Pelanggan (Web QR, GPS, QRIS & Struk WA)
Slot 2 (M5): Uji End-to-End & Bug Fixing Jalur Admin (Menu/Stok, Lokasi, POS & Ojek wa.me)
Slot 3 (M5): Uji End-to-End & Bug Fixing Jalur Owner (Akurasi Omzet, Performa & Ekspor)
Slot 4 (M5): Eksekusi Tabel Black-Box Testing & Penulisan Bab 5 (Pengujian & Penutup)
Slot 5 (M5): Perekaman & Editing Video Demonstrasi Lengkap (Alur 3 Aktor + Ojek wa.me)
Slot 6 (M5): Penggabungan Laporan Akhir PBL (Bab 1-5 + Manual) & Slide Presentasi


```

### Rincian Tugas Minggu 5

* **Slot 1 — QA & Bug Fixing Modul Pelanggan (`web_qr/`):**

  * Menguji seluruh skenario pelanggan (QR/Link *Lokasi Utama* & *Pasar Kuliner*, *topping*, ambil GPS *Delivery*, bayar *Cash/QRIS*, pelacakan status, dan masuknya struk otomatis di WhatsApp) serta memperbaiki *bug* tampilan/fungsional.

* **Slot 2 — QA & Bug Fixing Modul Admin (`admin_master/` & `admin_pos_orders/`):**

  * Menguji simulasi transaksi ramai antara pesanan Web QR dan POS Kasir Walk-In, cetak struk kasir, serta memastikan pesan `wa.me` ke ojek langganan membawa koordinat Google Maps yang akurat.

* **Slot 3 — QA & Bug Fixing Modul Owner (`owner_analytics/`):**

  * Memverifikasi akurasi perhitungan total penjualan, pemisahan omzet produk vs biaya pengantaran (ongkir), grafik perbandingan lokasi/metode bayar, dan hasil file ekspor PDF/CSV.

* **Slot 4 — Black-Box Testing & Penulisan Bab 5:**

  * Mengisi tabel hasil pengujian sistem (*Test Cases* seluruh fitur Pelanggan, Admin, dan Owner) serta menyelesaikan penulisan **Bab 5 (Pengujian Sistem, Kesimpulan, dan Saran)**.

* **Slot 5 — Video Demonstrasi Proyek PBL:**

  * Merekam dan mengedit video demo berdurasi 3–5 menit yang memperlihatkan alur nyata lintas perangkat: *Pelanggan scan QR & pesan Delivery* $\rightarrow$ *Struk WA masuk* $\rightarrow$ *Admin konfirmasi & kirim order ke Ojek via `wa.me`* $\rightarrow$ *Owner cek laporan & ekspor*.

* **Slot 6 — Finalisasi Laporan Akhir & Slide Presentasi:**

  * Menggabungkan seluruh dokumen laporan (**Bab 1–5 + User Manual + Lampiran**) ke format akhir kampus yang rapi dan menyusun **Slide Presentasi (PPT/Canva)** untuk sidang/evaluasi PBL.
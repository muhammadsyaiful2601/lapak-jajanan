# Product Requirements Document (PRD)
## Sistem Pemesanan & Kasir Hybrid — Lapak Jajanan
*(Multi-Lokasi: Lokasi Utama & Pasar Kuliner | Hybrid Web QR + Aplikasi Mobile Flutter)*

| Atribut Dokumen | Keterangan |
| :--- | :--- |
| **Nama Mitra UMKM** | **Lapak Jajanan** |
| **Status Dokumen** | Final Baseline Pengembangan PBL (Pembaruan Lengkap dari Grup) |
| **Target Waktu Pengerjaan** | **5 Minggu** (Hingga UAT & Finalisasi Laporan) |
| **Arsitektur Sistem** | Hybrid Monorepo (`web_qr/` untuk Pelanggan + `mobile_app/` Flutter untuk Admin & Owner) |
| **Database & Backend** | Supabase (PostgreSQL + Supabase Realtime + Edge Functions) |
| **Aktor Sistem** | 1. Pelanggan, 2. Admin (Operasional, Kasir POS & Dispatch Ojek), 3. Owner |
| **Integrasi Eksternal** | Payment Gateway (QRIS), WhatsApp API (Struk Otomatis), & `wa.me` Deep Link (Ojek Sekitar) |

---

## 1. Latar Belakang & Tujuan Sistem

### 1.1 Latar Belakang Masalah
**Lapak Jajanan** menjalankan aktivitas penjualan pada dua titik lokasi sekaligus, yakni **Lokasi Utama** dan **Pasar Kuliner**. Berdasarkan hasil diskusi bersama mitra dan penyelarasan kebutuhan tim, sistem ini dirancang untuk menyelesaikan permasalahan operasional berikut:
1. **Layanan Pemesanan Ganda (Online QR & Walk-In Kasir):** Pelanggan membutuhkan akses pemesanan mandiri via QR Code/tautan website (untuk layanan *Delivery* maupun *Pickup*), sementara pembeli yang datang langsung ke gerai tetap dilayani secara cepat melalui modul **Kasir (POS)**.
2. **Kustomisasi Topping & Sinkronisasi Stok Real-Time:** Produk memiliki variasi dan pilihan *topping* tambahan, serta ketersediaan stok (*Tersedia* / *Habis*) yang harus diperbarui secara seketika antara Admin dan Pelanggan.
3. **Pengantaran Lokal via Ojek Langganan (`wa.me`):** Mitra telah memiliki kontak **ojek langganan sekitar** dan tidak menggunakan layanan logistik pihak ketiga (Gojek/Grab). Sistem menyediakan mekanisme penugasan pengantaran via **WhatsApp (`wa.me`)** yang menyertakan rincian pesanan, ongkos kirim yang diatur Admin, serta tautan titik lokasi GPS pelanggan setelah pesanan dikonfirmasi.
4. **Transparansi Struk & Evaluasi Bisnis Menyeluruh:** Pelanggan menerima struk otomatis melalui WhatsApp dan dapat memantau progres pesanannya, sedangkan Owner membutuhkan pengawasan menyeluruh mulai dari omzet penjualan, **monitoring performa operasional**, hingga **monitoring biaya pengantaran** antar lokasi dan kurir ojek.

### 1.2 Tujuan Produk
* Membangun **Website Pemesanan Pelanggan (`web_qr/`)** yang mendukung QR Code/Link pemesanan, katalog, kustomisasi *topping*, keranjang, pemilihan *Delivery/Pickup* beserta titik GPS, pembayaran *Cash/QRIS*, pelacakan status pesanan & pengantaran, riwayat pesanan, serta struk otomatis WhatsApp.
* Membangun **Aplikasi Mobile Admin (`mobile_app/` Flutter)** untuk mengelola katalog menu/kategori/topping/stok, mengatur jadwal & status **Lokasi Utama** serta **Pasar Kuliner**, mengatur tarif ongkir & status *online* ojek langganan, menangani pesanan online & dispatch ojek via `wa.me`, serta melayani transaksi **Kasir (POS) Walk-In**.
* Membangun **Aplikasi Mobile Owner (`mobile_app/` Flutter)** untuk memantau penjualan & pendapatan, laporan berdasarkan periode, metode bayar, jenis pesanan, analisis menu terlaris, **monitoring performa operasional**, **monitoring biaya pengantaran**, serta ekspor laporan.

---

## 2. Arsitektur & Alur Sistem End-to-End

### 2.1 Diagram Arsitektur Hybrid (Supabase + Flutter + Web)
```text
+-----------------------------------+       +-----------------------------------+
|      WEB PELANGGAN (web_qr/)      |       |   APP ADMIN - POS KASIR (Flutter) |
|  (Browser HP via QR Code / Link)  |       |     (Transaksi Walk-In di Gerai)  |
+-----------------+-----------------+       +-----------------+-----------------+
                  |                                           |
                  | 1. Pilih Lokasi, Menu, Topping            | 1. Input Menu & Topping
                  | 2. Pilih Pickup / Delivery (+GPS & Ongkir)| 2. Hitung Total & Kembalian
                  | 3. Bayar Cash / QRIS + Input WA           | 3. Bayar Cash / QRIS + Cetak Struk
                  v                                           v
        +---------------------------------------------------------------+
        |                  SUPABASE BACKEND (PostgreSQL)                |
        |   Tables: locations, categories, menus, menu_toppings,        |
        |           shipping_rates, ojek_drivers, orders, order_items   |
        +----+--------------------------+--------------------------+----+
             |                          |                          |
             | Realtime Update          | Kelola Menu, Lokasi,     | Rekap Omzet, Performa
             v                          | Ojek & Status Pesanan    | & Biaya Pengantaran
+-------------------------+             v                          v
| WEB TRACKING & RIWAYAT  |  +---------------------+  +-----------------------+
| - Status Pesanan        |  | APP ADMIN (Flutter) |  |  APP OWNER (Flutter)  |
| - Info Pengantaran/Ojek |  +----------+----------+  +-----------------------+
+-------------------------+             |
                    +-------------------+-------------------+
                    | (Otomatis)                            | (Klik Kirim Order Ojek)
                    v                                       v
        +-----------------------+               +-----------------------+
        | WHATSAPP API GATEWAY  |               |  WHATSAPP DEEP LINK   |
        | Kirim Struk Otomatis  |               |  https://wa.me/628..  |
        | ke WhatsApp Pelanggan |               |  + Link Maps & Order  |
        +-----------------------+               +-----------------------+
```

### 2.2 Format Pesan Otomatis Dispatch Ojek Langganan (`wa.me`)
Ketika Admin mengonfirmasi pesanan **Delivery** dan memilih ojek yang sedang berstatus **Online**, aplikasi Flutter membuka tautan `https://wa.me/628xxx?text=...` dengan isi pesan otomatis:
```text
*ORDER PENGANTARAN - LAPAK JAJANAN*
Kode Tiket: TKT-105
Titik Ambil: Lokasi Utama

*Data Pelanggan:*
Nama: Kak Rina
No. WA: 081234567890
Alamat/Patokan: Jl. Merdeka No. 12 (Depan Masjid)
Titik Google Maps: https://www.google.com/maps?q=-0.456789,100.678912

*Rincian Pesanan:*
- 2x Pentol Kuah Pedas (Topping: Tetelan)
- 1x Es Teh Manis
Status Bayar: LUNAS (QRIS)
Ongkos Kirim: Rp 7.000
```

---

## 3. Spesifikasi Kebutuhan Fungsional Lengkap

### 3.1 Aktor 1: Pelanggan (`web_qr/`)
Berfungsi untuk melihat menu, melakukan pemesanan, pembayaran, dan memantau pesanan.

* **FR-P01 QR Code dan Link Pemesanan:** Halaman pemesanan dapat diakses melalui pemindaian QR Code di gerai/meja maupun tautan web dengan deteksi parameter lokasi (**Lokasi Utama** atau **Pasar Kuliner**).
* **FR-P02 Katalog Menu, Detail Menu, dan Harga:** Menampilkan daftar produk beserta foto, deskripsi detail, harga dasar, dan label status stok (*Tersedia* atau *Habis*).
* **FR-P03 Pencarian dan Filter Menu:** Menyediakan bilah pencarian nama produk dan filter kategori menu.
* **FR-P04 Kustomisasi Menu dan Pilihan Topping:** Menyediakan modal/halaman detail item untuk memilih variasi rasa/ukuran dan mencentang satu atau lebih *topping* tambahan dengan kalkulasi harga otomatis.
* **FR-P05 Keranjang Belanja:** Pengelolaan item pesanan (tambah/kurang kuantitas, hapus item, catatan khusus, dan ringkasan subtotal).
* **FR-P06 Pilihan Jenis Pesanan (Delivery atau Pickup):**
  * **Pickup:** Pelanggan mengambil pesanan langsung di lokasi gerai yang dipilih.
  * **Delivery:** Pelanggan mengisi alamat/patokan, menangkap titik koordinat GPS (`latitude`, `longitude`) untuk tautan Google Maps, serta memilih zona tarif ongkir yang telah diatur Admin.
* **FR-P07 Checkout, Pembayaran & Konfirmasi Pesanan:** Form identitas & nomor WhatsApp pelanggan, pilihan metode pembayaran **Cash** atau **QRIS melalui Payment Gateway**, serta halaman konfirmasi pesanan yang menerbitkan *Ticket Code*.
* **FR-P08 Pelacakan Status Pesanan:** Halaman pelacakan *real-time* menggunakan *Ticket Code* (`Menunggu Konfirmasi` $\rightarrow$ `Diproses` $\rightarrow$ `Diantar` $\rightarrow$ `Selesai`).
* **FR-P09 Informasi Status Pengantaran:** Menampilkan informasi khusus status pengiriman dan kontak ojek langganan yang bertugas pada pesanan *Delivery*.
* **FR-P10 Riwayat Pesanan:** Menampilkan daftar riwayat transaksi pelanggan berdasarkan nomor WhatsApp atau sesi perangkat.
* **FR-P11 Penerimaan Struk Otomatis melalui WhatsApp:** Menampilkan komponen struk digital yang dapat diunduh serta pemicu otomatis pengiriman struk transaksi ke WhatsApp pelanggan.

---

### 3.2 Aktor 2: Admin (`mobile_app/` — Flutter)
Berfungsi mengelola operasional usaha, menangani pesanan online, mengatur ojek langganan, serta melayani transaksi pembelian langsung sebagai kasir.

#### A. Dashboard dan Pengelolaan Menu
* **FR-A01 Dashboard Admin:** Ringkasan operasional harian (status buka/tutup tiap lokasi, jumlah ojek *Online*, jumlah pesanan aktif hari ini, dan pintasan navigasi).
* **FR-A02 Kelola Katalog Menu, Detail Menu, dan Harga:** Operasi Tambah, Edit, dan Hapus produk beserta foto, deskripsi, dan harga.
* **FR-A03 Kelola Kategori Menu:** Manajemen master kategori produk.
* **FR-A04 Kelola Variasi Menu dan Topping:** Pengaturan variasi rasa/ukuran dan daftar *topping* tambahan beserta harganya.
* **FR-A05 Kelola Ketersediaan Menu (Tersedia atau Habis):** Tombol *toggle* cepat untuk memperbarui status stok secara *real-time* ke Web Pelanggan.

#### B. Pengelolaan Pesanan & Dispatch Ojek Langganan
* **FR-A06 Kelola Pesanan Pelanggan:** Menampilkan daftar pesanan masuk dari Web Pelanggan lengkap dengan rincian menu, *topping*, jenis pesanan (*Delivery/Pickup*), titik lokasi GPS, ongkir, dan status pembayaran.
* **FR-A07 Kelola Status Pesanan:** Mengubah status pesanan secara berurutan: **Konfirmasi** $\rightarrow$ **Diproses** $\rightarrow$ **Diantar** *(jika Delivery)* $\rightarrow$ **Selesai**.
* **FR-A08 Penugasan Ojek Langganan (`wa.me`):** Untuk pesanan *Delivery* yang telah dikonfirmasi, Admin memilih ojek dari daftar ojek berstatus **Online** dan menekan tombol kirim untuk membuka `wa.me` dengan format pesan order + link Google Maps otomatis.
* **FR-A09 Riwayat Pesanan dan Transaksi:** Log riwayat seluruh pesanan online yang sudah selesai.

#### C. Modul Kasir (POS)
* **FR-A10 Input Pesanan Langsung (Walk-In):** Antarmuka kasir cepat untuk pelanggan yang membeli langsung di lokasi.
* **FR-A11 Pemilihan Menu dan Topping:** Memilih menu beserta variasi dan *topping* untuk pesanan *walk-in*.
* **FR-A12 Pengelolaan Keranjang Transaksi:** Tambah/kurang kuantitas, hapus item, dan catatan pesanan pada kasir.
* **FR-A13 Perhitungan Total Pembayaran dan Kembalian:** Kalkulasi otomatis total tagihan, input nominal uang tunai diterima, tombol pecahan cepat, dan perhitungan kembalian.
* **FR-A14 Pembayaran Cash dan QRIS melalui Payment Gateway:** Mendukung pembayaran tunai (*Cash*) maupun pemindaian kode *QRIS* dinamis di meja kasir.
* **FR-A15 Cetak Struk Transaksi & Riwayat Transaksi Kasir:** Pratinjau & cetak struk transaksi (thermal/PDF), dilengkapi tab **Riwayat Transaksi Kasir**.

#### D. Pengelolaan Lokasi & Master Pengantaran
* **FR-A16 Kelola Lokasi Operasional dan Waktu Operasional:** Mengatur jam buka/tutup dan status aktif untuk **Lokasi Utama** dan **Pasar Kuliner**.
* **FR-A17 Kelola Tarif Ongkir & Status Online Ojek Langganan:** Mengatur daftar zona/tarif ongkir serta mengelola daftar kontak ojek langganan (Nama, No. WA `628...`, Plat Nomor) lengkap dengan saklar **Online / Offline**.

---

### 3.3 Aktor 3: Owner (`mobile_app/` — Flutter)
Berfungsi mengawasi bisnis, memantau keuangan, dan mengevaluasi keseluruhan kegiatan operasional usaha.

* **FR-O01 Dashboard Owner:** Ringkasan KPI utama bisnis secara *real-time* (Total Penjualan, Total Pendapatan Bersih, Total Biaya Pengantaran, dan Performa Lokasi).
* **FR-O02 Monitoring Total Penjualan dan Pendapatan:** Pemantauan jumlah transaksi sukses dan akumulasi pendapatan kotor maupun bersih (produk + topping di luar ongkir).
* **FR-O03 Laporan Penjualan Berdasarkan Periode:** Filter laporan berdasarkan **Hari Ini**, **Mingguan**, **Bulanan**, dan **Rentang Tanggal Kustom**, serta filter lokasi (**Semua Lokasi**, **Lokasi Utama**, **Pasar Kuliner**).
* **FR-O04 Laporan Transaksi:** Tabel rincian seluruh transaksi gabungan dari kanal Web Pelanggan dan POS Kasir Walk-In.
* **FR-O05 Laporan Metode Pembayaran (Cash dan QRIS):** Grafik dan rincian perbandingan pendapatan antara metode **Cash** dan **QRIS**.
* **FR-O06 Laporan Jenis Pesanan (Delivery dan Pickup):** Grafik dan rincian perbandingan volume transaksi serta omzet antara **Delivery** dan **Pickup**.
* **FR-O07 Analisis Menu Terlaris:** Peringkat menu dan *topping* paling laku berdasarkan kuantitas terjual dan kontribusi pendapatan.
* **FR-O08 Monitoring Performa Operasional *(Baru)*:**
  * **Kecepatan Layanan Pesanan:** Menghitung rata-rata waktu pemrosesan pesanan dari tahap `Konfirmasi` $\rightarrow$ `Diproses` $\rightarrow$ `Selesai` berdasarkan selisih *timestamp*.
  * **Tingkat Penyelesaian Pesanan (*Completion Rate*):** Persentase pesanan sukses diselesaikan dibanding total pesanan masuk.
  * **Perbandingan Performa Lokasi:** Evaluasi jumlah pesanan, omzet, dan kecepatan layanan antara **Lokasi Utama** dan **Pasar Kuliner**.
  * **Produktivitas Pengantaran Ojek:** Rekap jumlah pengantaran berhasil per kurir ojek langganan.
* **FR-O09 Monitoring Biaya Pengantaran *(Baru)*:**
  * **Total Akumulasi Biaya Pengantaran (Ongkir):** Pemisahan jelas antara pendapatan penjualan produk (`subtotal_amount`) dengan dana ongkos kirim (`shipping_fee`).
  * **Rekap Ongkir Per Ojek & Zona:** Rincian nominal ongkos kirim yang dihasilkan oleh masing-masing ojek langganan dan zona pengantaran untuk memudahkan rekonsiliasi/setoran ongkir harian.
* **FR-O10 Ekspor Laporan:** Mengunduh dan membagikan laporan penjualan, biaya pengantaran, dan performa operasional ke format **PDF** dan **CSV / Excel**.

---

## 4. Skema Database Supabase (`database/database_schema.sql`)

```sql
-- 1. Lokasi Operasional (Lokasi Utama & Pasar Kuliner)
CREATE TABLE locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL, -- 'Lokasi Utama' | 'Pasar Kuliner'
  address TEXT,
  open_time TIME NOT NULL,
  close_time TIME NOT NULL,
  is_open BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Kategori Menu
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  sort_order INT DEFAULT 0
);

-- 3. Katalog Menu
CREATE TABLE menus (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price NUMERIC(12, 2) NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Variasi & Topping Menu
CREATE TABLE menu_toppings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_id UUID REFERENCES menus(id) ON DELETE CASCADE,
  topping_name VARCHAR(100) NOT NULL,
  extra_price NUMERIC(12, 2) DEFAULT 0,
  is_available BOOLEAN DEFAULT TRUE
);

-- 5. Pengaturan Tarif Ongkir (Diatur Admin)
CREATE TABLE shipping_rates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_name VARCHAR(100) NOT NULL,
  fee NUMERIC(12, 2) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE
);

-- 6. Master Ojek Langganan Sekitar (Diatur Admin)
CREATE TABLE ojek_drivers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  whatsapp_number VARCHAR(25) NOT NULL, -- Format: '6281234567890'
  vehicle_plate VARCHAR(30),
  is_online BOOLEAN DEFAULT FALSE,
  is_busy BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Tabel Pesanan & Transaksi (Mendukung Monitoring Performa & Biaya Pengantaran)
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_code VARCHAR(20) UNIQUE NOT NULL, -- Contoh: 'TKT-101'
  location_id UUID REFERENCES locations(id),
  ojek_id UUID REFERENCES ojek_drivers(id) ON DELETE SET NULL,
  order_source VARCHAR(20) NOT NULL, -- 'WEB_QR' | 'POS_WALKIN'
  order_type VARCHAR(20) NOT NULL,   -- 'DELIVERY' | 'PICKUP'
  customer_name VARCHAR(100) NOT NULL,
  customer_whatsapp VARCHAR(25),
  delivery_address TEXT,
  delivery_lat DOUBLE PRECISION,
  delivery_lng DOUBLE PRECISION,
  shipping_fee NUMERIC(12, 2) DEFAULT 0,
  payment_method VARCHAR(20) NOT NULL, -- 'CASH' | 'QRIS'
  payment_status VARCHAR(20) DEFAULT 'PENDING', -- 'PENDING' | 'PAID'
  order_status VARCHAR(30) DEFAULT 'MENUNGGU_KONFIRMASI',
  -- Status: 'MENUNGGU_KONFIRMASI' | 'DIPROSES' | 'DIANTAR' | 'SELESAI'
  subtotal_amount NUMERIC(12, 2) NOT NULL, -- Pendapatan bersih produk & topping
  total_amount NUMERIC(12, 2) NOT NULL,    -- subtotal_amount + shipping_fee
  cash_received NUMERIC(12, 2) DEFAULT 0,
  cash_change NUMERIC(12, 2) DEFAULT 0,
  wa_receipt_sent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  confirmed_at TIMESTAMPTZ,
  processed_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Detail Item Pesanan & Topping
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  menu_id UUID REFERENCES menus(id),
  menu_name VARCHAR(150) NOT NULL,
  selected_toppings JSONB DEFAULT '[]',
  quantity INT NOT NULL,
  unit_price NUMERIC(12, 2) NOT NULL,
  subtotal NUMERIC(12, 2) NOT NULL,
  item_note TEXT
);
```
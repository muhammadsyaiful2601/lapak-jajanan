# Catatan Pekerjaan — UI Web Pelanggan

**Tanggal:** 26 November 2026
**Branch:** `pbl`
**Status Git:** perubahan **belum di-commit dan belum di-push**. Commit terakhir di remote masih `202d041` (fondasi monorepo).

Dokumen ini mencatat pekerjaan slicing UI web pelanggan yang sudah dikerjakan setelah commit fondasi, supaya mudah dilanjutkan atau dipresentasikan.

---

## 1. Ringkasan

Slicing UI web pelanggan (`web_qr/`) mencakup dua halaman utama:

| Halaman | Rute | Cakupan FR |
| :--- | :--- | :--- |
| Katalog & topping | `/?location=<id>` | FR-P01–P04 |
| Keranjang | `/cart` | FR-P05 |

Checkout (`/checkout`) ikut disesuaikan agar perhitungan total konsisten dengan keranjang.

Tampilan memakai palet krem–cokelat, layout mobile-first (lebar konten maksimum 1040 px), bottom navigation, dan bottom sheet untuk detail menu.

---

## 2. Katalog & Topping

**File utama:** `web_qr/src/pages/MenuPage.tsx`

- Banner gerai: lokasi aktif dari parameter QR `?location=`, status **Buka**, jam operasional, dan pill kecepatan.
- Pencarian menu real-time berdasarkan nama.
- Dropdown urutan: **Terpopuler**, **Termurah**, **Nama A–Z**.
- Tab kategori: `Semua`, `Makanan Berat`, `Camilan`, `Minuman`.
- Daftar menu vertikal: thumbnail, nama, deskripsi, harga, tombol **+ Tambah**, badge, dan status **Habis**.
- Skeleton loading saat data Supabase dimuat, serta empty state + reset filter.
- Floating cart di atas bottom nav: jumlah menu, subtotal, dan tombol **Lihat Keranjang**.
- Data contoh otomatis dipakai jika `.env` Supabase belum diisi (**mode preview**).

**File komponen:**

- `web_qr/src/components/catalog/MenuCard.tsx` — kartu menu.
- `web_qr/src/components/catalog/MenuDetailSheet.tsx` — bottom sheet detail menu:
  - pilihan ukuran **Reguler / Jumbo** (`+Rp5.000`);
  - checkbox topping multi-pilih sesuai `menu_toppings`;
  - kolom catatan;
  - stepper jumlah;
  - total harga dihitung real-time;
  - tutup lewat backdrop, tombol ×, atau `Esc`.
- `web_qr/src/data/mockCatalog.ts` — kategori, menu, topping, dan dekorasi visual (emoji + warna) untuk mode preview. Termasuk menu **Pisang Madu Goreng** untuk banner upsell.

---

## 3. Keranjang

**File utama:** `web_qr/src/pages/CartPage.tsx`

- Kartu **Diproses dari** berisi lokasi aktif dan estimasi waktu.
- Judul **Keranjang Pesanan** + badge jumlah menu + tombol **Kosongkan**.
- Kartu item:
  - thumbnail (foto jika `image_url` ada, selain itu emoji + warna);
  - nama, harga satuan, dan `× qty` bila jumlah lebih dari satu;
  - baris ukuran dan topping beserta harga tambahan;
  - tombol hapus;
  - kotak **Catatan Pesanan** (hanya muncul jika ada catatan);
  - tag menu (mis. `Paling Diminati`);
  - tombol **Ubah Kustomisasi** dan stepper `− 1 +`.
- **Ubah Kustomisasi berfungsi**: membuka bottom sheet dengan ukuran, topping, catatan, dan qty yang sudah terisi. Menyimpan akan mengganti item lama di keranjang.
- Tombol **Tambah Menu Lain** menuju katalog.
- **Ringkasan Pesanan**: subtotal, estimasi ongkir (`Dihitung di checkout`), PB1 Resto 10%, dan kotak estimasi total.
- **Banner upsell** dinamis: menawarkan menu termurah yang belum ada di keranjang dan bisa langsung ditambahkan.
- **Bar checkout lengket** di atas bottom nav: total pembayaran + tombol **Lanjut ke Checkout**.
- **Empty state** khusus saat keranjang kosong, dengan tombol menuju katalog.
- Keranjang disimpan di `localStorage` dan tetap ada setelah reload (bug reset akibat efek ganda sudah diperbaiki dengan inisialisasi `loadCart`).

---

## 4. Perubahan pendukung

| File | Perubahan |
| :--- | :--- |
| `web_qr/src/components/Layout.tsx` | Header baru (brand, avatar, lokasi), ikon SVG, badge jumlah keranjang |
| `web_qr/src/index.css` | Tema krem–cokelat, style katalog, sheet, keranjang, bar checkout, responsif |
| `web_qr/src/types/index.ts` | `MenuTone`, `CartMenuSnapshot`, `CartTopping`; `CartItem` menyimpan snapshot menu/varian/topping |
| `web_qr/src/lib/pricing.ts` | **Baru** — konstanta & fungsi PB1 10% (`calculatePb1`, `calculateGrandTotal`) |
| `web_qr/src/pages/CheckoutPage.tsx` | Ringkasan menampilkan PB1; `total_amount` = subtotal + PB1 + ongkir |
| `web_qr/src/lib/supabase.ts` | Format rupiah dirapikan (`Rp15.000`, tanpa spasi) |
| `web_qr/src/components/SetupNotice.tsx` | Teks mode preview diperbarui |
| `web_qr/index.html` | Bahasa `id`, judul, meta description, theme color |
| `web_qr/README.md` | Dokumentasi halaman & slicing UI |
| `docs/02_checklist_minggu1.md` | Checklist slicing keranjang ditandai selesai |

File baru lain:

- `web_qr/src/components/catalog/MenuCard.tsx`
- `web_qr/src/components/catalog/MenuDetailSheet.tsx`
- `web_qr/src/data/mockCatalog.ts`
- `web_qr/src/lib/pricing.ts`

---

## 5. Keputusan teknis & catatan penting

1. **Mode preview** — tanpa `.env`, UI memakai `mockCatalog.ts`. Jika `VITE_SUPABASE_URL` dan `VITE_SUPABASE_PUBLISHABLE_KEY` diisi, data diambil dari Supabase dan otomatis fallback ke data contoh bila query gagal.
2. **PB1 Resto 10%** — tidak tertulis di PRD, tetapi diminta oleh desain referensi. Perhitungan dipusatkan di `src/lib/pricing.ts` dan ikut masuk `total_amount` saat checkout. **Perlu konfirmasi** jika pajak ini tidak diinginkan.
3. **Variasi ukuran (Reguler/Jumbo)** masih **UI-only** karena belum ada tabel varian di skema Supabase. Harga Jumbo ditambahkan di sisi keranjang.
4. **Snapshot menu di keranjang** — `CartItem` menyimpan nama, harga dasar, emoji/warna, dan topping agar halaman keranjang tidak perlu fetch ulang dan fitur edit tetap bekerja.
5. **Thumbnail** memakai emoji + gradien karena data contoh belum punya foto. Akan otomatis memakai foto jika `image_url` terisi.
6. **Tombol "Kosongkan"** menggantikan label "Tes Keranjang Kosong" pada desain referensi agar lebih masuk akal untuk pengguna.
7. **Upsell** memilih menu termurah yang belum ada di keranjang; banner hilang jika semua menu sudah masuk keranjang.

---

## 6. Verifikasi yang sudah dijalankan

| Pemeriksaan | Hasil |
| :--- | :--- |
| `npm run lint` | Bersih |
| `npm run build` | Sukses |
| Katalog: pencarian, filter kategori, urutan harga | Sesuai |
| Detail menu: Jumbo + topping + catatan + qty | Harga & isi keranjang sesuai |
| Keranjang: ubah kustomisasi (prefill) | Berhasil, qty & total ikut berubah |
| Keranjang: upsell, hapus, kosongkan, reload | Berhasil |
| Checkout: baris PB1 & total | Konsisten dengan keranjang |
| Console browser | Tidak ada error |

Preview saat pengecekan: `http://127.0.0.1:5174/?location=lokasi-utama`
(Port 5173 sedang dipakai aplikasi lain, sehingga Vite memakai 5174.)

---

## 7. Belum dikerjakan

- Integrasi data asli Supabase untuk seluruh alur (butuh project + `.env`).
- Foto menu asli menggantikan emoji.
- Varian ukuran di skema database (saat ini UI-only).
- Halaman checkout yang mengikuti gaya desain baru (baru disesuaikan totalnya).
- Tracking, riwayat, struk WhatsApp, QRIS gateway, dan GPS otomatis (minggu 3–4).
- Uji tampilan di perangkat fisik / viewport mobile nyata.

---

## 8. Status Git

Perubahan **belum di-commit** dan **belum di-push**.

Saran pesan commit setelah disetujui:

```bash
git add .
git commit -m "feat(web): slicing UI katalog, topping, dan keranjang pelanggan"
git push -u origin pbl
```

Jangan commit file `.env`, `node_modules/`, `dist/`, `.dart_tool/`, atau `local.properties`.

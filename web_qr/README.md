# web_qr — Pemesanan Pelanggan

Website pemesanan pelanggan Lapak Jajanan, diakses lewat QR code/link dengan parameter lokasi.

## Jalankan

```bash
npm install
cp .env.example .env
# isi VITE_SUPABASE_URL & VITE_SUPABASE_PUBLISHABLE_KEY
npm run dev
```

Tanpa `.env`, halaman tetap bisa dibuka dalam **mode preview** memakai data contoh dari `src/data/mockCatalog.ts`.

### Slicing UI Katalog, Topping & Keranjang (minggu 1)
- Hero katalog + deteksi lokasi dari QR (`?location=`), pencarian, dan tab kategori.
- Daftar kartu menu dengan badge, status stok, dan skeleton loading.
- Bottom sheet detail menu: pilihan ukuran, checkbox topping multi-pilih, catatan, stepper jumlah, dan tombol "+ ke keranjang" dengan kalkulasi harga real-time.
- Halaman keranjang: kartu item + kustomisasi, catatan pesanan, stepper qty, "Ubah Kustomisasi", ringkasan (subtotal, ongkir, PB1 10%), upsell, dan bar checkout lengket.
- Catatan: variasi ukuran masih **UI-only** (belum ada tabel di Supabase); topping memakai `menu_toppings`. PB1 10% dihitung di `src/lib/pricing.ts` dan ikut masuk `total_amount` saat checkout.

## Halaman & FR

| Rute | Fungsi | FR |
| :--- | :--- | :--- |
| `/?location=<id>` | Katalog, pencarian, filter, detail + topping | FR-P01–P04 |
| `/cart` | Keranjang, ubah kustomisasi, qty, catatan, ringkasan + PB1 | FR-P05 |
| `/checkout` | Delivery/Pickup, ongkir, Cash/QRIS, tiket | FR-P06–P07 |
| `/track/:ticketCode` | Pelacakan status pesanan | FR-P08–P09 |
| `/riwayat` | Riwayat berdasarkan WhatsApp | FR-P10 |

Belum diimplementasikan (minggu 4): GPS otomatis, QRIS gateway, struk WhatsApp (FR-P11).

## Teknologi

React 19 + TypeScript + Vite + `@supabase/supabase-js` + `react-router-dom` + `zustand` (tersedia untuk state lanjutan).

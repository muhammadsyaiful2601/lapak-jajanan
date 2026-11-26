# web_qr — Pemesanan Pelanggan

Website pemesanan pelanggan Lapak Jajanan, diakses lewat QR code/link dengan parameter lokasi.

## Jalankan

```bash
npm install
cp .env.example .env
# isi VITE_SUPABASE_URL & VITE_SUPABASE_PUBLISHABLE_KEY
npm run dev
```

Tanpa `.env`, halaman tetap bisa dibuka dalam **mode preview** (tanpa data dari Supabase).

## Halaman & FR

| Rute | Fungsi | FR |
| :--- | :--- | :--- |
| `/?location=<id>` | Katalog, pencarian, filter, detail + topping | FR-P01–P04 |
| `/cart` | Keranjang, qty, catatan, subtotal | FR-P05 |
| `/checkout` | Delivery/Pickup, ongkir, Cash/QRIS, tiket | FR-P06–P07 |
| `/track/:ticketCode` | Pelacakan status pesanan | FR-P08–P09 |
| `/riwayat` | Riwayat berdasarkan WhatsApp | FR-P10 |

Belum diimplementasikan (minggu 4): GPS otomatis, QRIS gateway, struk WhatsApp (FR-P11).

## Teknologi

React 19 + TypeScript + Vite + `@supabase/supabase-js` + `react-router-dom` + `zustand` (tersedia untuk state lanjutan).

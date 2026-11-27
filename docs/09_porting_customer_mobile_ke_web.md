# Porting UI/UX Customer dari Mobile ke Web

**Tanggal:** 27 November 2026
**Status:** RENCANA — belum dihapus kode mobile. Web harus jadi & teruji dulu, baru mobile dihapus.
**Penanggung jawab:** Tika (asal: mobile customer) → dialihkan ke web.
**Alasan:** PRD menetapkan pelanggan memakai `web_qr` (React), bukan app Flutter. Halaman customer di `mobile_app` jadi duplikat & out-of-scope. Logic/UI yang sudah dibuat Tika dipindahkan ke web agar tidak terbuang.

---

## 1. Ringkasan

Tika sudah membangun 3 halaman customer di Flutter:
- `mobile_app/lib/features/customer/checkout_page.dart` (~1548 baris)
- `mobile_app/lib/features/customer/tracking_page.dart` (~886 baris)
- `mobile_app/lib/features/customer/order_history_page.dart` (~1123 baris)

Ketiganya masih **UI mock** (data hardcoded, belum konek Supabase). Web (`web_qr`) sudah punya versi fungsional yang konek Supabase, tapi tampilan/fiturnya lebih sederhana.

**Tugas:** pindahkan UI/UX & fitur dari mobile ke web, pertahankan integrasi Supabase di web. Setelah web selesai & teruji, **hapus** 3 file customer mobile + rutenya.

---

## 2. Fitur mobile yang harus dipindahkan ke web

### 2.1 Checkout (`web_qr/src/pages/CheckoutPage.tsx`)
| Bagian mobile | Isi | Kondisi web sekarang |
| :--- | :--- | :--- |
| **Data Penerima** | Kartu terpisah: Nama, Nomor WA (diformat `628…`), catatan "Struk & update pesanan via WA" | Form biasa (nama + WA) |
| **Metode Pemenuhan** | Toggle Delivery/Pickup; **deteksi lokasi otomatis** (state: initial→loading→found→shared→failed); tampil koordinat; tombol **"Kirim Lokasi ke WhatsApp"** (`wa.me` + link Google Maps) | Delivery/Pickup + alamat teks + zona ongkir; GPS belum ada; share WA belum ada |
| **Metode Pembayaran** | Pilihan **QRIS Instant** (dengan kotak **QR preview** + badge "Auto-Verified < 2s") vs **Cash (Tunai di Tempat)** | Radio Cash/QRIS tanpa QR preview |
| **Rincian Pembayaran** | Daftar item (nama × qty + harga), subtotal, PB1, ongkir, total | Hanya subtotal/PB1/ongkir/total (tanpa daftar item) |
| **Bottom bar** | "Bayar Sekarang via QRIS" + total, sticky | Tombol "Buat pesanan" biasa |

### 2.2 Tracking (`web_qr/src/pages/TrackingPage.tsx`)
| Bagian mobile | Isi | Kondisi web sekarang |
| :--- | :--- | :--- |
| Kode tiket | Ditampilkan + **tombol salin** (copy) + snackbar | Ditampilkan saja |
| Timeline status | 4 langkah (Menunggu Konfirmasi → Diproses → Diantar → Selesai) | Sudah ada (timeline) |
| Kontak ojek/WA | Tombol buka WhatsApp ojek | Belum |
| Info pesanan | Total, metode, jenis | Sudah ada |

### 2.3 Riwayat (`web_qr/src/pages/HistoryPage.tsx`)
| Bagian mobile | Isi | Kondisi web sekarang |
| :--- | :--- | :--- |
| Cari by WA | Input nomor WA → daftar pesanan | Sudah ada |
| Filter selesai | Toggle tampilkan yang sudah selesai | Belum |
| Kartu pesanan | Kode tiket, tanggal, total, status | Sudah ada |

---

## 3. Urutan pengerjaan (Tika)

1. **Checkout** — port kartu Data Penerima, Metode Pemenuhan (deteksi GPS + share WA), Metode Pembayaran (QR preview), Rincian (daftar item), bottom bar sticky.
2. **Tracking** — tambah tombol salin kode tiket + kontak WA ojek.
3. **Riwayat** — tambah filter selesai.
4. **Validasi:** `npm run lint` + `npm run build`; uji manual mode preview (`?location=lokasi-utama`) dan dengan `.env` Supabase.
5. **Setelah lolos:** minta tech lead **hapus** `mobile_app/lib/features/customer/*` + route `/customer/*` di `app_router.dart` + import terkait.

---

## 4. Acceptance criteria

- [ ] Checkout menampilkan kartu Data Penerima, Metode Pemenuhan (GPS + share WA), Metode Pembayaran (QR preview), Rincian (daftar item), bottom bar sticky.
- [ ] Deteksi lokasi memakai `navigator.geolocation` dengan handling izin (granted/denied) dan state loading/failed.
- [ ] Share lokasi membuka `https://wa.me/…?text=…` berisi link Google Maps.
- [ ] Tracking punya tombol salin kode tiket dan kontak WA.
- [ ] Riwayat punya filter pesanan selesai.
- [ ] Data tetap dari Supabase (bukan hardcoded); fallback mock bila env kosong.
- [ ] `npm run lint` & `npm run build` lulus.
- [ ] Setelah lolos: kode customer mobile dihapus dan `flutter analyze` tetap 0 error.

---

## 5. File yang boleh diubah (web)

- `web_qr/src/pages/CheckoutPage.tsx`
- `web_qr/src/pages/TrackingPage.tsx`
- `web_qr/src/pages/HistoryPage.tsx`
- `web_qr/src/index.css` (style baru)
- `web_qr/src/lib/location.ts`, `web_qr/src/lib/pricing.ts`, `web_qr/src/types/index.ts` (bila perlu)

**Jangan** sentuh `mobile_app/` sampai web selesai & teruji.

---

## 6. Setelah web selesai (langkah penghapusan mobile)

1. Hapus folder `mobile_app/lib/features/customer/`.
2. Di `app_router.dart`: hapus 3 route `/customer/*`, import checkout/tracking/order_history, dan class `_CustomerMaterialScope` (jika tidak dipakai route lain).
3. Jalankan `flutter analyze` → 0 error.
4. Commit: `refactor(mobile): hapus halaman customer (sudah dipindah ke web)`.
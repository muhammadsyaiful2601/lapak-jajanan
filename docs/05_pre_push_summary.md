# Catatan Pre-Push (sebelum push ke GitHub)

**Tanggal:** 26 November 2026  
**Branch:** `pbl`  
**Commit terakhir sebelum push:** `202d041` ("first commit: PRD dan fondasi monorepo Lapak Jajanan")  
**Target push:** `git push -u origin pbl`

## Apa yang sudah dibuat **SEBELUH PUSH** (tidak di-commit & belum di-push)

### File yang dimodifikasi (13 file)

| File | Perubahan |
|---|---|
| `README.md` | Dokumentasi env `PUBLISHABLE_KEY`, catatan slicing belum di-push |
| `docs/02_checklist_minggu1.md` | Checklist slicing keranjang ditandai selesai |
| `web_qr/README.md` | Dokumentasi halaman & slicing UI |
| `web_qr/index.html` | Bahasa `id`, judul, meta description, theme color |
| `web_qr/src/components/Layout.tsx` | Header baru (brand, avatar, lokasi), ikon SVG, badge jumlah keranjang (+63/-13) |
| `web_qr/src/components/SetupNotice.tsx` | Teks mode preview diperbarui |
| `web_qr/src/context/CartContext.tsx` | Inisialisasi keranjang dari `localStorage` via `loadCart` (+11/-12) |
| `web_qr/src/index.css` | Tema krem–cokelat, katalog, sheet, keranjang, checkout bar (+1030/-98) |
| `web_qr/src/lib/supabase.ts` | Format rupiah tanpa spasi (`Rp15.000`) (+1/-1) |
| `web_qr/src/pages/CartPage.tsx` | Keranjang lengkap + ubah kustomisasi + upsell (+413/-37) |
| `web_qr/src/pages/CheckoutPage.tsx` | Ringkasan PB1 10% masuk `total_amount` (+7/-3) |
| `web_qr/src/pages/MenuPage.tsx` | Katalog, pencarian, filter, urutan, skeleton, mock fallback (+162/-116) |
| `web_qr/src/types/index.ts` | `MenuTone`, `CartMenuSnapshot`, `CartTopping`, field varian/topping di `CartItem` (+26) |
| `web_qr/src/data/mockCatalog.ts` | Data contoh menu/kategori/topping + dekorasi visual (+) |
| `web_qr/src/lib/pricing.ts` | Baru — konstanta & fungsi PB1 10% (`calculatePb1`, `calculateGrandTotal`) (+new) |
| `web_qr/src/components/catalog/MenuCard.tsx` | Kartu menu (+) |
| `web_qr/src/components/catalog/MenuDetailSheet.tsx` | Bottom sheet detail menu dengan ukuran, topping, catatan, qty, total real-time (+) |
| `web_qr/src/components/Layout.tsx` | Header baru, icon SVG, badge keranjang |
| `web_qr/src/components/SetupNotice.tsx` | Mode preview update |

### Path baru (untracked, belum disertakan commit)

- `web_qr/src/components/catalog/MenuCard.tsx`
- `web_qr/src/components/catalog/MenuDetailSheet.tsx`
- `web_qr/src/data/mockCatalog.ts`
- `web_qr/src/lib/pricing.ts`

### Perubahan utama (diff HEAD~1 → HEAD)

```
M README.md
M docs/02_checklist_minggu1.md
A docs/03_catatan_pekerjaan.md   (catatan lengkap pekerjaan UI)
A docs/04_pemindaian_branch.md   (scan status branch remote)
M web_qr/README.md
M web_qr/index.html
M web_qr/src/components/Layout.tsx
M web_qr/src/components/SetupNotice.tsx
A web_qr/src/components/catalog/MenuCard.tsx
A web_qr/src/components/catalog/MenuDetailSheet.tsx
M web_qr/src/context/CartContext.tsx
A web_qr/src/data/mockCatalog.ts
M web_qr/src/index.css
A web_qr/src/lib/pricing.ts
M web_qr/src/lib/supabase.ts
M web_qr/src/pages/CartPage.tsx
M web_qr/src/pages/CheckoutPage.tsx
M web_qr/src/pages/MenuPage.tsx
M web_qr/src/types/index.ts
```

### Catatan penting

1. **Mode preview** — tanpa `.env`, UI memakai `mockCatalog.ts`. Jika `VITE_SUPABASE_URL` dan `VITE_SUPABASE_PUBLISHABLE_KEY` diisi, data dari Supabase akan dipakai.
2. **PB1 Resto 10%** — tidak ada di PRD asli, tapi dipasangkan di `src/lib/pricing.ts` dan ikut masuk `total_amount` saat checkout. Perlu konfirmasi apakah harus tetap dipertahankan.
3. **Variasi ukuran (Reguler/Jumbo)** masih **UI-only** karena belum ada tabel varian di skema database. Harga Jumbo ditambahkan di sidebar keranjang.
4. **Thumbnail** memakai emoji + gradien karena data contoh belum punya foto; akan otomatis foto jika `image_url` terisi dari Supabase.
5. **Kotak "Kosongkan"** menggantikan label "Tes Keranjang Kosong".
6. **Upsell** memilih menu termurah yang belum ada di keranjang; banner hilang jika semua menu sudah masuk keranjang.
7. **Bar checkout lengket** di atas bottom nav: total pembayaran + tombol Lanjut ke Checkout.
8. **Empty state** khusus saat keranjang kosong.
9. Keranjang disimpan di `localStorage` dan tetap ada setelah reload (bug reset akibat efek ganda sudah diperbaiki).

### Verifikasi yang sudah dilakukan

- `npm run lint` → bersih
- `npm run build` → sukses
- Katalog: pencarian, filter kategori, urutan harga ✅
- Detail menu: Jumbo + topping + catatan + qty ✅
- Keranjang: ubah kustomisasi (prefill) ✅, upsell, hapus, kosongkan, reload ✅
- Checkout: bar PB1 & total ✅, konsisten dengan keranjang ✅
- Console browser: tidak ada error ✅

Preview live: `http://127.0.0.1:5174/?location=lokasi-utama` (port 5174 karena port 5173 dipakai aplikasi lain).

---

*Catatan ini hanya untuk referensi sebelum push ke GitHub. Tidak akan dipush.*

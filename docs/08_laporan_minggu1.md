# Laporan Minggu 1 — Lapak Jajanan

**Periode:** 19–26 November 2026
**Branch utama:** `pbl`
**Repository:** `https://github.com/muhammadsyaiful2601/lapak-jajanan.git`
**Penyusun laporan:** Muhammad Syaiful (pemegang branch `pbl`)

---

## 1. Ringkasan

Seluruh deliverable minggu 1 (sesuai `docs/02_checklist_minggu1.md`) telah selesai. Berdasarkan riwayat commit yang ada di repository, **pekerjaan minggu 1 dikerjakan oleh Muhammad Syaiful**. Anggota lain mulai berkontribusi pada minggu berikutnya (Tika: customer web, Hafiz: kasir POS, Rahma: owner). Branch `arum` dan `widia` belum memiliki commit di remote.

---

## 2. Deliverable minggu 1 & penanggung jawab

| No | Deliverable (sesuai checklist) | Penanggung jawab | Branch | Commit (hash) | File utama |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRD lengkap & final | Muhammad Syaiful | `pbl` / `syaiful` | `202d041` (first commit) + `875d201` | `product_requirements_document_prd_lengkap_lapak_jajanan.md` |
| 2 | Repository GitHub + branch `pbl` | Muhammad Syaiful | `pbl` | `202d041` | — |
| 3 | README utama + panduan setup | Muhammad Syaiful | `pbl` / `syaiful` | `202d041`, `875d201` | `README.md`, `docs/01_panduan_setup.md` |
| 4 | Skema database Supabase (8 tabel + RLS + seed) | Muhammad Syaiful | `pbl` / `syaiful` | `875d201` | `database/database_schema.sql`, `database/rls_policies.sql`, `database/seed.sql` |
| 5 | Scaffold Flutter `mobile_app/` (Android + iOS) | Muhammad Syaiful | `pbl` / `syaiful` | `875d201` | `mobile_app/lib/main.dart`, `mobile_app/lib/app.dart`, `mobile_app/lib/core/**` |
| 6 | Scaffold web `web_qr/` (React + TS + Vite) | Muhammad Syaiful | `pbl` / `syaiful` | `875d201` | `web_qr/src/main.tsx`, `web_qr/src/App.tsx`, `web_qr/vite.config.ts`, `web_qr/package.json` |
| 7 | Slicing UI web pelanggan: katalog, pencarian/filter, detail menu & topping, keranjang | Muhammad Syaiful | `pbl` / `syaiful` | `875d201` | `web_qr/src/pages/MenuPage.tsx`, `CartPage.tsx`, `web_qr/src/components/catalog/*`, `web_qr/src/data/mockCatalog.ts`, `web_qr/src/lib/pricing.ts` |
| 8 | Konfigurasi environment `.env.example` (tanpa secret) | Muhammad Syaiful | `pbl` / `syaiful` | `875d201` | `web_qr/.env.example` |

---

## 3. Bukti commit (riwayat Git)

| Hash | Tanggal | Penulis | Pesan |
| :--- | :--- | :--- | :--- |
| `202d041` | 2026-11-26 | muhammadsyaiful2601 | first commit: PRD dan fondasi monorepo Lapak Jajanan (Supabase, Flutter, web QR) |
| `875d201` | 2026-11-26 | muhammadsyaiful2601 | setup: fondasi monorepo, PRD, schema Supabase, scaffold Flutter & web |
| `572079a` / `5c3e3b1` | 2026-11-26 | tikawulandari | feat(customer): add checkout, order tracking, and order history UI *(mulai minggu 2+)* |
| `09f4b55` | 2026-11-26 | Hafiz-120 | feat(pos): implement kasir POS modular mingguan *(minggu 3)* |
| `43e5888` | 2026-11-26 | Rahmatulfadillah | feat(owner): slicing dashboard dan laporan owner *(minggu 4)* |

> **Catatan:** Commit `875d201` mencakup pekerjaan slicing UI web pelanggan yang sebelumnya belum di-commit (tercatat di `docs/03_catatan_pekerjaan.md`). Semua perubahan tersebut akhirnya masuk ke branch `pbl` melalui merge `572079a`.

---

## 4. Kontribusi anggota lain (status per 27 Nov 2026)

| Anggota | Branch | Status kontribusi minggu 1 |
| :--- | :--- | :--- |
| Muhammad Syaiful | `pbl`, `syaiful` | ✅ Seluruh deliverable minggu 1 |
| Tika | `tika` | Mulai berkontribusi minggu 2+ (customer checkout/tracking/history) — commit `5c3e3b1` |
| Hafiz | `hafiz` | Mulai minggu 3 (kasir POS) — commit `09f4b55` |
| Rahma | `rahma` | Mulai minggu 4 (dashboard & laporan owner) — commit `43e5888` |
| Arum | `arum` | **Belum push** (remote masih di `202d041`, commit fondasi) |
| Widia | — | Belum ada branch/commit di remote |

---

## 5. Ringkasan untuk laporan

- **Minggu 1 selesai 100%** (8/8 deliverable tercentang).
- **Penanggung jawab utama minggu 1: Muhammad Syaiful** (PRD, setup repo, skema DB, scaffold Flutter & web, slicing UI web pelanggan, .env.example, dokumentasi).
- Anggota lain baru mulai berkontribusi pada minggu 2–4 sesuai spesialisasi masing-masing.
- Arum dan Widia belum memiliki commit di remote per 27 Nov 2026.
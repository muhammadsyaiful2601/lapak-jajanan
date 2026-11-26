# mobile_app — Admin, Kasir & Owner (Flutter)

Aplikasi Flutter untuk aktor Admin dan Owner Lapak Jajanan.

## Menjalankan

```bash
flutter pub get
flutter test
flutter analyze
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
```

Aplikasi tetap bisa dibuka tanpa kredensial (UI scaffold saja). Kredensial dibaca lewat `--dart-define`, tidak disimpan di kode.

## Rute (go_router)

| Rute | Halaman | FR |
| :--- | :--- | :--- |
| `/` | Dashboard admin | FR-A01 |
| `/admin/menu` | Kelola katalog & topping | FR-A02–A05 |
| `/admin/orders` | Pesanan & dispatch ojek | FR-A06–A09, A16–A17 |
| `/pos` | Kasir walk-in | FR-A10–A15 |
| `/owner` | Laporan & monitoring owner | FR-O01–O10 |

Halaman selain dashboard saat ini berupa placeholder yang menampilkan cakupan FR; implementasi penuh mengikuti jadwal minggu 2–5.

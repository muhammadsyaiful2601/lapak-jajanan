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

Aplikasi tetap bisa dibuka tanpa kredensial; halaman admin memakai data preview lokal. Kredensial dibaca lewat `--dart-define`, tidak disimpan di kode.

Persyaratan Dart SDK: `^3.13.0` (termasuk Flutter dengan Dart 3.13 atau lebih baru).

## Rute (go_router)

| Rute | Halaman | FR |
| :--- | :--- | :--- |
| `/` | Dashboard operasional admin | FR-A01 |
| `/admin/menu` | Katalog menu & ketersediaan | FR-A02, FR-A05 |
| `/admin/categories` | Kategori menu | FR-A03 |
| `/admin/toppings` | Variasi & topping menu | FR-A04 |
| `/admin/locations` | Lokasi & jam operasional | FR-A16 |
| `/admin/locations/configure` | Konfigurasi & penyesuaian gerai | FR-A16 |
| `/admin/orders` | Pesanan & dispatch ojek | FR-A06–A09, A16–A17 |
| `/pos` | Kasir walk-in | FR-A10–A15 |
| `/owner` | Laporan & monitoring owner | FR-O01–O10 |

Lima halaman admin mengikuti referensi portal operasional dan memiliki layout responsif untuk ponsel maupun layar lebar. Formulir, filter, toggle, dan aksi CRUD saat ini berjalan pada data preview lokal; perubahan belum disimpan ke Supabase. Halaman pesanan, POS, dan owner masih berupa placeholder.

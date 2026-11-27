import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

import 'pos_shared.dart';

class PosSidebar extends StatelessWidget {
  final void Function(String, {bool error}) onNav;
  const PosSidebar({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    Widget section(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 6),
      child: Text(
        t.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1,
          fontWeight: FontWeight.w700,
          color: PosAppColors.outline,
        ),
      ),
    );
    Widget nav(IconData i, String label, {bool active = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: active ? PosAppColors.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => active
              ? null
              : onNav(
                  'Modul "$label" masih dalam pengembangan. '
                  'Estimasi pengerjaan minggu ke-2–5 sesuai roadmap PBL.',
                ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  i,
                  size: 20,
                  color: active ? Colors.white : PosAppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? Colors.white
                        : PosAppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      color: PosAppColors.white,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      posIconBox(Icons.coffee),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lapak Jajan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Admin Portal & Kasir',
                            style: TextStyle(
                              fontSize: 11,
                              color: PosAppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PosAppColors.surfaceLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.store,
                              size: 18,
                              color: PosAppColors.tertiary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Lokasi Utama',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PosAppColors.tertiary,
                              ),
                            ),
                          ],
                        ),
                        posPill(
                          'Buka',
                          bg: PosAppColors.tertiary.withValues(alpha: .1),
                          fg: PosAppColors.tertiary,
                          small: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PosAppColors.surfaceHigh.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: PosAppColors.secondaryContainer,
                          child: Icon(
                            Icons.badge,
                            size: 18,
                            color: PosAppColors.onSecondaryContainer,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bambang Irawan',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Super Admin & Kasir',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: PosAppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  section('Manajemen Menu & Toko'),
                  nav(Icons.grid_view, 'Dashboard'),
                  nav(Icons.restaurant_menu, 'Katalog Menu'),
                  nav(Icons.category, 'Kategori Menu'),
                  nav(Icons.tune, 'Variasi & Topping'),
                  nav(Icons.inventory_2, 'Ketersediaan Menu'),
                  section('Operasional & Kasir'),
                  nav(Icons.point_of_sale, 'Kasir / POS', active: true),
                  nav(Icons.receipt_long, 'Pesanan Pelanggan'),
                  nav(Icons.history, 'Riwayat Transaksi'),
                  nav(Icons.payments, 'Riwayat Kasir POS'),
                  section('Pengaturan Outlet'),
                  nav(Icons.schedule, 'Lokasi & Jam Buka'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                dense: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(Icons.logout, color: PosAppColors.error),
                title: const Text(
                  'Keluar (Logout)',
                  style: TextStyle(
                    color: PosAppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => onNav('Logout (demo)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';

import 'package:lapak_jajanan/features/shared/widgets/feature_placeholder.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.restaurant_menu_outlined,
      title: 'Kelola Katalog & Topping',
      description:
          'Tambah/edit/hapus menu, kategori, variasi, topping, dan toggle stok '
          'Tersedia/Habis yang tersinkron ke web pelanggan secara realtime.',
      frCodes: ['FR-A02', 'FR-A03', 'FR-A04', 'FR-A05'],
    );
  }
}

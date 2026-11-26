import 'package:material_ui/material_ui.dart';

import 'package:lapak_jajanan/features/shared/widgets/feature_placeholder.dart';

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.insights_outlined,
      title: 'Dashboard & Laporan Owner',
      description:
          'Pantau penjualan, pendapatan bersih, biaya pengantaran, performa '
          'operasional tiap lokasi, menu terlaris, serta ekspor PDF/CSV.',
      frCodes: [
        'FR-O01',
        'FR-O02',
        'FR-O03',
        'FR-O04',
        'FR-O05',
        'FR-O06',
        'FR-O07',
        'FR-O08',
        'FR-O09',
        'FR-O10',
      ],
    );
  }
}

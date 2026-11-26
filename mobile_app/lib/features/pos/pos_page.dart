import 'package:material_ui/material_ui.dart';

import 'package:lapak_jajanan/features/shared/widgets/feature_placeholder.dart';

class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.point_of_sale_outlined,
      title: 'Kasir Walk-In (POS)',
      description:
          'Input pesanan langsung, pilih topping, hitung total & kembalian, '
          'terima pembayaran Cash/QRIS, lalu cetak struk transaksi.',
      frCodes: ['FR-A10', 'FR-A11', 'FR-A12', 'FR-A13', 'FR-A14', 'FR-A15'],
    );
  }
}

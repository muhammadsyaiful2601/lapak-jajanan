import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/features/shared/widgets/feature_placeholder.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.history_outlined,
      title: 'Riwayat Transaksi',
      description: 'Log riwayat pesanan online yang sudah selesai.',
      frCodes: ['FR-A09'],
    );
  }
}

class PosHistoryPage extends StatelessWidget {
  const PosHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.point_of_sale_outlined,
      title: 'Riwayat Kasir POS',
      description: 'Riwayat transaksi kasir dan pratinjau cetak struk.',
      frCodes: ['FR-A15'],
    );
  }
}

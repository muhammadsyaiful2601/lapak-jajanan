import 'package:material_ui/material_ui.dart';

import 'package:lapak_jajanan/features/shared/widgets/feature_placeholder.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      icon: Icons.receipt_long_outlined,
      title: 'Pesanan & Dispatch Ojek',
      description:
          'Kelola pesanan online, ubah status (Konfirmasi → Diproses → Diantar → '
          'Selesai), dan kirim order ke ojek langganan lewat wa.me.',
      frCodes: ['FR-A06', 'FR-A07', 'FR-A08', 'FR-A09', 'FR-A16', 'FR-A17'],
    );
  }
}

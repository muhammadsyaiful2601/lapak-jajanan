import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<_DashboardOrder> _orders = [
    _DashboardOrder(
      code: '#KS-104',
      name: 'Nadia Paramita',
      detail: 'Delivery • QRIS Lunas • Pentol Kuah Pedas',
      amount: 'Rp78.000',
      status: 'Perlu konfirmasi',
      nextAction: 'Konfirmasi',
    ),
    _DashboardOrder(
      code: '#KS-103',
      name: 'Rafi Pratama',
      detail: 'Pickup • Cash • Mie Ayam Bakso',
      amount: 'Rp46.500',
      status: 'Perlu konfirmasi',
      nextAction: 'Konfirmasi',
    ),
    _DashboardOrder(
      code: '#KS-102',
      name: 'Siti Rahmawati',
      detail: 'Delivery • QRIS Lunas • Es Teh Manis',
      amount: 'Rp92.000',
      status: 'Sedang diproses',
      nextAction: 'Siap disaji',
    ),
    _DashboardOrder(
      code: '#KS-101',
      name: 'Hendra Gunawan',
      detail: 'Delivery • QRIS Lunas • Keripik Pisang',
      amount: 'Rp84.000',
      status: 'Diantar kurir',
      nextAction: 'Lacak',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Row(
          children: [
            const Expanded(
              child: AdminPageTitle(
                eyebrow: 'Ringkasan operasional harian',
                title: 'Dashboard Operasional Gerai',
                description: 'Pantau pesanan masuk, aktivitas dapur, dan ringkasan kasir hari ini.',
              ),
            ),
            const SizedBox(width: 8),
            const AdminStatusPill(label: 'Data contoh'),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final columns = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                AdminMetricCard(
                  key: const Key('dashboard-metric-confirmation'),
                  width: cardWidth,
                  label: 'Pesanan perlu konfirmasi',
                  value: '3',
                  detail: 'Pesanan baru',
                  icon: Icons.notifications_active_outlined,
                  tint: AdminColors.red,
                  background: AdminColors.redSoft,
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Sedang diproses',
                  value: '5',
                  detail: 'Tiket aktif',
                  icon: Icons.soup_kitchen_outlined,
                  tint: AdminColors.primary,
                  background: Color(0xFFF5DBCD),
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Sedang diantar',
                  value: '2',
                  detail: 'Dalam perjalanan',
                  icon: Icons.delivery_dining_outlined,
                  tint: AdminColors.green,
                  background: AdminColors.greenSoft,
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Omzet kasir hari ini',
                  value: 'Rp1,8 jt',
                  detail: '48 transaksi',
                  icon: Icons.payments_outlined,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final orders = AdminSectionCard(
              title: 'Pesanan Masuk Terbaru',
              subtitle: 'Prioritaskan pesanan dengan badge konfirmasi',
              trailing: TextButton(
                onPressed: () => context.go('/admin/orders'),
                child: const Text('Lihat semua'),
              ),
              child: Column(
                children: [
                  for (final order in _orders) ...[
                    _OrderRow(
                      order: order,
                      onAction: () => _advanceOrder(order),
                    ),
                    if (order != _orders.last)
                      const Divider(height: 20, color: AdminColors.border),
                  ],
                ],
              ),
            );
            final outlet = AdminSectionCard(
              title: 'Lapak Jajanan — Lokasi Utama',
              subtitle: 'Status outlet dan jam layanan',
              trailing: const AdminStatusPill(label: 'Buka'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _InfoLine(
                    icon: Icons.schedule_outlined,
                    label: 'Jam operasional',
                    value: '09.00 – 21.00 WIB',
                  ),
                  const SizedBox(height: 12),
                  const _InfoLine(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat gerai',
                    value: 'Jl. Merdeka No. 12',
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/admin/locations'),
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Kelola lokasi'),
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Aktivitas kasir POS',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const _InfoLine(
                    icon: Icons.point_of_sale_outlined,
                    label: 'Kasir aktif',
                    value: 'Admin Lapak',
                  ),
                  const SizedBox(height: 10),
                  const _InfoLine(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Saldo laci kasir',
                    value: 'Rp300.000',
                  ),
                  const SizedBox(height: 10),
                  const _InfoLine(
                    icon: Icons.qr_code_2_outlined,
                    label: 'Total Pembayaran QRIS',
                    value: 'Rp254.000',
                  ),
                ],
              ),
            );

            if (constraints.maxWidth >= 1120) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: orders),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: outlet),
                ],
              );
            }
            return Column(
              children: [orders, const SizedBox(height: 16), outlet],
            );
          },
        ),
      ],
    );
  }

  void _advanceOrder(_DashboardOrder order) {
    if (order.status == 'Diantar kurir') {
      context.go('/admin/orders');
      return;
    }
    setState(() {
      final index = _orders.indexOf(order);
      if (index < 0) return;
      if (order.status == 'Perlu konfirmasi') {
        _orders[index] = order.copyWith(
          status: 'Sedang diproses',
          nextAction: 'Siap disaji',
        );
      } else if (order.status == 'Sedang diproses') {
        _orders[index] = order.copyWith(
          status: 'Siap diambil',
          nextAction: 'Selesai',
        );
      } else {
        _orders[index] = order.copyWith(
          status: 'Selesai',
          nextAction: 'Selesai',
        );
      }
    });
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.onAction});

  final _DashboardOrder order;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final details = Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                order.code.replaceFirst('#', ''),
                key: Key('order-code-${order.code}'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AdminColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AdminColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    order.amount,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        );
        final actions = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            AdminStatusPill(
              label: order.status,
              isActive: order.status != 'Perlu konfirmasi',
            ),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: order.status == 'Perlu konfirmasi'
                    ? AdminColors.primary
                    : AdminColors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(order.nextAction),
            ),
          ],
        );

        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              details,
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: actions),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: details),
            const SizedBox(width: 12),
            actions,
          ],
        );
      },
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 19, color: AdminColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(color: AdminColors.muted)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _DashboardOrder {
  const _DashboardOrder({
    required this.code,
    required this.name,
    required this.detail,
    required this.amount,
    required this.status,
    required this.nextAction,
  });

  final String code;
  final String name;
  final String detail;
  final String amount;
  final String status;
  final String nextAction;

  _DashboardOrder copyWith({String? status, String? nextAction}) {
    return _DashboardOrder(
      code: code,
      name: name,
      detail: detail,
      amount: amount,
      status: status ?? this.status,
      nextAction: nextAction ?? this.nextAction,
    );
  }
}

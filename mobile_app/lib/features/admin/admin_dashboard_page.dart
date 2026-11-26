import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Dashboard Admin', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Ringkasan operasional hari ini (FR-A01)'),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                _MetricCard(label: 'Lokasi Buka', value: '—', icon: Icons.storefront_outlined),
                _MetricCard(label: 'Ojek Online', value: '—', icon: Icons.two_wheeler_outlined),
                _MetricCard(label: 'Pesanan Aktif', value: '—', icon: Icons.shopping_bag_outlined),
                _MetricCard(label: 'Omzet Hari Ini', value: '—', icon: Icons.attach_money_outlined),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Text('Pintasan', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Shortcut(label: 'Kelola Menu', icon: Icons.restaurant_menu_outlined, onTap: () => context.go('/admin/menu')),
            _Shortcut(label: 'Pesanan Masuk', icon: Icons.receipt_long_outlined, onTap: () => context.go('/admin/orders')),
            _Shortcut(label: 'Kasir Walk-In', icon: Icons.point_of_sale_outlined, onTap: () => context.go('/pos')),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Status koneksi Supabase'),
            subtitle: const Text('Angka akan terisi otomatis setelah backend terhubung.'),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const Spacer(),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), avatar: Icon(icon, size: 18), onPressed: onTap);
  }
}

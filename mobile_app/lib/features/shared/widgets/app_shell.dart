import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _managementDestinations = [
    _Destination('Dashboard', Icons.dashboard_outlined, '/'),
    _Destination('Katalog Menu', Icons.restaurant_menu_outlined, '/admin/menu'),
    _Destination('Kategori Menu', Icons.category_outlined, '/admin/categories'),
  ];

  static const _operationalDestinations = [
    _Destination('Kasir / POS', Icons.point_of_sale_outlined, '/pos'),
    _Destination(
      'Pesanan Pelanggan',
      Icons.receipt_long_outlined,
      '/admin/orders',
    ),
    _Destination(
      'Riwayat Transaksi',
      Icons.history_outlined,
      '/admin/transactions',
    ),
    _Destination(
      'Riwayat Kasir POS',
      Icons.point_of_sale_outlined,
      '/admin/pos-history',
    ),
  ];

  static const _outletDestinations = [
    _Destination(
      'Lokasi & Jam Buka',
      Icons.storefront_outlined,
      '/admin/locations',
    ),
  ];

  static const _destinations = [
    ..._managementDestinations,
    ..._operationalDestinations,
    ..._outletDestinations,
  ];

  static const _mobileDestinations = [
    _Destination('Admin', Icons.dashboard_outlined, '/'),
    _Destination('Menu', Icons.restaurant_menu_outlined, '/admin/menu'),
    _Destination('Pesanan', Icons.receipt_long_outlined, '/admin/orders'),
    _Destination('Kasir', Icons.point_of_sale_outlined, '/pos'),
  ];

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final selectedPath = _selectedPath(path);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return Scaffold(
            backgroundColor: AdminColors.canvas,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 258,
                  child: _DesktopSidebar(
                    selectedPath: selectedPath,
                    managementDestinations: _managementDestinations,
                    operationalDestinations: _operationalDestinations,
                    outletDestinations: _outletDestinations,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const _DesktopHeader(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1500),
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final destinationIndex = _mobileDestinations.indexWhere(
          (destination) => destination.path == selectedPath,
        );
        final mobileIndex = destinationIndex < 0
            ? (selectedPath.startsWith('/admin/') ? 1 : 0)
            : destinationIndex;
        return Scaffold(
          backgroundColor: AdminColors.canvas,
          drawer: _MobileDrawer(
            selectedPath: selectedPath,
            destinations: _destinations,
          ),
          appBar: AppBar(
            title: const Text(
              'Lapak Jajanan',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Center(
                  child: AdminStatusPill(
                    label: selectedPath == '/admin/locations'
                        ? 'Lokasi'
                        : 'Lokasi Utama',
                  ),
                ),
              ),
            ],
          ),
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: mobileIndex < 0 ? 0 : mobileIndex,
            onDestinationSelected: (index) =>
                context.go(_mobileDestinations[index].path),
            destinations: [
              for (final destination in _mobileDestinations)
                NavigationDestination(
                  icon: Icon(destination.icon),
                  label: destination.label,
                ),
            ],
          ),
        );
      },
    );
  }

  String _selectedPath(String path) {
    for (final destination in _destinations) {
      if (destination.path == '/') {
        if (path == '/') return destination.path;
      } else if (path.startsWith(destination.path)) {
        return destination.path;
      }
    }
    return '/';
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.selectedPath,
    required this.managementDestinations,
    required this.operationalDestinations,
    required this.outletDestinations,
  });

  final String selectedPath;
  final List<_Destination> managementDestinations;
  final List<_Destination> operationalDestinations;
  final List<_Destination> outletDestinations;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AdminColors.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 22, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AdminColors.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lapak Jajanan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Admin Portal & Kasir',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AdminColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.storefront_outlined,
                    size: 18,
                    color: AdminColors.green,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Lokasi Utama', style: TextStyle(fontSize: 13)),
                  ),
                  AdminStatusPill(label: 'Buka'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      'MANAJEMEN MENU & TOKO',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.8,
                        color: AdminColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final destination in managementDestinations)
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination.path == selectedPath,
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 18, 8, 8),
                    child: Text(
                      'OPERASIONAL & KASIR',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.8,
                        color: AdminColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final destination in operationalDestinations)
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination.path == selectedPath,
                    ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8, 18, 8, 8),
                    child: Text(
                      'PENGATURAN OUTLET',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0.8,
                        color: AdminColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final destination in outletDestinations)
                    _SidebarItem(
                      destination: destination,
                      isSelected: destination.path == selectedPath,
                    ),
                ],
              ),
            ),
            const Divider(color: AdminColors.border),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AdminColors.soft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Color(0xFFF5DBCD),
                    child: Icon(
                      Icons.person_outline,
                      size: 19,
                      color: AdminColors.primary,
                    ),
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Lapak',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Super Admin & Kasir',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: AdminColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AdminColors.red),
              label: const Text(
                'Keluar (Logout)',
                style: TextStyle(color: AdminColors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.selectedPath, required this.destinations});

  final String selectedPath;
  final List<_Destination> destinations;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AdminColors.canvas,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 14, 12, 18),
              child: Text(
                'Navigasi Admin',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
            ),
            for (final destination in destinations)
              _SidebarItem(
                destination: destination,
                isSelected: destination.path == selectedPath,
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.destination, required this.isSelected});

  final _Destination destination;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: isSelected,
        selectedTileColor: AdminColors.primary,
        selectedColor: Colors.white,
        leading: Icon(destination.icon, size: 19),
        title: Text(
          destination.label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          Scaffold.maybeOf(context)?.closeDrawer();
          context.go(destination.path);
        },
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.storefront_outlined,
            size: 18,
            color: AdminColors.muted,
          ),
          const SizedBox(width: 8),
          const Text(
            'Portal Admin',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Icon(Icons.chevron_right, size: 18, color: AdminColors.muted),
          const Spacer(),
          SizedBox(
            width: 280,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari menu, pesanan, pelanggan...',
                prefixIcon: Icon(Icons.search, size: 19),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const AdminStatusPill(label: 'Senja Tebet (Utama)'),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => context.go('/pos'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Transaksi Baru'),
            style: FilledButton.styleFrom(
              backgroundColor: AdminColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AdminColors.primary,
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Destination {
  const _Destination(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

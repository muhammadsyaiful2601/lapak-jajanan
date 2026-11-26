import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

/// Shell bersama untuk seluruh halaman: AppBar + bottom navigation.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const List<_Destination> _destinations = [
    _Destination('Admin', Icons.dashboard_outlined, '/'),
    _Destination('Menu', Icons.restaurant_menu_outlined, '/admin/menu'),
    _Destination('Pesanan', Icons.receipt_long_outlined, '/admin/orders'),
    _Destination('Kasir', Icons.point_of_sale_outlined, '/pos'),
    _Destination('Owner', Icons.insights_outlined, '/owner'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    var selectedIndex = 0;
    for (var i = 0; i < _destinations.length; i++) {
      if (currentPath.startsWith(_destinations[i].path)) selectedIndex = i;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapak Jajanan'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text(widgetLabel(selectedIndex))),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            context.go(_destinations[index].path),
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  static String widgetLabel(int index) => _destinations[index].label;
}

class _Destination {
  const _Destination(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}

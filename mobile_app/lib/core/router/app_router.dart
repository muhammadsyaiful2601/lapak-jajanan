import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/admin/admin_dashboard_page.dart';
import 'package:lapak_jajanan/features/admin/catalog_page.dart';
import 'package:lapak_jajanan/features/admin/categories_page.dart';
import 'package:lapak_jajanan/features/admin/history_pages.dart';
import 'package:lapak_jajanan/features/admin/locations_page.dart';
import 'package:lapak_jajanan/features/admin/outlet_configuration_page.dart';
import 'package:lapak_jajanan/features/admin/outlet_model.dart';
import 'package:lapak_jajanan/features/admin/orders_page.dart';
import 'package:lapak_jajanan/features/admin/toppings_page.dart';
import 'package:lapak_jajanan/features/owner/owner_dashboard_page.dart';
import 'package:lapak_jajanan/features/pos/pos_page.dart';
import 'package:lapak_jajanan/features/shared/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: '/admin/menu',
          builder: (context, state) => const CatalogPage(),
        ),
        GoRoute(
          path: '/admin/categories',
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: '/admin/toppings',
          builder: (context, state) => const ToppingsPage(),
        ),
        GoRoute(
          path: '/admin/locations',
          builder: (context, state) => const LocationsPage(),
        ),
        GoRoute(
          path: '/admin/locations/configure',
          builder: (context, state) {
            final extra = state.extra;
            final outlet = extra is Outlet ? extra : createDemoOutlets().first;
            return OutletConfigurationPage(outlet: outlet);
          },
        ),
        GoRoute(
          path: '/admin/orders',
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/admin/transactions',
          builder: (context, state) => const TransactionHistoryPage(),
        ),
        GoRoute(
          path: '/admin/pos-history',
          builder: (context, state) => const PosHistoryPage(),
        ),
        GoRoute(path: '/pos', builder: (context, state) => const PosPage()),
        GoRoute(
          path: '/owner',
          builder: (context, state) => const OwnerDashboardPage(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
    body: Center(child: Text(state.error.toString())),
  ),
);

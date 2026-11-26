import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/admin/admin_dashboard_page.dart';
import 'package:lapak_jajanan/features/admin/catalog_page.dart';
import 'package:lapak_jajanan/features/admin/orders_page.dart';
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
          path: '/admin/orders',
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/pos',
          builder: (context, state) => const PosPage(),
        ),
      ],
    ),
    // Owner memakai OwnerShell sendiri (sidebar + header), jadi tidak dibungkus AppShell.
    GoRoute(
      path: '/owner',
      builder: (context, state) => const OwnerDashboardPage(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
    body: Center(child: Text(state.error.toString())),
  ),
);

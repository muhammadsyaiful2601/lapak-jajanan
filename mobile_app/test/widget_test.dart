import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapak_jajanan/core/router/app_router.dart';
import 'package:lapak_jajanan/core/startup/app_bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Scaffold aplikasi admin menampilkan dashboard', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));

    expect(find.text('Lapak Jajanan'), findsWidgets);
    expect(find.text('Dashboard Operasional Gerai'), findsOneWidget);
    expect(find.text('Total Pembayaran QRIS'), findsOneWidget);
    expect(find.text('Rp254.000'), findsOneWidget);
    expect(find.text('Saldo laci kasir'), findsOneWidget);
    expect(find.byIcon(Icons.point_of_sale_outlined), findsWidgets);
  });

  testWidgets('Halaman admin baru dapat dibuka melalui rute', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));

    const pages = {
      '/admin/menu': 'Katalog & Pengelolaan Menu',
      '/admin/categories': 'Pengelolaan Kategori Menu',
      '/admin/toppings': 'Variasi & Topping Menu',
      '/admin/locations': 'Pengelolaan Lokasi & Jam Operasional',
      '/admin/locations/configure': 'Konfigurasi & Penyesuaian Gerai',
      '/admin/transactions': 'Riwayat Transaksi',
      '/admin/pos-history': 'Riwayat Kasir POS',
    };

    for (final entry in pages.entries) {
      appRouter.go(entry.key);
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget, reason: entry.key);
    }

    appRouter.go('/');
    await tester.pumpAndSettle();
  });

  testWidgets('Konfigurasi gerai ada di halaman terpisah', (tester) async {
    tester.view.physicalSize = const Size(1440, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    appRouter.go('/admin/locations');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    expect(find.text('Form konfigurasi gerai'), findsNothing);
    await tester.tap(find.byKey(const Key('configure-selected-outlet')));
    await tester.pumpAndSettle();
    expect(find.text('Konfigurasi & Penyesuaian Gerai'), findsOneWidget);
    expect(find.text('Form konfigurasi gerai'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('outlet-name')), 'Lokasi Uji');
    await _hideKeyboard(tester);
    await tester.ensureVisible(
      find.byKey(const Key('save-outlet-configuration')),
    );
    await tester.tap(find.byKey(const Key('save-outlet-configuration')));
    await tester.pumpAndSettle();

    expect(find.text('Pengelolaan Lokasi & Jam Operasional'), findsOneWidget);
    expect(find.text('Lokasi Uji'), findsWidgets);
    expect(
      find.text('Pengaturan gerai disimpan di preview lokal.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Dashboard tampil pada layout desktop', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    appRouter.go('/');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Operasional Gerai'), findsOneWidget);
    expect(find.text('Portal Admin'), findsOneWidget);
    expect(find.text('Dashboard Owner'), findsNothing);
    expect(find.text('Lokasi Utama'), findsOneWidget);
    expect(find.text('Super Admin & Kasir'), findsOneWidget);
    expect(
      tester
          .getSize(find.byKey(const Key('dashboard-metric-confirmation')))
          .width,
      greaterThan(250),
    );
    final orderCodeLeft = tester
        .getTopLeft(find.byKey(const Key('order-code-#KS-104')))
        .dx;
    for (final code in ['#KS-103', '#KS-102', '#KS-101']) {
      expect(
        tester.getTopLeft(find.byKey(Key('order-code-$code'))).dx,
        closeTo(orderCodeLeft, 0.1),
      );
    }
    final sidebarLabels = [
      'Kasir / POS',
      'Pesanan Pelanggan',
      'Riwayat Transaksi',
      'Riwayat Kasir POS',
      'PENGATURAN OUTLET',
      'Lokasi & Jam Buka',
    ];
    for (var index = 0; index < sidebarLabels.length - 1; index++) {
      expect(
        tester.getTopLeft(find.text(sidebarLabels[index])).dy,
        lessThan(tester.getTopLeft(find.text(sidebarLabels[index + 1])).dy),
        reason: '${sidebarLabels[index]} precedes ${sidebarLabels[index + 1]}',
      );
    }
    expect(
      tester.getTopLeft(find.text('Lokasi Utama')).dy,
      lessThan(tester.getTopLeft(find.text('Super Admin & Kasir')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Super Admin & Kasir')).dy,
      lessThan(tester.getTopLeft(find.text('Keluar (Logout)')).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Header desktop responsif dan placeholder menampilkan estimasi', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1124, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    appRouter.go('/');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    appRouter.go('/admin/orders');
    await tester.pumpAndSettle();
    expect(find.text('Dalam Pengembangan'), findsOneWidget);
    expect(
      find.text('Estimasi pengerjaan: minggu ke-2–5 sesuai roadmap PBL.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Halaman utama tetap muat di ponsel, tablet, dan desktop', (
    tester,
  ) async {
    const viewports = [
      Size(320, 640),
      Size(390, 844),
      Size(768, 1024),
      Size(1024, 768),
    ];
    const routes = [
      '/',
      '/admin/menu',
      '/admin/categories',
      '/admin/toppings',
      '/admin/locations',
      '/admin/locations/configure',
      '/admin/orders',
      '/admin/transactions',
      '/admin/pos-history',
      '/pos',
      '/owner',
    ];

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in viewports) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      appRouter.go('/');
      await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '/ at $viewport');

      for (final route in routes.skip(1)) {
        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$route at $viewport');
      }
    }
  });

  testWidgets('Laporan owner responsif di ponsel dan tablet', (tester) async {
    const viewports = [
      Size(320, 640),
      Size(390, 844),
      Size(768, 1024),
      Size(1024, 768),
    ];
    const reports = {
      'Laporan Penjualan': 'Laporan Penjualan & Pendapatan Usaha',
      'Laporan Transaksi': 'Laporan Seluruh Transaksi Penjualan',
      'Laporan Metode Pembayaran': 'Laporan Metode Pembayaran',
      'Laporan Jenis Pesanan':
          'Laporan Komparasi Jenis Pesanan (Delivery vs Pickup)',
    };

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final viewport in viewports) {
      tester.view.physicalSize = viewport;
      tester.view.devicePixelRatio = 1;
      appRouter.go('/owner');
      await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
      await tester.pumpAndSettle();

      for (final entry in reports.entries) {
        await tester.tap(find.byIcon(Icons.menu_rounded));
        await tester.pumpAndSettle();
        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();
        expect(find.text(entry.value), findsOneWidget, reason: entry.key);
        expect(tester.takeException(), isNull, reason: '$entry at $viewport');
      }
    }
  });

  testWidgets('Filter katalog rata kiri dan kartu ringkasan responsif', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    appRouter.go('/admin/menu');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const Key('catalog-metric-total'))).width,
      greaterThan(250),
    );
    expect(
      tester.getTopLeft(find.text('Semua')).dx,
      closeTo(tester.getTopLeft(find.text('Semua status')).dx, 0.1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Baris kategori mengisi kolom dan rata dengan kolom pencarian', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    appRouter.go('/admin/categories');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    final searchLeft = tester
        .getTopLeft(find.byKey(const Key('category-search')))
        .dx;
    final row = find.byKey(const Key('category-row-Makanan Berat'));
    expect(tester.getSize(row).width, greaterThan(600));
    expect(tester.getTopLeft(row).dx, closeTo(searchLeft, 8));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Editor menu mengelola variasi dan grup pilihan di mobile', (
    tester,
  ) async {
    _useMobileViewport(tester);
    appRouter.go('/admin/menu');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tambah Menu Baru'));
    await tester.pumpAndSettle();
    expect(find.text('Tambah Menu'), findsOneWidget);
    expect(find.byKey(const Key('menu-name')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const Key('pick-menu-photo'))).dy,
      lessThan(
        tester.getTopLeft(find.byKey(const Key('menu-availability'))).dy,
      ),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('menu-availability'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const Key('menu-name'))).dy),
    );
    expect(find.byKey(const Key('pick-menu-photo')), findsOneWidget);
    expect(find.byKey(const Key('menu-image-url')), findsNothing);
    await tester.enterText(find.byKey(const Key('menu-name')), 'Menu Uji');
    await tester.enterText(find.byKey(const Key('menu-price')), '12000');
    await _hideKeyboard(tester);

    await tester.ensureVisible(find.byKey(const Key('add-variation')));
    await tester.tap(find.byKey(const Key('add-variation')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('variation-name')), 'Ukuran');
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('add-variation-option')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('option-name')), 'Large');
    await tester.enterText(find.byKey(const Key('option-price')), '5000');
    await tester.tap(find.text('Opsi tersedia'));
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('save-option')));
    await tester.pumpAndSettle();
    expect(find.text('Habis'), findsOneWidget);
    await tester.tap(find.byKey(const Key('save-variation')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('variation-group-Ukuran')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('add-choice-group')));
    await tester.tap(find.byKey(const Key('add-choice-group')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('choice-group-name')),
      'Pilih topping',
    );
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('choice-kind')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opsional').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('choice-maximum')), '3');
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('add-choice-option')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('option-name')), 'Telur');
    await tester.enterText(find.byKey(const Key('option-price')), '5000');
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('save-option')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-choice-group')));
    await tester.pumpAndSettle();
    expect(find.text('Opsional, maksimal 3 pilihan'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('save-menu')));
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('menu-name')))
          .controller!
          .text,
      'Menu Uji',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('menu-price')))
          .controller!
          .text,
      '12000',
    );
    await tester.tap(find.byKey(const Key('save-menu')));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('Menu Uji'),
      find.byKey(const Key('catalog-scroll-view')),
      const Offset(0, -300),
    );
    expect(find.text('Menu Uji'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Add-on dapat dibuat dan dikelola terpisah per menu', (
    tester,
  ) async {
    _useMobileViewport(tester);
    appRouter.go('/admin/menu');
    await tester.pumpWidget(const ProviderScope(child: AppBootstrap()));
    await tester.pumpAndSettle();

    final editBaksoMenu = find.byTooltip('Edit menu Mie Ayam Bakso');
    await _scrollCatalogItemIntoView(tester, editBaksoMenu);
    await tester.tap(editBaksoMenu);
    await tester.pumpAndSettle();
    final baksoSwitch = find.byKey(const Key('addon-availability-extra-bakso'));
    await tester.ensureVisible(baksoSwitch);
    await tester.tap(baksoSwitch);
    await tester.pumpAndSettle();
    final baksoCard = find.byKey(const Key('menu-addon-extra-bakso'));
    expect(
      find.descendant(of: baksoCard, matching: find.text('Habis')),
      findsOneWidget,
    );
    await tester.tap(baksoSwitch);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: baksoCard, matching: find.text('Habis')),
      findsNothing,
    );
    expect(find.text('Gunakan add-on tersimpan'), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('add-addon')));
    await tester.tap(find.byKey(const Key('add-addon')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('addon-name')), 'Telur');
    await tester.enterText(find.byKey(const Key('addon-price')), '5000');
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('save-addon')));
    await tester.pumpAndSettle();
    expect(find.text('Telur'), findsWidgets);

    await tester.tap(find.byTooltip('Edit add-on Telur'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('addon-name')), 'Telur Rebus');
    await tester.enterText(find.byKey(const Key('addon-price')), '6000');
    await _hideKeyboard(tester);
    await tester.tap(find.byKey(const Key('save-addon')));
    await tester.pumpAndSettle();
    expect(find.text('Telur Rebus'), findsWidgets);

    await tester.tap(find.byTooltip('Hapus add-on Telur Rebus'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('save-menu')));
    await tester.tap(find.byKey(const Key('save-menu')));
    await tester.pumpAndSettle();
    final editPentolMenu = find.byTooltip('Edit menu Pentol Kuah Pedas');
    await _scrollCatalogItemIntoView(tester, editPentolMenu);
    await tester.tap(editPentolMenu);
    await tester.pumpAndSettle();
    expect(find.text('Telur Rebus'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

void _useMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _hideKeyboard(WidgetTester tester) async {
  tester.testTextInput.hide();
  await tester.pumpAndSettle();
}

Future<void> _scrollCatalogItemIntoView(
  WidgetTester tester,
  Finder item,
) async {
  final viewport = find.byKey(const Key('catalog-scroll-view'));
  for (var attempt = 0; attempt < 8; attempt++) {
    if (item.evaluate().isEmpty) {
      await tester.drag(viewport, const Offset(0, -400));
      await tester.pumpAndSettle();
      continue;
    }
    final itemRect = tester.getRect(item);
    final viewportRect = tester.getRect(viewport);
    if (itemRect.top >= viewportRect.top &&
        itemRect.bottom <= viewportRect.bottom) {
      return;
    }
    final direction = itemRect.bottom > viewportRect.bottom ? -1.0 : 1.0;
    await tester.drag(viewport, Offset(0, direction * 400));
    await tester.pumpAndSettle();
  }
  expect(item.evaluate(), isNotEmpty, reason: 'Catalog item should be built.');
  expect(tester.getRect(item).overlaps(tester.getRect(viewport)), isTrue);
}

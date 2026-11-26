import 'package:flutter/material.dart';
import '../../../core/theme/owner_theme.dart';

class OwnerShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectMenu;
  final VoidCallback? onLogout;
  final Widget child;

  const OwnerShell({
    super.key,
    required this.selectedIndex,
    required this.onSelectMenu,
    required this.child,
    this.onLogout,
  });

  static const List<({String label, IconData icon})> navItems = [
    (label: 'Dashboard', icon: Icons.pie_chart_rounded),
    (label: 'Laporan Penjualan', icon: Icons.trending_up_rounded),
    (label: 'Laporan Transaksi', icon: Icons.receipt_long_rounded),
    (label: 'Laporan Metode Pembayaran', icon: Icons.credit_card_rounded),
    (label: 'Laporan Jenis Pesanan', icon: Icons.shopping_bag_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Theme(
      data: OwnerTheme.theme,
      child: Scaffold(
        backgroundColor: OwnerColors.surface,
        drawer: isDesktop
            ? null
            : Drawer(
                backgroundColor: OwnerColors.surfaceContainerLow,
                child: _buildSidebarContent(context, closeDrawerOnTap: true),
              ),
        body: Row(
          children: [
            if (isDesktop)
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: OwnerColors.surfaceContainerLow,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: _buildSidebarContent(context),
              ),
            Expanded(
              child: Column(
                children: [
                  _buildTopHeader(context, isDesktop),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, {bool closeDrawerOnTap = false}) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lapak Jajan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: OwnerColors.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: OwnerColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Owner View',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: OwnerColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Executive Analytics Portal',
                      style: TextStyle(
                        fontSize: 12,
                        color: OwnerColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(navItems.length, (index) {
                    final item = navItems[index];
                    final isActive = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          onSelectMenu(index);
                          if (closeDrawerOnTap) Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: isActive ? OwnerColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: isActive ? OwnerColors.onPrimary : OwnerColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive ? OwnerColors.onPrimary : OwnerColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: OwnerColors.surfaceContainer.withValues(alpha: 0.6),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: OwnerColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: OwnerColors.primary,
                        child: Text(
                          'HG',
                          style: TextStyle(
                            color: OwnerColors.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hendra Gunawan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: OwnerColors.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Owner Access',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: OwnerColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: onLogout ??
                        () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                    style: TextButton.styleFrom(
                      backgroundColor: OwnerColors.surfaceContainerHigh,
                      foregroundColor: OwnerColors.onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Keluar (Logout)',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
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

  Widget _buildTopHeader(BuildContext context, bool isDesktop) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: OwnerColors.surface.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isDesktop)
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              const Icon(Icons.storefront_rounded, color: OwnerColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Lapak Jajan Group',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OwnerColors.onSurface,
                ),
              ),
              if (MediaQuery.of(context).size.width > 640) ...[
                const SizedBox(width: 6),
                const Text(
                  '(2 Gerai: Senja Tebet & Pasar Kuliner)',
                  style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                ),
              ],
              if (isDesktop) ...[
                const SizedBox(width: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: OwnerColors.tertiaryFixed,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(radius: 3.5, backgroundColor: OwnerColors.tertiary),
                      SizedBox(width: 6),
                      Text(
                        'Live Sync Data',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: OwnerColors.onTertiaryFixed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              if (MediaQuery.of(context).size.width > 540)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: OwnerColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 15, color: OwnerColors.onSurfaceVariant),
                      SizedBox(width: 6),
                      Text(
                        'Periode: Hari Ini',
                        style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 10),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_none_rounded, color: OwnerColors.onSurfaceVariant),
                  ),
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(radius: 4, backgroundColor: OwnerColors.primary),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              const CircleAvatar(
                radius: 16,
                backgroundColor: OwnerColors.primary,
                child: Icon(Icons.person_rounded, size: 18, color: OwnerColors.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
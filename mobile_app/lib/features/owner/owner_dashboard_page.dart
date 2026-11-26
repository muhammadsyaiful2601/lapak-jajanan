import 'package:flutter/material.dart';
import '../../core/theme/owner_theme.dart';
import '../../data/models/analytics_models.dart';
import 'order_type_page.dart';
import 'payment_method_page.dart';
import 'sales_report_page.dart';
import 'transaction_report_page.dart';
import 'widgets/custom_charts.dart';
import 'widgets/kpi_card.dart';
import 'widgets/owner_shell.dart';

class OwnerDashboardPage extends StatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  int _selectedMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OwnerDashboardContent(
        onNavigateToTransactions: () => setState(() => _selectedMenuIndex = 2),
      ),
      const SalesReportPage(),
      const TransactionReportPage(),
      const PaymentMethodPage(),
      const OrderTypePage(),
    ];

    return OwnerShell(
      selectedIndex: _selectedMenuIndex,
      onSelectMenu: (index) => setState(() => _selectedMenuIndex = index),
      child: pages[_selectedMenuIndex],
    );
  }
}

class _OwnerDashboardContent extends StatefulWidget {
  final VoidCallback onNavigateToTransactions;

  const _OwnerDashboardContent({required this.onNavigateToTransactions});

  @override
  State<_OwnerDashboardContent> createState() => _OwnerDashboardContentState();
}

class _OwnerDashboardContentState extends State<_OwnerDashboardContent> {
  int _selectedPreset = 1;
  bool _isRefreshing = false;

  void _triggerRefresh() {
    setState(() => _isRefreshing = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 960;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 20),

        // 4 Metrik Finansial & Operasional Utama
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 560
                    ? 2
                    : 1;
            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: crossAxisCount == 1 ? 2.1 : 1.38,
              children: const [
                KpiMetricCard(
                  title: 'Total Penjualan (Gross)',
                  value: 'Rp 48,75 Jt',
                  badgeText: '+14.2%',
                  badgeSubtext: 'vs 7 hari lalu',
                  footerLeft: 'Bruto: Rp 48.750.000',
                  footerRight: 'Target 108%',
                  icon: Icons.payments_rounded,
                ),
                KpiMetricCard(
                  title: 'Pendapatan Bersih (Net)',
                  value: 'Rp 43,88 Jt',
                  valueColor: OwnerColors.primary,
                  badgeText: '+12.8%',
                  badgeSubtext: 'Setelah PB1 & diskon',
                  footerLeft: 'Potongan: Rp 4.875.000',
                  footerRight: 'Margin 90.0%',
                  footerRightColor: OwnerColors.onSurface,
                  icon: Icons.account_balance_wallet_rounded,
                  iconBgColor: OwnerColors.tertiaryFixed,
                  iconColor: OwnerColors.onTertiaryFixedVariant,
                ),
                KpiMetricCard(
                  title: 'Jumlah Transaksi',
                  value: '1.428',
                  badgeText: '+6.4%',
                  badgeSubtext: '59 nota / hari',
                  footerLeft: 'AOV (Rata-rata Nota)',
                  footerRight: 'Rp 34.138',
                  footerRightColor: OwnerColors.onSurface,
                  icon: Icons.receipt_long_rounded,
                  iconBgColor: OwnerColors.surfaceContainerHigh,
                  iconColor: OwnerColors.secondary,
                ),
                KpiMetricCard(
                  title: 'Volume Pesanan Dapur',
                  value: '3.864',
                  badgeText: '+8.5%',
                  badgeSubtext: 'Porsi & Cup Minuman',
                  footerLeft: 'Efisiensi Sajian',
                  footerRight: '9.2 mnt / pesanan',
                  icon: Icons.restaurant_rounded,
                  iconBgColor: OwnerColors.secondaryContainer,
                  iconColor: OwnerColors.onSecondaryContainer,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),

        _buildTrendChartSection(),
        const SizedBox(height: 20),

        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildLeftPaymentAndOrderColumn()),
              const SizedBox(width: 20),
              Expanded(flex: 7, child: _buildTop5MenuCard()),
            ],
          )
        else ...[
          _buildLeftPaymentAndOrderColumn(),
          const SizedBox(height: 20),
          _buildTop5MenuCard(),
        ],
        const SizedBox(height: 20),

        _buildRecentTransactionsCard(),
      ],
    );
  }

  Widget _buildHeaderBanner() {
    final presets = ['Hari Ini', '7 Hari Terakhir', 'Bulan Ini (Okt 2023)'];

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 12,
      spacing: 16,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'RINGKASAN EKSEKUTIF',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: OwnerColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(radius: 2.5, backgroundColor: OwnerColors.outlineVariant),
                SizedBox(width: 8),
                Text(
                  'Update: 24 Okt 2023, 21:40 WIB',
                  style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Dashboard Eksekutif Kinerja Usaha',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: OwnerColors.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Pemantauan real-time performa finansial, volume penjualan, dan tren operasional gabungan Lapak Jajan (Gerai Tebet & Pasar Kuliner).',
              style: TextStyle(fontSize: 13.5, color: OwnerColors.onSurfaceVariant),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...List.generate(presets.length, (i) {
                final active = _selectedPreset == i;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => setState(() => _selectedPreset = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? OwnerColors.surfaceContainerLowest : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      presets[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                        color: active ? OwnerColors.primary : OwnerColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: OwnerColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, size: 15, color: OwnerColors.primary),
                    SizedBox(width: 6),
                    Text('01 Okt - 24 Okt 2023', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _isRefreshing ? null : _triggerRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: OwnerColors.primary,
                  foregroundColor: OwnerColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                icon: AnimatedRotation(
                  turns: _isRefreshing ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: const Icon(Icons.sync_rounded, size: 16),
                ),
                label: const Text('Refresh', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            spacing: 12,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tren Penjualan & Pendapatan Bersih Harian',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: OwnerColors.onSurface),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: OwnerColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '18 - 24 Okt 2023',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: OwnerColors.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Perbandingan harian nilai kotor (Gross) versus pendapatan bersih pasca potongan.',
                    style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: OwnerColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.workspace_premium_rounded, size: 16, color: OwnerColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Puncak: Sabtu 21 Okt (Rp 8,42 Jt)',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: OwnerColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  _legendDot(OwnerColors.primary, 'Penjualan Kotor'),
                  const SizedBox(width: 10),
                  _legendDot(OwnerColors.tertiary, 'Pendapatan Bersih'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SalesTrendAreaChart(data: MockAnalyticsRepository.weeklySales),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockAnalyticsRepository.weeklySales.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final d = MockAnalyticsRepository.weeklySales[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: d.isPeak ? OwnerColors.secondaryContainer : OwnerColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      d.isPeak ? '21 Okt (Sab)' : d.dayLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: d.isPeak ? FontWeight.w600 : FontWeight.w500,
                        color: d.isPeak ? OwnerColors.onSecondaryContainer : OwnerColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Rp ${d.grossMillion.toStringAsFixed(2).replaceAll('.', ',')} Jt',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: d.isPeak ? OwnerColors.primary : OwnerColors.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: OwnerColors.onSurface)),
      ],
    );
  }

  Widget _buildLeftPaymentAndOrderColumn() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payments_rounded, color: OwnerColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: OwnerColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('1.428 Transaksi', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: OwnerColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const DonutPaymentChart(
                      primaryPercent: 62,
                      centerTitle: '62%',
                      centerSubtitle: 'QRIS',
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          _paymentMethodRow(
                            color: OwnerColors.primary,
                            title: 'QRIS Dinamis',
                            amount: 'Rp 27,20 Jt',
                            subLeft: '885 transaksi',
                            subRight: '62,0%',
                            progress: 0.62,
                          ),
                          const SizedBox(height: 10),
                          _paymentMethodRow(
                            color: OwnerColors.secondary,
                            title: 'Tunai / Cash Kasir',
                            amount: 'Rp 16,67 Jt',
                            subLeft: '543 transaksi',
                            subRight: '38,0%',
                            progress: 0.38,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Non-Tunai mencakup QRIS BCA, GoPay, OVO, ShopeePay',
                      style: TextStyle(fontSize: 11.5, color: OwnerColors.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    'Cashless Dominan',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: OwnerColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.two_wheeler_rounded, color: OwnerColors.tertiary, size: 20),
                      SizedBox(width: 8),
                      Text('Jenis Pesanan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: OwnerColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('Total 1.428 Pesanan', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery Online (58%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  Text('Pickup Mandiri (42%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 58,
                        child: Container(
                          color: OwnerColors.primary,
                          alignment: Alignment.center,
                          child: const Text('58%', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 42,
                        child: Container(
                          color: OwnerColors.tertiary,
                          alignment: Alignment.center,
                          child: const Text('42%', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OwnerColors.secondaryContainer.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pesan Antar (Grab/Go/Web)', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                          SizedBox(height: 2),
                          Text('Rp 25.447.500', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: OwnerColors.primary)),
                          Text('828 pesanan selesai', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: OwnerColors.tertiaryFixed.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bawa Pulang / Dine-In', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                          SizedBox(height: 2),
                          Text('Rp 18.427.500', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: OwnerColors.tertiary)),
                          Text('600 pesanan diambil', style: TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '*Tren order delivery melonjak saat jam 17:00 - 20:30 WIB (Lapak Rush Hour).',
                style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: OwnerColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodRow({
    required Color color,
    required String title,
    required String amount,
    required String subLeft,
    required String subRight,
    required double progress,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 4.5, backgroundColor: color),
                const SizedBox(width: 6),
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
            Text(amount, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(subLeft, style: const TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
            Text(subRight, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: OwnerColors.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildTop5MenuCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, color: OwnerColors.primary, size: 22),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top 5 Menu Paling Laris', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      Text('Berdasarkan volume penjualan 7 hari terakhir', style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: OwnerColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'High Velocity',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: OwnerColors.onTertiaryFixed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...MockAnalyticsRepository.topMenus.map((item) {
            final badgeBg = item.rank == 1
                ? OwnerColors.primary
                : item.rank == 2
                    ? OwnerColors.secondaryContainer
                    : OwnerColors.surfaceContainerHigh;
            final badgeFg = item.rank == 1
                ? OwnerColors.onPrimary
                : item.rank == 2
                    ? OwnerColors.onSecondaryContainer
                    : OwnerColors.onSurface;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: OwnerColors.surfaceContainerLow.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: badgeBg,
                      child: Text(
                        '#${item.rank}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: badgeFg),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: OwnerColors.secondaryFixed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.ramen_dining_rounded, color: OwnerColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.subtitle,
                            style: const TextStyle(fontSize: 11.5, color: OwnerColors.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.revenue, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                        Text(
                          item.growth,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: item.isPositiveHighlight ? OwnerColors.tertiary : OwnerColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: OwnerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '5 Menu ini menyumbang 88.2% omset makanan total',
                    style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Analisis Lengkap',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: OwnerColors.primary),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 15, color: OwnerColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded, color: OwnerColors.primary, size: 22),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('5 Transaksi Terkini', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                      Text('Data masuk secara otomatis dari kasir cabang', style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: widget.onNavigateToTransactions,
                icon: const Text(
                  'Lihat Semua Transaksi di Laporan Transaksi',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: OwnerColors.primary),
                ),
                label: const Icon(Icons.chevron_right_rounded, size: 18, color: OwnerColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(OwnerColors.surfaceContainerLow),
              columns: const [
                DataColumn(label: Text('No. Transaksi')),
                DataColumn(label: Text('Waktu & Gerai')),
                DataColumn(label: Text('Pelanggan')),
                DataColumn(label: Text('Jenis Pesanan')),
                DataColumn(label: Text('Metode Bayar')),
                DataColumn(label: Text('Total Pembayaran'), numeric: true),
                DataColumn(label: Text('Status')),
              ],
              rows: MockAnalyticsRepository.transactions.map((trx) {
                return DataRow(
                  cells: [
                    DataCell(Text(trx.id, style: const TextStyle(fontWeight: FontWeight.w600, color: OwnerColors.primary))),
                    DataCell(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(trx.time, style: const TextStyle(fontWeight: FontWeight.w500)),
                        Text(trx.outlet, style: const TextStyle(fontSize: 11, color: OwnerColors.onSurfaceVariant)),
                      ],
                    )),
                    DataCell(Text(trx.customer, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(_pillBadge(trx.orderType, OwnerColors.secondaryContainer, OwnerColors.onSecondaryContainer)),
                    DataCell(_pillBadge(trx.paymentMethod, OwnerColors.surfaceContainer, OwnerColors.onSurface)),
                    DataCell(Text(trx.total, style: const TextStyle(fontWeight: FontWeight.w700))),
                    DataCell(_pillBadge(
                      trx.status,
                      trx.status == 'Selesai' ? OwnerColors.tertiaryFixed : OwnerColors.errorContainer,
                      trx.status == 'Selesai' ? OwnerColors.onTertiaryFixed : OwnerColors.error,
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: OwnerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_user_rounded, color: OwnerColors.primary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                      children: [
                        TextSpan(
                          text: 'Mode Owner (Read-Only): ',
                          style: TextStyle(fontWeight: FontWeight.w700, color: OwnerColors.onSurface),
                        ),
                        TextSpan(
                          text:
                              'Seluruh data disinkronisasi langsung dari sistem POS Kasir dan Web Pelanggan secara terenkripsi. Fitur edit maupun pembatalan transaksi dinonaktifkan pada portal ini untuk menjaga transparansi dan integritas buku pembukuan usaha.',
                        ),
                      ],
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

  Widget _pillBadge(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
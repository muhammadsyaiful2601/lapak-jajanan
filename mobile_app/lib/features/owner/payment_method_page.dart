import 'package:flutter/material.dart';
import '../../core/theme/owner_theme.dart';
import 'widgets/custom_charts.dart';
import 'widgets/kpi_card.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [
      (name: 'BCA Mobile & MyBCA', amount: 'Rp 9.520.875', pct: '(35%)', color: OwnerColors.primary),
      (name: 'GoPay E-Wallet', amount: 'Rp 6.800.625', pct: '(25%)', color: OwnerColors.tertiary),
      (name: 'ShopeePay', amount: 'Rp 4.896.450', pct: '(18%)', color: OwnerColors.secondary),
      (name: 'DANA & OVO', amount: 'Rp 3.808.350', pct: '(14%)', color: OwnerColors.primaryContainer),
      (name: 'LinkAja, Mandiri Livin, Lainnya', amount: 'Rp 2.176.200', pct: '(8%)', color: OwnerColors.outline),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Laporan Metode Pembayaran', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text(
          'Analisis komparasi volume transaksi, perputaran likuiditas uang tunai laci kasir vs penerimaan QRIS otomatis antar cabang Lapak Jajan.',
          style: TextStyle(fontSize: 13.5, color: OwnerColors.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth >= 850 ? 3 : 1;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: cols == 1 ? 2.2 : 1.55,
              children: const [
                KpiMetricCard(
                  title: 'TOTAL PEMBAYARAN QRIS',
                  value: 'Rp 27.202.500',
                  badgeText: '+18.4%',
                  badgeSubtext: '885 Transaksi • Share 62%',
                  footerLeft: 'AOV: Rp 30.737',
                  footerRight: 'Gateway Sync',
                  icon: Icons.qr_code_2_rounded,
                  iconBgColor: OwnerColors.tertiaryFixed,
                  iconColor: OwnerColors.onTertiaryFixed,
                ),
                KpiMetricCard(
                  title: 'TOTAL KASIR TUNAI / CASH',
                  value: 'Rp 21.547.500',
                  badgeText: '100% Cocok',
                  badgeSubtext: '543 Transaksi • Share 38%',
                  footerLeft: 'AOV: Rp 39.682',
                  footerRight: 'Fisik POS',
                  icon: Icons.payments_rounded,
                ),
                KpiMetricCard(
                  title: 'POTONGAN BIAYA GATEWAY (MDR)',
                  value: '-Rp 190.417',
                  valueColor: OwnerColors.primary,
                  badgeText: 'MDR 0.7%',
                  badgeSubtext: 'Net QRIS: Rp 27.012.083',
                  footerLeft: '99.8% Settled Tepat',
                  footerRight: 'GPN Standar',
                  icon: Icons.receipt_long_rounded,
                  iconBgColor: OwnerColors.surfaceContainerHigh,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rincian Provider QRIS (885 Transaksi)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 28,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const DonutPaymentChart(
                    primaryPercent: 62,
                    centerTitle: 'Rp 27.20M',
                    centerSubtitle: 'Total QRIS',
                    size: 145,
                  ),
                  SizedBox(
                    width: 420,
                    child: Column(
                      children: providers.map((p) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(radius: 5, backgroundColor: p.color),
                                  const SizedBox(width: 8),
                                  Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              Text('${p.amount} ${p.pct}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
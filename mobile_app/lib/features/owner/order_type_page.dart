import 'package:flutter/material.dart';

import '../../core/theme/owner_theme.dart';
import 'widgets/kpi_card.dart';

class OrderTypePage extends StatelessWidget {
  const OrderTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Laporan Komparasi Jenis Pesanan (Delivery vs Pickup)',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text(
          'Analisis perbandingan volume transaksi, perolehan omset kotor, rata-rata belanja (AOV), serta perilaku konsumen antara pemesanan antar (Delivery) dan ambil sendiri / dine-in (Pickup).',
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
              mainAxisExtent: 280,
              children: const [
                KpiMetricCard(
                  title: 'TOTAL PESANAN DELIVERY',
                  value: '828 Pesanan',
                  badgeText: '+16,2%',
                  badgeSubtext: '58,0% Pangsa Volume',
                  footerLeft: 'Omset: Rp 25.447.500',
                  footerRight: 'AOV Rp 30.733',
                  icon: Icons.moped_rounded,
                ),
                KpiMetricCard(
                  title: 'PICKUP & DINE-IN TOTAL',
                  value: '600 Pesanan',
                  badgeText: '+11,8%',
                  badgeSubtext: '42,0% Pangsa Volume',
                  footerLeft: 'Omset: Rp 23.302.500',
                  footerRight: 'AOV Rp 38.837',
                  icon: Icons.shopping_bag_rounded,
                ),
                KpiMetricCard(
                  title: 'SELISIH KERANJANG (AOV GAP)',
                  value: '+Rp 8.104',
                  valueColor: OwnerColors.primary,
                  badgeText: 'Pickup +26,4%',
                  badgeSubtext: 'Add-on camilan & topping',
                  footerLeft: 'Radius Antar: 3,4 km',
                  footerRight: 'Waktu: 28,4 mnt',
                  icon: Icons.analytics_rounded,
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
              const Text(
                'Tabel Rincian Kinerja Berdasarkan Kanal Pesanan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    OwnerColors.surfaceContainerLow,
                  ),
                  columns: const [
                    DataColumn(label: Text('Kanal Pesanan & Sub-Tipe')),
                    DataColumn(label: Text('Volume'), numeric: true),
                    DataColumn(label: Text('Pangsa Vol'), numeric: true),
                    DataColumn(label: Text('Total Omset Kotor'), numeric: true),
                    DataColumn(
                      label: Text('Rata-rata Nota (AOV)'),
                      numeric: true,
                    ),
                    DataColumn(label: Text('Avg Item')),
                    DataColumn(label: Text('Status Operasional')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Pesan Antar Online (Delivery)',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(Text('828')),
                        DataCell(
                          Text(
                            '58,0%',
                            style: TextStyle(
                              color: OwnerColors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rp 25.447.500',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rp 30.733',
                            style: TextStyle(
                              color: OwnerColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(Text('2,8 Item')),
                        DataCell(Text('Optimal (Radius 5 km)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Ambil di Tempat (Pickup / Takeaway)',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(Text('340')),
                        DataCell(
                          Text(
                            '23,8%',
                            style: TextStyle(
                              color: OwnerColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rp 10.502.500',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(Text('Rp 30.890')),
                        DataCell(Text('2,6 Item')),
                        DataCell(Text('Lancar (Tanpa Antrean)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            'Makan di Tempat (Dine-in)',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(Text('260')),
                        DataCell(
                          Text(
                            '18,2%',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rp 12.800.000',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rp 49.230',
                            style: TextStyle(
                              color: OwnerColors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(Text('3,6 Item')),
                        DataCell(Text('Kapasitas Meja 92%')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

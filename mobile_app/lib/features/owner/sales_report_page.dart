import 'package:flutter/material.dart';
import '../../core/theme/owner_theme.dart';
import '../../data/models/analytics_models.dart';
import 'widgets/custom_charts.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSales = MockAnalyticsRepository.weeklySales
        .where((s) => s.fullDate.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
        .reversed
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(
              label: Text('LAPORAN FINANSIAL & PENJUALAN'),
              backgroundColor: OwnerColors.secondaryContainer,
              labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: OwnerColors.onSecondaryContainer),
              side: BorderSide.none,
            ),
            Text(
              '• Update Real-Time Terakhir: 24 Okt 2023, 21:45 WIB',
              style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Laporan Penjualan & Pendapatan Usaha',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: OwnerColors.onSurface),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pantau performa penjualan kotor (gross sales), pendapatan bersih (net profit), volume transaksi, dan tren omset harian gabungan seluruh gerai (Senja Tebet & Pasar Kuliner).',
          style: TextStyle(fontSize: 13.5, color: OwnerColors.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grafik Tren Penjualan Harian & Pendapatan Bersih',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 4),
              Text(
                'Analisis fluktuasi omset harian kotor vs bersih serta volume transaksi gabungan Senja Tebet & Pasar Kuliner',
                style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
              ),
              SizedBox(height: 16),
              SalesTrendAreaChart(data: MockAnalyticsRepository.weeklySales),
            ],
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rincian Penjualan Harian (7 Hari Terakhir)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        Text('Daftar buku harian detail penerimaan kotor, diskon, pajak PB1, dan laba bersih.', style: TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Cari tanggal / hari...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18),
                        filled: true,
                        fillColor: OwnerColors.surfaceContainerLow,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(OwnerColors.surfaceContainerLow),
                  columns: const [
                    DataColumn(label: Text('Tanggal & Hari')),
                    DataColumn(label: Text('Nota'), numeric: true),
                    DataColumn(label: Text('Item'), numeric: true),
                    DataColumn(label: Text('AOV'), numeric: true),
                    DataColumn(label: Text('Diskon'), numeric: true),
                    DataColumn(label: Text('PB1 (10%)'), numeric: true),
                    DataColumn(label: Text('Penjualan Kotor'), numeric: true),
                    DataColumn(label: Text('Pendapatan Bersih'), numeric: true),
                    DataColumn(label: Text('Status Audit')),
                  ],
                  rows: filteredSales.map((d) {
                    return DataRow(
                      color: d.isPeak ? WidgetStateProperty.all(OwnerColors.primary.withValues(alpha: 0.06)) : null,
                      cells: [
                        DataCell(Text(
                          d.isPeak ? '${d.fullDate} (PUNCAK)' : d.fullDate,
                          style: TextStyle(
                            fontWeight: d.isPeak ? FontWeight.w700 : FontWeight.w500,
                            color: d.isPeak ? OwnerColors.primary : OwnerColors.onSurface,
                          ),
                        )),
                        DataCell(Text('${d.transactions} nota')),
                        DataCell(Text('${d.itemsSold} item')),
                        DataCell(Text(d.aov)),
                        DataCell(Text(d.discount, style: const TextStyle(color: OwnerColors.error))),
                        DataCell(Text(d.pb1)),
                        DataCell(Text(d.grossFormatted, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(d.netFormatted, style: const TextStyle(fontWeight: FontWeight.w700, color: OwnerColors.primary))),
                        DataCell(Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: d.isToday ? OwnerColors.secondaryContainer : OwnerColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            d.isToday ? 'Berjalan Real-time' : 'Selesai Rekonsiliasi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: d.isToday ? OwnerColors.onSecondaryContainer : OwnerColors.onTertiaryFixed,
                            ),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
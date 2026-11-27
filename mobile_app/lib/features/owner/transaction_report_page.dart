import 'package:flutter/material.dart';

import '../../core/theme/owner_theme.dart';
import '../../data/models/analytics_models.dart';

class TransactionReportPage extends StatefulWidget {
  const TransactionReportPage({super.key});

  @override
  State<TransactionReportPage> createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  String _searchText = '';
  String _selectedOrderType = 'Semua';
  TransactionRecord _selectedTrx = MockAnalyticsRepository.transactions.first;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1280;
    final filtered = MockAnalyticsRepository.transactions.where((t) {
      final matchesQuery =
          t.id.toLowerCase().contains(_searchText.toLowerCase()) ||
          t.customer.toLowerCase().contains(_searchText.toLowerCase());
      final matchesType =
          _selectedOrderType == 'Semua' ||
          t.orderType.contains(_selectedOrderType);
      return matchesQuery && matchesType;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Laporan Seluruh Transaksi Penjualan',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: OwnerColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Arsip menyeluruh transaksi pesanan pelanggan online (Delivery & Pickup) serta penjualan kasir POS langsung. Akses khusus Owner (Read-Only).',
          style: TextStyle(fontSize: 13.5, color: OwnerColors.onSurfaceVariant),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: OwnerColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  onChanged: (v) => setState(() => _searchText = v),
                  decoration: InputDecoration(
                    hintText: 'Cari No. Transaksi atau Pelanggan...',
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
              ...['Semua', 'Dine-in', 'Delivery', 'Pickup', 'Walk-in'].map((
                type,
              ) {
                final active = _selectedOrderType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: active,
                  selectedColor: OwnerColors.primary,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? OwnerColors.onPrimary
                        : OwnerColors.onSurfaceVariant,
                  ),
                  onSelected: (_) => setState(() => _selectedOrderType = type),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 8, child: _buildTransactionTable(filtered)),
              const SizedBox(width: 18),
              Expanded(flex: 4, child: _buildDetailPanel(_selectedTrx)),
            ],
          )
        else ...[
          _buildTransactionTable(filtered),
          const SizedBox(height: 18),
          _buildDetailPanel(_selectedTrx),
        ],
      ],
    );
  }

  Widget _buildTransactionTable(List<TransactionRecord> list) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Buku Transaksi (Klik baris untuk detail)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              headingRowColor: WidgetStateProperty.all(
                OwnerColors.surfaceContainerLow,
              ),
              columns: const [
                DataColumn(label: Text('No. Transaksi')),
                DataColumn(label: Text('Waktu & Gerai')),
                DataColumn(label: Text('Pelanggan')),
                DataColumn(label: Text('Jenis')),
                DataColumn(label: Text('Metode Bayar')),
                DataColumn(label: Text('Total'), numeric: true),
                DataColumn(label: Text('Status')),
              ],
              rows: list.map((trx) {
                final isSelected = trx.id == _selectedTrx.id;
                return DataRow(
                  selected: isSelected,
                  color: WidgetStateProperty.resolveWith((states) {
                    if (isSelected) {
                      return OwnerColors.secondaryContainer.withValues(
                        alpha: 0.45,
                      );
                    }
                    return null;
                  }),
                  onSelectChanged: (_) => setState(() => _selectedTrx = trx),
                  cells: [
                    DataCell(
                      Text(
                        trx.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: OwnerColors.primary,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        '${trx.time}\n${trx.outlet}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    DataCell(
                      Text(
                        trx.customer,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    DataCell(Text(trx.orderType)),
                    DataCell(Text(trx.paymentMethod)),
                    DataCell(
                      Text(
                        trx.total,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: trx.status == 'Selesai'
                              ? OwnerColors.tertiaryFixed
                              : OwnerColors.errorContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          trx.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: trx.status == 'Selesai'
                                ? OwnerColors.onTertiaryFixed
                                : OwnerColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(TransactionRecord trx) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1E16).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: OwnerColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${trx.orderType} • ${trx.subCustomer}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: OwnerColors.onSecondaryContainer,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: OwnerColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trx.status == 'Selesai' ? 'Lunas' : 'Void',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: OwnerColors.onTertiaryFixed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Rincian ${trx.id}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: OwnerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktu: ${trx.time} WIB',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Kasir: ${trx.cashier}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Gerai: Lapak Jajan ${trx.outlet}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Pelanggan: ${trx.customer}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'DAFTAR ITEM PESANAN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: OwnerColors.outline,
            ),
          ),
          const SizedBox(height: 8),
          ...trx.items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: OwnerColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        item.price,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ...item.notes.map(
                    (n) => Text(
                      '• $n',
                      style: const TextStyle(
                        fontSize: 11,
                        color: OwnerColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: OwnerColors.secondaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.speaker_notes_rounded,
                  size: 16,
                  color: OwnerColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Catatan Khusus: "${trx.specialNote}"',
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: OwnerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal Item Menu',
                      style: TextStyle(
                        fontSize: 12,
                        color: OwnerColors.onSurfaceVariant,
                      ),
                    ),
                    Text(trx.subtotal, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pajak Restoran PB1 (10%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: OwnerColors.onSurfaceVariant,
                      ),
                    ),
                    Text(trx.pb1, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const Divider(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      trx.total,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: OwnerColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

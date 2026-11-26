import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/customer/customer_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool _showCompletedOrders = false;

  void _showNotice(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _openWhatsApp(String phone, {String? message}) async {
    final text = message == null ? '' : '?text=${Uri.encodeComponent(message)}';
    final launched = await launchUrl(
      Uri.parse('https://wa.me/$phone$text'),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      _showNotice('WhatsApp tidak dapat dibuka.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CustomerColors.surface,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 76,
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Lapak Jajan',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CustomerColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '/',
                    style: TextStyle(
                      color: CustomerColors.outline,
                      fontSize: 13,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    'Rasa Nusantara',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CustomerColors.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.circle, size: 7, color: CustomerColors.tertiary),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Lokasi Utama • Buka 10:00 - 22:00 WIB',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: CustomerColors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: CustomerColors.primary,
              child: const Icon(
                Icons.person,
                size: 19,
                color: CustomerColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _buildTabSwitcher(),
          const SizedBox(height: 14),
          if (_showCompletedOrders)
            ..._buildCompletedOrders()
          else ...[
            _buildActiveOrderBanner(),
            const SizedBox(height: 12),
            _buildActiveReceiptCard(),
          ],
          const SizedBox(height: 14),
          _buildHelpBanner(),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _HistoryTab(
            label: 'Dalam Proses (1)',
            icon: Icons.circle,
            selected: !_showCompletedOrders,
            onTap: () => setState(() => _showCompletedOrders = false),
          ),
          _HistoryTab(
            label: 'Riwayat Selesai (2)',
            icon: Icons.history,
            selected: _showCompletedOrders,
            onTap: () => setState(() => _showCompletedOrders = true),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderBanner() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: CustomerColors.primary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: CustomerColors.primary.withValues(alpha: 0.18),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CustomerColors.primaryContainer,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.two_wheeler,
              color: CustomerColors.onPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#KD-5082',
                      style: TextStyle(
                        color: CustomerColors.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 7),
                    _LiveBadge(),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Sedang Diantar Kurir • Tiba ~10 mnt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: CustomerColors.primaryFixed,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => context.push('/customer/tracking'),
            icon: const Icon(Icons.near_me, size: 14),
            label: const Text(
              'Lacak',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: CustomerColors.onPrimary,
              foregroundColor: CustomerColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveReceiptCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildReceiptHeader(),
          _buildProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildReceiptTitle(),
                const SizedBox(height: 12),
                _buildReceiptStoreHeader(),
                const SizedBox(height: 10),
                _buildCustomerReceiptInfo(),
                const SizedBox(height: 9),
                const _ReceiptItem(name: 'Bakmi Spesial', quantity: '1x'),
                const _ReceiptItem(name: 'Dimsum Mentai', quantity: '1x'),
                const _ReceiptItem(name: 'Es Teh Manis', quantity: '1x'),
                const SizedBox(height: 9),
                _buildActiveCostBreakdown(),
                const SizedBox(height: 11),
                _buildReceiptMessage(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showNotice(
                          'Menu pesanan ditambahkan ke keranjang.',
                        ),
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text(
                          'Pesan Lagi',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CustomerColors.primary,
                          side: const BorderSide(
                            color: CustomerColors.primaryFixed,
                          ),
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _openWhatsApp(
                          '6281388992345',
                          message:
                              'Halo Lapak Jajan, saya ingin melihat '
                              'struk pesanan #KD-5082.',
                        ),
                        icon: const Icon(Icons.chat, size: 16),
                        label: const Text(
                          'Buka di WhatsApp',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: CustomerColors.whatsappGreen,
                          foregroundColor: CustomerColors.onPrimaryFixed,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

  Widget _buildReceiptHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 11),
      color: CustomerColors.surfaceContainerLow,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '#KD-5082',
                      style: TextStyle(
                        color: CustomerColors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: CustomerColors.tertiaryFixed,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.two_wheeler,
                            size: 12,
                            color: CustomerColors.onTertiaryFixed,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              color: CustomerColors.onTertiaryFixed,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Text(
                  'Hari ini, 12:35 WIB',
                  style: TextStyle(
                    color: CustomerColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp68.300',
                style: TextStyle(
                  color: CustomerColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    size: 13,
                    color: CustomerColors.tertiary,
                  ),
                  SizedBox(width: 3),
                  Text(
                    'QRIS Lunas',
                    style: TextStyle(
                      color: CustomerColors.tertiary,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pesanan Diterima',
                style: TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
              Text(
                'Di Jalan',
                style: TextStyle(
                  color: CustomerColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Tiba',
                style: TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const LinearProgressIndicator(
              value: 2 / 3,
              minHeight: 6,
              backgroundColor: CustomerColors.surfaceContainer,
              valueColor: AlwaysStoppedAnimation(CustomerColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptTitle() {
    return Row(
      children: [
        const Icon(Icons.receipt_long, size: 18, color: CustomerColors.primary),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Pratinjau Struk Digital',
            style: TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: CustomerColors.tertiaryFixed.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Row(
            children: [
              Icon(Icons.chat, size: 12, color: CustomerColors.tertiary),
              SizedBox(width: 3),
              Text(
                'WhatsApp Synced',
                style: TextStyle(
                  color: CustomerColors.tertiary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptStoreHeader() {
    return Row(
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: const BoxDecoration(
            color: CustomerColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_cafe,
            size: 16,
            color: CustomerColors.primary,
          ),
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lapak Jajan',
                style: TextStyle(
                  color: CustomerColors.onSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Lokasi Utama',
                style: TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          decoration: BoxDecoration(
            color: CustomerColors.surfaceContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            '#KD-5082',
            style: TextStyle(
              color: CustomerColors.secondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerReceiptInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rizky Ramadhan',
                  style: TextStyle(
                    color: CustomerColors.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '+62 813-8899-2345',
                  style: TextStyle(color: CustomerColors.outline, fontSize: 9),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              children: [
                Icon(Icons.pin_drop, size: 13, color: CustomerColors.tertiary),
                SizedBox(width: 3),
                Text(
                  'WA Share Loc',
                  style: TextStyle(
                    color: CustomerColors.tertiary,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCostBreakdown() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Column(
        children: [
          _CostRow(label: 'Ongkir Delivery (Share Loc)', amount: 'Rp10.000'),
          SizedBox(height: 5),
          _CostRow(label: 'PB1 (10%)', amount: 'Rp5.300'),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: _CostRow(
              label: 'Total Tagihan',
              amount: 'Rp68.300',
              isTotal: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptMessage() {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: CustomerColors.tertiaryFixed.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mark_chat_read, size: 17, color: CustomerColors.tertiary),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Struk terkirim otomatis ke WhatsApp pelanggan.',
              style: TextStyle(
                color: CustomerColors.onTertiaryFixed,
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCompletedOrders() {
    return [
      _CompletedOrderCard(
        ticket: '#KD-4912',
        type: 'Pickup',
        amount: 'Rp32.000',
        date: 'Kemarin, 18:20 WIB',
        onReceipt: () => _showNotice('Struk #KD-4912 siap dilihat.'),
        onReorder: () =>
            _showNotice('Menu dari pesanan #KD-4912 ditambahkan ke keranjang.'),
      ),
      const SizedBox(height: 10),
      _CompletedOrderCard(
        ticket: '#KD-4200',
        type: 'Delivery',
        amount: 'Rp35.000',
        date: '20 Nov 2026, 12:15 WIB',
        onReceipt: () => _showNotice('Struk #KD-4200 siap dilihat.'),
        onReorder: () =>
            _showNotice('Menu dari pesanan #KD-4200 ditambahkan ke keranjang.'),
      ),
    ];
  }

  Widget _buildHelpBanner() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: CustomerColors.secondaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: CustomerColors.secondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              color: CustomerColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 9),
          const Expanded(
            child: Text(
              'Butuh bantuan pesanan?',
              style: TextStyle(
                color: CustomerColors.onSecondaryContainer,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () => _openWhatsApp(
              '6281288992345',
              message: 'Halo Lapak Jajan, saya butuh bantuan pesanan.',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: CustomerColors.primary,
              side: const BorderSide(color: CustomerColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text(
              'Chat CS',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected
            ? CustomerColors.surfaceContainerLowest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!selected)
                  Icon(icon, size: 14, color: CustomerColors.secondary)
                else
                  const Icon(
                    Icons.circle,
                    size: 8,
                    color: CustomerColors.primary,
                  ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected
                          ? CustomerColors.primary
                          : CustomerColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: CustomerColors.primaryFixed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'LIVE',
        style: TextStyle(
          color: CustomerColors.onPrimaryFixed,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ReceiptItem extends StatelessWidget {
  const _ReceiptItem({required this.name, required this.quantity});

  final String name;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            quantity,
            style: const TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CustomerColors.onSurface,
                fontSize: 10,
              ),
            ),
          ),
          Text(
            switch (name) {
              'Bakmi Spesial' => 'Rp28.000',
              'Dimsum Mentai' => 'Rp20.000',
              _ => 'Rp5.000',
            },
            style: const TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final String amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? CustomerColors.onSurface
                  : CustomerColors.onSurfaceVariant,
              fontSize: isTotal ? 12 : 9,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isTotal ? CustomerColors.primary : CustomerColors.onSurface,
            fontSize: isTotal ? 14 : 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CompletedOrderCard extends StatelessWidget {
  const _CompletedOrderCard({
    required this.ticket,
    required this.type,
    required this.amount,
    required this.date,
    required this.onReceipt,
    required this.onReorder,
  });

  final String ticket;
  final String type;
  final String amount;
  final String date;
  final VoidCallback onReceipt;
  final VoidCallback onReorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: const BoxDecoration(
                  color: CustomerColors.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: CustomerColors.tertiary,
                  size: 19,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ticket,
                          style: const TextStyle(
                            color: CustomerColors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _OrderKindBadge(type: type),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      date,
                      style: const TextStyle(
                        color: CustomerColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  color: CustomerColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: CustomerColors.surfaceContainerHigh),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReceipt,
                  icon: const Icon(Icons.receipt_long, size: 15),
                  label: const Text(
                    'Lihat Struk',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CustomerColors.primary,
                    side: const BorderSide(color: CustomerColors.primaryFixed),
                    minimumSize: const Size.fromHeight(39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onReorder,
                  icon: const Icon(Icons.replay, size: 15),
                  label: const Text(
                    'Pesan Lagi',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: CustomerColors.primary,
                    foregroundColor: CustomerColors.onPrimary,
                    minimumSize: const Size.fromHeight(39),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderKindBadge extends StatelessWidget {
  const _OrderKindBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final isPickup = type == 'Pickup';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isPickup
            ? CustomerColors.secondaryContainer
            : CustomerColors.tertiaryFixed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: isPickup
              ? CustomerColors.onSecondaryContainer
              : CustomerColors.onTertiaryFixed,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

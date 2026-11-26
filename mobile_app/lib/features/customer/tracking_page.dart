import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/customer/customer_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  static const String _ticketCode = '#KD-5082';
  static const String _whatsappNumber = '+62 813-8899-2345';
  static const String _whatsappDigits = '6281388992345';

  Future<void> _copyTicket(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _ticketCode));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('ID pesanan berhasil disalin.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/$_whatsappDigits');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp tidak dapat dibuka.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        backgroundColor: CustomerColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Konfirmasi & Tracking',
          style: TextStyle(
            color: CustomerColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: CustomerColors.onSurface),
        ),
        actions: [
          IconButton(
            tooltip: 'Pesanan saya',
            onPressed: () => context.push('/customer/orders'),
            icon: const Icon(Icons.receipt_long, color: CustomerColors.primary),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildPaymentSuccessBanner(),
          const SizedBox(height: 12),
          _buildOrderCard(context),
          const SizedBox(height: 12),
          _buildWhatsAppReceiptCard(context),
          const SizedBox(height: 12),
          _buildTimelineCard(),
          const SizedBox(height: 12),
          _buildMenuCard(),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: () => context.push('/customer/checkout'),
              icon: const Icon(Icons.restaurant_menu, size: 19),
              label: const Text(
                'Pesan Menu Lainnya',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: CustomerColors.primary,
                foregroundColor: CustomerColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSuccessBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomerColors.tertiaryFixed,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          _CircleIcon(
            icon: Icons.check,
            background: CustomerColors.tertiary,
            foreground: CustomerColors.onTertiary,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pembayaran QRIS Berhasil & Lunas',
                  style: TextStyle(
                    color: CustomerColors.onTertiaryFixed,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'via Payment Gateway (TRX-GW-882194)',
                  style: TextStyle(
                    color: CustomerColors.onTertiaryFixed,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: CustomerColors.tertiary, size: 18),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context) {
    return _TrackingCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ID PESANAN',
                      style: TextStyle(
                        color: CustomerColors.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Text(
                          _ticketCode,
                          style: TextStyle(
                            color: CustomerColors.primary,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          tooltip: 'Salin ID Pesanan',
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints.tightFor(
                            width: 30,
                            height: 30,
                          ),
                          onPressed: () => _copyTicket(context),
                          icon: const Icon(
                            Icons.content_copy,
                            size: 15,
                            color: CustomerColors.onSurfaceVariant,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: CustomerColors.surfaceContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const _OrderTypeBadge(),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _InfoTile(label: 'Pemesan', value: 'Rizky Ramadhan'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _InfoTile(label: 'Waktu', value: 'Hari ini, 12:35 WIB'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: CustomerColors.primaryFixed,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule, size: 20, color: CustomerColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimasi Tiba',
                        style: TextStyle(
                          color: CustomerColors.onPrimaryFixed,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '~20-25 Menit (12:55 WIB)',
                        style: TextStyle(
                          color: CustomerColors.onPrimaryFixed,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.circle, color: CustomerColors.primary, size: 9),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppReceiptCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomerColors.whatsappDarkBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CustomerColors.whatsappDarkBg.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CircleIcon(
            icon: Icons.chat,
            background: Color(0xFF2E7D32),
            foreground: Colors.white,
            size: 40,
            iconSize: 22,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF388E3C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TERKIRIM OTOMATIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Struk Resmi Digital via WhatsApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Struk rincian biaya dan nomor pesanan telah dikirim ke $_whatsappNumber.',
                  style: TextStyle(
                    color: Color(0xFFE0F2E9),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 11),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _openWhatsApp(context),
                    icon: const Icon(Icons.forum, size: 17),
                    label: const Text(
                      'Buka Obrolan WhatsApp Gerai',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: CustomerColors.whatsappGreen,
                      foregroundColor: CustomerColors.onPrimaryFixed,
                      minimumSize: const Size.fromHeight(42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
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

  Widget _buildTimelineCard() {
    return _TrackingCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.timeline,
                size: 20,
                color: CustomerColors.primary,
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Pelacakan Pesanan',
                  style: TextStyle(
                    color: CustomerColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomerColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Live Update',
                  style: TextStyle(
                    color: CustomerColors.onTertiaryFixed,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _TimelineStep(
            title: 'Menunggu Konfirmasi',
            time: '12:35 WIB',
            description: 'Pesanan telah diterima kasir Lapak Jajan.',
            state: _TimelineState.done,
            isLast: false,
          ),
          const _TimelineStep(
            title: 'Diproses di Dapur',
            time: '12:37 WIB',
            description: 'Pesanan sedang disiapkan di dapur.',
            state: _TimelineState.done,
            isLast: false,
          ),
          const _TimelineStep(
            title: 'Diantar Kurir',
            time: '12:45 WIB',
            description:
                'Kurir: Budi Santoso • Honda Beat B 4120 SNF (1.2 km lagi)',
            state: _TimelineState.active,
            isLast: false,
          ),
          const _TimelineStep(
            title: 'Selesai',
            time: 'Estimasi 12:55 WIB',
            description: 'Pesanan diserahterimakan kepada pemesan.',
            state: _TimelineState.pending,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    return _TrackingCard(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rincian Menu',
                  style: TextStyle(
                    color: CustomerColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '3 Produk',
                style: TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _MenuItemRow(
            quantity: '1x',
            name: 'Bakmi Spesial Komplit',
            price: 'Rp28.000',
          ),
          const _MenuItemRow(
            quantity: '1x',
            name: 'Dimsum Mentai',
            price: 'Rp20.000',
          ),
          const _MenuItemRow(
            quantity: '1x',
            name: 'Es Teh Manis',
            price: 'Rp5.000',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              children: [
                _CostRow(label: 'Subtotal', amount: 'Rp53.000'),
                SizedBox(height: 7),
                _CostRow(label: 'Ongkos Kirim Delivery', amount: 'Rp10.000'),
                SizedBox(height: 7),
                _CostRow(label: 'PB1 (10%)', amount: 'Rp5.300'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 9),
                  child: Divider(
                    height: 1,
                    color: CustomerColors.surfaceContainerHighest,
                  ),
                ),
                _CostRow(
                  label: 'Total Pembayaran',
                  amount: 'Rp68.300',
                  isTotal: true,
                ),
                SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: CustomerColors.tertiary,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Lunas QRIS',
                      style: TextStyle(
                        color: CustomerColors.tertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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

class _TrackingCard extends StatelessWidget {
  const _TrackingCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 9,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.icon,
    required this.background,
    required this.foreground,
    this.size = 32,
    this.iconSize = 18,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: iconSize, color: foreground),
    );
  }
}

class _OrderTypeBadge extends StatelessWidget {
  const _OrderTypeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: CustomerColors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.two_wheeler, size: 14, color: CustomerColors.primary),
          SizedBox(width: 4),
          Text(
            'Delivery',
            style: TextStyle(
              color: CustomerColors.onSecondaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CustomerColors.secondary,
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum _TimelineState { done, active, pending }

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.time,
    required this.description,
    required this.state,
    required this.isLast,
  });

  final String title;
  final String time;
  final String description;
  final _TimelineState state;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      _TimelineState.done => CustomerColors.tertiary,
      _TimelineState.active => CustomerColors.primary,
      _TimelineState.pending => CustomerColors.surfaceContainerHighest,
    };
    final textColor = state == _TimelineState.pending
        ? CustomerColors.secondary
        : CustomerColors.onSurface;
    final icon = switch (state) {
      _TimelineState.done => Icons.check,
      _TimelineState.active => Icons.two_wheeler,
      _TimelineState.pending => Icons.flag_outlined,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: state == _TimelineState.active
                        ? [
                            BoxShadow(
                              color: CustomerColors.primary.withValues(
                                alpha: 0.18,
                              ),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 17,
                    color: state == _TimelineState.pending
                        ? CustomerColors.secondary
                        : Colors.white,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: state == _TimelineState.done
                          ? CustomerColors.tertiary
                          : CustomerColors.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18, top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: state == _TimelineState.active
                                ? CustomerColors.primary
                                : textColor,
                            fontSize: 12,
                            fontWeight: state == _TimelineState.pending
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: state == _TimelineState.active
                              ? CustomerColors.primary
                              : CustomerColors.secondary,
                          fontSize: 9,
                          fontWeight: state == _TimelineState.active
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: state == _TimelineState.pending
                          ? CustomerColors.secondary
                          : CustomerColors.onSurfaceVariant,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemRow extends StatelessWidget {
  const _MenuItemRow({
    required this.quantity,
    required this.name,
    required this.price,
  });

  final String quantity;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(
            quantity,
            style: const TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: CustomerColors.onSurface,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            price,
            style: const TextStyle(
              color: CustomerColors.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
              fontSize: isTotal ? 13 : 10,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isTotal ? CustomerColors.primary : CustomerColors.onSurface,
            fontSize: isTotal ? 15 : 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

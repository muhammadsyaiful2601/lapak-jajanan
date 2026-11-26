import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/customer/customer_theme.dart';
import 'package:url_launcher/url_launcher.dart';

enum _OrderType { delivery, pickup }

enum _PaymentMethod { qris, cash }

enum _LocationState { initial, loading, found, shared, failed }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const int _subtotal = 53000;
  static const int _deliveryFee = 10000;
  static const int _tax = 5300;
  static const String _coordinates = '-6.2241, 106.8095';
  static const String _mapsUrl = 'https://maps.google.com/?q=-6.2241,106.8095';
  static const List<String> _locationLabels = [
    '1. Awal',
    '2. Proses',
    '3. Ditemukan',
    '4. Dari WA',
    '5. Gagal',
  ];

  final TextEditingController _nameController = TextEditingController(
    text: 'Rizky Ramadhan',
  );
  final TextEditingController _whatsappController = TextEditingController(
    text: '+62 813-8899-2345',
  );

  _OrderType _orderType = _OrderType.delivery;
  _PaymentMethod _paymentMethod = _PaymentMethod.qris;
  _LocationState _locationState = _LocationState.initial;

  int get _shippingFee => _orderType == _OrderType.delivery ? _deliveryFee : 0;

  int get _total => _subtotal + _shippingFee + _tax;

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  String _rupiah(int amount) {
    final digits = amount.toString();
    final groups = <String>[];
    for (var end = digits.length; end > 0; end -= 3) {
      final start = end >= 3 ? end - 3 : 0;
      groups.insert(0, digits.substring(start, end));
    }
    return 'Rp${groups.join('.')}';
  }

  Future<void> _detectLocation() async {
    setState(() => _locationState = _LocationState.loading);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _locationState = _LocationState.found);
  }

  Future<void> _openLink(String url) async {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tautan tidak dapat dibuka.')),
      );
    }
  }

  Future<void> _openWhatsApp() async {
    final digits = _whatsappController.text.replaceAll(RegExp(r'\D'), '');
    final phone = digits.startsWith('0') ? '62${digits.substring(1)}' : digits;
    final message = Uri.encodeComponent(
      'Halo Lapak Jajanan, ini lokasi pengantaran saya: $_mapsUrl',
    );
    await _openLink('https://wa.me/$phone?text=$message');
  }

  void _startPayment() {
    context.push('/customer/tracking');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerColors.surface,
      appBar: AppBar(
        backgroundColor: CustomerColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Checkout',
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
            icon: const Icon(
              Icons.receipt_long_outlined,
              color: CustomerColors.primary,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          _buildGreeting(),
          const SizedBox(height: 12),
          _buildRecipientCard(),
          const SizedBox(height: 12),
          _buildFulfillmentCard(),
          const SizedBox(height: 12),
          _buildPaymentCard(),
          const SizedBox(height: 12),
          _buildPaymentSummaryCard(),
          const SizedBox(height: 16),
          _buildFreshlyPreparedNote(),
          const SizedBox(height: 8),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildGreeting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: CustomerColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '☕  Lapak Jajanan • Table & Delivery',
                  style: TextStyle(
                    color: CustomerColors.onSecondaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selesaikan Pesanan',
                style: TextStyle(
                  color: CustomerColors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          decoration: BoxDecoration(
            color: CustomerColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 17,
                color: CustomerColors.primary,
              ),
              SizedBox(width: 4),
              Text(
                'Est. 15-20 mnt',
                style: TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientCard() {
    return _SectionCard(
      title: 'Data Penerima',
      icon: Icons.person_pin_circle_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Nama Lengkap'),
          const SizedBox(height: 5),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration(
              icon: Icons.badge_outlined,
              suffix: const Icon(
                Icons.check_circle,
                size: 18,
                color: CustomerColors.tertiary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _FieldLabel('Nomor WhatsApp Aktif'),
          const SizedBox(height: 5),
          TextField(
            controller: _whatsappController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration(
              icon: Icons.chat_bubble_outline,
              suffix: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomerColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Aktif',
                  style: TextStyle(
                    color: CustomerColors.onTertiaryContainer,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 15,
                color: CustomerColors.primary,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Struk dan update pesanan dikirim via WhatsApp',
                  style: TextStyle(
                    color: CustomerColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFulfillmentCard() {
    return _SectionCard(
      title: 'Metode Pemenuhan',
      icon: Icons.moped_outlined,
      trailing: const Text(
        'Area Aktif',
        style: TextStyle(
          color: CustomerColors.tertiary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _FulfillmentOption(
                  label: 'Delivery (Antar)',
                  icon: Icons.two_wheeler,
                  selected: _orderType == _OrderType.delivery,
                  onTap: () => setState(() {
                    _orderType = _OrderType.delivery;
                  }),
                ),
                _FulfillmentOption(
                  label: 'Pickup (Ambil Sendiri)',
                  icon: Icons.storefront_outlined,
                  selected: _orderType == _OrderType.pickup,
                  onTap: () => setState(() {
                    _orderType = _OrderType.pickup;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _orderType == _OrderType.delivery
                ? _buildDeliveryLocation()
                : _buildPickupDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLocation() {
    return Container(
      key: const ValueKey('delivery-location'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(_locationLabels.length, (index) {
                final state = _LocationState.values[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == _locationLabels.length - 1 ? 0 : 6,
                  ),
                  child: ChoiceChip(
                    label: Text(_locationLabels[index]),
                    selected: _locationState == state,
                    onSelected: (_) => setState(() => _locationState = state),
                    visualDensity: VisualDensity.compact,
                    labelStyle: TextStyle(
                      color: _locationState == state
                          ? CustomerColors.onPrimary
                          : CustomerColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: CustomerColors.surfaceContainerHigh,
                    selectedColor: CustomerColors.primary,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    showCheckmark: false,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          _buildLocationStateBody(),
        ],
      ),
    );
  }

  Widget _buildLocationStateBody() {
    switch (_locationState) {
      case _LocationState.initial:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LocationIntro(
              title: 'Lokasi Pengantaran',
              message: 'Bagikan titik lokasi Anda agar pesanan dapat diantar oleh kurir kami.',
              icon: Icons.add_location_alt_outlined,
            ),
            const SizedBox(height: 10),
            _infoMessage(
              Icons.info_outline,
              'Website akan meminta izin akses lokasi dari browser Anda.',
            ),
            const SizedBox(height: 10),
            _wideButton(
              label: 'Gunakan Lokasi Saya',
              icon: Icons.my_location,
              onPressed: _detectLocation,
            ),
          ],
        );
      case _LocationState.loading:
        return const Column(
          children: [
            _LocationIntro(
              title: 'Sedang mendeteksi lokasi...',
              message: 'Mohon tunggu sebentar.',
              icon: Icons.location_searching,
            ),
            SizedBox(height: 12),
            Center(
              child: CircularProgressIndicator(
                color: CustomerColors.primary,
                strokeWidth: 3,
              ),
            ),
          ],
        );
      case _LocationState.found:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: CustomerColors.tertiary,
                  size: 20,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Lokasi berhasil ditemukan',
                    style: TextStyle(
                      color: CustomerColors.tertiary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  'GPS ~8 m',
                  style: TextStyle(
                    color: CustomerColors.tertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _coordinateTile(
              title: 'Koordinat: $_coordinates (Senopati, Jaksel)',
              subtitle: 'Pin lokasi siap dikirim ke driver via WA',
              trailing: TextButton.icon(
                onPressed: _detectLocation,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Perbarui'),
                style: TextButton.styleFrom(
                  foregroundColor: CustomerColors.secondary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _wideButton(
              label: 'Kirim Lokasi ke WhatsApp',
              icon: Icons.share_location,
              background: CustomerColors.whatsappGreen,
              onPressed: _openWhatsApp,
            ),
            const SizedBox(height: 6),
            const Text(
              'WhatsApp akan dibuka dengan tautan Google Maps lokasi Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomerColors.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        );
      case _LocationState.shared:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bookmark_added, color: CustomerColors.tertiary),
                SizedBox(width: 7),
                Text(
                  'Lokasi tersimpan',
                  style: TextStyle(
                    color: CustomerColors.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _openLink(_mapsUrl),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CustomerColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.map_outlined, color: CustomerColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'maps.google.com/?q=$_coordinates',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: CustomerColors.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: CustomerColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            _wideButton(
              label: 'Kirim Ulang Lokasi ke WhatsApp',
              icon: Icons.refresh,
              background: CustomerColors.secondaryContainer,
              foreground: CustomerColors.onSecondaryContainer,
              onPressed: _openWhatsApp,
            ),
          ],
        );
      case _LocationState.failed:
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: CustomerColors.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_off,
                    color: CustomerColors.error,
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lokasi belum berhasil didapatkan. Aktifkan izin lokasi, lalu coba lagi.',
                      style: TextStyle(
                        color: CustomerColors.onErrorContainer,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _wideButton(
              label: 'Coba Lagi',
              icon: Icons.refresh,
              onPressed: _detectLocation,
            ),
          ],
        );
    }
  }

  Widget _buildPickupDetails() {
    return Container(
      key: const ValueKey('pickup-details'),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SquareIcon(
                icon: Icons.storefront,
                color: CustomerColors.primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lapak Jajanan — Lokasi Utama',
                      style: TextStyle(
                        color: CustomerColors.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Gerai aktif • Estimasi siap ~15–20 menit',
                      style: TextStyle(
                        color: CustomerColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailLine(
                  icon: Icons.location_on_outlined,
                  label: 'Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan',
                ),
                SizedBox(height: 9),
                _DetailLine(
                  icon: Icons.schedule,
                  label: 'Jam Operasional  10:00–22:00 WIB',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: CustomerColors.secondaryContainer.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Tunjukkan nomor pesanan #KD-5082 kepada kasir saat mengambil pesanan.',
              style: TextStyle(
                color: CustomerColors.onSecondaryContainer,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return _SectionCard(
      title: 'Metode Pembayaran',
      icon: Icons.payments_outlined,
      child: Column(
        children: [
          const SizedBox(height: 12),
          _paymentOption(
            method: _PaymentMethod.qris,
            title: 'QRIS Instant',
            subtitle: 'Bayar dengan aplikasi pembayaran pilihan Anda',
            icon: Icons.qr_code_2,
          ),
          if (_paymentMethod == _PaymentMethod.qris) ...[
            const SizedBox(height: 9),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: CustomerColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: CustomerColors.surfaceContainerHigh,
                      ),
                    ),
                    child: const CustomPaint(painter: _QrPreviewPainter()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CustomerColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Auto-Verified < 2s',
                            style: TextStyle(
                              color: CustomerColors.onTertiaryFixed,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Preview QRIS',
                          style: TextStyle(
                            color: CustomerColors.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Nominal pembayaran ${_rupiah(_total)}',
                          style: const TextStyle(
                            color: CustomerColors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'GoPay • BCA Mobile • OVO • DANA',
                          style: TextStyle(
                            color: CustomerColors.secondary,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          _paymentOption(
            method: _PaymentMethod.cash,
            title: 'Cash (Tunai di Tempat)',
            subtitle: _orderType == _OrderType.delivery
                ? 'Bayar saat pesanan sampai'
                : 'Bayar saat mengambil pesanan di gerai',
            icon: Icons.payments_outlined,
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required _PaymentMethod method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _paymentMethod == method;
    return Material(
      color: selected
          ? CustomerColors.primaryFixed.withValues(alpha: 0.28)
          : CustomerColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => setState(() => _paymentMethod = method),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? CustomerColors.primary
                  : CustomerColors.surfaceContainerHigh,
            ),
          ),
          child: Row(
            children: [
              Radio<_PaymentMethod>(
                value: method,
                groupValue: _paymentMethod,
                activeColor: CustomerColors.primary,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _paymentMethod = value);
                  }
                },
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: CustomerColors.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: CustomerColors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, size: 20, color: CustomerColors.secondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
    return _SectionCard(
      title: 'Rincian Pembayaran',
      icon: Icons.receipt_long_outlined,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _ItemPriceRow(
                  title: '1x Bakmi Spesial Komplit',
                  price: _rupiah(28000),
                ),
                _ItemPriceRow(title: '1x Dimsum Mentai', price: _rupiah(20000)),
                _ItemPriceRow(title: '1x Es Teh Manis', price: _rupiah(5000)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _priceRow('Subtotal Menu (3 item)', _rupiah(_subtotal)),
          const SizedBox(height: 8),
          _priceRow(
            _orderType == _OrderType.delivery
                ? 'Ongkos Kirim Delivery'
                : 'Biaya Layanan Pickup',
            _shippingFee == 0 ? 'Gratis (Rp0)' : _rupiah(_shippingFee),
            valueColor: _shippingFee == 0 ? CustomerColors.tertiary : null,
          ),
          const SizedBox(height: 8),
          _priceRow('PB1 Resto (10%)', _rupiah(_tax)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              color: CustomerColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(
                          color: CustomerColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _orderType == _OrderType.delivery
                            ? 'Termasuk pajak & ongkir'
                            : 'Termasuk pajak • Bebas biaya pickup',
                        style: const TextStyle(
                          color: CustomerColors.tertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _rupiah(_total),
                  style: const TextStyle(
                    color: CustomerColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: CustomerColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? CustomerColors.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFreshlyPreparedNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomerColors.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.coffee_maker, color: CustomerColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Pesanan diramu segar setelah dikonfirmasi.',
              style: TextStyle(
                color: CustomerColors.onSecondaryContainer,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: CustomerColors.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: CustomerColors.tertiary,
                  size: 14,
                ),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    'Terenkripsi 256-Bit SSL • QRIS Bank Indonesia Terdaftar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomerColors.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: _startPayment,
                style: FilledButton.styleFrom(
                  backgroundColor: CustomerColors.primary,
                  foregroundColor: CustomerColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _paymentMethod == _PaymentMethod.qris
                          ? Icons.qr_code_scanner
                          : Icons.payments_outlined,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _paymentMethod == _PaymentMethod.qris
                            ? 'Bayar Sekarang via QRIS'
                            : 'Konfirmasi Pesanan Tunai',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      _rupiah(_total),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required IconData icon,
    required Widget suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: CustomerColors.secondary),
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: suffix,
      ),
      suffixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      filled: true,
      fillColor: CustomerColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: CustomerColors.primary),
      ),
    );
  }

  Widget _wideButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color background = CustomerColors.primary,
    Color foreground = CustomerColors.onPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget _infoMessage(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: CustomerColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: CustomerColors.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coordinateTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: CustomerColors.tertiaryFixed.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const _SquareIcon(
            icon: Icons.location_on,
            color: CustomerColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: CustomerColors.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CustomerColors.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomerColors.primaryFixed,
                ),
                child: Icon(icon, size: 16, color: CustomerColors.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: CustomerColors.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: CustomerColors.onSurfaceVariant,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FulfillmentOption extends StatelessWidget {
  const _FulfillmentOption({
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
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected
                      ? CustomerColors.primary
                      : CustomerColors.secondary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
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

class _LocationIntro extends StatelessWidget {
  const _LocationIntro({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SquareIcon(icon: icon, color: CustomerColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: CustomerColors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: const TextStyle(
                  color: CustomerColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SquareIcon extends StatelessWidget {
  const _SquareIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: CustomerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: CustomerColors.primary),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: CustomerColors.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemPriceRow extends StatelessWidget {
  const _ItemPriceRow({required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
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
              color: CustomerColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPreviewPainter extends CustomPainter {
  const _QrPreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = CustomerColors.onSurface;
    const cells = 17;
    final cell = size.width / cells;

    for (var row = 0; row < cells; row++) {
      for (var column = 0; column < cells; column++) {
        final inFinder =
            _finderCell(row, column, 0, 0) ||
            _finderCell(row, column, 0, cells - 7) ||
            _finderCell(row, column, cells - 7, 0);
        final dark =
            inFinder || ((row * 7 + column * 11 + row * column) % 5 < 2);
        if (dark) {
          canvas.drawRect(
            Rect.fromLTWH(column * cell, row * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  bool _finderCell(int row, int column, int top, int left) {
    final localRow = row - top;
    final localColumn = column - left;
    if (localRow < 0 || localColumn < 0 || localRow >= 7 || localColumn >= 7) {
      return false;
    }
    return localRow == 0 ||
        localRow == 6 ||
        localColumn == 0 ||
        localColumn == 6 ||
        (localRow >= 2 &&
            localRow <= 4 &&
            localColumn >= 2 &&
            localColumn <= 4);
  }

  @override
  bool shouldRepaint(covariant _QrPreviewPainter oldDelegate) => false;
}

import 'package:flutter/services.dart';

import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

import 'dialogs/pos_dialogs.dart';
import 'models/pos_models.dart';
import 'widgets/menu_card.dart';
import 'widgets/pos_shared.dart';
import 'widgets/pos_sidebar.dart';
import 'widgets/pos_top_bar.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});
  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final _searchFocus = FocusNode();
  final _cashCtrl = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _category = 'Semua Menu';
  String _query = '';
  bool _isQris = false;
  bool _dineIn = true;
  int _orderNo = 42;
  int _received = 0;
  final List<CartLine> _cart = [];
  StateSetter? _sheetSet;

  @override
  void dispose() {
    _searchFocus.dispose();
    _cashCtrl.dispose();
    super.dispose();
  }

  int get _subtotal => _cart.fold(0, (s, l) => s + l.total);
  int get _tax => (_subtotal * kTaxRate).round();
  int get _total => _subtotal + _tax;
  int get _itemCount => _cart.fold(0, (s, l) => s + l.qty);

  void _mutate(VoidCallback fn) {
    setState(fn);
    _sheetSet?.call(() {});
  }

  void _toast(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? PosAppColors.error : const Color(0xFF31302D),
          duration: const Duration(milliseconds: 2200),
        ),
      );
  }

  // ---- cart actions
  void _addLine(CartLine line) {
    _mutate(() {
      final i = _cart.indexWhere((l) => l.key == line.key);
      if (i >= 0) {
        _cart[i].qty += line.qty;
      } else {
        _cart.add(line);
      }
    });
    _toast('${line.item.name} ditambahkan (+${line.qty})');
  }

  Future<void> _onTapMenu(MenuItem item) async {
    if (!item.available) return;
    if (item.toppings.isEmpty) {
      _addLine(CartLine(item, 1, const [], ''));
      return;
    }
    final line = await showDialog<CartLine>(
      context: context,
      builder: (_) => PosCustomizeDialog(item: item),
    );
    if (line != null) _addLine(line);
  }

  void _changeQty(CartLine l, int d) {
    _mutate(() {
      l.qty += d;
      if (l.qty < 1) l.qty = 1;
    });
  }

  void _clearCart() {
    if (_cart.isEmpty) return;
    _mutate(() {
      _cart.clear();
      _received = 0;
      _cashCtrl.clear();
    });
    _toast('Keranjang dikosongkan');
  }

  void _setPay(bool qris) => _mutate(() => _isQris = qris);

  void _setReceived(int v) {
    _mutate(() {
      _received = v;
      _cashCtrl.text = v == 0 ? '' : _plain(v);
      _cashCtrl.selection = TextSelection.collapsed(
        offset: _cashCtrl.text.length,
      );
    });
  }

  String _plain(int v) => rp(v).replaceFirst('Rp', '');

  Future<void> _checkout() async {
    if (_cart.isEmpty) {
      _toast('Keranjang masih kosong', error: true);
      return;
    }
    if (!_isQris && _received < _total) {
      _toast('Uang diterima kurang ${rp(_total - _received)}', error: true);
      return;
    }
    final change = _isQris ? 0 : _received - _total;
    await showDialog<void>(
      context: context,
      builder: (_) => PosReceiptDialog(
        orderNo: _orderNo,
        lines: List.of(_cart),
        subtotal: _subtotal,
        tax: _tax,
        total: _total,
        method: _isQris ? 'QRIS Dinamis' : 'Tunai',
        received: _isQris ? _total : _received,
        change: change,
        dineIn: _dineIn,
      ),
    );
    _mutate(() {
      _cart.clear();
      _received = 0;
      _cashCtrl.clear();
      _orderNo++;
    });
    if (_sheetSet != null && mounted) Navigator.of(context).maybePop();
  }

  void _openCartSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: PosAppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) {
          _sheetSet = set;
          return SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.92,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: _cartPanel(),
            ),
          );
        },
      ),
    ).whenComplete(() => _sheetSet = null);
  }

  // ---------------------------------------------------------------- BUILD
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f1): () =>
            _searchFocus.requestFocus(),
        const SingleActivator(LogicalKeyboardKey.f4): _clearCart,
        const SingleActivator(LogicalKeyboardKey.f8): () => _setPay(false),
        const SingleActivator(LogicalKeyboardKey.f9): () => _setPay(true),
      },
      child: Focus(
        autofocus: true,
        child: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 1100;
            return Scaffold(
              key: _scaffoldKey,
              drawer: wide ? null : Drawer(child: PosSidebar(onNav: _toast)),
              floatingActionButton: wide
                  ? null
                  : FloatingActionButton.extended(
                      backgroundColor: PosAppColors.primary,
                      foregroundColor: Colors.white,
                      onPressed: _openCartSheet,
                      icon: const Icon(Icons.shopping_cart),
                      label: Text('$_itemCount item • ${rp(_total)}'),
                    ),
              body: Row(
                children: [
                  if (wide)
                    SizedBox(width: 272, child: PosSidebar(onNav: _toast)),
                  Expanded(
                    child: Column(
                      children: [
                        PosTopBar(
                          wide: wide,
                          onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                        Expanded(
                          child: wide
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: _menuSection(wide),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          16,
                                          24,
                                          16,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: PosAppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                            boxShadow: posShadow,
                                          ),
                                          child: _cartPanel(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : _menuSection(wide),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- MENU SIDE
  Widget _menuSection(bool wide) {
    final items = kMenu.where((m) {
      final okCat = _category == 'Semua Menu' || m.category == _category;
      final q = _query.toLowerCase();
      final okQ =
          q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.id.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, wide ? 16 : 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // status strip
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              posPill(
                'Terminal Kasir POS #01 Online',
                bg: PosAppColors.tertiary.withValues(alpha: .15),
                fg: PosAppColors.tertiary,
                dot: true,
              ),
              const Text(
                '• Mode Walk-in & Takeaway Cepat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PosAppColors.onSurfaceVariant,
                ),
              ),
              if (wide)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PosAppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Pintasan: [F1] Cari • [F4] Hapus • [F8] Cash • [F9] QRIS',
                    style: TextStyle(
                      fontSize: 11,
                      color: PosAppColors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // search + chips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PosAppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: posShadow,
            ),
            child: Column(
              children: [
                TextField(
                  focusNode: _searchFocus,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari menu, SKU cepat... (Tekan F1)',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: PosAppColors.outline,
                    ),
                    filled: true,
                    fillColor: PosAppColors.surfaceLow,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kCategories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final c = kCategories[i];
                      final sel = c == _category;
                      final count = c == 'Semua Menu'
                          ? kMenu.length
                          : kMenu.where((m) => m.category == c).length;
                      return ChoiceChip(
                        label: Text('$c ($count)'),
                        selected: sel,
                        showCheckmark: false,
                        selectedColor: PosAppColors.onSurface,
                        backgroundColor: PosAppColors.surfaceHigh,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: sel
                              ? PosAppColors.surface
                              : PosAppColors.onSurface,
                        ),
                        onSelected: (_) => setState(() => _category = c),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // grid
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'Menu tidak ditemukan',
                      style: TextStyle(color: PosAppColors.outline),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final maxCrossAxisExtent = constraints.maxWidth < 360
                          ? constraints.maxWidth
                          : 240.0;
                      return GridView.builder(
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: maxCrossAxisExtent,
                          mainAxisExtent: 258,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, i) => MenuCard(
                          item: items[i],
                          onTap: () => _onTapMenu(items[i]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- CART SIDE
  Widget _cartPanel() {
    return Column(
      children: [
        // header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: PosAppColors.surfaceLow,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            children: [
              posIconBox(Icons.point_of_sale),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _dineIn ? 'Dine-in' : 'Takeaway',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        posPill(
                          '#${_orderNo.toString().padLeft(4, '0')}',
                          bg: PosAppColors.secondaryContainer,
                          fg: PosAppColors.onSecondaryContainer,
                        ),
                      ],
                    ),
                    const Text(
                      'Kasir: Bambang Irawan',
                      style: TextStyle(
                        fontSize: 12,
                        color: PosAppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: PosAppColors.errorContainer,
                  foregroundColor: const Color(0xFF93000A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _clearCart,
                icon: const Icon(Icons.delete_sweep, size: 16),
                label: const Text(
                  'Kosongkan [F4]',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        // order type
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: posSegmented(
            left: ('Dine-in', Icons.restaurant),
            right: ('Takeaway', Icons.takeout_dining),
            leftSelected: _dineIn,
            onChange: (l) => _mutate(() => _dineIn = l),
          ),
        ),
        // lines
        Expanded(
          child: _cart.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_basket_outlined,
                        size: 40,
                        color: PosAppColors.outline,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Keranjang kosong. Pilih menu di sisi kiri.',
                        style: TextStyle(color: PosAppColors.outline),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cart.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => _cartTile(_cart[i]),
                ),
        ),
        // totals + payment
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PosAppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row('Subtotal Item ($_itemCount porsi)', rp(_subtotal)),
                    const SizedBox(height: 6),
                    _row('PB1 Restoran (10%)', rp(_tax)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TOTAL TAGIHAN BERSIH',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1,
                                color: PosAppColors.outline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              rp(_total),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: PosAppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        posPill(
                          'Belum Dibayar',
                          bg: PosAppColors.primaryFixed,
                          fg: const Color(0xFF3A0A00),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              posSegmented(
                left: ('CASH [F8]', Icons.payments),
                right: ('QRIS [F9]', Icons.qr_code_scanner),
                leftSelected: !_isQris,
                onChange: (l) => _setPay(!l),
              ),
              const SizedBox(height: 12),
              _isQris ? _qrisPanel() : _cashPanel(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: PosAppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _checkout,
                  icon: const Icon(Icons.verified),
                  label: Text(
                    _isQris
                        ? 'KONFIRMASI QRIS LUNAS (${rp(_total)})'
                        : 'PROSES PEMBAYARAN CASH (${rp(_total)})',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _ghostButton(
                      Icons.print,
                      'Cetak Bill Sementara',
                      () => _toast(
                        'Mencetak bill sementara ke printer thermal...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ghostButton(Icons.note_alt, 'Catatan', _editNote),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editNote() async {
    final ctrl = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Catatan dapur / kasir'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: Kurang manis, pisah sambal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (note != null && note.trim().isNotEmpty) {
      _toast('Catatan disimpan: $note');
    }
  }

  Widget _cartTile(CartLine l) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PosAppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${rp(l.unitPrice)} / porsi',
                  style: const TextStyle(
                    fontSize: 12,
                    color: PosAppColors.onSurfaceVariant,
                  ),
                ),
                if (l.toppings.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final t in l.toppings)
                          posPill(
                            '+${t.name}',
                            bg: PosAppColors.secondaryContainer,
                            fg: PosAppColors.onSecondaryContainer,
                            small: true,
                          ),
                      ],
                    ),
                  ),
                if (l.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Catatan: ${l.note}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: PosAppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _qtyBtn(Icons.remove, () => _changeQty(l, -1)),
                SizedBox(
                  width: 28,
                  child: Text(
                    '${l.qty}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                _qtyBtn(Icons.add, () => _changeQty(l, 1)),
              ],
            ),
          ),
          SizedBox(
            width: 88,
            child: Text(
              rp(l.total),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close,
              size: 18,
              color: PosAppColors.outline,
            ),
            onPressed: () {
              _mutate(() => _cart.remove(l));
              _toast('Item dihapus dari pesanan');
            },
          ),
        ],
      ),
    );
  }

  Widget _cashPanel() {
    final change = _received - _total;
    final ok = change >= 0 && _cart.isNotEmpty;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _quickCash('Uang Pas', _total)),
            const SizedBox(width: 8),
            Expanded(child: _quickCash('Rp50.000', 50000)),
            const SizedBox(width: 8),
            Expanded(child: _quickCash('Rp100.000', 100000, highlight: true)),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _cashCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          onChanged: (v) => _mutate(() => _received = int.tryParse(v) ?? 0),
          decoration: InputDecoration(
            prefixText: 'Rp ',
            hintText: 'Uang diterima',
            filled: true,
            fillColor: PosAppColors.surfaceLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: (ok ? PosAppColors.tertiary : PosAppColors.error).withValues(
              alpha: .1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.change_circle,
                    color: ok ? PosAppColors.tertiary : PosAppColors.error,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'KEMBALIAN PELANGGAN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Text(
                _received == 0 ? 'Rp0' : rp(change),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: ok ? PosAppColors.tertiary : PosAppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qrisPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PosAppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PosAppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_2, size: 96),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan QRIS Lapak Jajan Dinamis',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const Text(
            'BCA, Mandiri, GoPay, OVO, ShopeePay, DANA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: PosAppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          posPill(
            'Menunggu Pembayaran Pelanggan...',
            bg: PosAppColors.secondaryContainer,
            fg: PosAppColors.onSecondaryContainer,
          ),
        ],
      ),
    );
  }

  // ---- small helpers
  Widget _quickCash(String label, int amount, {bool highlight = false}) {
    return SizedBox(
      height: 40,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: highlight
              ? PosAppColors.secondaryContainer
              : PosAppColors.surfaceHigh,
          foregroundColor: PosAppColors.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _setReceived(amount),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _ghostButton(IconData icon, String label, VoidCallback onTap) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: PosAppColors.surfaceHigh,
        foregroundColor: PosAppColors.onSurface,
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(8),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(6),
      child: Icon(icon, size: 16),
    ),
  );

  Widget _row(String l, String r) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        l,
        style: const TextStyle(
          fontSize: 14,
          color: PosAppColors.onSurfaceVariant,
        ),
      ),
      Text(r, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}

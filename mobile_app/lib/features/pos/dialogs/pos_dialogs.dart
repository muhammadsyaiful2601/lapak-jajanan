import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

import '../models/pos_models.dart';

class PosCustomizeDialog extends StatefulWidget {
  final MenuItem item;
  const PosCustomizeDialog({super.key, required this.item});
  @override
  State<PosCustomizeDialog> createState() => _PosCustomizeDialogState();
}

class _PosCustomizeDialogState extends State<PosCustomizeDialog> {
  final Set<Topping> _selected = {};
  final _noteCtrl = TextEditingController();
  int _qty = 1;

  int get _unit => widget.item.price + _selected.fold(0, (s, t) => s + t.price);

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Dialog(
      backgroundColor: PosAppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: PosAppColors.surfaceLow,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: PosAppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: PosAppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KUSTOMISASI MENU',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                            color: PosAppColors.primary,
                          ),
                        ),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Basis: ${rp(item.price)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: PosAppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Topping Tambahan (Opsional)',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  for (final t in item.toppings)
                    CheckboxListTile(
                      value: _selected.contains(t),
                      onChanged: (v) => setState(() {
                        v == true ? _selected.add(t) : _selected.remove(t);
                      }),
                      activeColor: PosAppColors.primary,
                      tileColor: _selected.contains(t)
                          ? PosAppColors.primary.withValues(alpha: .06)
                          : PosAppColors.surfaceLow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        t.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      secondary: Text(
                        '+${rp(t.price)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: PosAppColors.primary,
                        ),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kuantitas',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: PosAppColors.surfaceLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(
                                    () => _qty = _qty > 1 ? _qty - 1 : 1,
                                  ),
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  '$_qty',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => setState(() => _qty++),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _noteCtrl,
                          decoration: InputDecoration(
                            labelText: 'Catatan Khusus Dapur',
                            hintText: 'Contoh: kuah pisah...',
                            filled: true,
                            fillColor: PosAppColors.surfaceLow,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: PosAppColors.surfaceLow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: PosAppColors.primary,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(
                        context,
                        CartLine(
                          item,
                          _qty,
                          _selected.toList(),
                          _noteCtrl.text.trim(),
                        ),
                      ),
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(
                        'Tambahkan ke Keranjang (${rp(_unit * _qty)})',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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
}

class PosReceiptDialog extends StatelessWidget {
  final int orderNo, subtotal, tax, total, received, change;
  final List<CartLine> lines;
  final String method;
  final bool dineIn;
  const PosReceiptDialog({
    super.key,
    required this.orderNo,
    required this.lines,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.method,
    required this.received,
    required this.change,
    required this.dineIn,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    const mono = TextStyle(fontFamily: 'monospace', fontSize: 12);

    Widget r(String l, String v, {TextStyle? s}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: s ?? mono),
          Text(v, style: s ?? mono),
        ],
      ),
    );
    const div = Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Text(
        '- - - - - - - - - - - - - - - - - - - - -',
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(color: PosAppColors.outline, fontSize: 11),
      ),
    );

    return Dialog(
      backgroundColor: PosAppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: PosAppColors.tertiary),
                  SizedBox(width: 8),
                  Text(
                    'Pembayaran Berhasil',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: PosAppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'LAPAK JAJAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Jl. Tebet Raya No. 42, Jakarta Selatan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      ),
                      div,
                      r(
                        'No. Nota',
                        '#POS-${orderNo.toString().padLeft(4, '0')}',
                      ),
                      r(
                        'Waktu',
                        '${two(now.day)}/${two(now.month)}/${now.year} ${two(now.hour)}:${two(now.minute)}',
                      ),
                      r('Tipe', dineIn ? 'Dine-in' : 'Takeaway'),
                      r('Kasir', 'Bambang Irawan'),
                      div,
                      for (final l in lines) ...[
                        r(
                          '${l.qty}x ${l.item.name}',
                          rp(l.total),
                          s: mono.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (l.toppings.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, bottom: 4),
                            child: Text(
                              '+ ${l.toppings.map((t) => t.name).join(', ')}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: PosAppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                      div,
                      r('Subtotal', rp(subtotal)),
                      r('PB1 (10%)', rp(tax)),
                      r(
                        'TOTAL',
                        rp(total),
                        s: mono.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: PosAppColors.primary,
                        ),
                      ),
                      div,
                      r('Metode', method),
                      r('Diterima', rp(received)),
                      r('Kembalian', rp(change)),
                      div,
                      const Text(
                        '*** TERIMA KASIH ***',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print),
                      label: const Text('Cetak Struk'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: PosAppColors.primary,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Transaksi Baru'),
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
}

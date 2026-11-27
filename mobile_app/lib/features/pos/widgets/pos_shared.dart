import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

final posShadow = [
  BoxShadow(
    color: const Color(0xFF2C1E16).withValues(alpha: .06),
    blurRadius: 12,
    offset: const Offset(0, 2),
  ),
];

Widget posIconBox(IconData icon) => Container(
  width: 40,
  height: 40,
  decoration: BoxDecoration(
    color: PosAppColors.primary,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(icon, color: Colors.white, size: 22),
);

Widget posPill(
  String text, {
  required Color bg,
  required Color fg,
  bool dot = false,
  bool small = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: small ? 6 : 10,
      vertical: small ? 2 : 4,
    ),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: small ? 10 : 12,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ],
    ),
  );
}

Widget posSegmented({
  required (String, IconData) left,
  required (String, IconData) right,
  required bool leftSelected,
  required ValueChanged<bool> onChange,
}) {
  Widget seg((String, IconData) d, bool sel, VoidCallback tap) => Expanded(
    child: GestureDetector(
      onTap: tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: sel ? PosAppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              d.$2,
              size: 18,
              color: sel ? Colors.white : PosAppColors.onSurface,
            ),
            const SizedBox(width: 6),
            Text(
              d.$1,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: sel ? Colors.white : PosAppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: PosAppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        seg(left, leftSelected, () => onChange(true)),
        seg(right, !leftSelected, () => onChange(false)),
      ],
    ),
  );
}

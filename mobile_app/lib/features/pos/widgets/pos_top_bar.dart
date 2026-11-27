import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

class PosTopBar extends StatelessWidget {
  final bool wide;
  final VoidCallback onMenu;
  const PosTopBar({super.key, required this.wide, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: PosAppColors.surface,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1E16).withValues(alpha: .05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!wide)
            IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
          const Icon(
            Icons.storefront,
            size: 18,
            color: PosAppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            wide ? 'Portal Admin  ›  ' : '',
            style: const TextStyle(
              fontSize: 12,
              color: PosAppColors.onSurfaceVariant,
            ),
          ),
          const Text(
            'Lapak Jajan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (wide)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: PosAppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.pin_drop, size: 18, color: PosAppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Senja Tebet (Utama)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 12),
          const ClockText(),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 16,
            backgroundColor: PosAppColors.primary,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ClockText extends StatefulWidget {
  const ClockText({super.key});
  @override
  State<ClockText> createState() => _ClockTextState();
}

class _ClockTextState extends State<ClockText> {
  late Timer _t;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    return Text(
      '${two(_now.hour)}:${two(_now.minute)}:${two(_now.second)} WIB',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF6D5A50),
      ),
    );
  }
}

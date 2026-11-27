import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/theme/pos_app_colors.dart';

import '../models/pos_models.dart';
import 'pos_shared.dart';

class MenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  const MenuCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ok = item.available;
    return Opacity(
      opacity: ok ? 1 : .6,
      child: Material(
        color: ok ? PosAppColors.white : PosAppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        elevation: ok ? 1 : 0,
        shadowColor: Colors.black26,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: ok ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image placeholder (ganti dengan Image.network bila ada URL foto)
                Container(
                  height: 118,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: ok
                          ? [
                              PosAppColors.secondaryContainer,
                              PosAppColors.primaryFixed,
                            ]
                          : [
                              PosAppColors.surfaceHighest,
                              PosAppColors.surfaceHigh,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          item.icon,
                          size: 48,
                          color: ok
                              ? PosAppColors.primary.withValues(alpha: .7)
                              : PosAppColors.outline,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: ok
                            ? posPill(
                                'Tersedia',
                                bg: PosAppColors.tertiary,
                                fg: Colors.white,
                                small: true,
                              )
                            : posPill(
                                'HABIS TERJUAL',
                                bg: PosAppColors.error,
                                fg: Colors.white,
                                small: true,
                              ),
                      ),
                      if (item.badge != null && ok)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: posPill(
                            item.badge!,
                            bg: PosAppColors.white.withValues(alpha: .9),
                            fg: PosAppColors.onSurface,
                            small: true,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ok
                        ? PosAppColors.onSurface
                        : PosAppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  item.desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: PosAppColors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rp(item.price),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: ok ? PosAppColors.primary : PosAppColors.outline,
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: ok
                            ? PosAppColors.primary
                            : PosAppColors.surfaceHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        ok ? Icons.add : Icons.block,
                        size: 20,
                        color: ok ? Colors.white : PosAppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

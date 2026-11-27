import 'package:flutter/material.dart';
import '../../../core/theme/owner_theme.dart';

class KpiMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String badgeText;
  final String badgeSubtext;
  final String footerLeft;
  final String footerRight;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color valueColor;
  final Color footerRightColor;

  const KpiMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.badgeText,
    required this.badgeSubtext,
    required this.footerLeft,
    required this.footerRight,
    required this.icon,
    this.iconBgColor = OwnerColors.secondaryContainer,
    this.iconColor = OwnerColors.primary,
    this.valueColor = OwnerColors.onSurface,
    this.footerRightColor = OwnerColors.tertiary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: OwnerColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C1E16).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: OwnerColors.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: OwnerColors.tertiaryFixed.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_upward_rounded, size: 13, color: OwnerColors.tertiary),
                    const SizedBox(width: 2),
                    Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: OwnerColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  badgeSubtext,
                  style: const TextStyle(fontSize: 12, color: OwnerColors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                footerLeft,
                style: const TextStyle(
                  fontSize: 12,
                  color: OwnerColors.onSurfaceVariant,
                ),
              ),
              Text(
                footerRight,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: footerRightColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
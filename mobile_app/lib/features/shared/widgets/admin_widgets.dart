import 'package:material_ui/material_ui.dart';

class AdminColors {
  const AdminColors._();

  static const primary = Color(0xFF94452C);
  static const canvas = Color(0xFFFCF9F4);
  static const surface = Color(0xFFFFFFFF);
  static const soft = Color(0xFFF6F3EE);
  static const border = Color(0xFFEAE3D9);
  static const text = Color(0xFF2C1E16);
  static const muted = Color(0xFF88726C);
  static const green = Color(0xFF3E6447);
  static const greenSoft = Color(0xFFE8F1E9);
  static const red = Color(0xFFBA1A1A);
  static const redSoft = Color(0xFFFFE9E6);
}

class AdminPageTitle extends StatelessWidget {
  const AdminPageTitle({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.action,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final titleWidth = constraints.maxWidth < 660
            ? constraints.maxWidth
            : 640.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              SizedBox(
                width: titleWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AdminColors.primary,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AdminColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AdminColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              ?action,
            ],
          ),
        );
      },
    );
  }
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.width = 218,
    this.detail,
    this.tint = AdminColors.primary,
    this.background = AdminColors.soft,
  });

  final String label;
  final String value;
  final IconData icon;
  final double width;
  final String? detail;
  final Color tint;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: tint),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AdminColors.muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AdminColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (detail != null)
                      Text(
                        detail!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: tint,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminStatusPill extends StatelessWidget {
  const AdminStatusPill({super.key, required this.label, this.isActive = true});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AdminColors.green : AdminColors.red;
    final background = isActive ? AdminColors.greenSoft : AdminColors.redSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class AdminSectionCard extends StatelessWidget {
  const AdminSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(18),
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = this.subtitle;
    final subtitleText = subtitle == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AdminColors.muted,
              ),
            ),
          );
    return Card(
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AdminColors.text,
                        ),
                      ),
                      ?subtitleText,
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class AdminPrimaryButton extends StatelessWidget {
  const AdminPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.add, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AdminColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

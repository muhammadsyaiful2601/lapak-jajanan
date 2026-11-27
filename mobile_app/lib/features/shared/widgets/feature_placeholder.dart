import 'package:material_ui/material_ui.dart';

/// Kartu placeholder untuk modul yang akan diimplementasikan pada minggu 2–5.
/// Menampilkan kode FR dari PRD supaya cakupan kebutuhan tetap terlihat.
class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    super.key,
    required this.title,
    required this.description,
    required this.frCodes,
    this.icon = Icons.construction_outlined,
  });

  final String title;
  final String description;
  final List<String> frCodes;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.construction_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dalam Pengembangan',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Estimasi pengerjaan: minggu ke-2–5 sesuai roadmap PBL.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final code in frCodes)
                      Chip(
                        label: Text(code),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Estimasi dapat berubah mengikuti prioritas pengembangan dan hasil integrasi.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

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
                Wrap(
                  spacing: 8,
                  children: [
                    for (final code in frCodes)
                      Chip(label: Text(code), labelPadding: const EdgeInsets.symmetric(horizontal: 4)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Modul ini disiapkan pada minggu 1 sebagai fondasi. '
          'Implementasi UI dan integrasi Supabase mengikuti jadwal PBL.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

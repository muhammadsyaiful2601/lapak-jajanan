import 'package:material_ui/material_ui.dart';

class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFFEF6C00);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}

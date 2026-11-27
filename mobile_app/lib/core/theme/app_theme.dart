import 'package:material_ui/material_ui.dart';

class AppTheme {
  const AppTheme._();

  static const Color seedColor = Color(0xFF94452C);
  static const Color canvasColor = Color(0xFFFCF9F4);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFEAE3D9);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: canvasColor,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: canvasColor,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: borderColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF6F3EE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      );
}

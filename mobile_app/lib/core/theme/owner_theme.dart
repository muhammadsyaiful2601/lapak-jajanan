import 'package:flutter/material.dart';

class OwnerColors {
  // Surface & Background
  static const Color surface = Color(0xFFFCF9F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainer = Color(0xFFF0EDE9);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);

  // Primary (Terracotta)
  static const Color primary = Color(0xFF94452C);
  static const Color primaryContainer = Color(0xFFB35C41);
  static const Color primaryFixed = Color(0xFFFFDBD0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryFixed = Color(0xFF3A0A00);
  static const Color onPrimaryFixedVariant = Color(0xFF793019);

  // Secondary (Warm Earth)
  static const Color secondary = Color(0xFF6D5A50);
  static const Color secondaryContainer = Color(0xFFF5DBCD);
  static const Color secondaryFixed = Color(0xFFF7DDD0);
  static const Color onSecondaryContainer = Color(0xFF725F54);
  static const Color onSecondaryFixed = Color(0xFF261911);

  // Tertiary (Sage Green)
  static const Color tertiary = Color(0xFF3E6447);
  static const Color tertiaryFixed = Color(0xFFC2EDC8);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryFixed = Color(0xFF00210C);
  static const Color onTertiaryFixedVariant = Color(0xFF294F33);

  // Text & Neutral
  static const Color onSurface = Color(0xFF1C1C19);
  static const Color onSurfaceVariant = Color(0xFF55433E);
  static const Color outline = Color(0xFF88726C);
  static const Color outlineVariant = Color(0xFFDBC1BA);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
}

class OwnerTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: OwnerColors.surface,
      fontFamily: 'Plus Jakarta Sans',
      colorScheme: const ColorScheme.light(
        primary: OwnerColors.primary,
        onPrimary: OwnerColors.onPrimary,
        primaryContainer: OwnerColors.primaryContainer,
        secondary: OwnerColors.secondary,
        secondaryContainer: OwnerColors.secondaryContainer,
        tertiary: OwnerColors.tertiary,
        surface: OwnerColors.surface,
        onSurface: OwnerColors.onSurface,
        error: OwnerColors.error,
        outline: OwnerColors.outline,
      ),
      cardTheme: CardThemeData(
        color: OwnerColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
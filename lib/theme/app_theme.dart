import 'package:flutter/material.dart';

/// Central design tokens. Defined once and reused everywhere so the deep-navy /
/// amber identity stays consistent across screens (and so a future re-theme is
/// a one-file change). This is the "reusable widgets / maintainability" story.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF080E1C); // deep navy canvas
  static const Color backgroundElevated = Color(0xFF0D1528);
  static const Color surface = Color(0xFF141E36); // cards
  static const Color surfaceAlt = Color(0xFF1C2844); // inputs / chips
  static const Color amber = Color(0xFFF5B301); // primary action / brand
  static const Color amberSoft = Color(0xFFFFD166);
  static const Color textPrimary = Color(0xFFF5F7FB);
  static const Color textMuted = Color(0xFF8B98B8);
  static const Color border = Color(0xFF2A3654);
  static const Color success = Color(0xFF3DD68C);
  static const Color danger = Color(0xFFFF6B6B);

  // Campus accents — Kigali vs Mauritius are first-class in this app.
  static const Color kigali = Color(0xFF5B8DEF);
  static const Color mauritius = Color(0xFF36C2A6);
}

class AppRadius {
  AppRadius._();
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
}

/// Shared decorations so cards, glows, and ambient backgrounds stay consistent.
class AppDecorations {
  AppDecorations._();

  static const LinearGradient backgroundGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AF5B301),
      Color(0x00080E1C),
      Color(0x145B8DEF),
    ],
    stops: [0.0, 0.45, 1.0],
  );

  static BoxDecoration card({Color? borderColor}) => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      );

  static List<BoxShadow> amberGlow({double opacity = 0.35}) => [
        BoxShadow(
          color: AppColors.amber.withOpacity(opacity),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.amber,
      onPrimary: Color(0xFF1A1300),
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      secondary: AppColors.amberSoft,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        borderSide: const BorderSide(color: AppColors.amber, width: 1.5),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.surfaceAlt,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

import 'package:flutter/material.dart';

/// Clean, minimal, light design system for the Salon Admin app.
/// Neutral surfaces, hairline borders (no heavy shadows), one calm accent,
/// generous spacing and a tight type scale.
class AppColors {
  static const bg = Color(0xFFFFFFFF); // page background
  static const surfaceAlt = Color(0xFFF7F8FA); // subtle section fill
  static const border = Color(0xFFECEEF1); // hairline dividers/cards
  static const ink = Color(0xFF0F172A); // primary text
  static const inkMuted = Color(0xFF6B7280); // secondary text
  static const inkFaint = Color(0xFF9AA3AF); // tertiary text

  static const accent = Color(0xFF0E7C6B); // calm teal
  static const accentSoft = Color(0xFFE7F3F1);

  static const danger = Color(0xFFDC2626);
  static const dangerSoft = Color(0xFFFDECEC);
  static const success = Color(0xFF15803D);
  static const successSoft = Color(0xFFE9F6EE);
  static const violet = Color(0xFF6D28D9);
  static const violetSoft = Color(0xFFF1EBFB);
  static const whatsapp = Color(0xFF25D366);
}

class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const pill = 999.0;
}

class AppSpace {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

const _font = 'AppSans';

/// A soft card decoration used across screens (white, hairline border, no shadow).
BoxDecoration cardDecoration({Color? color, Color? borderColor, double radius = AppRadius.lg}) =>
    BoxDecoration(
      color: color ?? AppColors.bg,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? AppColors.border),
    );

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    primary: AppColors.accent,
    brightness: Brightness.light,
  ).copyWith(
    surface: AppColors.bg,
    onSurface: AppColors.ink,
  );

  TextStyle t(double size, FontWeight w, {Color? c, double? h, double? ls}) => TextStyle(
        fontFamily: _font,
        fontSize: size,
        fontWeight: w,
        color: c ?? AppColors.ink,
        height: h,
        letterSpacing: ls,
      );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: scheme,
    primaryColor: AppColors.accent,
    dividerColor: AppColors.border,
    splashFactory: InkRipple.splashFactory,
    textTheme: base.textTheme
        .apply(fontFamily: _font, bodyColor: AppColors.ink, displayColor: AppColors.ink)
        .copyWith(
          displaySmall: t(28, FontWeight.w800, ls: -0.5),
          headlineSmall: t(22, FontWeight.w800, ls: -0.3),
          titleLarge: t(18, FontWeight.w700),
          titleMedium: t(15, FontWeight.w700),
          bodyLarge: t(15, FontWeight.w500, h: 1.4),
          bodyMedium: t(14, FontWeight.w500, c: AppColors.inkMuted, h: 1.4),
          labelLarge: t(14, FontWeight.w700),
          labelMedium: t(12, FontWeight.w600, c: AppColors.inkMuted, ls: 0.2),
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.ink,
      iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
      titleTextStyle: t(20, FontWeight.w800, ls: -0.2),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bg,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: t(15, FontWeight.w500, c: AppColors.inkFaint),
      labelStyle: t(15, FontWeight.w500, c: AppColors.inkMuted),
      floatingLabelStyle: t(13, FontWeight.w600, c: AppColors.accent),
      prefixIconColor: AppColors.inkFaint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: t(15, FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(0, 52),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: t(15, FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: t(14, FontWeight.w700),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.surfaceAlt,
      side: const BorderSide(color: AppColors.border),
      labelStyle: t(12, FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: t(14, FontWeight.w600, c: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
    ),
  );
}

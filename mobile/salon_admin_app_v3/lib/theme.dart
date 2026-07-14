import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

/// Clean, minimal, light design system for the Salon Admin app.
/// Neutral surfaces, hairline borders (no heavy shadows), one calm accent,
/// generous spacing and a tight type scale.
///
/// v3 change: the accent is no longer a single hardcoded teal. The salon
/// owner picks one of [kAppColorSeeds] at signup (or later in Account ->
/// Appearance) and [AppColors.accent] / [AppColors.accentSoft] are derived
/// from that choice at runtime via [AppColors.applySeed]. Every other
/// semantic color (danger/success/violet/whatsapp) stays fixed regardless
/// of the chosen accent, since those carry meaning (error, success, etc.)
/// independent of brand color.
class AppColorSeed {
  const AppColorSeed(this.id, this.label, this.color);

  final String id;
  final String label;
  final Color color;
}

const kAppColorSeeds = <AppColorSeed>[
  AppColorSeed('teal', 'Teal', Color(0xFF0E7C6B)),
  AppColorSeed('terracotta', 'Terracotta', Color(0xFFD85A30)),
  AppColorSeed('blue', 'Blue', Color(0xFF185FA5)),
  AppColorSeed('violet', 'Violet', Color(0xFF6D28D9)),
  AppColorSeed('rose', 'Rose', Color(0xFFD4537E)),
];

/// [AppColorSeed.label] is a fixed English id used for lookups; use this to
/// get the translated display name shown in the theme picker.
String colorSeedLabel(AppLocalizations t, String id) {
  switch (id) {
    case 'teal':
      return t.colorTeal;
    case 'terracotta':
      return t.colorTerracotta;
    case 'blue':
      return t.colorBlue;
    case 'violet':
      return t.colorViolet;
    case 'rose':
      return t.colorRose;
    default:
      return id;
  }
}

const _defaultSeed = Color(0xFF0E7C6B);

class AppColors {
  static const bg = Color(0xFFFFFFFF); // page background
  static const surfaceAlt = Color(0xFFF7F8FA); // subtle section fill
  static const border = Color(0xFFDCE1E8); // hairline dividers/cards (visible)
  static const ink = Color(0xFF0B1220); // primary text (near-black)
  static const inkMuted = Color(0xFF44505F); // secondary text (WCAG AA on white)
  static const inkFaint = Color(0xFF667080); // tertiary text (readable)

  // These two are the only colors that change with the chosen theme seed.
  // They start as the default (teal) and are overwritten by [applySeed]
  // once the salon's saved preference (or signup choice) loads.
  static Color accent = _defaultSeed;
  static Color accentSoft = _softTint(_defaultSeed);

  static const danger = Color(0xFFDC2626);
  static const dangerSoft = Color(0xFFFDECEC);
  static const success = Color(0xFF15803D);
  static const successSoft = Color(0xFFE9F6EE);
  static const violet = Color(0xFF6D28D9);
  static const violetSoft = Color(0xFFF1EBFB);
  static const whatsapp = Color(0xFF25D366);

  static Color _softTint(Color seed) =>
      Color.alphaBlend(seed.withValues(alpha: 0.12), Colors.white);

  /// Applies a newly chosen accent color. Call this before rebuilding the
  /// theme (see [ThemeController]) whenever the user picks a different
  /// color, or once at startup after loading the saved preference.
  static void applySeed(Color seed) {
    accent = seed;
    accentSoft = _softTint(seed);
  }
}

/// Holds the current accent choice and notifies listeners (the app root)
/// so the whole app rebuilds with a new [ThemeData] when it changes.
/// There's no backend field for this yet (see docs/GLOBAL-READINESS.md) —
/// the choice lives in [AppPrefs] on-device only.
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  AppColorSeed _seed = kAppColorSeeds.first;
  AppColorSeed get seed => _seed;

  void applyLoaded(String? savedId) {
    _seed = kAppColorSeeds.firstWhere(
      (s) => s.id == savedId,
      orElse: () => kAppColorSeeds.first,
    );
    AppColors.applySeed(_seed.color);
  }

  void select(AppColorSeed seed) {
    _seed = seed;
    AppColors.applySeed(seed.color);
    notifyListeners();
  }
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
          bodyLarge: t(15, FontWeight.w600, h: 1.4),
          bodyMedium: t(14, FontWeight.w600, c: AppColors.inkMuted, h: 1.4),
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
        borderSide: BorderSide(color: AppColors.accent, width: 1.6),
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
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.accentSoft,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return t(11, selected ? FontWeight.w700 : FontWeight.w500,
            c: selected ? AppColors.accent : AppColors.inkFaint);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
            color: selected ? AppColors.accent : AppColors.inkFaint, size: 22);
      }),
    ),
  );
}

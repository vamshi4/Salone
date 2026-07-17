import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

/// Clean white + vivid-pink design system for the Salon Admin app (v4).
/// Third design pass this session — ported from a Dribbble reference
/// ("StyleHub – Salon App Design", see docs/HANDOFF.md) after both the
/// coral "Tres Beaux" pass and the cream/terracotta "Open Design" pass were
/// rejected. White surfaces (no cream, no hairline borders — cards float on
/// a soft shadow only), a single vivid magenta/pink accent, one clean sans
/// font throughout (no serif/sans pairing), pill-heavy filled controls.
///
/// The accent is not a single hardcoded color. The salon owner picks one of
/// [kAppColorSeeds] at signup (or later in Account -> Appearance) and
/// [AppColors.accent] / [AppColors.accentSoft] are derived from that choice
/// at runtime via [AppColors.applySeed]. Every other semantic color
/// (danger/success/amber/violet/whatsapp) stays fixed regardless of the
/// chosen accent, since those carry meaning (error, success, needs-action,
/// etc.) independent of brand color.
class AppColorSeed {
  const AppColorSeed(this.id, this.label, this.color);

  final String id;
  final String label;
  final Color color;
}

const kAppColorSeeds = <AppColorSeed>[
  AppColorSeed('magenta', 'Magenta', Color(0xFFE91E76)),
  AppColorSeed('terracotta', 'Terracotta', Color(0xFFC96442)),
  AppColorSeed('teal', 'Teal', Color(0xFF0E7C6B)),
  AppColorSeed('blue', 'Blue', Color(0xFF185FA5)),
  AppColorSeed('violet', 'Violet', Color(0xFF6D28D9)),
];

/// [AppColorSeed.label] is a fixed English id used for lookups; use this to
/// get the translated display name shown in the theme picker. `magenta` has
/// no translated key yet (added this session, ARB files not touched) so it
/// falls through to a capitalized id.
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
      return id.isEmpty ? id : '${id[0].toUpperCase()}${id.substring(1)}';
  }
}

const _defaultSeed = Color(0xFFE91E76);

class AppColors {
  static const bg = Color(0xFFFFFFFF); // page/scaffold background — clean white
  static const surface = Color(0xFFFFFFFF); // card/input/tile background — same white, distinguished by shadow only
  static const surfaceAlt = Color(0xFFF7F7F8); // subtle off-white fill (unselected chips, section backgrounds)
  static const border = Color(0xFFECECEE); // faint hairline, used sparingly (inputs, unselected chip outline)
  static const ink = Color(0xFF1A1A1A); // primary text (near-black)
  static const inkMuted = Color(0xFF6B6B6B); // secondary text (WCAG AA on white)
  static const inkFaint = Color(0xFF9E9E9E); // tertiary text/icons

  // These two are the only colors that change with the chosen theme seed.
  // They start as the default (magenta) and are overwritten by [applySeed]
  // once the salon's saved preference (or signup choice) loads.
  static Color accent = _defaultSeed;
  static Color accentSoft = _softTint(_defaultSeed);

  static const danger = Color(0xFFC0392B);
  static const dangerSoft = Color(0xFFFEF2F2);
  static const success = Color(0xFF2D7D46);
  static const successSoft = Color(0xFFEDF7F0);
  // "Needs action" semantic — pending bookings, at-risk customers. Kept
  // distinct from [accent] so a primary CTA and an attention badge never
  // read as the same color.
  static const amber = Color(0xFFB8860B);
  static const amberSoft = Color(0xFFFEF7E0);
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
  static const xl = 24.0;
  static const pill = 999.0;
}

class AppSpace {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

// One clean sans family throughout — no serif/sans pairing this pass. The
// PlayfairDisplay font asset stays registered in pubspec.yaml (harmless if
// unused) in case a future direction wants it back; every TextStyle here
// resolves to Inter now, including what used to be the "display" face.
const _fontBody = 'Inter';
const _fontDisplay = _fontBody;

/// A white card that floats on shadow alone — no border, matching the
/// reference's minimal-chrome list rows and cards (replaces both the
/// original hairline-border card and the cream-pass's bordered-plus-shadow
/// card).
BoxDecoration cardDecoration({Color? color, Color? borderColor, double radius = AppRadius.lg}) =>
    BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: borderColor != null ? Border.all(color: borderColor) : null,
      boxShadow: [
        BoxShadow(
          color: AppColors.ink.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 3),
        ),
      ],
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

  TextStyle t(double size, FontWeight w, {Color? c, double? h, double? ls, String? family}) => TextStyle(
        fontFamily: family ?? _fontBody,
        fontSize: size,
        fontWeight: w,
        color: c ?? AppColors.ink,
        height: h,
        letterSpacing: ls,
      );

  TextStyle d(double size, FontWeight w, {Color? c, double? h, double? ls}) =>
      t(size, w, c: c, h: h, ls: ls, family: _fontDisplay);

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: scheme,
    primaryColor: AppColors.accent,
    dividerColor: AppColors.border,
    splashFactory: InkRipple.splashFactory,
    textTheme: base.textTheme
        .apply(fontFamily: _fontBody, bodyColor: AppColors.ink, displayColor: AppColors.ink)
        .copyWith(
          displaySmall: d(28, FontWeight.w800, ls: -0.5),
          headlineSmall: d(22, FontWeight.w800, ls: -0.3),
          titleLarge: t(18, FontWeight.w800),
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
      titleTextStyle: d(20, FontWeight.w800, ls: -0.2),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: t(15, FontWeight.w500, c: AppColors.inkMuted),
      labelStyle: t(15, FontWeight.w500, c: AppColors.inkMuted),
      floatingLabelStyle: t(13, FontWeight.w700, c: AppColors.accent),
      prefixIconColor: AppColors.inkMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        borderSide: BorderSide(color: AppColors.accent, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
        textStyle: t(15, FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size(0, 52),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
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
      side: BorderSide.none,
      labelStyle: t(13, FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
      contentTextStyle: t(14, FontWeight.w600, c: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return t(10, selected ? FontWeight.w700 : FontWeight.w500,
            c: selected ? AppColors.accent : AppColors.inkMuted, ls: 0.1);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
            color: selected ? AppColors.accent : AppColors.inkMuted, size: 22);
      }),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/auth_gate.dart';
import 'core/format.dart';
import 'core/locale_controller.dart';
import 'core/locale_detection.dart';
import 'core/prefs.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';

void main() {
  runApp(const SalonAdminApp());
}

class SalonAdminApp extends StatefulWidget {
  const SalonAdminApp({super.key});

  @override
  State<SalonAdminApp> createState() => _SalonAdminAppState();
}

class _SalonAdminAppState extends State<SalonAdminApp> {
  bool _prefsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    // Rebuild the whole app whenever the accent color or currency changes
    // (Account -> Appearance / Country, or during signup) so every already-
    // built screen picks up the new value on its next frame.
    ThemeController.instance.addListener(_onPrefsChanged);
    CurrencyController.instance.addListener(_onPrefsChanged);
    LocaleController.instance.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    ThemeController.instance.removeListener(_onPrefsChanged);
    CurrencyController.instance.removeListener(_onPrefsChanged);
    LocaleController.instance.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() => setState(() {});

  Future<void> _loadPrefs() async {
    // First launch only: guess country (and its default language) from GPS
    // or device locale, so a brand-new install doesn't sit on the hardcoded
    // English/India default. Never runs again after this, so it can't
    // clobber a choice the user already made (detected or manual).
    if (!await AppPrefs.hasDetectedLocale()) {
      final detected = await detectCountryCode();
      if (detected != null) {
        await AppPrefs.setCountryCode(detected);
        await AppPrefs.setLanguageCode(countryByCode(detected).defaultLanguageCode);
      }
      await AppPrefs.markLocaleDetected();
    }

    final colorId = await AppPrefs.getThemeColorId();
    final countryCode = await AppPrefs.getCountryCode();
    final languageCode = await AppPrefs.getLanguageCode();
    ThemeController.instance.applyLoaded(colorId);
    CurrencyController.instance.applyLoaded(countryCode);
    LocaleController.instance.applyLoaded(languageCode);
    if (mounted) setState(() => _prefsLoaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded) {
      // Keep this minimal — AppColors defaults to teal until prefs load,
      // which is fast enough that this frame is barely visible.
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      title: 'Salon Admin',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: LocaleController.instance.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}
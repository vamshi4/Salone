import 'package:flutter/material.dart';

import 'prefs.dart';

/// Holds the current app locale and notifies listeners (the app root) so
/// the whole app rebuilds with translated strings when it changes. There's
/// no backend field for this yet (see docs/GLOBAL-READINESS.md) — the
/// choice lives in [AppPrefs] on-device only, same pattern as
/// [ThemeController] in theme.dart.
class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  Locale _locale = Locale(kLanguages.first.code);
  Locale get locale => _locale;

  void applyLoaded(String? savedCode) {
    final code = languageByCode(savedCode).code;
    _locale = Locale(code);
    notifyListeners();
  }
}

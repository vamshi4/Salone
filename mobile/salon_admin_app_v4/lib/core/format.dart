import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'prefs.dart';

/// Single shared currency/date formatter, replacing the three near-duplicate
/// `_rupees()` / date-string helpers that existed across main.dart,
/// EarningsScreen, and RetentionScreen in v2. See docs/GLOBAL-READINESS.md
/// ("Currency") — this is the consolidation that doc recommends.
///
/// The currency symbol comes from the on-device country preference (see
/// [AppPrefs]/[CountryOption]), not from the backend — `Salon.currency`
/// doesn't exist yet, so every salon is priced in whatever currency the
/// owner picked locally. Amounts are always stored server-side as an `int`
/// in the smallest currency unit (paise, cents, ...), matching
/// `schema.prisma`; this file is the only place that divides by 100.
class CurrencyController extends ChangeNotifier {
  CurrencyController._();
  static final CurrencyController instance = CurrencyController._();

  String _symbol = kCountries.first.currencySymbol;
  String get symbol => _symbol;

  void applyLoaded(String countryCode) {
    _symbol = countryByCode(countryCode).currencySymbol;
  }

  void applyCountry(String countryCode) {
    _symbol = countryByCode(countryCode).currencySymbol;
    notifyListeners();
  }

  /// Applies the salon's actual stored currency (Salon.currency, an ISO
  /// 4217 code) rather than deriving one from country — this is the real
  /// backend value and should win over whatever the device-local country
  /// pref implies, since currency and country are independently editable
  /// (see docs/GLOBAL-READINESS.md). Falls back to showing the raw code if
  /// it's not one of [kCountries]'s currencies.
  void applyCurrencyCode(String currencyCode) {
    final match = kCountries.where((c) => c.currencyCode == currencyCode);
    _symbol = match.isNotEmpty ? match.first.currencySymbol : currencyCode;
    notifyListeners();
  }
}

/// Formats an amount stored in the smallest currency unit (e.g. paise) as a
/// whole-unit display string with the current currency symbol, e.g. 513000
/// -> "₹5,130". Not every currency has exactly 2 decimal digits (JPY has 0,
/// some have 3) — this assumes 2, matching the "divide by 100" convention
/// already used throughout the backend. See docs/GLOBAL-READINESS.md.
String formatMoney(int minorUnits) {
  final symbol = CurrencyController.instance.symbol;
  final whole = minorUnits / 100;
  final hasFraction = minorUnits % 100 != 0;
  final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: hasFraction ? 2 : 0);
  return formatter.format(whole);
}

/// Short date, e.g. "12 Jul".
String formatShortDate(DateTime date) => DateFormat('d MMM').format(date);

/// Full date, e.g. "12 Jul 2026".
String formatFullDate(DateTime date) => DateFormat('d MMM y').format(date);

/// Time of day, e.g. "4:00 PM".
String formatTime(DateTime date) => DateFormat('h:mm a').format(date);

/// Combined date + time for booking rows, e.g. "12 Jul, 4:00 PM".
String formatDateTime(DateTime date) => '${formatShortDate(date)}, ${formatTime(date)}';

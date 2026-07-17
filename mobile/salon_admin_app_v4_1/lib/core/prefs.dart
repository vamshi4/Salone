import 'package:shared_preferences/shared_preferences.dart';

/// Country + currency + dial-code bundle shown in the signup country picker
/// and the Account "Country and currency" row.
///
/// NOTE: this is a small hand-rolled list, not a full ISO-3166 table — there
/// is no country/locale package in pubspec.yaml yet. It covers enough to
/// demonstrate the flow end to end. See docs/GLOBAL-READINESS.md ("Country")
/// for the real backend fields this should eventually read from
/// (`Salon.countryCode`, `Salon.currency`) instead of local prefs — today
/// the backend has neither field, so this choice is device-local only and
/// does not affect how the backend prices or formats anything server-side.
class CountryOption {
  const CountryOption({
    required this.code,
    required this.name,
    required this.flagEmoji,
    required this.dialCode,
    required this.currencyCode,
    required this.currencySymbol,
    required this.defaultLanguageCode,
  });

  final String code; // ISO 3166-1 alpha-2
  final String name;
  final String flagEmoji;
  final String dialCode; // e.g. "+91"
  final String currencyCode; // ISO 4217, e.g. "INR"
  final String currencySymbol; // e.g. "₹"
  final String defaultLanguageCode; // e.g. "en"
}

const kCountries = <CountryOption>[
  CountryOption(
    code: 'IN',
    name: 'India',
    flagEmoji: '🇮🇳',
    dialCode: '+91',
    currencyCode: 'INR',
    currencySymbol: '₹',
    defaultLanguageCode: 'en',
  ),
  CountryOption(
    code: 'US',
    name: 'United States',
    flagEmoji: '🇺🇸',
    dialCode: '+1',
    currencyCode: 'USD',
    currencySymbol: '\$',
    defaultLanguageCode: 'en',
  ),
  CountryOption(
    code: 'GB',
    name: 'United Kingdom',
    flagEmoji: '🇬🇧',
    dialCode: '+44',
    currencyCode: 'GBP',
    currencySymbol: '£',
    defaultLanguageCode: 'en',
  ),
  CountryOption(
    code: 'AE',
    name: 'United Arab Emirates',
    flagEmoji: '🇦🇪',
    dialCode: '+971',
    currencyCode: 'AED',
    currencySymbol: 'AED',
    defaultLanguageCode: 'en',
  ),
  CountryOption(
    code: 'NP',
    name: 'Nepal',
    flagEmoji: '🇳🇵',
    dialCode: '+977',
    currencyCode: 'NPR',
    currencySymbol: 'रु',
    defaultLanguageCode: 'hi',
  ),
  CountryOption(
    code: 'BD',
    name: 'Bangladesh',
    flagEmoji: '🇧🇩',
    dialCode: '+880',
    currencyCode: 'BDT',
    currencySymbol: '৳',
    defaultLanguageCode: 'bn',
  ),
  CountryOption(
    code: 'MX',
    name: 'Mexico',
    flagEmoji: '🇲🇽',
    dialCode: '+52',
    currencyCode: 'MXN',
    currencySymbol: '\$',
    defaultLanguageCode: 'es',
  ),
  CountryOption(
    code: 'BR',
    name: 'Brazil',
    flagEmoji: '🇧🇷',
    dialCode: '+55',
    currencyCode: 'BRL',
    currencySymbol: 'R\$',
    defaultLanguageCode: 'pt',
  ),
  CountryOption(
    code: 'ID',
    name: 'Indonesia',
    flagEmoji: '🇮🇩',
    dialCode: '+62',
    currencyCode: 'IDR',
    currencySymbol: 'Rp',
    defaultLanguageCode: 'id',
  ),
  CountryOption(
    code: 'EG',
    name: 'Egypt',
    flagEmoji: '🇪🇬',
    dialCode: '+20',
    currencyCode: 'EGP',
    currencySymbol: 'E£',
    defaultLanguageCode: 'ar',
  ),
  CountryOption(
    code: 'TR',
    name: 'Turkey',
    flagEmoji: '🇹🇷',
    dialCode: '+90',
    currencyCode: 'TRY',
    currencySymbol: '₺',
    defaultLanguageCode: 'tr',
  ),
  CountryOption(
    code: 'DE',
    name: 'Germany',
    flagEmoji: '🇩🇪',
    dialCode: '+49',
    currencyCode: 'EUR',
    currencySymbol: '€',
    defaultLanguageCode: 'de',
  ),
  CountryOption(
    code: 'IT',
    name: 'Italy',
    flagEmoji: '🇮🇹',
    dialCode: '+39',
    currencyCode: 'EUR',
    currencySymbol: '€',
    defaultLanguageCode: 'it',
  ),
  CountryOption(
    code: 'PK',
    name: 'Pakistan',
    flagEmoji: '🇵🇰',
    dialCode: '+92',
    currencyCode: 'PKR',
    currencySymbol: 'Rs',
    defaultLanguageCode: 'ur',
  ),
  CountryOption(
    code: 'FR',
    name: 'France',
    flagEmoji: '🇫🇷',
    dialCode: '+33',
    currencyCode: 'EUR',
    currencySymbol: '€',
    defaultLanguageCode: 'fr',
  ),
  CountryOption(
    code: 'RU',
    name: 'Russia',
    flagEmoji: '🇷🇺',
    dialCode: '+7',
    currencyCode: 'RUB',
    currencySymbol: '₽',
    defaultLanguageCode: 'ru',
  ),
  CountryOption(
    code: 'VN',
    name: 'Vietnam',
    flagEmoji: '🇻🇳',
    dialCode: '+84',
    currencyCode: 'VND',
    currencySymbol: '₫',
    defaultLanguageCode: 'vi',
  ),
  CountryOption(
    code: 'KE',
    name: 'Kenya',
    flagEmoji: '🇰🇪',
    dialCode: '+254',
    currencyCode: 'KES',
    currencySymbol: 'KSh',
    defaultLanguageCode: 'sw',
  ),
  CountryOption(
    code: 'PH',
    name: 'Philippines',
    flagEmoji: '🇵🇭',
    dialCode: '+63',
    currencyCode: 'PHP',
    currencySymbol: '₱',
    defaultLanguageCode: 'fil',
  ),
  CountryOption(
    code: 'MY',
    name: 'Malaysia',
    flagEmoji: '🇲🇾',
    dialCode: '+60',
    currencyCode: 'MYR',
    currencySymbol: 'RM',
    defaultLanguageCode: 'ms',
  ),
  CountryOption(
    code: 'PL',
    name: 'Poland',
    flagEmoji: '🇵🇱',
    dialCode: '+48',
    currencyCode: 'PLN',
    currencySymbol: 'zł',
    defaultLanguageCode: 'pl',
  ),
  CountryOption(
    code: 'IR',
    name: 'Iran',
    flagEmoji: '🇮🇷',
    dialCode: '+98',
    currencyCode: 'IRR',
    currencySymbol: '﷼',
    defaultLanguageCode: 'fa',
  ),
  CountryOption(
    code: 'UA',
    name: 'Ukraine',
    flagEmoji: '🇺🇦',
    dialCode: '+380',
    currencyCode: 'UAH',
    currencySymbol: '₴',
    defaultLanguageCode: 'uk',
  ),
  CountryOption(
    code: 'RO',
    name: 'Romania',
    flagEmoji: '🇷🇴',
    dialCode: '+40',
    currencyCode: 'RON',
    currencySymbol: 'lei',
    defaultLanguageCode: 'ro',
  ),
];

class LanguageOption {
  const LanguageOption(this.code, this.label, this.defaultCountryCode);
  final String code;
  final String label;
  /// Country whose currency/dial-code is applied when this language is
  /// picked directly (e.g. from Account -> Appearance), so currency tracks
  /// language even if the user never opens the separate Country picker.
  /// For languages spoken across many countries (English, Spanish, Arabic,
  /// French, Portuguese) this is a reasonable single default, not a claim
  /// that it's the "correct" country — the Country picker remains the
  /// precise way to set currency independent of language.
  final String defaultCountryCode;
}

/// Top 25 languages weighted by WhatsApp usage in each market (the app's
/// core reach-out feature is the wa.me reminder flow in RetentionScreen),
/// not raw global speaker count. Every one of these has a matching
/// lib/l10n/app_<code>.arb translation file — see docs/GLOBAL-READINESS.md.
const kLanguages = <LanguageOption>[
  LanguageOption('en', 'English', 'US'),
  LanguageOption('hi', 'हिन्दी', 'IN'),
  LanguageOption('es', 'Español', 'MX'),
  LanguageOption('pt', 'Português', 'BR'),
  LanguageOption('id', 'Bahasa Indonesia', 'ID'),
  LanguageOption('ar', 'العربية', 'EG'),
  LanguageOption('tr', 'Türkçe', 'TR'),
  LanguageOption('de', 'Deutsch', 'DE'),
  LanguageOption('it', 'Italiano', 'IT'),
  LanguageOption('bn', 'বাংলা', 'BD'),
  LanguageOption('ur', 'اردو', 'PK'),
  LanguageOption('fr', 'Français', 'FR'),
  LanguageOption('ru', 'Русский', 'RU'),
  LanguageOption('vi', 'Tiếng Việt', 'VN'),
  LanguageOption('sw', 'Kiswahili', 'KE'),
  LanguageOption('mr', 'मराठी', 'IN'),
  LanguageOption('te', 'తెలుగు', 'IN'),
  LanguageOption('ta', 'தமிழ்', 'IN'),
  LanguageOption('gu', 'ગુજરાતી', 'IN'),
  LanguageOption('fil', 'Filipino', 'PH'),
  LanguageOption('ms', 'Bahasa Melayu', 'MY'),
  LanguageOption('pl', 'Polski', 'PL'),
  LanguageOption('fa', 'فارسی', 'IR'),
  LanguageOption('uk', 'Українська', 'UA'),
  LanguageOption('ro', 'Română', 'RO'),
];

CountryOption countryByCode(String? code) => kCountries.firstWhere(
      (c) => c.code == code,
      orElse: () => kCountries.first,
    );

LanguageOption languageByCode(String? code) => kLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => kLanguages.first,
    );

/// Device-local app preferences: theme color, country, and language.
/// None of these are synced to the backend yet — see docs/GLOBAL-READINESS.md.
class AppPrefs {
  static const _themeColorKey = 'pref_theme_color_id';
  static const _countryKey = 'pref_country_code';
  static const _languageKey = 'pref_language_code';
  static const _localeDetectedKey = 'pref_locale_detected';

  static Future<String?> getThemeColorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeColorKey);
  }

  static Future<void> setThemeColorId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeColorKey, id);
  }

  static Future<String> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_countryKey) ?? kCountries.first.code;
  }

  static Future<void> setCountryCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, code);
  }

  static Future<String> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? kLanguages.first.code;
  }

  static Future<void> setLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
  }

  /// Whether first-launch country/language auto-detection has already run
  /// on this device (see core/locale_detection.dart). Detection should only
  /// ever run once — after that, whatever the user has saved (detected or
  /// manually picked) is authoritative and must not be silently overwritten
  /// on a later cold start.
  static Future<bool> hasDetectedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_localeDetectedKey) ?? false;
  }

  static Future<void> markLocaleDetected() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_localeDetectedKey, true);
  }
}

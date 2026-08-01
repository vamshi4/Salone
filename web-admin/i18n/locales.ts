// Matches mobile's lib/l10n/ language set (salon_admin_app_v4_1) so the two
// clients offer the same languages, even though the translated strings
// themselves are separate (the UI copy differs between web and mobile).
export const locales = [
  'en', 'hi', 'te', 'ta', 'bn', 'gu', 'mr', 'ur',
  'ar', 'fa', 'tr',
  'es', 'fr', 'de', 'it', 'pt', 'pl', 'ro', 'ru', 'uk',
  'id', 'ms', 'fil', 'vi', 'sw',
] as const;

export type Locale = (typeof locales)[number];

export const defaultLocale: Locale = 'en';

export const localeNames: Record<Locale, string> = {
  en: 'English',
  hi: 'हिन्दी',
  te: 'తెలుగు',
  ta: 'தமிழ்',
  bn: 'বাংলা',
  gu: 'ગુજરાતી',
  mr: 'मराठी',
  ur: 'اردو',
  ar: 'العربية',
  fa: 'فارسی',
  tr: 'Türkçe',
  es: 'Español',
  fr: 'Français',
  de: 'Deutsch',
  it: 'Italiano',
  pt: 'Português',
  pl: 'Polski',
  ro: 'Română',
  ru: 'Русский',
  uk: 'Українська',
  id: 'Bahasa Indonesia',
  ms: 'Bahasa Melayu',
  fil: 'Filipino',
  vi: 'Tiếng Việt',
  sw: 'Kiswahili',
};

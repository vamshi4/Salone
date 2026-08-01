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

// Picks the best-supported locale out of a browser's `Accept-Language`
// header (e.g. "en-US,en;q=0.9,hi;q=0.8") — used to pick a sensible first
// render for visitors who haven't set the `locale` cookie yet, instead of
// always defaulting to English. Falls back to defaultLocale on no match.
export function parseAcceptLanguage(header: string | null | undefined): Locale {
  if (!header) return defaultLocale;
  const tags = header
    .split(',')
    .map((part) => {
      const [tag, q] = part.trim().split(';q=');
      return { tag: tag.split('-')[0].toLowerCase(), quality: q ? parseFloat(q) : 1 };
    })
    .sort((a, b) => b.quality - a.quality);
  for (const { tag } of tags) {
    if (locales.includes(tag as Locale)) return tag as Locale;
  }
  return defaultLocale;
}

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

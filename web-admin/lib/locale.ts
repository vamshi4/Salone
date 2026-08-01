import type { Locale } from '@/i18n/locales';

// Plain (non-httpOnly) cookie — this is only a UI display preference, not
// sensitive, and next-intl's i18n/request.ts reads it server-side to pick
// which message catalog to load for the next render.
export function setLocaleCookie(locale: Locale) {
  document.cookie = `locale=${locale}; path=/; max-age=${60 * 60 * 24 * 365}; samesite=lax`;
}

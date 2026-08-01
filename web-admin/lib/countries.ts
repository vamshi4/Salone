// The country/currency pairs offered at signup and editable later from
// Account > Preferences. Mirrors mobile's kCountries
// (mobile/salon_admin_app_v4_1/lib/core/prefs.dart) so both apps offer the
// same markets — flag/dial-code/currency data kept in lockstep, and the
// dial codes match backend/src/country-dial-codes.ts (bare digits there,
// '+' prefixed for display here). Labels live under the
// `signup.countries.*` message namespace (translated in all 25 locales) so
// both places share one translated string instead of duplicating it.
export const COUNTRIES = [
  { code: 'IN', currency: 'INR', dialCode: '91', flag: '🇮🇳', phonePlaceholder: '98765 43210' },
  { code: 'US', currency: 'USD', dialCode: '1', flag: '🇺🇸', phonePlaceholder: '415 555 0100' },
  { code: 'GB', currency: 'GBP', dialCode: '44', flag: '🇬🇧', phonePlaceholder: '7911 123456' },
  { code: 'AE', currency: 'AED', dialCode: '971', flag: '🇦🇪', phonePlaceholder: '50 123 4567' },
  { code: 'NP', currency: 'NPR', dialCode: '977', flag: '🇳🇵', phonePlaceholder: '984 123 4567' },
  { code: 'BD', currency: 'BDT', dialCode: '880', flag: '🇧🇩', phonePlaceholder: '1712 345678' },
  { code: 'MX', currency: 'MXN', dialCode: '52', flag: '🇲🇽', phonePlaceholder: '55 1234 5678' },
  { code: 'BR', currency: 'BRL', dialCode: '55', flag: '🇧🇷', phonePlaceholder: '11 91234 5678' },
  { code: 'ID', currency: 'IDR', dialCode: '62', flag: '🇮🇩', phonePlaceholder: '812 3456 789' },
  { code: 'EG', currency: 'EGP', dialCode: '20', flag: '🇪🇬', phonePlaceholder: '100 123 4567' },
  { code: 'TR', currency: 'TRY', dialCode: '90', flag: '🇹🇷', phonePlaceholder: '501 234 56 78' },
  { code: 'DE', currency: 'EUR', dialCode: '49', flag: '🇩🇪', phonePlaceholder: '151 12345678' },
  { code: 'IT', currency: 'EUR', dialCode: '39', flag: '🇮🇹', phonePlaceholder: '312 345 6789' },
  { code: 'PK', currency: 'PKR', dialCode: '92', flag: '🇵🇰', phonePlaceholder: '300 1234567' },
  { code: 'FR', currency: 'EUR', dialCode: '33', flag: '🇫🇷', phonePlaceholder: '6 12 34 56 78' },
  { code: 'RU', currency: 'RUB', dialCode: '7', flag: '🇷🇺', phonePlaceholder: '912 345 67 89' },
  { code: 'VN', currency: 'VND', dialCode: '84', flag: '🇻🇳', phonePlaceholder: '91 234 56 78' },
  { code: 'KE', currency: 'KES', dialCode: '254', flag: '🇰🇪', phonePlaceholder: '712 345678' },
  { code: 'PH', currency: 'PHP', dialCode: '63', flag: '🇵🇭', phonePlaceholder: '917 123 4567' },
  { code: 'MY', currency: 'MYR', dialCode: '60', flag: '🇲🇾', phonePlaceholder: '12 345 6789' },
  { code: 'PL', currency: 'PLN', dialCode: '48', flag: '🇵🇱', phonePlaceholder: '512 345 678' },
  { code: 'IR', currency: 'IRR', dialCode: '98', flag: '🇮🇷', phonePlaceholder: '912 345 6789' },
  { code: 'UA', currency: 'UAH', dialCode: '380', flag: '🇺🇦', phonePlaceholder: '50 123 4567' },
  { code: 'RO', currency: 'RON', dialCode: '40', flag: '🇷🇴', phonePlaceholder: '721 234 567' },
] as const;

export type CountryCode = (typeof COUNTRIES)[number]['code'];

export const DIAL_CODES: Record<CountryCode, string> = Object.fromEntries(
  COUNTRIES.map((c) => [c.code, c.dialCode])
) as Record<CountryCode, string>;

export const PHONE_PLACEHOLDERS: Record<CountryCode, string> = Object.fromEntries(
  COUNTRIES.map((c) => [c.code, c.phonePlaceholder])
) as Record<CountryCode, string>;

export const FLAGS: Record<CountryCode, string> = Object.fromEntries(
  COUNTRIES.map((c) => [c.code, c.flag])
) as Record<CountryCode, string>;

// Pre-fills the signup country/currency picker from the browser's own
// language list (e.g. "en-GB" -> GB, "vi-VN" -> VN) — it stays a manual,
// editable choice, never used to silently change an existing salon's
// already-saved currency. Falls back to India, this product's home market.
export function detectCountryCode(): CountryCode {
  if (typeof navigator === 'undefined') return 'IN';
  const codes = new Set(COUNTRIES.map((c) => c.code));
  for (const tag of navigator.languages ?? [navigator.language]) {
    const region = tag.split('-')[1]?.toUpperCase();
    if (region && codes.has(region as CountryCode)) {
      return region as CountryCode;
    }
  }
  return 'IN';
}

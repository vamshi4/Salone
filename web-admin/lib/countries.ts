// The country/currency pairs offered at signup and editable later from
// Account > Preferences. Labels live under the `signup.countries.*` message
// namespace (already translated in all 25 locales) so both places share one
// translated string instead of duplicating it.
export const COUNTRIES = [
  { code: 'IN', currency: 'INR' },
  { code: 'AE', currency: 'AED' },
  { code: 'US', currency: 'USD' },
  { code: 'GB', currency: 'GBP' },
] as const;

// Matches backend/src/country-dial-codes.ts (bare digits, no '+') — the
// phone number itself is always submitted bare/national-format (backend
// just trims it and stores it verbatim), so this is a visual prefix only,
// never concatenated into the submitted value.
export const DIAL_CODES: Record<(typeof COUNTRIES)[number]['code'], string> = {
  IN: '91',
  AE: '971',
  US: '1',
  GB: '44',
};

export const PHONE_PLACEHOLDERS: Record<(typeof COUNTRIES)[number]['code'], string> = {
  IN: '98765 43210',
  AE: '50 123 4567',
  US: '415 555 0100',
  GB: '7911 123456',
};

// Pre-fills the signup country/currency picker from the browser's own
// language list (e.g. "en-GB" -> GB, "ar-AE" -> AE) — it stays a manual,
// editable choice, never used to silently change an existing salon's
// already-saved currency. Falls back to India, this product's home market.
export function detectCountryCode(): (typeof COUNTRIES)[number]['code'] {
  if (typeof navigator === 'undefined') return 'IN';
  const codes = new Set(COUNTRIES.map((c) => c.code));
  for (const tag of navigator.languages ?? [navigator.language]) {
    const region = tag.split('-')[1]?.toUpperCase();
    if (region && codes.has(region as (typeof COUNTRIES)[number]['code'])) {
      return region as (typeof COUNTRIES)[number]['code'];
    }
  }
  return 'IN';
}

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

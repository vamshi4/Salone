// Mirrors mobile/salon_admin_app_v3/lib/core/prefs.dart's kCountries — keep
// both lists in sync when adding a country. Used to turn a salon's stored
// countryCode into the dial-code prefix a bare national-format phone number
// needs before it can be sent to the WhatsApp Cloud API (which requires full
// E.164 digits, no leading '+').
export const countryDialCodes: Record<string, string> = {
  IN: '91',
  US: '1',
  GB: '44',
  AE: '971',
  NP: '977',
  BD: '880',
  MX: '52',
  BR: '55',
  ID: '62',
  EG: '20',
  TR: '90',
  DE: '49',
  IT: '39',
  PK: '92',
  FR: '33',
  RU: '7',
  VN: '84',
  KE: '254',
  PH: '63',
  MY: '60',
  PL: '48',
  IR: '98',
  UA: '380',
  RO: '40',
};

export function dialCodeFor(countryCode: string | null | undefined): string {
  return countryDialCodes[countryCode || 'IN'] || countryDialCodes.IN;
}

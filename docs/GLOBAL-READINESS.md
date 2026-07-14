# Going Global — Language, Currency, Country, and DB Strategy

Scope: what changes across backend (`schema.prisma`, API) and the three Flutter apps to support
multiple countries, currencies, and languages, plus a data architecture that stays on one Postgres
database now but can split by country later without a rewrite.

## 1. Language (i18n)

Today every string in `main.dart` (and the customer/stylist apps) is hardcoded English.

- Adopt Flutter's `intl` package with ARB files (`lib/l10n/app_en.arb`, `app_hi.arb`, ...). Run
  `flutter gen-l10n` to generate typed accessors (`AppLocalizations.of(context).newBooking`).
- Every user-facing string in `main.dart` needs to move into an ARB key. Given the file is ~5,000
  lines of inline `Text('...')`, this is the single largest line-count task in this whole effort —
  budget for it separately from the color/currency work.
- Store the salon's/user's language preference (`languageCode`, e.g. `en`, `hi`) on `User`. Default
  from device locale at signup, let them override in the country/language step already mocked above.
- Dates: don't hand-format (`'${d.day}/${d.month}/${d.year}'` appears in `RetentionScreen`). Use
  `DateFormat.yMMMd(locale)` from `intl` so day/month order matches the user's locale.
- Numbers: same — route through `NumberFormat`, not string interpolation.
- Backend stays language-agnostic. It should never embed user-facing copy in responses (check for
  any hardcoded English error strings returned to the app and move those to client-side lookup by
  an error code instead).

## 2. Currency

Amounts are already stored as `Int` in the smallest currency unit (`price`, `basePrice`,
`salonPayout`, etc. in `schema.prisma`) — this is the right storage format and needs no migration.
What's missing is the currency *identity* and *display*.

- Add `currency String @default("INR")` to `Salon` (ISO 4217 code: `INR`, `USD`, `GBP`, ...). A
  booking's price is always in its salon's currency, so the field belongs on `Salon`, not `Booking`.
- Replace every hardcoded `'₹${amount ~/ 100}'` / `_rupees()` helper (there are at least three
  near-duplicate versions of this across `main.dart`, `EarningsScreen`, `RetentionScreen`) with one
  shared formatter: `NumberFormat.currency(locale: ..., name: salon.currency).format(amount / 100)`.
  Consolidating those duplicates is worth doing regardless of the global push — right now a fix to
  the rupee-formatting logic has to be repeated in three places.
- Smallest-unit assumption: not every currency has 2 decimal places (JPY has 0, some have 3). If
  multi-currency actually ships, either keep a per-currency `minorUnitExponent` lookup table or
  constrain to currencies where "divide by 100" holds, and validate at signup.

## 3. Country

No `country` field exists anywhere yet (`Salon.address` is free text, `User.phone` has no explicit
dial code). Country is what drives currency default, phone format, and language default in the
signup flow mocked above.

- Add `countryCode String @default("IN")` (ISO 3166-1 alpha-2) to `Salon` and to `User` (a customer
  could sign up from a different country than the salon in principle, though for v1 they'll match).
- Store phone numbers in E.164 (`+91XXXXXXXXXX`) instead of the current bare-digit `phone` field, so
  a number is unambiguous without also carrying country separately. Validate against the selected
  country's format at signup (the mocked country picker sets the dial-code prefix).
- Country selection at signup should set sensible defaults (currency, language, dial code) but all
  three should remain independently editable — a salon owner may want English UI with INR pricing,
  for instance.

## 4. Database strategy — single DB now, country-shardable later

Splitting into one physical database per country is real infrastructure work (connection routing,
cross-country reporting, migrations run N times) and isn't justified before there's demand in more
than one country. The goal here is only to avoid decisions now that make that split harder later.

What already helps: every model uses `cuid()` string primary keys, not auto-increment integers.
That means rows from two different country databases could be merged or moved without ID
collisions — this is the hard part of a later split, and it's already handled.

What to add now, while it's cheap:

- Put `countryCode` directly on the tenant root (`Salon`, and `User` for customers/stylists not
  attached to a salon). Every row that hangs off a salon (`Booking`, `Service`, `SalonCustomer`,
  `SalonStylist`) already reaches its country transitively through `salonId` — don't duplicate the
  column onto every child table, just make sure no query joins across two salons' data without
  going through that root.
- Keep a single data-access layer (the existing route handlers calling `prisma.*` directly are
  fine for now, but avoid raw SQL that assumes a single global connection) so that "which database
  do I connect to for this salon" can become a lookup keyed on `countryCode` later, without
  touching business logic.
- Avoid any feature that requires a cross-country join or a global unique constraint that isn't
  already scoped by country (e.g. don't add a globally-unique salon slug without checking this).
- When/if a country split does happen, the migration path is: stand up a new Postgres per target
  country, copy that country's rows (filtered by `countryCode`), point a connection-routing layer
  at the right database per request. No ID remapping needed because of the `cuid()` choice above.

## 5. Other gaps for going global (not yet covered)

- **Timezones**: `slotStart`/`slotEnd`/`completedAt` are stored as `DateTime` (UTC in Postgres) but
  rendered with local device time (`DateTime.parse(...).toLocal()` in a few places, plain
  `DateTime.parse` without `.toLocal()` in others — inconsistent). Store `timezone` on `Salon`
  (IANA name, e.g. `Asia/Kolkata`) and always render booking times in the salon's timezone, not the
  viewing device's timezone — otherwise a booking made from a different timezone displays wrong.
- **Phone/WhatsApp reach-out**: `RetentionScreen._remind()` hardcodes `91$digits` when a number is
  10 digits (assumes India). This breaks for any other country — derive the dial code from the
  stored country/E.164 number instead of a length heuristic.
- **Tax**: no tax/GST field exists on `Service` or `Booking`. Countries differ on whether tax is
  inclusive or added at checkout, and on labeling (GST vs VAT vs sales tax). Not urgent until
  payments ship, but worth noting since payments are already a P0 gap per `PRODUCTION_READINESS.md`.
- **Address format**: `Salon.address` is one free-text field. Fine for India; some countries expect
  structured fields (street/city/state/postal code) for shipping/legal/tax purposes. Low priority
  unless a specific country needs it.
- **Legal**: `docs/legal/` should be checked for whether privacy/terms content is India-specific
  (e.g. references to Indian law) before presenting the app as available elsewhere.
- **App store listings**: currently one listing (per `brand/` assets). Multi-language app store
  metadata and screenshots are a separate, non-technical task once UI localization lands.

## Suggested build order

1. Schema: add `currency`, `countryCode` to `Salon`; `countryCode` to `User`; switch `phone` storage
   to E.164.
2. Backend: derive currency/timezone from `salon.currency`/`salon.timezone` wherever an amount or
   time is formatted server-side (push notification copy, if/when that ships).
3. App: consolidate the three duplicate rupee-formatting helpers into one currency-aware formatter;
   wire the signup country/language step (already mocked) to set these fields.
4. App: introduce `intl` + ARB files; migrate strings incrementally (start with Home/Bookings/Staff,
   the screens already redesigned in this pass) rather than all ~5,000 lines at once.
5. Fix the WhatsApp dial-code assumption and timezone-naive date rendering while touching those
   files anyway.

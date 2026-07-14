# Salon Admin App v3 — Handoff

_Written 2026-07-12, updated 2026-07-13. v3 is now the primary/installed salon
admin app (device `ed083e3d`) — verified end-to-end, `flutter analyze` clean,
localization + real backend currency/country wired up. v2 is superseded, kept
only as reference (see status update at the bottom of this file)._

## What this is

A full redesign + rebuild of the salon admin app (`mobile/salon_admin_app_v2`
→ `mobile/salon_admin_app_v3`), done collaboratively over a chat session:
current screens were reviewed, a new direction was mocked screen-by-screen
(Home, Bookings, Staff, Add staff, New booking, Insights, Account, sign-in/up,
theme picker), then built out in Flutter. Same backend, same `Salone` API —
nothing on the server changed.

Two product decisions drove the redesign, both confirmed with the owner
mid-session:

1. **No pre-booking is the common case.** The salon logs walk-ins manually
   after the fact ("Done service" mode, already in v2 via
   `docs/WALKIN-FLOW-DESIGN.md`) rather than taking advance customer
   bookings. So Home leads with a **New booking** button and a log of what's
   already been recorded today — not a schedule or a "needs your response"
   queue. That queue still exists as a real feature (a customer can still
   request a reschedule, an admin can still "Schedule later") — it just moved
   to the **Bookings** tab as a small banner instead of dominating Home.
2. **Bottom navigation replaces the app-bar icon stack.** v2's app bar had six
   unlabeled icons (new booking, earnings, retention, refresh, account,
   logout) crammed next to the salon name. v3 uses five bottom-nav
   destinations — **Home, Bookings, Staff, Insights, Account** — with
   Earnings and Retention merged into Insights (sub-tab toggle) and Account
   replacing the old settings-sheet-behind-an-icon pattern.

## Where things are

```
mobile/salon_admin_app_v3/
  lib/
    main.dart                 — app entry, loads prefs, wires ThemeController/CurrencyController
    theme.dart                 — design tokens + 5 selectable accent colors (was: fixed teal)
    core/
      api.dart                 — Dio client + bearer token storage (was: _api() in main.dart)
      format.dart               — shared currency/date formatting (was: 3 duplicate _rupees())
      prefs.dart                — device-local country/language/theme-color storage
      location.dart             — GPS + reverse geocode (unchanged from v2)
      helpers.dart               — customerKey, effectiveBookingTime, dateInput, etc.
    auth/
      login_screen.dart, signup_flow.dart (3-step: country+phone+password, salon
      details, pick color), update_required_screen.dart, auth_gate.dart
    shell/
      dashboard_data.dart        — shared salon/bookings/staff state (was: AdminDashboardScreen's state)
      dashboard_scope.dart        — InheritedNotifier exposing it to every tab
      root_shell.dart              — the bottom-nav Scaffold
    screens/                     — home, bookings, staff, insights, account
    sheets/                      — add_staff_sheet, staff_manage_sheet, new_booking_sheet
    widgets/                      — shared cards/rows/pickers used across screens
```

Same `applicationId` (`com.chairful.admin`) as v2 — v3 is meant to eventually
replace v2 as the installed app, not run alongside it as a separate app.

## What's wired to the real backend vs. what's local-only

Everything that existed in v2 — auth, dashboard/bookings/staff load, manual
booking (including the Done service / Schedule later toggle and customer
autocomplete), staff services/hours CRUD, earnings, retention (cohorts,
at-risk, missed, WhatsApp reminders), account profile + password — hits the
**same endpoints with the same payloads** as v2. No backend changes were made.

Three things are new and are **device-local only**, saved via
`SharedPreferences` (`AppPrefs`), not synced to the backend:

- **Theme color** — 5 accent choices, picked at signup step 3 or later in
  Account → Appearance.
- **Country / currency** — picked at signup step 1, editable in Account. Drives
  the dial-code prefix and the currency symbol used by `formatMoney()`.
- **Language** — picked alongside country. **The picker is real; the
  translations are not** — only English strings exist anywhere in the app.
  Picking Hindi/Nepali/Bengali saves the preference but changes nothing on
  screen yet.

None of `Salon.currency`, `Salon.countryCode`, or any language field exist in
`schema.prisma` yet. Full plan for adding them (and why single-DB-now,
shardable-by-country-later is the right call) is in
**`docs/GLOBAL-READINESS.md`** — read that before making country/currency
"real" on the backend.

## One behavior change worth flagging: multi-service staff setup

v2's "Add staff" only took one starter service (`staff-setup` endpoint is
single-service by design). The redesign asked for adding several services up
front, so v3's `AddStaffSheet` does this **without a backend change**: the
first service goes through the existing `staff-setup` call, then each
additional service is added with its own call to the existing
`POST /stylists/:id/services`. Works, but adding N services at signup means
N+1 requests. If that ever matters, the real fix is a backend change to accept
`services: [{name, price}, ...]` in `staff-setup` directly.

## Known gaps / what's not done

- **Never compiled.** This environment has no Flutter/Dart toolchain, so
  nothing here has run through `flutter analyze` or `flutter run`. The code
  was written carefully and cross-checked by hand (import paths resolve,
  brace/paren balance, no `const`-with-mutable-color bugs, no stray references
  to old v2 private class names), but **treat first build as the real test.**
  Start with:
  ```powershell
  cd mobile/salon_admin_app_v3
  flutter pub get
  flutter analyze
  flutter run --dart-define=API_URL=http://YOUR_PC_IP:3000
  ```
- **`test/widget_test.dart`** still passes conceptually (it just checks the
  literal string "Salon Admin" isn't rendered, which is still true), but
  **`integration_test/*.dart` (667 lines) will fail** — they drive v2's
  segmented-tab navigation and single-service staff setup, both gone in v3.
  Specifically broken finders: `dashboard_tab_bookings` / `dashboard_tab_staff`
  (now separate bottom-nav destinations, not tabs), `staff_setup_service` /
  `staff_setup_price` (now a dynamic multi-service list), `auth_toggle_mode`
  (login and signup are now separate screens, not one toggle). Everything
  else (`auth_phone`, `booking_create`, `staff_add_button`,
  `account_save_profile`, etc.) kept the same `Key` on purpose so those finders
  still work once the navigation steps around them are updated.
- **`fl_chart` dependency was dropped** — it was in v2's pubspec but the
  retention cohort donut is now a small hand-rolled `CustomPainter`
  (`_DonutPainter` in `insights_screen.dart`) instead, to avoid pinning to an
  unverified chart-library API without a compiler to check it against. Trade
  fewer dependencies for a slightly less polished chart; swap back to
  `fl_chart`'s `PieChart` if you want the nicer animation and have a way to
  test it.
- **A latent bug from v2 was NOT carried over**: v2's manual booking sheet
  calls `.firstOrNull` on a `List` without importing `package:collection`,
  which likely doesn't resolve (Dart doesn't ship that extension in core).
  v3 uses the existing `firstOrNull()` helper function everywhere instead. If
  v2 is still in use, worth checking whether that line actually compiles.

## Suggested next steps

1. Run the three commands above. Fix whatever `flutter analyze` surfaces —
   there will likely be small things (a missing named parameter, a type
   mismatch) that only a real compiler catches.
2. Rewrite `integration_test/*.dart` for the new navigation (bottom nav
   `find.text('Bookings')` instead of tab keys; multi-service staff setup
   instead of single fields). Still not done — the 667-line v2 suite hasn't
   been ported.
3. ~~Once it's verified end-to-end on the phone, swap v3 in as the primary
   app the way v2 replaced v1.~~ **Done 2026-07-13** — see status update below.
4. ~~Then pick up `docs/GLOBAL-READINESS.md` if country/currency/language
   should become real backend fields.~~ **Done** — see below.

## Status update — 2026-07-13

Everything in "Known gaps" above except the integration tests has been
resolved this session:

- **Compiled and verified on device.** `flutter analyze` is clean (0 issues).
  Installed and launched on `ed083e3d` multiple times across this session with
  no Flutter exceptions.
- **Localization is real**, not just a picker: `flutter_localizations` + ARB
  files for the top 25 world languages (by WhatsApp usage per market), full
  MaterialApp locale wiring, ~190 translated keys per language. GPS-first +
  device-locale-fallback auto-detection on first launch
  (`core/locale_detection.dart`).
- **`Salon.currency` and `Salon.countryCode` are now real backend fields**
  (`schema.prisma`), populated at signup and editable via `PATCH /auth/me`.
  `CurrencyController.applyCurrencyCode()` makes the salon's stored currency
  (not the device-local pref) the source of truth once a salon record loads —
  see `shell/dashboard_data.dart`. The plan in `docs/GLOBAL-READINESS.md` for
  making these real has been executed (single-DB, not sharded — that part of
  the plan is still just a future option, not needed yet).
- **WhatsApp reminders derive the dial code from `salon.countryCode`**
  instead of hardcoding India's `91` — fixed in `insights_screen.dart`'s
  `_remind()`. Verified live on-device: correct `+91` prefix, correct number,
  correct message.
- **Insights (Earnings + Retention) was reworked to be the app's core value
  proposition** — added period-over-period comparison chips, top
  services/staff ranking, reactivated-customer count, and a "wins" summary
  section, on top of the existing retention cohorts and WhatsApp reminders.
- Realistic multi-month seed data available for any existing owner's salon via
  `backend/prisma/seed-owner-salon.ts` (`npx tsx prisma/seed-owner-salon.ts`,
  override phone via `SEED_OWNER_PHONE`) — additive only, safe to re-run.
- **v3 is now the primary/installed app** (same `applicationId` as v2, so
  installing v3 already replaced v2 on-device). `AGENTS.md` updated
  accordingly. v2's folder is left in place as reference/rollback, not
  deleted.

Still open: the integration test rewrite (item 2 above), and native-speaker
review of the 24 non-English translations (machine-translated, not yet
proofread by a native speaker of each language).

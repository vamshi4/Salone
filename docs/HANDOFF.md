# Session Handoff — Retention Analytics + Admin App Redesign

> Living record for the next agent (Codex/Claude). **Read this first**, then
> `docs/STATUS.md` (crisp current-state summary), then `AGENTS.md`. Sequential
> hand-off only — one agent works at a time. When you stop: commit, append to
> this file (what + why), and run `graphify update .`.
>
> **New chat starting fresh with no prior context?** Read, in order:
> `docs/STATUS.md` → this file (skip to the 2026-07-14 v4 redesign entry at
> the bottom, it's the most recent) → `docs/HANDOFF-SALON-ADMIN-V3.md` (v3 app
> details) → `docs/GLOBAL-READINESS.md` (currency/language backend design).

_Last updated: 2026-07-17 · Branch: `feature/retention-and-redesign` · Canonical dir: `D:\vamshi\Salone`_

> **Starting cold and want the newest state?** Skip straight to the
> **2026-07-15 → 2026-07-17** entry at the very bottom of this file — it supersedes everything
> above it in terms of "what's the current app state." Read `docs/STATUS.md`'s warning box first
> though; it has the short version + the exact release blockers.

## Canonical location (important)
- Do **all** work in `D:\vamshi\Salone`. A stale sibling copy `D:\vamshi\Salone2`
  exists — ignore it.
- Current work lives on branch **`feature/retention-and-redesign`** (4 commits on
  top of `main` @ `1f51760`). Not yet merged or pushed.

## What changed this session (and why)

### 1. Password auth for salon owners — `backend/src/routes/auth.routes.ts`, `mobile/salon_admin_app`
- Signup/login now require a password (scrypt hash `scrypt$salt$hash`), plus a
  `change-password` endpoint. **Why:** owners are paying customers; phone-only
  "auth" wasn't real security.
- New **Account Settings** sheet (top profile icon): edit owner/phone/email/
  salon/address + change password; shows role/plan/joined.

### 2. Month-end retention analytics (the flagship "pay-for" feature)
- Backend `GET /api/v2/salons/:id/retention` → new/retained(constant)/churned/
  reactivated cohorts + %s, churn rate, revenue delta, and a **"missed"** list
  (customers active last month but not this month). **Why:** owners will pay to
  see who stopped coming and win them back.
- Admin screen `RetentionScreen` (query_stats app-bar icon), gated by
  `saasPlan` (FREE → upsell). "Missed" customers have one-tap **WhatsApp
  reminders** (`wa.me`, via `url_launcher`). Verified end-to-end on device.

### 3. Demo salon — `backend/prisma/seed-demo.ts` (`npm run prisma:seed:demo`)
- "Glamour Salon", 3 stylists, 8 services, 13 customers, 28 bookings over 3
  months with deliberate retention patterns. **Login: `9000000001` /
  `glamour123`.** Needed to build/demo any analytics.

### 4. Clean-minimal UI redesign — `mobile/salon_admin_app_v2/`
- Separate app folder (original untouched). `lib/theme.dart` design system;
  redesigned login + dashboard metric cards; shared card style app-wide.
  **Why:** owner disliked the old UI. Direction chosen by user: whole app,
  clean-minimal-light, separate folder.
- Status: login + dashboard reskinned. **Remaining screens still need a layout
  pass** (bookings queue, staff, account settings sheet, retention details) —
  they inherit the theme but aren't hand-tuned yet.

### 5. Force-update gate — `backend/src/index.ts`, v2 `AuthGate`
- Public `GET /api/v2/app-config` returns per-app `minVersion` + store URL
  (env-overridable, e.g. `SALON_ADMIN_MIN_VERSION=2.1.0`). v2 app compares its
  `appVersion` (const in main.dart, keep in sync with pubspec) on launch and
  shows `UpdateRequiredScreen` if too old. **Fails open** if the check errors.
  **Why:** push forced updates to installed owners without a code deploy.

## How to run & test on the physical phone
Device: `ed083e3d` (Redmi/MIUI). Backend on the PC, reached via adb reverse.

```bash
# 1. backend running on :3000, then:
adb -s ed083e3d reverse tcp:3000 tcp:3000
cd mobile/salon_admin_app_v3   # primary app since 2026-07-13; v2 is legacy/reference only
flutter run -d ed083e3d --dart-define=API_URL=http://127.0.0.1:3000
```

**Critical gotcha — Gradle "Unable to establish loopback connection":** set
`JAVA_TOOL_OPTIONS=-Djdk.net.unixdomain.tmpdir=C:\nonexistent-dir-force-inet`
before any `flutter run`/`flutter test`/gradle command (it's in the user's
terminal profile but not always inherited).

Integration tests (v1):
```bash
flutter test integration_test\salon_admin_smoke_test.dart -d ed083e3d --dart-define=API_URL=http://127.0.0.1:3000
flutter test integration_test\salon_admin_negative_test.dart -d ed083e3d --dart-define=API_URL=http://127.0.0.1:3000
```

Other gotchas:
- **MIUI** kills apps launched via `am start`/Maestro `clearState` — launch via
  the launcher (`monkey -p <pkg> -c android.intent.category.LAUNCHER 1`).
- **Maestro doesn't see Flutter widget keys** (only visible text); integration
  tests do. Prefer integration tests for driving the app.
- Driving login via adb taps: the centered layout shifts when the keyboard
  opens — fill phone, send IME "next" (`input keyevent 66`) to move to
  password, don't tap the second field blindly.

## Next / backlog (priority-ish)
1. ~~Finish v2 redesign, then swap v2 in as the primary app.~~ Superseded twice
   over: v2 replaced v1, then v3 (full redesign + globalization + rebuild)
   replaced v2 **on Play Store itself as of 2026-07-14** (not just locally) —
   see the 2026-07-13/14 entry above for the full deploy story. v2 users are
   now force-redirected to update. See `docs/HANDOFF-SALON-ADMIN-V3.md` for
   what v3 changed and its own backlog (integration test rewrite,
   native-speaker translation review, WhatsApp Business API setup to unhide
   forgot-password).
2. **Day-of booking statuses** (agreed, deferred): `WAITING → IN_PROGRESS →
   COMPLETED` with per-transition timestamps → unlocks duration/wait/utilization
   analytics. Build in v3.
3. **Easy-but-useful features** (low owner effort, high value): auto customer
   profiles, quick-rebook ("book usual"), auto appointment reminders (reuse the
   wa.me plumbing), auto review requests, end-of-day summary.
4. **Force-update rollout** to customer + stylist apps (same `app-config`).
5. **Version-gate live demo** not yet shown on device (needs min bumped > 2.0.0).
6. **Upgrade-to-PRO** button in RetentionScreen is a placeholder (no billing).

## Baton-pass protocol (sequential agents)
When you finish a chunk: (1) commit with *why* in the body, (2) append a dated
line here, (3) `graphify update .`. The next agent starts from this file + git log.

## 2026-07-08 production API deploy note
- Backend image `salone-backend:20260708-1` is imported on `192.168.0.150`
  (`k8s-master`) and running in namespace `salone`.
- Public API health is live at `https://api.slotvibe.buzz/health` and returns
  `{"status":"ok","version":"2.0.0"}` through Cloudflare.
- Nginx routing is in the existing `kimai/kimai-timesheet-nginx` ConfigMap with
  a separate `api.slotvibe.buzz` server block proxying to
  `salone-api.salone.svc.cluster.local:3000`.
- `/dev/sdc` is mounted at `/mnt/dbsa`; Postgres data was copied from
  `/mnt/salone/postgres` to `/mnt/dbsa/salone`, and the live Postgres deployment
  now uses PVC `salone-pvc` (PV `salone-pv`, 25Gi) for
  `/var/lib/postgresql/data`.
- Old PVC `salone-postgres-pvc`/PV `salone-postgres-pv` still exists as a
  fallback copy on `/mnt/salone/postgres`; do not delete until we take a real
  database backup and run the app for a few days.

## 2026-07-08 launch-prep (commit b99df08) — NEEDS A BACKEND REDEPLOY
- New backend route `GET /privacy` serves the Play Store privacy policy
  (`backend/src/privacy.ts`). `/api/v2/app-config` store URL default changed to
  `com.chairful.admin`. **These are code-only — the live image
  `salone-backend:20260708-1` does NOT have them yet.** Rebuild the image (next
  tag, e.g. `:20260708-2`), import to containerd, `kubectl -n salone set image`
  the `salone-api` deploy (both the app container AND the `migrate` initContainer,
  imagePullPolicy Never), then roll it. Then `https://api.slotvibe.buzz/privacy`
  goes live.
- **Before redeploy:** fill the 3 placeholders in `backend/src/privacy.ts`
  (effective date, legal/business name, support email).
- App is now `com.chairful.admin`, signed release AAB builds via
  `android/key.properties` (gitignored). Signed AAB is Play-ready.

## 2026-07-09 GHCR + ArgoCD setup
- Added GitHub Actions workflow `.github/workflows/backend-image.yml` to build
  and push backend images to `ghcr.io/vamshi4/salone-backend`.
- Kubernetes manifest now uses
  `ghcr.io/vamshi4/salone-backend:feature-retention-and-redesign` with
  `imagePullPolicy: Always` instead of the manual local containerd image.
- Added ArgoCD Application manifest at `deploy/argocd/salone-app.yaml`.
- If the GHCR package is private after first publish, either make it public in
  GitHub Packages or create a Kubernetes `imagePullSecret` for GHCR before
  syncing ArgoCD.

## 2026-07-10 production auth incident fix
- Rotated live `salone-secrets.jwt-secret`; all old JWTs are invalid and users
  must sign in again.
- Production API now runs with `NODE_ENV=production`, `AUTH_REQUIRED=true`, and
  `DEMO_AUTH_ENABLED=false`.
- Backend now fails closed: auth is required unless explicitly disabled outside
  production; `/auth/demo-token` is hidden in production unless explicitly
  enabled outside production; passwordless login returns false.
- `GET /api/v2/salons` now requires auth. Anonymous check returns `401`.
- Existing passwordless users were locked with a non-login marker; database
  check returned zero users with `password is null`.

## 2026-07-11 super-admin dashboard / CRUD
- Added `/admin` super-admin dashboard shell and `/api/v2/admin/*` APIs.
- Admin APIs are guarded by `requireRole('SUPER_ADMIN')`; the public HTML shell
  renders no platform data until a SUPER_ADMIN login succeeds.
- Added soft-delete columns (`User.deletedAt`, `Salon.deletedAt`) and
  `AdminAuditLog`; super-admin salon edits/deletes/restores are audited.
- Deploy requires the backend image built from this commit and Prisma `db push`
  to apply the new columns/table.

## 2026-07-11 build 5 deploy fix
- Build-5 CI failed because committed salon listing filtered nested stylists by
  `deletedAt`, but `Stylist.deletedAt` was not committed in the Prisma schema.
- Added `Stylist.deletedAt` to schema/admin CRUD migration so GHCR build and
  prod `prisma db push` can apply it before build-5 deployment.

## 2026-07-11 super-admin console prod verification
- Rolled prod backend to `ghcr.io/vamshi4/salone-backend:43452f7` via deploy commit `46b10b2`.
- Verified `/admin` serves the full console shell and the `ADMIN-CRUD-VERIFY.md` API checklist
  passes on throwaway prod salon `cmrgm1p1u00038v9q42ni4udk`.
- SUPER_ADMIN login exists for `vamshi`; the `create-super-admin.ts` runbook remains the preferred
  way to create/promote future admins with a 12+ character password.

## 2026-07-12 Company OS / marketing agents
- Added `docs/COMPANY_OS/` as the operating system for release-synced marketing and automation.
- Defined Product/Engineering, QA/Compliance, Feature Marketing, Social Media, and Sales/CRM agent
  roles with approval gates.
- Added release-to-marketing workflow, content approval queue, marketing asset guide, and n8n
  automation plan. First version drafts content automatically but requires owner approval before
  posting or messaging real leads.

## 2026-07-12 Build 5 Instagram campaign
- Added first Instagram-only campaign pack at
  `docs/COMPANY_OS/CAMPAIGNS/2026-07-build-5-instagram/`.
- Campaign theme: "Stop losing walk-in money" for build 5 features (Done service, earnings,
  customer autocomplete).
- Added feed posts, reel scripts, stories, asset prompts, and approval checklist; queued items
  `IG-B5-01` through `IG-B5-07` in `CONTENT_APPROVAL_QUEUE.md`.
- Generated first draft image for `IG-B5-01`:
  `docs/COMPANY_OS/CAMPAIGNS/2026-07-build-5-instagram/assets/IG-B5-01-stop-losing-walk-in-money-v1.png`.
- Added v2 after owner feedback to match the actual app UI more closely:
  `docs/COMPANY_OS/CAMPAIGNS/2026-07-build-5-instagram/assets/IG-B5-01-stop-losing-walk-in-money-v2.png`.
- Added and owner-approved v4 with the provided reference face but previous black dress/app-post style:
  `docs/COMPANY_OS/CAMPAIGNS/2026-07-build-5-instagram/assets/IG-B5-01-stop-losing-walk-in-money-v4-reference-face-black-dress.png`.
- Owner asked to use the same reference person across all Build 5 Instagram images; campaign docs now
  define this as the visual consistency rule.

## 2026-07-12 Salon admin app v3 — full redesign + rebuild
- New parallel app folder `mobile/salon_admin_app_v3/` (v2 untouched), same pattern as v1 → v2.
- Redesigned IA: bottom nav (Home, Bookings, Staff, Insights, Account) replaces the six-icon app bar
  and segmented tabs. Earnings + Retention merged into Insights. Home leads with "New booking" and a
  log of today's completed walk-ins instead of a schedule, since there's no pre-booking in the common
  case; the rare pending/reschedule item moved to a banner on Bookings.
- Added a 5-color theme picker (signup step 3 + Account → Appearance) and a country/currency/language
  step in signup — all three are **device-local prefs only**, no backend fields yet.
- Full details, file map, what's wired to the real backend vs. local-only, and known gaps (not yet
  compiled — no Flutter toolchain in the build environment; integration tests need rewriting for the
  new nav) are in **`docs/HANDOFF-SALON-ADMIN-V3.md`**. Read that before touching v3.
- Related: `docs/GLOBAL-READINESS.md` (added same session) covers what real backend support for
  country/currency/language would need.

## 2026-07-13/14 — v3 verified + globalized, forgot-password, Google sign-in, **v3 shipped to Play Store**

Long session, several distinct chunks. **This is the entry to read if you're starting cold.**

### A. v3 first-time compile + verification
- v3 (from the 2026-07-12 session above) had **never been compiled**. Ran `flutter pub get` +
  `flutter analyze` for the first time, fixed all compile errors (a truncated/NUL-corrupted
  `main.dart` and `signup_flow.dart` from a bad write, a few type mismatches). Redeployed to
  physical device `ed083e3d` and confirmed clean launch.
- Root-caused and fixed a login bug ("no owner found" / "already registered" no matter what):
  stale dev backend process holding the port, a **passwordless legacy account** (predated
  password auth — fixed by setting a scrypt hash directly via psql), and a **too-short
  `JWT_SECRET`** in `backend/docker-compose.yml` (didn't match `backend/.env`, silently broke
  local token verification). Local dev pattern is now: `docker-compose up -d --build
  --force-recreate api` after every backend change — `--build` alone does not guarantee the
  container picks up a rebuilt image.

### B. Full globalization (top 25 languages, 24 countries)
- Popup-behind-popup Flutter crash (`ListTile`/`DecoratedBox` assertion) fixed by wrapping in
  `Material(color: Colors.transparent)` — affects `option_picker_sheet.dart` and
  `new_booking_sheet.dart`.
- Added `flutter_localizations` + full ARB pipeline. **25 languages** (English + top 24 by
  WhatsApp usage per target market — India/Bangladesh/Pakistan/Egypt/Nigeria/Indonesia/etc, not
  raw global speaker count), ~190 keys per language, all in `lib/l10n/app_<code>.arb`. Rollout
  was "all at once," not incremental, per explicit owner direction.
- `LocaleController` (`core/locale_controller.dart`) — `ChangeNotifier` singleton, same pattern
  as `ThemeController`/`CurrencyController`. `main.dart` wires it into `MaterialApp.locale`.
- **Auto-detection on first launch**: `core/locale_detection.dart`'s `detectCountryCode()` tries
  GPS + Nominatim reverse-geocode first, falls back to device locale
  (`PlatformDispatcher.instance.locale.countryCode`), validates against `kCountries`. Runs once
  (`AppPrefs.hasDetectedLocale()` guards it), then the picker in Account/login always lets the
  user override.
- **`Salon.currency` / `Salon.countryCode` became real backend fields** (were device-local-only
  prefs before this session — see `docs/GLOBAL-READINESS.md` for the original design). Added to
  `schema.prisma`, wired through `/salon-signup` and `PATCH /auth/me`.
  `CurrencyController.applyCurrencyCode()` makes the salon's *stored* currency the source of
  truth once a salon record loads (`shell/dashboard_data.dart`), overriding whatever the
  device-local country pref implies.
- Fixed decimal price entry (`int.tryParse` → `double.tryParse`, decimal-aware keyboard) and a
  `formatMoney()` bug always showing 2 decimals.
- Fixed the WhatsApp retention-reminder deep link (`insights_screen.dart`'s `_remind()`) —
  was hardcoded to assume a 10-digit India number gets `91` prepended; now derives the dial code
  from `salon.countryCode` via `backend/src/country-dial-codes.ts` (server-side) and
  `core/prefs.dart`'s `kCountries` (client-side) — **keep these two lists in sync** if a country
  is ever added.
- Fixed a backend bug where `canSetServicePrice()` (meant to gate a *stylist* setting their own
  price) was incorrectly also blocking the *salon owner* from setting a stylist's price directly
  — this was the "price always shows 499 no matter what I enter" bug. Fix:
  `req.user!.role !== 'STYLIST' || canSetServicePrice(stylist)` in
  `backend/src/routes/stylist.routes.ts`.
- Made staff working-hours actually editable (previously wrote-once): `staff_manage_sheet.dart`
  now deletes-then-recreates only the *selected* day(s)' rules instead of the whole week, with a
  day-picker and tap-to-edit-one-day.
- Login screen's country picker was non-functional (dial code stuck at whatever the device
  detected) — added `_pickCountry()` + a real bottom sheet.

### C. Insights (Earnings + Retention) value-add pass
- Owner asked for Insights to be "more valuable... this is our main value for our app." Added:
  period-over-period comparison chips, top-services and by-staff ranking, reactivated-customer
  count, a "wins" summary section — on top of the existing retention cohorts and WhatsApp
  reminders. All in `insights_screen.dart`.
- Fixed a bug found during review (not user-reported): `_EarningRow` was reading a nested
  `booking['service']?['name']` path that doesn't match the API's flat `serviceName`/
  `customerName` fields — showed generic "Customer · Service" for every row.
- Seeded realistic multi-month data into the owner's own real test salon (not the separate demo
  account) via new `backend/prisma/seed-owner-salon.ts` — additive/idempotent (`:seed:`-prefixed
  deterministic booking IDs), safe to re-run, targets phone `7989698923` by default
  (override via `SEED_OWNER_PHONE`).

### D. Forgot-password (WhatsApp OTP) — built, **hidden this release**
- New backend: `POST /auth/forgot-password` (generic response either way — doesn't leak whether
  a phone is registered), `POST /auth/reset-password-otp` (verify + set new password in one
  call). OTP hashed with the same `scrypt$salt$hash` helper as passwords
  (`User.resetOtpHash/resetOtpExpiresAt/resetOtpAttempts/resetOtpSentAt`, 10 min TTL, 60s resend
  cooldown, 5 max attempts). `backend/src/whatsapp.ts` sends via Meta WhatsApp Business Cloud
  API — **in dev/local (`NODE_ENV!=production`) it just logs the OTP to console instead of
  sending**, so the flow is fully testable without real credentials.
  `backend/src/country-dial-codes.ts` supplies the dial-code prefix from the salon's
  `countryCode`.
- Frontend: `lib/auth/forgot_password_flow.dart` (two-step: phone → OTP+new-password), linked
  from a "Forgot password?" button on the login screen.
- **Owner doesn't want to pay for WhatsApp Business API yet** — the "Forgot password?" link is
  hidden behind `const kForgotPasswordEnabled = false;` at the top of `login_screen.dart`. Flip
  it to `true` once a Meta WhatsApp Business account + approved OTP template exist (see
  env vars below). The flow itself is fully built and backend-verified — just not user-visible.
- Prod env vars needed to actually turn this on: `WHATSAPP_ACCESS_TOKEN`,
  `WHATSAPP_PHONE_NUMBER_ID` (currently unset in `deploy/k8s/salone-api.yaml`, and unset — not
  even placeholder'd — since the feature is off). `WHATSAPP_OTP_TEMPLATE_NAME`/`_LANG` default
  to `otp_login`/`en_US` in code if unset.

### E. "Continue with Google" — fully working, including account linking
- **Why this exists**: forgot-password needs a paid WhatsApp API the owner isn't ready to set up
  yet, and they got locked out of their own test account mid-session. Google Sign-In is a *free*
  account-recovery path that doesn't depend on it.
- Backend: `POST /auth/google-login` (logs into an **existing** account only — matched by
  `googleId`, or by `email` on first use which also auto-links), `POST /auth/salon-signup` now
  accepts an optional `googleIdToken` instead of `password` for brand-new owners, `POST
  /auth/link-google` (authenticated — lets someone who still has their password attach a Google
  account for future logins). `backend/src/google-auth.ts` verifies the ID token via
  `google-auth-library`'s `OAuth2Client`, audience = `GOOGLE_CLIENT_ID` env var (a **Web** OAuth
  client ID — not secret, safe in plain env). `User.googleId String? @unique` added to schema.
- Frontend: `core/google_auth.dart` wraps the `google_sign_in` package.
  `serverClientId` is passed via `--dart-define=GOOGLE_SERVER_CLIENT_ID=...` at build time (same
  pattern as `API_URL`) — **must match the backend's `GOOGLE_CLIENT_ID` exactly** or token
  verification fails. **Important fix**: `signInWithGoogleIdToken()` calls `_googleSignIn.signOut()`
  right before `.signIn()` — without this, the picker silently reuses whichever Google account
  was last used instead of showing the chooser, which is broken UX for anyone (like the owner)
  with multiple Google accounts on their phone.
  `widgets/google_icon.dart` — a `ShaderMask`-gradient "G" glyph (Google's 4 brand colors), used
  instead of the real logo asset since there's no `flutter_svg` dependency and no bundled asset.
- Google's OAuth setup needs **two separate OAuth clients per signing key** in the same Google
  Cloud project (`mystical-banner-157112`): one **Android** client per signing certificate
  (matched by package `com.chairful.admin` + SHA-1, used automatically by Play Services — never
  referenced in code) and **one Web client** (used as `GOOGLE_CLIENT_ID`/`serverClientId`
  everywhere). Two Android clients now exist — debug keystore SHA-1
  `81:B3:55:87:0F:26:66:D6:64:28:54:9C:82:26:74:2C:40:18:A4:1B` and release keystore
  (`upload-keystore.jks`, shared with v2) SHA-1
  `97:97:6E:59:34:30:EF:CA:7D:A6:C5:22:67:58:DF:EA:25:78:BA:DA`. **If the signing key ever
  changes again (e.g. Play App Signing re-signs with a different key), Google Sign-In breaks
  until a matching Android client is added** — this bit us once already for the release build.
- Verified live end-to-end on device: real multi-account picker (4 Google accounts), correct
  backend verification, account linking confirmed via direct DB query
  (`SELECT ... "googleId" IS NOT NULL`).
- Signup also **auto-fills the owner-name field from the Google profile's `name` claim**
  (decoded client-side from the ID token JWT payload, just for prefill — backend independently
  re-verifies) if the user picked Google before typing a name. Email is always taken from
  Google; phone/salon-name/address are still typed manually regardless of auth method (Google
  doesn't provide a phone number, and the app is phone-first for bookings/WhatsApp reminders).

### F. Login screen language switcher
- Previously only reachable from Account (post-login) or the signup flow — a returning user
  whose auto-detected language guessed wrong had no way to fix it before signing in. Added a
  `🌐 <language name>` button top-right of the login screen (`_pickLanguage()` in
  `login_screen.dart`) that applies immediately via `LocaleController.instance.applyLoaded()` —
  deliberately does **not** touch the country/dial-code picker, since reading the app in French
  doesn't imply a French phone number.

### G. Shipped v3 to Play Store, replacing v2
- **v2 was already live** on Play Store Internal testing (`Chairful-2.0.0-b5.aab`, versionCode
  5) with a real production backend at `https://api.slotvibe.buzz` (Kubernetes / ArgoCD / GHCR
  — this was **not known at the start of this session**; discovered by reading
  `docs/STATUS.md`/`docs/DEPLOY-BUILD5.md`, which this session hadn't read yet at that point).
  Owner explicitly chose to switch the Play Store release to v3 rather than keep shipping v2.
- Verified v3 has full feature parity with v2's already-shipped build 5 (walk-in "Done service"
  logging, customer autocomplete, earnings with day/week/month breakdown) before replacing it —
  all three call the same unchanged backend endpoints. Found and fixed one cosmetic-only
  regression: `_EarningsBars` in `insights_screen.dart` read a `d['label']` field the `/earnings`
  endpoint never returns (only `date`) — bar chart date captions were blank. Fixed to format
  `d['date']` via the existing `formatShortDate()` helper.
- **Bumped `pubspec.yaml` version `3.0.0+1` → `3.0.0+6`** — Play Console requires versionCode to
  strictly increase across *all* uploads to a package regardless of which app variant produced
  it, and v2's last upload was versionCode 5.
- Deploy sequence actually used (works without `gh`/`kubectl` access — this sandbox only has
  unauthenticated `curl` against GitHub's public REST API and no cluster access):
  1. Committed backend changes (schema, new routes, `google-auth.ts`/`whatsapp.ts`/
     `country-dial-codes.ts`, `docker-compose.yml`, `GOOGLE_CLIENT_ID` in
     `deploy/k8s/salone-api.yaml`) — commit `1d13bfd`.
  2. `git push` → GHCR Action builds `ghcr.io/vamshi4/salone-backend:1d13bfd` automatically
     (watch via `curl -s https://api.github.com/repos/vamshi4/Salone/actions/runs?branch=...`,
     no auth needed for this public repo).
  3. Pinned that tag in **both** the `migrate` initContainer and the `api` container images in
     `deploy/k8s/salone-api.yaml`, committed, pushed (commit `ad7d37f`) — ArgoCD
     (`automated: {selfHeal: true}`, tracks this exact branch) picks it up on its own poll
     interval, no manual sync command available/needed from this environment.
  4. Verified against prod with the same curl checklist as `docs/DEPLOY-BUILD5.md` (earnings
     200, customers 200, unauth 401) plus checks that the *new* endpoints exist and behave
     correctly even unconfigured (`/forgot-password` → 500 "not configured" — correct, no
     WhatsApp account yet; `/google-login` → 401 "wrong number of segments" — correct, means
     `GOOGLE_CLIENT_ID` landed and real verification is being attempted).
  5. Built the signed release AAB locally: `flutter build appbundle --release
     --dart-define=API_URL=https://api.slotvibe.buzz
     --dart-define=GOOGLE_SERVER_CLIENT_ID=<web client id>` — **note the release build command
     needs the URL passed explicitly**; despite `docs/ENVIRONMENTS.md` implying the source
     default points at prod, the actual source default in both v2 and v3 is
     `http://10.0.2.2:3000` (Android emulator loopback) — whoever built `b5.aab` must have
     passed `--dart-define` explicitly and the doc's wording is just imprecise.
  6. Owner uploaded `Chairful-3.0.0-b6.aab` to Play Console → Internal testing themselves (not
     something an agent can do — needs their Play Console login). Confirmed live: release
     "Redesigned app", version code 6, available to internal testers.
  7. **Force-updated v2 users**: set `SALON_ADMIN_MIN_VERSION=3.0.0` in
     `deploy/k8s/salone-api.yaml` (was previously unset, defaulting to `2.0.0` — which does
     *not* block `2.0.0`, so v2 kept working indefinitely). Both apps' `AuthGate` already
     compared `appVersion` against this on every launch (built back in the 2026-07-07 session,
     see item 5 near the top of this file) — just needed the env var bumped now that v3 is the
     intended release. Verified live: `curl https://api.slotvibe.buzz/api/v2/app-config` →
     `salonAdminMinVersion: "3.0.0"`.
- `docs/STATUS.md` and `AGENTS.md` updated to say v3 is the active/primary app; v2 is fully
  retired from the release pipeline (source kept as reference only, do not add features to it).

### Dev-environment gotchas hit this session (Windows, this specific machine)
- **Docker Desktop kept crashing on launch** with "initializing Inference manager... The file
  cannot be accessed by the system" pointing at
  `%LocalAppData%\Docker\run\dockerInference`. Root cause: Docker Desktop's AI/model-runner
  feature (`EnableDockerAI: true` in `%AppData%\Docker\settings-store.json`) trying to touch a
  broken/orphaned socket-like file — almost certainly the same class of bug as the known Windows
  AF_UNIX issue on this machine (see memory `windows-af-unix-broken-gradle-workaround`). **Fix:
  set `EnableDockerAI: false`** in that settings file. Attempting to delete the stuck file
  directly (`Remove-Item`) reproduces the exact same "cannot be accessed" error — don't bother,
  just disable the feature that touches it.
- **`flutter run`/Gradle OOM'd repeatedly** at ~2GB free system RAM (only 15.7GB total on this
  machine, heavily contended by Docker's WSL2 VM + multiple concurrent Claude Code sessions +
  Chrome + other apps). Working pattern that resolved it every time: stop a stale Gradle daemon
  first (`cd android && ./gradlew --stop`); if still tight, `docker-compose stop` the local
  backend containers, then **`wsl --shutdown`** (this is what actually reclaims the memory — the
  WSL2 VM does not release RAM back to the host just because containers inside it stopped) — this
  also kills Docker Desktop's own process as a side effect, so restart it
  (`Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"`) and wait for `docker info`
  to succeed before `docker-compose start`ing the backend again. Also created
  `C:\Users\<user>\.wslconfig` capping WSL2 to `memory=4GB, processors=4, swap=2GB` (half the
  default ~50%-of-host allocation) per explicit ask, to reduce how much headroom Docker eats by
  default.
- `keytool` isn't on `PATH` — used Android Studio's bundled JBR instead:
  `"C:\Program Files\Android\Android Studio\jbr\bin\keytool"`.
- `gh` CLI isn't installed in this environment. GitHub Actions run status was checked via plain
  unauthenticated `curl` against `api.github.com/repos/vamshi4/Salone/actions/runs` — works fine
  since the repo is public. `kubectl` exists locally but points at a `minikube` context, not the
  actual prod cluster — there's no way to directly inspect pod rollout status from this machine;
  verification has to be black-box via `curl` against the public API, same as
  `docs/DEPLOY-BUILD5.md` already assumed.
- adb UI-automation tap coordinates from a screenshot need **exact device-pixel scaling** (this
  device: screenshot shown at 900px wide, real device 1220px, factor ×1.356) — safer to
  `adb shell uiautomator dump` and read exact `bounds="[x0,y0][x1,y1]"` for a target's
  `content-desc` than to eyeball-scale coordinates from a screenshot, especially once a soft
  keyboard is open and reflows the layout.
- `pm clear com.chairful.admin` is the fast way to reset local app state (saved auth token,
  device prefs) back to a clean login screen for testing, without needing to uninstall/reinstall.

### What's genuinely NOT done (real backlog, not just "could do more")
1. **Enable forgot-password**: owner needs to create a Meta WhatsApp Business Cloud API account,
   verify a phone number, get an "Authentication"-category template approved (usually
   minutes-to-hours), then set `WHATSAPP_ACCESS_TOKEN`/`WHATSAPP_PHONE_NUMBER_ID` in prod and
   flip `kForgotPasswordEnabled = true` in `login_screen.dart`. Not free at volume (per-message
   cost, varies by country) — see conversation for the full explainer if the owner asks again.
2. **Integration tests for v3**: zero automated coverage right now. The old 667-line v1/v2 suite
   (`integration_test/salon_admin_smoke_test.dart` etc.) targets segmented-tab navigation and
   single-service staff setup, both gone in v3's bottom-nav + multi-service design. Needs a
   full rewrite, not a patch.
3. **Native-speaker review of the 24 non-English translations** — machine-translated (by the
   agent doing the work each time, not a translation API), never proofread by an actual speaker
   of each language. Fine for a first release, worth flagging before scaling in any specific
   market.
4. **Play Store progression**: still on Internal testing → next gate per `docs/STATUS.md` is
   Closed testing (12 testers × 14 days) → apply for Production. Nothing code-side blocks this,
   it's a Play Console process the owner drives.
5. Everything already listed in the "Next / backlog" section below this entry (day-of booking
   statuses, force-update rollout to customer/stylist apps, etc.) is still open and unaffected
   by this session's work.

## 2026-07-14 — v4 redesign: cream/terracotta "Open Design" prototype + Services tab

New session, same day as the v3 ship above. Owner wants a visual redesign, tried two directions
before landing on one — **read this whole entry**, the first attempt was discarded.

### A. First attempt (discarded) — coral "Tres Beaux" reskin
Owner shared a reference image (`docs/design-references/tres-beaux-reference.png`) and asked for
a whole-app coral/peach reskin in a new parallel folder `mobile/salon_admin_app_v4/` (same
pattern as v1→v2→v3 — v3 untouched). Built: coral palette, floating pill bottom nav, a horizontal
day-strip calendar on Bookings, colored service-tag chips on Staff cards. **Then superseded** —
see below. If you find references to "floating pill nav" or "day-strip calendar" anywhere, they
describe this discarded direction, not what's actually in `v4` now.

### B. Second direction (current) — "Open Design" prototype
Owner shared a much more polished, fully-interactive static HTML prototype built in "Open
Design": `C:\Users\vamshikrishna.sangi\AppData\Roaming\Open Design\namespaces\release-stable-win\data\projects\edd79427-ecac-46b4-b7ff-1c3497c2cf42\index.html`
(1,729 lines — six simulated iPhone screens: Dashboard, Bookings, Staff, Insights, **Services**,
Profile; that exact path is local to the owner's machine, not in this repo). Owner explicitly
chose to **replace** the coral work with this design (not run both, not cherry-pick) — `v4/lib`
was reset to a clean copy of v3's `lib/` and rebuilt from there.

**Design language** (all in `lib/theme.dart`): warm cream background (`#FAF7F4`), white
(`AppColors.surface`) cards with a hairline border + barely-there shadow (not the coral pass's
heavy shadow), terracotta accent (`#C96442`, replaces teal as the default `AppColorSeed` — teal
still exists as a picker option), Playfair Display serif for headlines/display text paired with
Inter for body (both real OFL-licensed variable font files, fetched from `google/fonts` on GitHub
into `assets/fonts/`, registered in `pubspec.yaml` with multiple weight entries pointing at the
same variable file — Flutter/Skia resolves the requested weight via the font's `wght` axis). Added
a fourth semantic color, `AppColors.amber`, specifically for "needs action"/pending/at-risk
badges — previously `BookingActionCard`'s pending pill reused `AppColors.accent`, which read as
the same color as primary CTAs; now disambiguated.

**Navigation restructure** (`lib/shell/root_shell.dart`): the coral pass's floating pill nav is
gone, replaced with a flush translucent blur bar (`BackdropFilter`) with a thin 3px top indicator
line on the active tab — a custom `_TabBar` widget, not Material's `NavigationBar` (its pill
indicator doesn't match this look). Five tabs: **Home, Bookings, Staff, Insights, Services**
(Services replaces Account). Account is no longer a tab — `HomeScreen` takes an `onOpenAccount`
callback wired to `Navigator.push` from the header avatar button.

**New Services tab** (`lib/screens/services_screen.dart`, `lib/sheets/service_sheet.dart`) — a
salon-wide service catalog, grouped by category with search + category filter chips. This needed
one small **backend addition**, not just UI: `backend/prisma/schema.prisma` already had a
first-class `Service` model with a nullable `salonId` (no migration needed), but every existing
route (`backend/src/routes/stylist.routes.ts`) was stylist-scoped only. Added salon-scoped CRUD to
`backend/src/routes/salon.routes.ts`: `GET/POST/PATCH/DELETE /api/v2/salons/:salonId/services`,
using the same `findOwnedSalon()` ownership check and `requireRole('SALON_OWNER', 'SUPER_ADMIN')`
pattern as the file's other sub-resources. The screen reads the list from `salon['services']`
(already included in the existing `GET /api/v2/salons` payload `DashboardData.load()` fetches —
no separate GET needed client-side) and writes through the new endpoints. **Note**: this list
shows *all* of a salon's services, including ones created via the pre-existing per-stylist
add-staff flow (those also get `salonId` set) — not a separate parallel catalog. Existing
`add_staff_sheet.dart`/`staff_manage_sheet.dart` free-text service entry was deliberately left
unchanged (not refactored to pick from this new catalog) — a natural follow-up, not required to
ship the tab.

**Motion**: added two small reusable widgets to `lib/widgets/common.dart` — `EntranceFade`
(staggered fade+slide-up via `AnimatedOpacity`/`AnimatedSlide`, used on Home's logged-today list)
and `CountUpNumber` (`TweenAnimationBuilder<int>`) — idiomatic-Flutter stand-ins for the
prototype's CSS keyframe stagger and JS count-up animation, not literal ports.

**l10n**: added 12 new keys (`addServiceTitle`, `editServiceTitle`, `serviceNameLabel`,
`categoryLabel`, `priceLabel`, `durationMinutesLabel`, `deleteServiceButton`,
`fillServiceFields`, `couldNotSaveService`, `noServicesInCatalog`, `searchServicesHint`,
`filterAllCategories`) across all 25 ARB files in `lib/l10n/` — machine-translated same as the
original 25-language rollout, not proofread by native speakers (same caveat as before). The nav
tab label reuses the existing `statServices` key rather than adding a 13th. **Gotcha hit while
doing this**: a Python script that round-tripped the ARB JSON with `object_pairs_hook=list` (to
preserve key order) corrupted nested metadata objects like `@completedServicesCount`'s
`placeholders` map into JSON arrays, which broke `flutter gen-l10n` silently at first (all new
getters showed as "undefined" in `flutter analyze` even though the ARB files "loaded fine" per a
naive JSON-validity check). Fixed by reloading from a clean v3 copy and re-running with a plain
`json.load`/`json.dump` (Python 3.7+ dicts preserve insertion order natively — the
`object_pairs_hook` trick was unnecessary and actively harmful for nested objects). If you ever
bulk-edit ARB files with a script, verify with `flutter gen-l10n` (not just `json.load`), since a
value can be syntactically valid JSON while still being semantically wrong for ARB's nested
metadata format.

### Verification done this session
- `flutter analyze` in `salon_admin_app_v4` — clean, zero issues.
- Backend: `npx tsc --noEmit` clean. Started Docker Desktop + local `postgres`/`redis` +
  `npm run dev`, seeded demo data (`npm run prisma:seed:demo`), logged in as
  `9000000001`/`glamour123` (**note**: `POST /auth/login` needs `"role":"SALON_OWNER"` in the
  body — it defaults to `CUSTOMER` and silently 401s otherwise, easy to trip over), then curl-
  verified all 4 new endpoints end-to-end (list, create, update, delete-then-confirm-gone) plus
  both security checks (wrong/nonexistent `salonId` → 404, no token → 401).
- **Not done**: no physical-device walkthrough this session (device wasn't connected when backend
  verification finished). Do this before treating v4 as ready to show the owner — connect
  `ed083e3d`, `adb reverse tcp:3000 tcp:3000`, `flutter run -d ed083e3d
  --dart-define=API_URL=http://127.0.0.1:3000` from `mobile/salon_admin_app_v4`.
- **Not done, intentionally out of scope**: no prod deploy of the new backend routes. v3 remains
  the live/shipped app; v4 is still local-only.

## 2026-07-15 → 2026-07-17 — v4 → v4_1: Phase 5 platform pivot, salary/commission, public booking + QR, dead-bug fix. **THIS IS THE MOST CURRENT ENTRY — read `docs/STATUS.md`'s top warning box first for the short version.**

Multi-day, multi-session block of work. `mobile/salon_admin_app_v4_1` is a straight copy of `v4`
(same pattern as every prior vN→vN+1 step) made partway through, once Phase 5 scope was decided —
all work described below lives in `v4_1`; `v4` is now just a frozen earlier snapshot, don't build
on it. **None of this — backend or app — is committed to git, and none of the backend changes are
deployed to prod.** See the release-readiness checklist at the very end of this entry before doing
anything Play-Store-facing.

### Why the pivot: Phase 5 in `STRATEGY.md`
Owner explicitly chose to add multi-branch + inventory on top of the existing single-salon
retention product, after being shown the tradeoff (breadth vs. the "not another booking app"
positioning). `docs/STRATEGY.md` documents this under "Phase 5 · Platform & scale" — retention
stays the differentiator, multi-branch/inventory are now table stakes to land salon groups.
Sequencing used: **Staff CRM → multi-branch → inventory** (staff CRM has no dependency on the
other two and shipped first; inventory came last so it could be branch-scoped from day one).

### Prep: fixed a real pre-existing security bug
`stylist.routes.ts` had **zero ownership checks** on `PATCH /:id`, `POST/PATCH/DELETE
/:id/services[/:serviceId]`, and `POST /:id/make-independent` — any authenticated `SALON_OWNER`
could mutate *any* stylist in the system, not just their own. Added an `ownsStylist()` helper
(mirrors `findOwnedSalon()`) and guarded all five routes before starting multi-branch work (which
would have made the blast radius worse — stylists spanning branches).

### 1. Staff CRM
- **Pay type per stylist** — owner-configurable Commission / Salary / Both.
  `SalonStylist.payType` (`StaffPayType` enum), `salaryAmount`. `backend/src/commission.ts`
  (`commissionSplit()`) is now the **single shared function** for every commission calculation —
  replaced three previously-hardcoded 70/30 splits in `booking.routes.ts` (self-booking + salon-
  manual) and `public-booking.ts`. Returns `{stylistPct:0, salonPct:100}` for `SALARY` payType.
- **Payouts** — new `StylistPayout` model (`isSalaryPayout`, `salaryMonth` as an idempotency key
  so "pay this month's salary" can't double-pay). New endpoints on `salon.routes.ts`:
  `POST/GET /:salonId/stylists/:stylistId/payouts`, extended `GET .../earnings` to return
  `payType`/`salaryAmount`/`salaryPaidThisMonth`.
- **Flutter**: `staff_manage_sheet.dart` got a pay-type editor (SegmentedButton) and a full rewrite
  of the working-hours UI — was "select days, one shared time range" (always gave every selected
  day the same hours); now 7 independent day rows, each with its own `Switch` + two time-picker
  chips. `staff_payout_sheet.dart` got a "Pay salary" button/flow. `staff_screen.dart` gained a
  search box + Active/Inactive/All filter chips, and two permission toggles
  (`canSetOwnPrice`/`canCancelBooking`) were hidden — no stylist-facing app exists yet to use them.

### 2. Multi-branch
- **Schema**: dropped `@unique` on `Salon.ownerId` (kept an explicit `@@index`) — an owner can now
  have N salons.
- **`auth.routes.ts`**: `GET /me` gained a `salons` array **alongside** the existing singular
  `salon` key — the singular key is a deliberate compatibility shim for `v3`'s
  `account_screen.dart` (v3 is live with real users; **never remove that key** until v3 is
  retired). New `PATCH /api/v2/salons/:salonId` (per-branch profile edits) and
  `POST /api/v2/salons` ("add a branch").
- **`DashboardData`** (`lib/shell/dashboard_data.dart`): `salon` field → `salons` list +
  `selectedSalonId` + `currentSalon` getter. New `viewingAllBranches` mode
  (`selectedSalonId == 'ALL'`) — `currentSalon` returns `null` in this mode, which every consumer
  screen now has to distinguish from the genuine "no salon at all" error state (checking
  `salons.isEmpty` instead of `currentSalon == null` for the error gate — **this exact bug bit us
  once**, watch for the same mistake in new code). `switchToAllBranches()` fetches every branch's
  data in parallel and tags each booking/staff row with `_branchId`/`_branchName` client-side so
  existing generic getters (`todayCount` etc.) work unchanged.
- **Branch switcher**: a persistent header bar above every tab (not just Home), tap opens a sheet
  listing every branch + an "All branches" card, each showing per-branch today stats
  (`GET /api/v2/salons` now returns `todayStats: {count, revenue}` per salon, computed server-side
  via a shared `istStartOfDay()` IST-boundary helper).
- Swept all 7 `data.salon` → `data.currentSalon` consumers in one pass (mechanically safe rename —
  none of them assumed singularity beyond "there is one").

### 3. Inventory
- New `Product` model (salon-scoped, soft-delete via `deletedAt`, plain mutable `stockQty` —
  deliberately not a transaction ledger, same tradeoff as `Service.basePrice`). CRUD routes mirror
  the Services pattern exactly. New `products_screen.dart` + `product_sheet.dart`, and a Home
  low-stock alert card. Not a 6th bottom-nav tab (reached as a pushed screen from Home) — 5 tabs is
  already the comfortable max and inventory is checked far less often than daily-use tabs.

### 4. Six UI fixes (owner-requested batch)
"Switch branch" button label clarity, hid the two dead permission toggles (see Staff CRM above),
branch switcher visual clarity (the persistent header bar), time-picker for staff hours instead of
typing, per-day-independent hours (see Staff CRM above), and a `Delete` button that was rendering
underneath the phone's on-screen nav bar in 3 different bottom sheets — fixed via
`MediaQuery.of(context).viewPadding.bottom` added to each sheet's bottom padding.

### 5. `share_plus` major-version bump (fixes a recurring build warning)
`10.1.2` → `13.2.1` — resolves a Kotlin Gradle Plugin deprecation warning that showed on every
single build. `Share.shareXFiles(...)` (deprecated API) → `SharePlus.instance.share(ShareParams(...))`
(current API) in `insights_screen.dart`'s CSV export. Verified CSV export still works after the
bump (owner tested on-device).

### 6. Translations
All new UI strings from this whole block of work (89 keys across Staff CRM/multi-branch/inventory,
plus 6 more for the booking-link feature below) were added to `app_en.arb` and machine-translated
into all 24 other `app_<code>.arb` files. `flutter gen-l10n` + `flutter analyze` both clean. Same
caveat as always: machine-translated by whichever agent did the work, never proofread by a native
speaker of each language.

### 7. Google Sign-In status correction
An earlier session in this block incorrectly flagged Google Sign-In as "local-dev-only, not yet
live in prod." That was wrong — re-checked `deploy/k8s/salone-api.yaml` directly and confirmed
`GOOGLE_CLIENT_ID` has been live in prod since the 2026-07-14 v3 ship (commit `1d13bfd`). No work
was actually needed here; just a correction to earlier (wrong) session notes.

### 8. Dead-`Salon.commissionRate` bug — found and fixed
The super-admin console's "Commission %" field on a salon (`Salon.commissionRate`, an existing
schema field) looked editable and functional but **nothing in the booking system ever read it** —
editing it silently did nothing. Root cause: every `SalonStylist` row was created with no explicit
`commissionRate`, so it always fell back to the Prisma schema's own hardcoded `@default(70)`,
completely bypassing the salon-level field. Fixed at both creation sites in `salon.routes.ts` (the
"add staff" `staff-setup` handler, and the `make-exclusive` handler) — both now compute
`defaultCommissionRate = salon.commissionRate > 0 ? salon.commissionRate : 70` and pass it
explicitly. **Behavior-neutral** for every salon that's never touched the field (still gets 70).
Live-verified against the real local dev DB: a salon with `commissionRate=15` now produces new
staff at 15%; an untouched salon (`commissionRate=0`) still produces staff at 70%; both creation
paths (add-staff and make-exclusive) checked; test data cleaned up afterward.

**Note on how this bug was found/fixed**: a separately-spawned background agent session was asked
to fix this same bug earlier and got it wrong — it rewrote self-booking commission math against a
stale, pre-multi-branch snapshot of the codebase (working in an orphaned git worktree,
`agitated-lovelace-624b08`, that had never seen any of this session's work). That worktree's change
was discarded (never merged) and the fix above was written fresh, directly in the main checkout,
with the real current codebase in view. If you ever see a stray git worktree under
`.claude/worktrees/` referencing this bug, it's leftover from that dead end — safe to ignore/clean
up, nothing from it was merged.

### 9. Public self-booking page + QR/share link
- **`backend/src/public-booking.ts`** (new file): `GET /book/:salonId` — a plain HTML page (same
  zero-framework approach as `privacy.ts`/`admin-page.ts`, no build step) listing the salon's
  active stylists + services; customer picks one of each + a date/time, submits name/phone/
  optional-email. `POST /api/v2/public/salons/:salonId/bookings` creates a normal `PENDING`
  booking — flows straight into the existing owner-side "Needs Action" confirm/reject queue, no
  changes needed there. Commission split uses the same shared `commissionSplit()` as every other
  booking path, so it correctly picks up per-salon `commissionRate` defaults and salary/commission
  pay types. Abuse guard: max 3 pending requests per phone number per salon.
- **Phone verification was built, then explicitly removed** (owner's direct request on
  2026-07-17). It briefly existed as an *optional* WhatsApp-OTP step (reusing the same
  `User.resetOtp*` fields as forgot-password) with a `User.phoneVerifiedAt` schema field. All of
  it — both endpoints, the schema field, the HTML/JS verify widget — was fully removed the same
  day. **Do not re-add phone verification to the booking page unless explicitly asked again** —
  it was a deliberate rollback, not an oversight.
- **Booking-link + QR on the Account screen**: `mobile/salon_admin_app_v4_1/lib/screens/
  account_screen.dart` now has a "Booking link" section — one card per branch (from
  `widget.data.salons`), each showing a `qr_flutter`-rendered QR code of `$baseUrl/book/$salonId`,
  the link text, and Copy (clipboard)/Share (`share_plus`) buttons. New dependency: `qr_flutter:
  ^4.1.0`. Note `baseUrl` (`lib/core/api.dart`) is whatever `--dart-define=API_URL=...` the APK was
  built with — a debug build pointed at `localhost:3000` will bake `localhost:3000` into every QR
  code/link shown in that build; a real release build needs the prod `API_URL` so the QR/links
  actually work for customers scanning them.
- **Verified live on-device** (`ed083e3d`, debug build, local backend via `adb reverse`): Account
  screen renders both branch cards correctly with real scannable-looking QR codes; Copy shows a
  "Link copied" toast; Share opens the native Android share sheet with correct pre-filled text
  (dismissed without actually sending, to avoid messaging a real contact during a test); the public
  page itself loads correctly in the phone's own Chrome (via the same adb tunnel) with all fields
  present and no leftover verify-phone UI; two real test bookings submitted through the page
  (`Vcc`/`Beard Trim`, `Vamshj`/`Facial + shaving`) landed correctly as `PENDING` under "Needs
  action" in the app **once switched to the correct branch** — see the gotcha below, this tripped
  the owner up during testing.

### Gotcha hit during this block: which branch you're viewing matters
A booking submitted via a specific branch's `/book/:salonId` link only shows up in the app when
that same branch is selected (or "All branches" is). The owner tested by scanning/opening the
"Glamour Salon" link but had "Glamour Salon - Kondapur" selected in the app at the time, and
reported "the booking isn't showing up" — it wasn't missing, just on the other branch. If this
happens again: check the DB directly (`Booking` table, filter `bookedVia='PUBLIC_PAGE'`, join
`Salon` for the name) before assuming something's broken client-side.

### Gotcha hit during on-device UI testing: don't tap near the top of the screen blindly
While tap-testing the Account screen's avatar button, a tap at a screenshot-derived coordinate
landed on an **Instagram incoming-call notification banner** that happened to pop up at that exact
moment, overlaying the app — it opened Instagram directly into an active call with a real contact
on the owner's business account (`chair_full`). Caught immediately and hung up (ended as "Missed
audio call," nothing was said/sent). No lasting harm, but it's a real risk of coordinate-based
`adb input tap` automation on a personal device with live notifications enabled. Prefer
`adb shell uiautomator dump` + exact `bounds="[x0,y0][x1,y1]"` for a target `content-desc` over
eyeballing screenshot pixel coordinates (the existing scaling-factor gotcha above already said
this for accuracy reasons — this is an additional *safety* reason). Screenshot immediately before
any tap near the top of the screen to check for overlay notifications first if possible.

### `graphify update .` run 2026-07-17
Project graph regenerated after all of the above (34,740 nodes, 42,796 edges) — reflects the
current file structure including `commission.ts`, `public-booking.ts`, and all `v4_1` files.

### ⚠️ Release readiness — concrete checklist, do these in order before any Play Store action
1. **Get explicit go-ahead and commit everything to git.** This repo's convention (and this
   assistant's standing instruction) is: never commit without the human explicitly saying so. This
   has been asked and left unanswered across multiple sessions now — resolve it before anything
   else. `git status` currently shows the full backend diff + `salon_admin_app_v4`/`v4_1` as
   uncommitted/untracked.
2. **Deploy the backend.** Push → wait for the GHCR Action (`ghcr.io/vamshi4/salone-backend`) to
   build the new commit's image → update **both** image refs (the `migrate` initContainer and the
   `api` container) in `deploy/k8s/salone-api.yaml` → push → ArgoCD self-heals onto it (no manual
   sync command available/needed from this environment, same as the 2026-07-14 v3 deploy
   documented above). Verify with the same curl-checklist pattern as `DEPLOY-BUILD5.md`.
3. **Bump `pubspec.yaml` version** in `salon_admin_app_v4_1` (currently `3.0.0+6`, same as live
   v3 — Play requires strictly increasing versionCode across all uploads regardless of variant).
4. **Build a real release AAB** with `--dart-define=API_URL=https://api.slotvibe.buzz` (NOT
   localhost — the debug builds used for on-device testing this week all point at localhost via
   `adb reverse`, which only works on this one dev machine).
5. **Smoke-test the actual release build against prod** before uploading — at minimum: login,
   branch switcher, add a staff member (confirm commission default), submit a public booking via a
   real (non-localhost) QR/link, confirm it lands in the app.
6. Then it's an owner-driven Play Console upload, same as every prior release in this file.

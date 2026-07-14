# Session Handoff — Retention Analytics + Admin App Redesign

> Living record for the next agent (Codex/Claude). **Read this first**, then
> `AGENTS.md`. Sequential hand-off only — one agent works at a time. When you
> stop: commit, append to this file (what + why), and run `graphify update .`.

_Last updated: 2026-07-07 · Branch: `feature/retention-and-redesign` · Canonical dir: `D:\vamshi\Salone`_

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
1. ~~Finish v2 redesign, then swap v2 in as the primary app.~~ Superseded: v2
   was replaced by a full redesign+rebuild, **`salon_admin_app_v3`, which is
   now the primary/installed app (2026-07-13)**. See
   `docs/HANDOFF-SALON-ADMIN-V3.md` for what changed and its own backlog
   (integration test rewrite, native-speaker translation review).
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

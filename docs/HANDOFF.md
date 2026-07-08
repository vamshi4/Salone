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
cd mobile/salon_admin_app_v2   # or salon_admin_app for v1
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
1. **Finish v2 redesign** — layout pass on bookings queue, staff cards, account
   settings sheet, retention details; then swap v2 in as the primary app.
2. **Day-of booking statuses** (agreed, deferred): `WAITING → IN_PROGRESS →
   COMPLETED` with per-transition timestamps → unlocks duration/wait/utilization
   analytics. Build in v2.
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

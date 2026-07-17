# Chairful — Project Status (START HERE)

Single source of truth across all chats (Claude, Codex, future sessions). Update this when state
changes. Last updated: **2026-07-17**.

## ⚠️ READ THIS FIRST — nothing new is released; here's exactly what's blocking it
Everything described below under "v4_1 (built, not released)" is **code-complete and verified
locally only**. If you're asked "can we release this" or "is this live," the answer is **no**
until all of these are done, in order:
1. **Nothing is committed to git.** `git status` on `feature/retention-and-redesign` shows the
   entire backend diff + `mobile/salon_admin_app_v4`/`v4_1` as uncommitted/untracked. This is the
   single biggest risk — it only exists on this one Windows machine. Commit it (ask the human
   first — this repo's convention is explicit consent before every commit).
2. **Prod backend is pinned to an old commit.** `deploy/k8s/salone-api.yaml` still points at
   `ghcr.io/vamshi4/salone-backend:1d13bfd` — from *before* multi-branch, staff CRM, inventory,
   salary/commission, and the public booking page existed. None of that is live. Deploying means:
   commit → push → wait for the GHCR Action to build the new image tag → update both image refs in
   `salone-api.yaml` (the `migrate` initContainer AND the `api` container) → push → ArgoCD picks it
   up. Same sequence as the 2026-07-14 v3 ship documented in `HANDOFF.md`.
3. **The APK built/tested on-device this week points at `http://localhost:3000`** (via
   `--dart-define=API_URL=http://localhost:3000` + `adb reverse`). A release build MUST pass the
   real prod URL (`--dart-define=API_URL=https://api.slotvibe.buzz`) or every user's app will try
   to reach their own phone's localhost and fail completely.
4. **`pubspec.yaml` version is still `3.0.0+6`** — identical to the already-published v3. Needs a
   version bump before any Play Console upload (Play requires strictly increasing versionCode).
5. **v4_1 has never been released.** v3 is still the app real users have. Swapping v4_1 in is a
   first-time replacement, not a routine update — treat it as a deliberate go/no-go decision, not
   something to do quietly.

## What it is
**Chairful** — salon-management Android app for India SMB salons, now expanding to 25 languages
and 24 countries. Positioning: *retention intelligence* (show owners which regulars stopped
coming, win them back over WhatsApp), now expanding toward multi-branch salon groups. Repo:
`D:\vamshi\Salone` (the active one — **not** `Salone2`). Package `com.chairful.admin`. Backend:
Node/Express + Prisma + Postgres.

**Active/shipped app (what real users have): `mobile/salon_admin_app_v3`** (switched from v2 on
2026-07-14 — full redesign, bottom-nav shell, 25-language localization, real
`Salon.currency`/`countryCode`, WhatsApp-OTP forgot-password (built but hidden — no WhatsApp
Business API account), "Continue with Google" sign-in/signup. `mobile/salon_admin_app_v2` is
legacy/reference only. See `docs/HANDOFF-SALON-ADMIN-V3.md`.

**v4_1 (built, NOT released — this is the newest work, see the warning box above):**
`mobile/salon_admin_app_v4_1` is a copy of `mobile/salon_admin_app_v4` (itself a cream/terracotta
visual redesign of v3 from 2026-07-14, see `HANDOFF.md`'s 2026-07-14 entry), extended over
2026-07-15 → 2026-07-17 with a full platform pivot ("Phase 5" — see `STRATEGY.md`). Everything
below is code-complete, `flutter analyze`-clean, backend `tsc --noEmit`-clean, and curl/on-device
verified against the **local** dev backend only:
- **Multi-branch**: an owner can have multiple salons. `Salon.ownerId` uniqueness dropped;
  `DashboardData` tracks a `salons` list + `currentSalon`; a branch-switcher header bar; an
  "All branches" combined view (merged bookings/staff across every branch, tagged client-side);
  per-branch today-stats comparison in the switcher.
- **Staff CRM**: owner-configurable pay type per stylist — Commission / Salary / Both
  (`SalonStylist.payType`, `salaryAmount`), a real payout history model (`StylistPayout`), a
  shared `commission.ts` (`commissionSplit()`) replacing three previously-hardcoded 70/30 splits,
  active/inactive toggle, staff search + filters, per-day-independent working hours with a time
  picker.
- **Inventory**: salon-scoped `Product` catalog (stock qty, low-stock threshold), a Products
  screen, a Home low-stock alert card.
- **Public self-booking page**: `GET /book/:salonId` — a no-login-required HTML page (in
  `backend/src/public-booking.ts`) where a walk-by customer picks a stylist/services/time and
  submits a request; lands as a normal `PENDING` booking in the owner's existing queue. Optional
  email field. (A phone-OTP-verification step was built, then explicitly removed at the owner's
  request on 2026-07-17 — do not re-add it without being asked.)
- **Booking link + QR**: the Account screen now shows a "Booking link" card per branch — QR code
  (via `qr_flutter`), the `/book/:salonId` link, Copy/Share buttons.
- **Bug fix**: `Salon.commissionRate` (a super-admin-editable field in `/admin`) used to do
  nothing — editing it silently had no effect. Now it's the default commission rate applied to
  newly-added staff at that salon (falls back to 70% for salons that never touched it — behavior-
  neutral for everyone else).
- All new UI strings translated into all 24 non-English languages (machine-translated, not
  proofread — same caveat as the rest of the app's translations).
- `share_plus` bumped `10.1.2` → `13.2.1` (fixes a recurring Kotlin Gradle Plugin build warning).

> ⚠️ `mobile/salon_admin_app` (no `_v2`, package `com.salone.admin`, "Salone Admin" branding) is the
> **old pre-rebrand app — dead, being deleted.** Never work on it. If you see it referenced anywhere
> (e.g. an old doc claiming it's "canonical"), that doc is stale — trust this file instead.

## Working efficiently (low token — read first)
To make quota last: **one short chat per task, not one giant chat.** Every message re-reads the whole
history, so long chats get expensive fast.
- **New chat per feature**, point it at this file. Use `/compact` when a chat gets long, `/clear` between unrelated tasks.
- **Model:** Sonnet for routine coding/edits; Opus only for hard debugging/design.
- **Avoid screenshots** — images cost ~100× text. The user tests on the phone and reports results in words; verify via logs/`curl`, not screencaps.
- **Read specific line ranges**, not whole files. Don't re-explain what's already in this doc.

## Key URLs & credentials
- Prod API: **https://api.slotvibe.buzz** (k8s / ArgoCD / GHCR). `/privacy`, `/delete-account`, `/admin` live.
- Play review login (prod): **9999900000 / Review@2026** (role SALON_OWNER).
- Local demo login (pre-prod seed): **9000000001 / glamour123**.
- Owner's real test account (seeded data, see `backend/prisma/seed-owner-salon.ts`): **7989698923**,
  password known to the owner; Google account `vamshikittu114@gmail.com` linked to it as an
  alternate login (no password needed via "Continue with Google").
- Signing: upload keystore `mobile/salon_admin_app_v3/android/app/upload-keystore.jks` (also
  present under `salon_admin_app_v2/`, identical file — **shared key**, required since both use
  `com.chairful.admin`), alias `upload`, password **Chairful@2026** (gitignored — back it up).
  `keytool` isn't on PATH on this dev machine; use
  `"C:\Program Files\Android\Android Studio\jbr\bin\keytool"`.
- Google Cloud project `mystical-banner-157112` (console.cloud.google.com → APIs & Services →
  Credentials). **Web OAuth client** (used as backend `GOOGLE_CLIENT_ID` env var *and* app
  `--dart-define=GOOGLE_SERVER_CLIENT_ID`, must match exactly):
  `562611122778-qip8n4i7q2a1ad2fpo85l1g8ngt1u17d.apps.googleusercontent.com`. Two **Android**
  OAuth clients also exist (never referenced in code — Play Services matches them automatically
  by package + SHA-1): one for the debug keystore (SHA-1
  `81:B3:55:87:0F:26:66:D6:64:28:54:9C:82:26:74:2C:40:18:A4:1B`), one for the release/upload
  keystore (SHA-1 `97:97:6E:59:34:30:EF:CA:7D:A6:C5:22:67:58:DF:EA:25:78:BA:DA`). **If the app
  is ever signed with a different key (e.g. Play App Signing re-signing), Google Sign-In breaks
  until a matching Android client is added for that new SHA-1.**

## Environments & workflow (do this every time)
See [`ENVIRONMENTS.md`](./ENVIRONMENTS.md). **Test on local pre-prod first, then deploy to prod.**
- Pre-prod = local: `cd backend`, `docker compose up -d postgres redis`, `npm run dev` (:3000). Phone
  via `adb reverse tcp:3000 tcp:3000` + app built `--dart-define=API_URL=http://localhost:3000`.
- Prod = live: fail-closed auth required (`AUTH_REQUIRED=true`, `DEMO_AUTH_ENABLED=false`,
  `JWT_SECRET` 32+). See memory `backend-auth-hardening`.

## Play Store launch state
- On **Internal testing**. Opt-in link exists. App content: **10/10 declarations done** (data safety,
  content rating Everyone/3+, target 18+, no ads, privacy + delete-account URLs).
- Next gate: **Closed testing 12 testers × 14 days** → then apply for Production.
- **Done (2026-07-14): switched the published app from v2's build 5 to v3.** Backend commits
  `1d13bfd` (forgot-password OTP, Google sign-in, currency/country fields) and `ad7d37f` (pin
  image) deployed to prod via GHCR/ArgoCD, verified green (`/earnings` 200, `/customers` 200,
  unauth `/salons` 401, `/forgot-password` and `/google-login` respond — the former correctly
  500s "not configured" since no WhatsApp Business account exists yet, the latter correctly
  attempts real Google token verification). A second Android OAuth client (release SHA-1
  `97:97:6E:59:34:30:EF:CA:7D:A6:C5:22:67:58:DF:EA:25:78:BA:DA`) was added in Google Cloud
  Console alongside the debug one so Google Sign-In survives the signed build.
  **`Chairful-3.0.0-b6.aab`** (versionCode bumped 1→6 to stay above v2's last upload of 5) built
  signed with the shared `upload-keystore.jks` against `https://api.slotvibe.buzz`, uploaded to
  Play Console → Internal testing → live as release "Redesigned app", version code 6.
  `mobile/salon_admin_app_v2` is now fully retired from the release pipeline.

## Shipped features (app build 5, `Chairful-2.0.0-b5.aab` / `-arm64.apk`, v2 — superseded by v3)
All built & verified on local pre-prod:
- **"Done service" walk-in** — log a finished service in one step: current time, no slot, status
  COMPLETED + `completedAt`. Toggle vs "Schedule later". (`61a4d62`) — [`WALKIN-FLOW-DESIGN.md`](./WALKIN-FLOW-DESIGN.md)
- **Customer autocomplete** in the booking sheet (`b910fbe`).
- **Daily/weekly/monthly earnings** screen + `/earnings` endpoint (`3ac2e39`).
- **Live total** under selected services; **"Done" button**; **darker UI** (WCAG AA); **show/hide password**.

## Backend deploy state
- **Build-5 backend deployed to prod** by Codex (`e2caeba deploy: roll build 5 backend`).
  → Confirm the [`DEPLOY-BUILD5.md`](./DEPLOY-BUILD5.md) verification passed: `/earnings?period=day`
  200, `/customers` 200, unauth `/salons` 401, a `completed:true` walk-in → 201 COMPLETED.
- **Super-admin console backend deployed to prod** by Codex (`46b10b2 deploy: roll super-admin console backend`)
  on image `ghcr.io/vamshi4/salone-backend:43452f7`.
- **App build 5 (AAB/APK) is ready to publish** once that verification is green.

## Super-admin dashboard (`/admin`)
- Read dashboard + full CRUD implemented (Codex). Status/detail: [`ADMIN-CRUD-STATUS.md`](./ADMIN-CRUD-STATUS.md),
  spec: [`ADMIN-CRUD-SPEC.md`](./ADMIN-CRUD-SPEC.md).
- Guardrails: soft-delete + restore, typed-confirm deletes, audit log, can't delete/demote self.
- **Prod verified:** SUPER_ADMIN login exists (`vamshi`), `/admin` serves the full console shell, and
  [`ADMIN-CRUD-VERIFY.md`](./ADMIN-CRUD-VERIFY.md) API checks passed on a throwaway prod salon.

## Open items (need a human / not done)
1. **Breach access-log check** — the 2026-07-09 open-API incident exposed all salons' customer
   phone numbers unauth. Check nginx/ingress logs for third-party access before onboarding salons.
   (Legal: DPDP reportable if accessed.) Memory: `backend-auth-hardening`.
2. **Migration reconcile** — `Booking.completedAt` and the `20260711120000_admin_crud` migration have
   no clean migration backing; prod applies schema via `prisma db push` (P3009 history gap). Reconcile
   before ever switching to `migrate deploy`.
3. Marketing: competitor brief (ReSpark/Fresha) → campaign → outreach; one-pager PDF at
   `marketing/Chairful-for-salons.pdf` (CTA is "reply", swap to Play link once listing is public).

## Deferred / backlog
- ~~QR self-service ordering~~ **Built 2026-07-17** — see the v4_1 section above (public booking
  page + Account-screen QR/link cards). Code-complete, not yet deployed to prod.
- **Rejected:** face recognition for customer identification — technically feasible on-device, but
  biometric consent/DPDP + Play Data-safety risk and salon-environment accuracy problems (lighting,
  haircuts changing appearance) outweigh the benefit versus the QR approach above.
- WhatsApp **automatic** reminders need the WhatsApp Business API (cost + template approval) — current
  win-back is one-tap `wa.me`. Interim: a "reminders due today" batch screen.
- Per-salon timezone + currency (foundation for targeting countries beyond India).
- Admin UI: services/stylists/customers edit controls (endpoints exist; UI wiring remains).

## Doc map
- `STATUS.md` (this file) — start here.
- `DAILY_UPDATES.md` — plain-language, newest-first changelog. Point a new/different chat at this
  one if you just want "what happened lately" without the technical depth of `HANDOFF.md`.
- `HANDOFF.md` — the detailed technical handoff log (file-level specifics, gotchas, exact fixes).
  Its **2026-07-15 → 2026-07-17** entry at the bottom is the most current — read that plus this
  file's top warning box for the full current-state picture.
- `ROADMAP.md` — longer-horizon plan.
- `ENVIRONMENTS.md` — pre-prod/prod + workflow.
- `WALKIN-FLOW-DESIGN.md` — Done-service design.
- `DEPLOY-BUILD5.md` — build-5 deploy steps + verification (same pattern to follow for deploying
  the v4_1 backend changes — see the warning box above).
- `ADMIN-CRUD-SPEC.md` / `ADMIN-CRUD-STATUS.md` — super-admin console.
- `WORKLOG.md` — multi-chat coordination (which files/lanes different concurrent sessions own).
- `COMPANY_OS/` — release-synced marketing, social media agents, approval queue, asset guide,
  and n8n automation plan.
- `STRATEGY.md`, `PRODUCTION_READINESS.md` — earlier context.
- Memory (auto-loaded): `chairful-launch-status`, `backend-auth-hardening`, `dev-workflow-envs`,
  `positioning-and-naming`, `retention-feature-and-demo`.

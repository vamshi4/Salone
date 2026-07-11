# Chairful — Project Status (START HERE)

Single source of truth across all chats (Claude, Codex, future sessions). Update this when state
changes. Last updated: **2026-07-11**.

## What it is
**Chairful** — salon-management Android app for India SMB salons. Positioning: *retention
intelligence* (show owners which regulars stopped coming, win them back over WhatsApp).
Repo: `D:\vamshi\Salone` (the active one — **not** `Salone2`). Package `com.chairful.admin`.
Active app: `mobile/salon_admin_app_v2`. Backend: Node/Express + Prisma + Postgres.

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
- Signing: upload keystore `mobile/salon_admin_app_v2/android/` (CN=Chairful), password **Chairful@2026** (gitignored — back it up).

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

## Shipped features (app build 5, `Chairful-2.0.0-b5.aab` / `-arm64.apk`)
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
- WhatsApp **automatic** reminders need the WhatsApp Business API (cost + template approval) — current
  win-back is one-tap `wa.me`. Interim: a "reminders due today" batch screen.
- Per-salon timezone + currency (foundation for targeting countries beyond India).
- Admin UI: services/stylists/customers edit controls (endpoints exist; UI wiring remains).

## Doc map
- `STATUS.md` (this file) — start here.
- `ENVIRONMENTS.md` — pre-prod/prod + workflow.
- `WALKIN-FLOW-DESIGN.md` — Done-service design.
- `DEPLOY-BUILD5.md` — build-5 deploy steps + verification.
- `ADMIN-CRUD-SPEC.md` / `ADMIN-CRUD-STATUS.md` — super-admin console.
- `COMPANY_OS/` — release-synced marketing, social media agents, approval queue, asset guide,
  and n8n automation plan.
- `HANDOFF.md`, `STRATEGY.md`, `PRODUCTION_READINESS.md` — earlier context.
- Memory (auto-loaded): `chairful-launch-status`, `backend-auth-hardening`, `dev-workflow-envs`,
  `positioning-and-naming`, `retention-feature-and-demo`.

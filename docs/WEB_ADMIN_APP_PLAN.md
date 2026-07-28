# Salon Admin Web App — Complete Flow (Plan)

**Status: planning only, nothing built yet.** This is a desktop/browser version of the salon owner
dashboard (same audience as `mobile/salon_admin_app_v4_1`), reusing the existing backend as-is.

## 1. Why this is a thin build, not a rebuild

The entire product already exists as a backend API (`backend/`) — the Flutter app is just one
client of it. A web app is a **second client of the same API**, not a new product. Everything
below assumes:
- **Zero backend logic changes.** Every screen maps to an endpoint that already exists (full list
  in §5).
- **One backend change only:** add the web app's origin to `CORS_ORIGIN` in
  `deploy/k8s/salone-api.yaml` once it has a real domain (currently only
  `https://api.slotvibe.buzz` is allowed — see `backend/src/index.ts`'s CORS middleware).
- The web app is **owner-only** (same as the mobile admin app) — not a customer-facing site. The
  existing `/book/:salonId` public page already covers customer-facing web.

## 2. Tech stack recommendation

- **Next.js (React) + TypeScript** — matches the backend's language, gives you file-based routing
  for the multi-screen IA below, and SSR/static-export flexibility if you later want the login
  page to load fast.
- **TanStack Query (React Query)** for data fetching/caching against the REST API — same mental
  model as `DashboardData` in the Flutter app (load once, cache, refetch), just idiomatic React
  instead of a `ChangeNotifier`.
- **Tailwind CSS**, with a small token file porting the same palette/type scale as
  `mobile/salon_admin_app_v4_1/lib/theme.dart` (cream `#FAF7F4` background, terracotta/coral
  accent, Playfair Display + Inter) — so the web dashboard looks like the same product, not a
  different one.
- **Auth**: JWT from `POST /api/v2/auth/login`, stored in an httpOnly cookie set by a thin
  Next.js API route (safer than `localStorage`, avoids XSS token theft) — the browser talks to
  `/api/*` on the Next.js server, which attaches the token and proxies to the real backend. This
  is the one deliberate deviation from the mobile app's `SharedPreferences` token storage; it's
  the right call specifically because a web app is exposed to arbitrary third-party JS in ways a
  native app isn't.
- **Folder**: new top-level `web/salon-admin-web/`, sibling to `mobile/` and `backend/` — same
  flat-repo convention already in use.

## 3. Information architecture (desktop layout)

Mobile's 5-tab bottom nav + Account-via-avatar becomes a **left sidebar**, since desktop has the
width to show more at once and a persistent branch switcher:

```
┌─────────────┬──────────────────────────────────────┐
│  Chairful    │  <branch switcher pill>   <avatar>   │
│              │                                       │
│  ▸ Home      │                                       │
│  ▸ Bookings  │         (page content)                │
│  ▸ Staff     │                                       │
│  ▸ Insights  │                                       │
│  ▸ Services  │                                       │
│  ▸ Products  │                                       │
│              │                                       │
│  Account     │                                       │
│  Sign out    │                                       │
└─────────────┴──────────────────────────────────────┘
```

Branch switcher (dropdown, not a bottom sheet — desktop has room for it inline) stays visible in
the top bar on every page, same "All branches" combined-view concept as mobile.

## 4. Auth flow

1. `/login` — phone + password fields, same validation as mobile. Also: "Continue with Google"
   (reuses `POST /api/v2/auth/google-login` — needs Google's **Web** OAuth client, which already
   exists: `562611122778-qip8n4i7q2a1ad2fpo85l1g8ngt1u17d.apps.googleusercontent.com`, since a web
   app uses the standard OAuth redirect flow, not the mobile SDK picker).
2. `/signup` — multi-step, mirrors the Flutter signup flow (owner/salon basics → address → theme
   color, though theme color is arguably skippable for v1 web — it's cosmetic, not core).
3. On success, the JWT is set as an httpOnly cookie by a Next.js API route; all subsequent
   `/api/*` calls from the browser go through that route, which forwards to the real backend with
   the `Authorization: Bearer <token>` header attached server-side.
4. `/forgot-password` — same two-step OTP flow as mobile, **currently disabled everywhere**
   (`kForgotPasswordEnabled = false` in the Flutter app — no WhatsApp Business API account yet).
   Build the UI but gate it the same way, don't wire it live until that's resolved.
5. Route guard: any page under the dashboard layout redirects to `/login` if the cookie/session
   check fails (equivalent to Flutter's `AuthGate`).
6. Force-update equivalent: web apps don't need this — there's no app-store install to be behind
   on, the deployed web app always reflects the latest push. Skip entirely.

## 5. Screen-by-screen flow (mirrors §3, one section per sidebar item)

Each maps 1:1 to endpoints that already exist in `backend/src/routes/salon.routes.ts` /
`auth.routes.ts` / `booking.routes.ts` — no new backend work.

### Home (`/`)
- Load: `GET /api/v2/salons` (branch list + `todayStats`), `GET /api/v2/salons/:id/bookings`
  (today's logged services)
- Widgets: today's revenue-vs-goal, low-stock alert (`GET /:salonId/products`, filter client-side
  same as mobile), "New booking" CTA opens a modal (not a full page — matches the mobile sheet
  pattern)

### Bookings (`/bookings`)
- Load: `GET /:salonId/bookings` with search/filter query params (mirror what
  `bookings_screen.dart` already sends)
- Actions: `PATCH /api/v2/bookings/:id/status` (Confirm/Reject/Start/Done — same state machine as
  mobile: PENDING → CONFIRMED → IN_PROGRESS → COMPLETED), reschedule accept/reject
- New booking modal: same fields as mobile's New Booking sheet (§4 of `MANUAL_TESTING.md`),
  `POST /api/v2/bookings/salon-manual`

### Staff (`/staff`)
- Load: `GET /:salonId/stylists` (or embedded in `GET /salons` payload, same as mobile)
- Add staff: `POST /:salonId/staff-setup`
- Manage staff panel (side drawer, not a full page — keeps context of the list visible):
  `PATCH /:salonId/stylists/:stylistId` (pay type, commission rate, salary, active/inactive,
  working hours)
- Payouts panel: `GET/POST /:salonId/stylists/:stylistId/payouts`, `GET .../earnings`

### Insights (`/insights`)
- Earnings tab: `GET /:salonId/earnings?period=...`, CSV export via
  `GET /:salonId/earnings/export` (a real file download on web — arguably a **better** experience
  than mobile's share-sheet detour, since a browser can just download it directly)
- Retention tab: `GET /:salonId/retention`, `GET /:salonId/at-risk`; WhatsApp reminder button opens
  `wa.me/...` in a new tab (same mechanism as mobile's `url_launcher`)

### Services (`/services`)
- Full CRUD against `GET/POST/PATCH/DELETE /:salonId/services` — a table view instead of mobile's
  card list makes sense here; desktop users editing a catalog benefit from seeing more rows at once

### Products (`/products`)
- Full CRUD against `GET/POST/PATCH/DELETE /:salonId/products`, same table-over-cards reasoning

### Account (`/account`)
- Profile: `GET/PATCH /api/v2/auth/me`
- **Booking link section**: same QR + Copy/Share concept as mobile's Account screen — on web,
  "Share" can use the native `navigator.share()` API where supported, falling back to just a Copy
  button (most desktop browsers don't support Web Share). QR generation: any lightweight JS QR
  library (e.g. `qrcode` npm package), same `$baseUrl/book/:salonId` payload.
- Branch management: `POST /api/v2/salons` (add branch), `PATCH /api/v2/salons/:salonId`
- Change password: `POST /api/v2/auth/change-password`

## 6. What's explicitly NOT in v1 (defer, don't gold-plate)

- Theme color picker — cosmetic, mobile-first feature, low value on desktop where the whole point
  is information density, not personalization
- Language switcher — the 24-language translation work is real but porting it to web (i18n
  library, re-translating UI strings in a different framework's format) is a second project, not
  a v1 requirement. English-only for v1 web is fine.
- Any offline/PWA behavior — desktop dashboard use case doesn't need it
- Native app parity for animations (`EntranceFade`/`CountUpNumber` equivalents) — nice-to-have
  polish, not blocking

## 7. Build order

1. **Scaffold**: Next.js + TypeScript + Tailwind in `web/salon-admin-web/`, port the color/type
   tokens from `theme.dart`, auth cookie plumbing, route guard.
2. **Login/signup** — the only screens that must work before anything else is testable.
3. **Home + Bookings** — the daily-use core, same priority order the mobile app itself was built in.
4. **Staff + Insights** — the two screens with the most business value (commission/salary, and the
   retention win-back that's the actual product differentiator).
5. **Services + Products + Account** — CRUD-shaped, lowest risk, can be done in any order or in
   parallel.
6. **Deploy**: new `Dockerfile` + GitHub Action (same GHCR pattern as the backend) + a new k8s
   Deployment/Service/Ingress in `deploy/k8s/`, picked up by the same ArgoCD Application — OR,
   simpler for a v1: static/SSR-friendly hosting (Vercel free tier) pointed at the existing
   `https://api.slotvibe.buzz` backend via CORS, migrate to the k8s cluster later once it's proven
   out. **This is a real decision point, not made here** — flag it before starting §7.6.

## 8. Verification plan (once built)

Same pattern as everything else in this repo: `docs/MANUAL_TESTING.md`'s checklist items apply
almost unchanged (they're feature flows, not mobile-specific UI descriptions) — extend that file
with a "Web app" section once screens start shipping, rather than starting a separate QA doc.

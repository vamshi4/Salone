# Super-Admin Full-CRUD — Build Status

Living status/handoff for the work specified in [`ADMIN-CRUD-SPEC.md`](./ADMIN-CRUD-SPEC.md).
Keep this file current so every chat/session starts from the same picture.

**Last updated:** 2026-07-11
**Branch:** `feature/retention-and-redesign` · started from `e2caeba`
**Backend build:** ✅ `npm run build` clean · TypeScript ✅ · embedded admin JS passes `node --check`
**Prod deploy:** done - `46b10b2` rolled image `ghcr.io/vamshi4/salone-backend:43452f7`.
**Prod verification:** done - API runbook checks passed on throwaway salon `cmrgm1p1u00038v9q42ni4udk`;
`/admin` page shell returns 200 and contains Dashboard/Deleted/Audit/Services/Staff/Customers.

---

## TL;DR — where we are

The **entire backend (spec section 2)** and the **admin-page UI (spec section 3)** are implemented.
The backend, admin-page UI, prod rollout, and section-4 API checklist are complete. Remaining work
is normal operational use and any future migration-history reconcile before switching away from
the current `db push` deploy flow.

| Spec area | Status |
|---|---|
| 1 · Schema (`deletedAt`, `AdminAuditLog`) + read-query filtering | ✅ done |
| 2 · Backend endpoints (salons, users, bookings, services, customers, stylists, audit) | ✅ done |
| 3 · Admin-page UI (edit/delete, owner panel, booking actions, deleted tab, audit tab) | ✅ done |
| 4 · Post-deploy verification checklist | done - passed on prod API runbook |
| 5 · Sequencing | followed 1→5 |

---

## 1. Schema & migration

- `Salon.deletedAt`, `User.deletedAt`, `Stylist.deletedAt` (all `DateTime?`).
- New model `AdminAuditLog` (`actorId, action, targetType, targetId, before?, after?, createdAt`),
  indexed on `(targetType, targetId)` and `(actorId)`.
- Migration: [`backend/prisma/migrations/20260711120000_admin_crud/migration.sql`](../backend/prisma/migrations/20260711120000_admin_crud/migration.sql)
  — hand-authored to match the repo's existing SQL-migration convention.
- Prod applies this schema through the project's `prisma db push` initContainer on deploy.
- ⚠️ Separate pre-existing drift: `Booking.completedAt` appears in `schema.prisma` with **no migration
  backing it**. Reconcile that before/with the next `migrate deploy` or it will drift.

### Read-query soft-delete filtering (the easy-to-miss step)
Every existing salon/user/stylist **display** read now excludes soft-deleted rows:
- `admin.routes.ts` — `/stats` counts, `/salons` list, `/salons/:id` drill-down, `/growth`.
- `salon.routes.ts` — `findOwnedSalon`, app-facing `GET /api/v2/salons`, and the salon's **active
  stylist roster** (`stylist: { deletedAt: null }`).
- `booking.routes.ts` — both owner-salon auth lookups + both booking-creation stylist guards.
- `stylist.routes.ts` — customer-facing `GET /api/v2/stylists` discovery list.
- `auth.routes.ts` — login rejects a soft-deleted user.

---

## 2. Backend endpoints — all under `/api/v2/admin`, all `SUPER_ADMIN`-guarded

Every mutation writes its `AdminAuditLog` row **inside the same `$transaction`** as the change, via
[`backend/src/admin-audit.ts`](../backend/src/admin-audit.ts) `writeAudit(tx, entry)`.

### Salons
- `PATCH /salons/:id` — `name, address, saasPlan, commissionRate, lat, lng`. `saasPlan` validated
  against `KNOWN_SAAS_PLANS = ['FREE','PREMIUM']`; `commissionRate` int 0–100.
- `DELETE /salons/:id` — **soft** (sets `deletedAt`); owner untouched.
- `POST /salons/:id/restore` — clears `deletedAt`.

### Users / owners
- `PATCH /users/:id` — `name, phone, email`; phone/email collision → **409**.
- `POST /users/:id/reset-password` — `{ password }`, **min 12 chars**, hashed via shared
  `password.ts` (same `scrypt$salt$hash` as auth). Audit row carries **no** password material.
- `PATCH /users/:id/role` — `{ role }`; **refuses `id === req.user.id`** (can't change own role).
- `DELETE /users/:id` — **soft**; **refuses self-delete**.
- `POST /users/:id/restore` — clears `deletedAt` (added for the deleted-items view).

### Bookings
- `PATCH /bookings/:id` — `status` (validated vs `BookingStatus`), `slotStart, slotEnd, price`;
  enforces `slotEnd > slotStart`.
- `DELETE /bookings/:id` — **hard** (the one model allowed). Deletes the optional `Review` first
  (no cascade on it), then the booking; `BookingServiceItem` cascades.

### Services
- `PATCH /services/:id` — `name, category, duration, basePrice`.
- `DELETE /services/:id` — **hard**; if still referenced by bookings (FK `RESTRICT`) → **409**, not 500.

### Customers (`SalonCustomer`; `:id` is the join-row id)
- `PATCH /customers/:id` — `notes, tags` (array-of-strings) + linked `User` `name, phone` in one tx.
- `DELETE /customers/:id` — hard-delete the **link row only** (carries no history); User + bookings
  untouched; before-snapshot in the audit log makes it recoverable.

### Stylists (staff)
- `PATCH /stylists/:id` — `basePrice, homeServiceEnabled, independentBookingEnabled`.
- `DELETE /stylists/:id` — **soft**; drops out of discovery, rosters, and new-booking eligibility.
- `POST /stylists/:id/restore` — clears `deletedAt`.

### Audit & deleted-items (read)
- `GET /audit?targetType=&targetId=&limit=50` — newest first, `limit` clamped 1–200.
- `GET /deleted` — soft-deleted salons + users, for the restore UI.

---

## 3. Admin-page UI — [`backend/src/admin-page.ts`](../backend/src/admin-page.ts)

Vanilla, framework-free, single embedded HTML string (unchanged approach). Served at `GET /admin`.
Verified: page shell + CSS + JS load with **no console errors**; login view renders. (Authenticated
flows need a super-admin account + DB to click through.)

- **Tabs:** Dashboard · Deleted · Audit.
- **Salon drill-down:** inline edit form (name / address / plan / commission) → `PATCH`; **Delete**
  → GitHub-style typed-confirm modal (type the salon name) → soft-delete.
- **Owner panel:** edit name/phone/email; **Reset password** (prompt, min 12); **Change role**
  (dropdown); **Delete owner** (typed-confirm on owner phone). Role-change + delete are **hidden for
  your own account** (matches the API self-protection).
- **Bookings table:** per-row status `<select>` (auto-`PATCH` on change) + **Delete** (confirm → hard).
- **Deleted tab:** soft-deleted salons + users with **Restore**.
- **Audit tab:** recent admin actions (when / action / target / target id / actor).
- Reuses `esc()` for all user strings; every call goes through `api()` which bounces to login on 401/403
  and surfaces server `{ error }` messages as toasts.

### Drill-down management (added)
The `/salons/:id` detail response now also returns the salon's **services, staff roster (incl.
soft-deleted, for restore), and customers**, and the drill-down renders each as an editable table:
- **Services** — inline edit (name/category/duration/price) + hard-delete.
- **Staff** — inline edit (base price / home-service / independent-booking toggles), soft-delete,
  and **Restore** for already-deleted stylists.
- **Customers** — inline edit (name/phone via the linked User; notes; comma-separated tags) + remove
  the salon link (account + bookings untouched).

The console now covers every value in a salon end to end.

---

## 3a. Creating the first SUPER_ADMIN

`/admin` is unusable until a SUPER_ADMIN account exists. Script:
[`backend/prisma/create-super-admin.ts`](../backend/prisma/create-super-admin.ts) — idempotent
(creates or promotes + resets password), scrypt hash matches auth login, min-12-char password,
credentials come from the operator (never hardcoded), password never printed.

```
cd backend
npx tsx prisma/create-super-admin.ts <phone> <password> [name]
# or: SUPER_ADMIN_PHONE=... SUPER_ADMIN_PASSWORD=... npx tsx prisma/create-super-admin.ts
```

Run it against the target DB (prod uses `db push` for schema — see STATUS.md item 2), then sign in
at `/admin` with that phone + password (role SUPER_ADMIN).

## 4. Verification checklist (run after deploy — from the spec)

> **Runbook:** [`ADMIN-CRUD-VERIFY.md`](./ADMIN-CRUD-VERIFY.md) turns every box below into copy-paste
> `curl` steps (create the admin → log in → check each item). Run pre-prod first, then prod.

- [x] `GET /api/v2/admin/salons` with no token -> 401
- [x] Edit a salon's plan -> reflected in `/salons` **and** an `AdminAuditLog` row exists
- [x] Soft-delete a salon -> gone from `/salons` and app-facing `/api/v2/salons`; Restore -> reappears
- [x] Reset an owner's password -> new works, old fails
- [x] Change your **own** role -> refused; delete your **own** admin -> refused
- [x] Hard-delete a booking -> gone, its `BookingServiceItem` rows gone (cascade)
- [x] Malformed/oversized request -> 4xx, not 500

Prod result snapshot (2026-07-11): guard no-token `401`, guard with token `200`, plan `PREMIUM`,
audit `salon.update`, soft-delete hidden in admin/app-facing lists, restore back, owner new login
`200`, owner old login `401`, self-role/self-delete `400`, booking hard-delete ok, malformed JSON
`400`, bad plan `400`.

---

## Files touched / added

**Added:** `backend/src/admin-audit.ts`, `backend/src/password.ts`,
`backend/prisma/migrations/20260711120000_admin_crud/migration.sql`, this doc.
**Modified:** `backend/prisma/schema.prisma`, `backend/src/routes/admin.routes.ts`,
`backend/src/routes/auth.routes.ts`, `backend/src/routes/salon.routes.ts`,
`backend/src/routes/booking.routes.ts`, `backend/src/routes/stylist.routes.ts`,
`backend/src/admin-page.ts`.

## Guardrails honored (spec section 0)
Soft-delete for Salon/User/Stylist (+ restore); hard-delete only for Booking (and leaf Service/customer
link); typed client confirmation on destructive salon/owner actions; audit log on every mutation;
self role-change / self-delete refused; `SUPER_ADMIN` guard never widened.

# Super-Admin Full-CRUD — Build Spec & Handoff

**Goal:** extend the existing read-only super-admin dashboard into a full read / edit / delete
console over every salon, user, booking, customer, staff member, and service on the platform.

**Status of what already exists (commit `bba0263`):**
- `backend/src/routes/admin.routes.ts` — SUPER_ADMIN-only, read endpoints (`/stats`, `/salons`, `/salons/:id`, `/growth`)
- `backend/src/admin-page.ts` — dashboard shell at `GET /admin` (login + KPIs + chart + salon table + drill-down)
- Guard pattern: `router.use(requireRole('SUPER_ADMIN'))` at top of `admin.routes.ts` — **every** new route inherits it. Do not remove it.

This spec is the remaining ~80%. Implement in a fresh Claude chat (clean tool access) or via Codex.

---

## 0. Non-negotiable guardrails

These are the whole reason this is a spec and not a five-minute hack. The platform *just* had a
data-exposure incident (see `docs/HANDOFF.md` / memory `backend-auth-hardening`). Destroying real
customer data with one click is unacceptable.

1. **Soft-delete, never hard-delete** for `Salon` and `User`. Add `deletedAt DateTime?`; "delete"
   sets the timestamp; every existing read query must filter `where: { deletedAt: null }`.
   Provide a **restore** endpoint. This also sidesteps foreign-key failures — a `Salon` has
   `Booking`/`SalonCustomer`/`Service` children with no `onDelete: cascade`, so a hard delete
   would throw anyway.
2. **Hard delete allowed only for `Booking`** (leaf-ish; `BookingServiceItem` already cascades).
   Everything else soft-deletes.
3. **Confirmation on the client** for any destructive action — require typing the entity's name
   (salon name / owner phone) before the button enables. GitHub-style.
4. **Audit log** — every write/delete records who/what/when (model below). No exceptions.
5. **Never change a SUPER_ADMIN's own role or delete your own account** — the API must refuse if
   `req.user.id === targetUserId` for role-change/delete, so you can't lock yourself out.
6. Keep the SUPER_ADMIN guard. Do not add these routes anywhere a lower role can reach them.

---

## 1. Schema changes (`backend/prisma/schema.prisma`)

Add soft-delete columns:

```prisma
model Salon {
  // ...existing fields...
  deletedAt DateTime?
}

model User {
  // ...existing fields...
  deletedAt DateTime?
}
```

Add the audit log:

```prisma
model AdminAuditLog {
  id         String   @id @default(cuid())
  actorId    String            // the SUPER_ADMIN user id
  action     String            // "salon.update" | "salon.delete" | "user.reset-password" | ...
  targetType String            // "Salon" | "User" | "Booking" | "SalonCustomer" | ...
  targetId   String
  before     Json?             // snapshot before the change (omit secrets like password hash)
  after      Json?             // snapshot after
  createdAt  DateTime @default(now())

  @@index([targetType, targetId])
  @@index([actorId])
}
```

Migration: `npx prisma migrate dev --name admin-crud` locally; deploy with the project's existing
`prisma db push` / migrate flow (note prior P3009 pain — see HANDOFF).

**Then update every existing read query** in `admin.routes.ts`, `salon.routes.ts`, and the app-facing
routes to exclude soft-deleted rows (`where: { deletedAt: null }`). This is the easy-to-miss step —
grep for `prisma.salon.` and `prisma.user.` and add the filter.

---

## 2. Backend endpoints (add to `admin.routes.ts`)

All return `500 { error }` on catch, matching the existing style. Wrap each mutation in a helper that
writes an `AdminAuditLog` row in the same transaction.

### Salons
- `PATCH /api/v2/admin/salons/:id` — body may include `name, address, saasPlan, commissionRate, lat, lng`. Validate `saasPlan` against known plans.
- `DELETE /api/v2/admin/salons/:id` — **soft**: set `deletedAt`. Also soft-hide the owner? No — leave the owner; just the salon.
- `POST /api/v2/admin/salons/:id/restore` — clear `deletedAt`.

### Users / owners
- `PATCH /api/v2/admin/users/:id` — `name, phone, email`. Enforce phone/email uniqueness.
- `POST /api/v2/admin/users/:id/reset-password` — body `{ password }`, min 12 chars; hash with the
  **same** `scrypt$salt$hash` format as `auth.routes.ts` (`hashPassword`). Extract that helper to a
  shared module so it isn't duplicated.
- `PATCH /api/v2/admin/users/:id/role` — body `{ role }`. **Refuse if `id === req.user.id`.**
- `DELETE /api/v2/admin/users/:id` — **soft**. Refuse self-delete.

### Bookings
- `PATCH /api/v2/admin/bookings/:id` — `status, slotStart, slotEnd, price`. Validate `status` against `BookingStatus`.
- `DELETE /api/v2/admin/bookings/:id` — **hard** delete (allowed; children cascade).

### Customers (SalonCustomer)
- `PATCH /api/v2/admin/customers/:id` — `notes, tags`, and via the linked `User`: `name, phone`.
- `DELETE /api/v2/admin/customers/:id` — soft-hide the `SalonCustomer` link (add `deletedAt` there
  too if you want customer removal; otherwise just hard-delete the join row — it carries no history).

### Staff / services
- `PATCH /api/v2/admin/stylists/:id`, `DELETE .../stylists/:id` (soft)
- `PATCH /api/v2/admin/services/:id`, `DELETE .../services/:id` (hard — leaf)

### Audit
- `GET /api/v2/admin/audit?targetType=&targetId=&limit=50` — recent admin actions, newest first.

---

## 3. Frontend (`admin-page.ts`)

The page is a self-contained HTML string. Extend it — no framework, keep it vanilla like today.

- **Salon drill-down** gains **Edit** and **Delete** buttons.
  - Edit → inline form (name, address, plan, commission) → `PATCH` → refresh.
  - Delete → modal: "Type the salon name to confirm" → enable button → `DELETE` → toast + refresh.
- **Owner panel** in the drill-down: edit name/phone/email, **Reset password** (prompt for new),
  **Change role** (dropdown), **Delete** (typed confirm).
- **Bookings table** in drill-down: each row gets edit-status dropdown + delete (confirm).
- **Deleted items view**: a toggle/tab listing soft-deleted salons & users with **Restore**.
- **Audit tab**: table of recent admin actions (actor, action, target, when).
- Reuse the existing `esc()` for all user-supplied strings. Every destructive fetch checks 401/403 →
  bounce to login (already wired).

---

## 4. Verification checklist (after deploy)

- [ ] `GET /api/v2/admin/salons` with no token → **401** (guard intact)
- [ ] Edit a salon's plan → reflected in `/salons`, and an `AdminAuditLog` row exists
- [ ] Soft-delete a salon → it vanishes from `/salons` **and** from the app-facing `/api/v2/salons`
- [ ] Restore it → reappears
- [ ] Reset an owner's password → that owner can log in with the new password, not the old
- [ ] Try to change your **own** role → **refused**
- [ ] Try to delete your **own** admin user → **refused**
- [ ] Hard-delete a booking → gone; its `BookingServiceItem` rows gone (cascade)
- [ ] Malformed/oversized request → 4xx, not 500 (error handler already fixed in `index.ts`)

---

## 5. Sequencing note

If it's too big for one pass, ship in this order — each is independently useful:
1. Salon edit + soft-delete + restore + audit log (the schema + audit foundation)
2. User edit + password reset + role change (with self-protection)
3. Booking edit/delete
4. Customers / staff / services
5. Audit tab + deleted-items view in the UI

Foundation first: **do the schema (`deletedAt` + `AdminAuditLog`) and the read-query filtering before
any delete endpoint exists**, or you'll ship a hard-delete you have to walk back.

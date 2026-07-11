# WORKLOG — multi-chat coordination board

Two+ chats/agents share ONE working tree (`D:\vamshi\Salone`). This file is how they stay out of
each other's way. **Every chat reads this and `STATUS.md` before starting, and updates this when it
starts and finishes a task.**

## The 5 rules (paste these into each chat)

1. **Pull before you touch anything.** `git pull --rebase`. Never start editing on a stale tree.
2. **Claim your area here first.** Add a CLAIM line (below) naming the files/dirs you'll edit. If
   another chat has an open CLAIM overlapping your files, **do not edit them** — pick different work
   or wait.
3. **Stay in your lane** (see Territory). Don't edit files owned by the other chat's lane.
4. **Commit small and often, then release the claim.** Don't leave big uncommitted diffs sitting in
   the shared tree — that's what causes collisions. Push after committing.
5. **`schema.prisma` is a shared lock.** Only ONE chat edits it at a time, and only while holding an
   explicit CLAIM on it. Announce schema changes here so the other chat re-pulls.

## Territory (default lanes)

| Lane | Owns | Files |
|---|---|---|
| **A — Admin/backend-platform** | super-admin console, admin API | `backend/src/admin-page.ts`, `backend/src/routes/admin.routes.ts`, `backend/src/admin-audit.ts`, `backend/src/password.ts` |
| **B — App features/booking** | mobile app + booking/salon/earnings backend | `mobile/**`, `backend/src/routes/booking.routes.ts`, `salon.routes.ts`, `stylist.routes.ts`, `auth.routes.ts` |
| **Shared (coordinate)** | — | `backend/prisma/schema.prisma`, `backend/src/index.ts`, `docs/STATUS.md` |

If you must cross lanes, CLAIM the specific files and say so.

## Active claims (add at top; remove/mark DONE when finished)

<!-- Format: [CHAT-ID | YYYY-MM-DD HH:MM] STATUS: files — what you're doing -->

- [Chat A | 2026-07-11 22:07] CLAIMING: `backend/src/admin-page.ts`, `backend/src/routes/admin.routes.ts`, `backend/src/password.ts`, `docs/ADMIN-CRUD-STATUS.md`, `docs/ADMIN-CRUD-SPEC.md` — committing the rest of the super-admin full-CRUD backend (users/bookings/services/customers/stylists + audit + deleted-items reads) and the admin-page CRUD UI. Lane A.
- [Chat A | 2026-07-11 22:07] CLAIMING (cross-lane B, coordinated): `backend/src/routes/auth.routes.ts`, `backend/src/routes/booking.routes.ts`, `backend/src/routes/stylist.routes.ts` — small soft-delete read-filters the admin feature depends on (login rejects soft-deleted user; deleted stylist drops out of discovery/booking). Additive, no overlap with Chat B's mobile/build-5 work. Will release immediately after commit.

## Recently done (last ~10, newest first)

- [2026-07-11] Chat B: build 5 shipped (walk-in Done-service, autocomplete, earnings, darker UI) — committed through `269a265`, backend deployed `e2caeba`.
- [2026-07-11] Chat A: super-admin CRUD backend + admin-page UI — in progress (uncommitted at time of writing; commit + claim-release needed).

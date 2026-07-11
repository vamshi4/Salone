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

- _(none — add yours here)_

## Recently done (last ~10, newest first)

- [2026-07-11] Chat A: `ADMIN-CRUD-VERIFY.md` operator runbook added (`337e607`) — create-admin + curl steps for the section-4 checklist + UI smoke. The super-admin console is now code-complete + documented; remaining work is ops (run create-admin on prod, walk the runbook). Claim released.
- [2026-07-11] Chat A: services/staff/customers management wired into `/admin` drill-down (`bdea66f`) — `/salons/:id` now returns them; inline edit + delete/restore. **This closes STATUS.md backlog line ~65 ("Admin UI: services/stylists/customers edit controls").** A STATUS.md owner can drop that line. Claim released.
- [2026-07-11] Chat A: `create-super-admin.ts` script added (`f795d69`) — idempotent create/promote for the `/admin` login account, credentials from operator, never hardcoded. Claim released. Still needs a human to run it against prod + do section-4 verification (STATUS.md item 3 stays open until then).
- [2026-07-11] Chat A: super-admin full CRUD committed + pushed (`5f9ab33` backend+UI, `40e1d65` soft-delete read-filters). Claim released. Lane B route touches (auth/booking/stylist) were the small soft-delete guards only. `schema.prisma`/migration already committed (`0dd625a`) — not re-touched. Remaining: create first SUPER_ADMIN + run section-4 verification on prod (see `ADMIN-CRUD-STATUS.md`).
- [2026-07-11] Chat B: build 5 shipped (walk-in Done-service, autocomplete, earnings, darker UI) — committed through `269a265`, backend deployed `e2caeba`.
- [2026-07-11] Chat A: super-admin CRUD backend + admin-page UI — in progress (uncommitted at time of writing; commit + claim-release needed).

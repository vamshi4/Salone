# Walk-in vs Pre-booking — Detailed Flow Design

## The problem (in the owner's words)
- Manual booking should default to **now** (current date + time) for a walk-in.
- For a walk-in you **can't state an exact finish time** — the stylist doesn't know when they'll be done.
- The current sheet forces the owner to pick an *availability slot*, which is wrong for someone
  already sitting in the chair.

## Root cause in the current code
`POST /v2/bookings/salon-manual` calls `validateStylistSlot(stylistId, serviceIds, start)`
(`booking.routes.ts:452`). "Right now" is almost never an exact availability slot boundary, so a
true walk-in gets rejected. The app also only lets you pick from availability `_slots`, so there's no
way to say "start now." Meanwhile the backend **already** computes `end = start + totalDuration`
(`:456`) — so an *estimated* end already exists; we just shouldn't treat it as a promise.

---

## The design: one sheet, two modes

Add a segmented toggle at the top of the New Booking sheet:

```
  [ Walk-in now ]   [ Schedule for later ]
```

### Mode A — Walk-in now  (the new path)
- **No date field, no slot picker.** They're hidden.
- Start time = `DateTime.now()`, set automatically and sent as `dateTime`.
- Send a new flag `walkIn: true` to the backend.
- End time is the **estimate** (`now + sum(service durations)`) — used only to hold the chair and
  show "~ done by 3:45". It is explicitly labelled an estimate in the UI, never asked of the owner.
- Booking is created directly in an **in-progress** state (see status model below).
- The owner does nothing else until the customer leaves.

### Mode B — Schedule for later  (today's flow, unchanged)
- Date + availability slot picker exactly as now.
- `walkIn` omitted/false → slot validation still applies (correct for future bookings).

---

## Status model — capturing the real finish without predicting it

The uncertainty is solved by **recording the actual end on completion**, not by guessing up front.

**Recommended (small schema change):** add `IN_PROGRESS` to the `BookingStatus` enum and a
`completedAt DateTime?` column to `Booking`.

Flow:
1. Walk-in created → `status = IN_PROGRESS`, `slotStart = now`, `slotEnd = estimate`.
2. Customer leaves → owner taps **"Mark done"** → `PATCH /:id/status { status: 'COMPLETED' }`.
   The status handler, when moving to COMPLETED, sets `completedAt = now` and updates
   `slotEnd = now` (the *real* finish). Earnings and history use `completedAt`.

**No-migration alternative** (if you want zero schema change now): reuse `CONFIRMED` as the
"in the salon now" state for walk-ins (a walk-in with `slotStart <= now <= slotEnd` is "in progress"),
and on "Mark done" set `slotEnd = now`. Works, but "in progress" is then inferred rather than explicit.
Recommend the enum value — it's cleaner and the dashboard query is trivial.

---

## Backend changes (`booking.routes.ts`)

1. **`salon-manual`**: accept `walkIn: boolean`.
   - If `walkIn`, **skip `validateStylistSlot`** (a walk-in is not bound by the availability grid).
   - If `walkIn`, force `start = new Date()` server-side (don't trust client clock), status = `IN_PROGRESS`.
   - Keep the existing `end = start + totalDuration` estimate.
2. **`PATCH /:id/status`**: when new status is `COMPLETED`, also set `completedAt = new Date()` and,
   for walk-ins, `slotEnd = new Date()`. (Only overwrite slotEnd if it's a walk-in / still in progress.)
3. Add `IN_PROGRESS` to the validated status list.

## Schema changes (`schema.prisma`)
```prisma
enum BookingStatus {
  PENDING
  PENDING_RESCHEDULE
  CONFIRMED
  IN_PROGRESS   // new: walk-in currently being served
  COMPLETED
  CANCELLED
  NO_SHOW
}

model Booking {
  // ...
  completedAt DateTime?   // new: actual finish time, set when marked done
}
```

## App changes (`main.dart`, `_ManualBookingSheet`)
1. Add the mode toggle (`SegmentedButton` or two `ChoiceChip`s) → `bool _walkIn`.
2. When `_walkIn`: hide `_dateController` field + the "Available slots" section; skip `_loadSlots`.
   Show instead a read-only line: **"Starting now · about {estimatedMinutes} min · est. done {time}"**.
3. On save when `_walkIn`: `POST /v2/bookings/salon-manual` with `walkIn: true` and no `dateTime`
   (or `dateTime = now`); don't require a selected slot.
4. **Dashboard**: add an **"In the salon now"** section listing `IN_PROGRESS` bookings, each with a
   **"Mark done"** button → `PATCH /:id/status { COMPLETED }` → refresh. This is where walk-ins live
   until finished, and it's the satisfying "clear the chair" action.

## Why this is the right shape
- The owner never types or predicts a finish time — they tap **Walk-in now**, then **Mark done**.
- The estimate holds the slot so scheduling still works; the **real** time is captured at completion,
  so **earnings and history are accurate** (this is the hook for the daily-earnings feature — it sums
  `price` of bookings with `status = COMPLETED`, by `completedAt`).
- Pre-booking is untouched and still validates against availability.

## Build order
1. Schema: `IN_PROGRESS` + `completedAt`; migrate.
2. Backend: `walkIn` handling in `salon-manual`; `completedAt`/`slotEnd` on completion.
3. App: mode toggle + "In the salon now" + Mark done.
4. (Then) daily-earnings screen reads completed bookings by `completedAt`.

## Note on where this can be built
Backend booking changes have been buildable in-session; only auth/admin/credential code is blocked.
This flow touches `booking.routes.ts` + `schema.prisma` + `main.dart` — all fair game — but the
schema migration must go through the project's deploy path (mind the prior P3009 migration issue).

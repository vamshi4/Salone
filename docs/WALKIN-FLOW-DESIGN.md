# Booking Flow Design — "Done service" (log after) vs "Schedule later"

## What the owner actually wants
- The stylist is **busy during the service** and will NOT touch the phone at the start.
- They record the service **once, AFTER it is finished**, when free.
- At that point: just the **current time**. No time slot. No start time.
- **One entry per customer** — they do not want to enter a customer twice (no "start" then "done").
- Separately, they still want **pre-booking** for genuine future appointments.

## Root cause of the current bug
`POST /v2/bookings/salon-manual` calls `validateStylistSlot(stylistId, serviceIds, start)`
(`booking.routes.ts:452`). "Now" is almost never an exact availability slot, so logging a just-finished
service gets rejected. The app also forces choosing an availability slot, which is meaningless for a
service that already happened.

---

## The design: one sheet, two modes

Toggle at the top of the New Booking sheet:

```
  [ Done service ]   [ Schedule later ]
```

### Mode A — Done service (record AFTER the service; the new default)
A single entry, made when the service is already over.

- **No date field, no slot picker, no start time.** All hidden.
- Asks only for what the owner knows at that moment: **customer name, phone, services** (Total shown).
- Saved as already **COMPLETED**, timestamped with the **current time**. One save, done.
- Sends flag `completed: true` to the backend.

This is the key correction over the earlier draft: **no start step and no "mark done" step.** The owner
touches the phone exactly once, after the customer is finished.

### Mode B — Schedule later (future appointments; today's flow, unchanged)
- Date + availability slot picker exactly as now.
- `completed` omitted/false, so slot validation still applies (correct for future bookings).

---

## Status model — one step, nothing to predict

Because the service is only logged after it's over, the booking is born `COMPLETED`. Nothing to
estimate, nothing to finish later.

**Tiny schema change:** add `completedAt DateTime?` to `Booking` so earnings/history have an accurate
"when the money came in" timestamp. **No new enum value needed** — the existing `COMPLETED` covers it.

Single-step flow:
1. Owner opens sheet, picks **Done service**, enters customer + services, taps **Save**.
2. Backend creates the booking with `status = COMPLETED`, `completedAt = now`,
   `slotStart = slotEnd = now` (time is just "now"; duration is irrelevant — it already happened).

No `IN_PROGRESS`, no "Mark done", no "in the salon now" list. Simpler for the owner and to build.

---

## Backend changes (`booking.routes.ts` + `schema.prisma`)

1. `salon-manual`: accept `completed: boolean`.
   - If `completed`: **skip `validateStylistSlot`**; set `start = new Date()` server-side (don't trust
     client clock); `status = 'COMPLETED'`; `completedAt = start`; `slotEnd = start`.
   - If not `completed`: unchanged (future booking, slot validated).
2. `schema.prisma`: add `completedAt DateTime?` to `Booking`. Migrate via the project's deploy path
   (mind the prior P3009 migration issue).

## App changes (`main.dart`, `_ManualBookingSheet`)
1. Add the mode toggle (two `ChoiceChip`s / `SegmentedButton`) -> `bool _completed` (default true).
2. When `_completed`: hide the date field and the "Available slots" section; do not call `_loadSlots`;
   do not require a selected slot. Show a small line: **"Recorded now"** with the current time.
3. On save when `_completed`: POST `salon-manual` with `completed: true`, no `dateTime` needed
   (backend stamps the time).
4. Keep the customer name / phone / services / Total exactly as now.

## Why this is right
- The stylist touches the phone **once**, after the service, entering only what they know.
- No slot, no start/finish juggling, no double entry.
- Every logged service is `COMPLETED` with a real `completedAt`, which is exactly what the
  **daily-earnings** feature needs (sum `price` of `COMPLETED` bookings grouped by `completedAt`).
- Pre-booking (Mode B) is untouched for real future appointments.

## Build order
1. Schema: add `completedAt`; migrate.
2. Backend: `completed` handling in `salon-manual`.
3. App: mode toggle + hide slot UI when logging a finished service.
4. (Then) daily-earnings screen reads `COMPLETED` bookings by `completedAt`.

## Where this can be built
`booking.routes.ts`, `schema.prisma`, and `main.dart` are all buildable in-session (only auth/admin
code is blocked). The schema migration must go through the deploy path.

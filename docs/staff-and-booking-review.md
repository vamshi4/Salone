# Chairful — Add Staff & New Booking: field guide + improvements

Based on the screen recording of creating the first booking (27 Jul 2026). The flow works end-to-end: add staff → create booking → appears in Bookings with ₹ total.

> **Provenance:** written against the pre-v3 app and recovered from the stale `Salone2` copy on
> 2026-08-20. The improvement lists below were never implemented — treat them as an open backlog,
> but re-check each against `salon_admin_app_v3` before acting, since the UI was redesigned since.

> ~~⚠️ **Brand flag:** the live app UI is **pink/magenta**, but the brand + all marketing is **teal (#0E7C6B)**. Align these before onboarding salons — pick one and make app + marketing match.~~
> **Resolved** — `salon_admin_app_v3/lib/theme.dart` is now white/neutral with no pink, and `brand/README.md` confirms teal `#0E7C6B` as primary.

---

## PART 1 — ADD STAFF page

Why it exists: **a booking must be assigned to a staff member**, so you need at least one staff before you can take a booking. This page also defines the **services + prices** that show up in the booking screen.

### Fields explained

| Field | What it does | Required? |
|---|---|---|
| **Staff name** | The person doing the service (e.g. "akhil"). Shown in bookings & the staff filter. | ✅ Yes |
| **Staff phone** | Contact number for the staff member. | Optional |
| **Services** (list) | The services this staff offers + price each (Haircut ₹499, hair colour ₹150). Each has an **✕** to remove. These prices auto-fill the booking total. | ✅ At least 1 |
| **Service name + Price + (+)** | Type a service name, type the price, tap the pink **(+)** to add it to the list. | — |
| **Working hours — Opens / Closes** | Daily open & close time (09:00 / 18:00). Tap to open a time picker. | Defaulted |
| **Working days** | Chips Sun–Sat; tap to toggle which days this staff works. | Defaulted |
| **Create staff setup** | Saves the staff + services + hours. | — |

### Improvements (Add Staff)

1. **Fix the price field** — it shows a truncated "Pr..." placeholder, which looks broken. Widen it or use a ₹ prefix and place price on its own line under the service name.
2. **Preset service chips** — offer common salon services as one-tap chips (Haircut, Facial, Threading, Wax, Colour, Beard, Pedicure…) so owners don't type everything. **Faster setup = fewer drop-offs.**
3. **"Enter to add" service** — pressing the keyboard's ✓/enter after price should add the service (not only the small +).
4. **Clear selected state on working-day chips** — make selected days a filled solid colour and unselected clearly hollow, so it's obvious at a glance.
5. **Smart defaults** — pre-select all 7 days + 09:00–18:00 (already done) so a fast owner can just add name + one service and save.
6. **Validation + friendly errors** — block "Create" until name + ≥1 service exist, with a gentle inline message ("Add at least one service").
7. **Mark phone optional** — label it "Staff phone (optional)" so owners don't think it's required and stall.

---

## PART 2 — NEW BOOKING page

Why it matters most: **every "Done service" booking is a visit record.** This is the data that powers the whole Retention report ("who's slipping"). If bookings aren't logged, the retention feature has nothing to show. **This page is your data pipeline — protect its speed.**

### Fields explained

| Field | What it does |
|---|---|
| **Done service / Schedule later** (toggle) | *Done service* = log a walk-in that just happened (records payment now). *Schedule later* = book a future appointment. |
| **Customer name** | The customer (e.g. "akki"). |
| **Customer phone** | The customer's number. As you type, it **matches existing customers** and suggests them (e.g. "Build Five Smoke · 88728…"). This phone is what links repeat visits → the retention engine. |
| **Staff** (dropdown) | Which staff did/does the service. Their services then appear below. |
| **Services** (checkboxes) | Multi-select the services done (Haircut ₹499 ☑, hair colour ₹150). Total updates automatically. |
| **Recorded now — 27 Jul 2026** / date-time | For *Done service* it stamps now; for *Schedule later* you pick a future slot. |
| **Payment — Cash / Card / UPI** | How the customer paid. Feeds earnings. |
| **Summary bar** | "1 service · akhil · ₹499" — live running total. |
| **Cancel / Save booking · ₹total** | Saves the booking; it then appears in Bookings + counts toward earnings + retention. |

### Improvements (New Booking)

1. **⭐ Allow back-dating a "Done service"** — let owners set a past date/time when logging a visit. This is the single most important change: it lets a new salon **seed their regulars' past visits in minutes**, so the Retention report has data on day one instead of being empty for months. (This directly fixes the cold-start problem.)
2. **⭐ Make phone the customer identity + dedupe** — since retention depends on recognising repeat customers, match/merge strictly by phone and show **"last visit: 24 days ago"** in the suggestion so the owner sees the returning customer instantly.
3. **Auto-select staff** — if there's only one staff, pre-select them (skip a tap).
4. **Remember last payment method** — default to whatever they used last (most Indian salons = Cash or UPI).
5. **Show running total on the service list** — a small "Total ₹649" near the checkboxes as they tick, not only at the bottom.
6. **Add time to the "Recorded now" stamp** — show "Recorded now · 1:40 PM · 27 Jul 2026".
7. **Validation** — require name/phone + staff + ≥1 service before Save; disable the Save button until then with a hint.
8. **Optional customer name** — phone alone should be enough to save (name optional), to keep walk-in logging to 3 taps.

---

## PART 3 — Priority order (if you fix a few things)

**Do first (unblocks strategy):**
- Pick ONE brand colour (teal vs pink) and align app + marketing.
- Back-dating on "Done service" (seed past visits → fixes empty-screen cold start).
- Phone-based customer identity + "last visit" in suggestions.

**Do next (polish / speed):**
- Fix the truncated price field.
- Preset service chips.
- Auto-select single staff + remember payment method.

**Nice to have:**
- Running total near services, time in the timestamp, clearer working-day chips.

---

## Note on the flow you recorded
You created: staff **akhil** (Haircut ₹499 + hair colour ₹150) → booking for **akki**, both services, **₹649**, UPI. It landed correctly in Bookings (Total ₹649 · Avg ticket ₹649). The core loop is solid — the improvements above are about **speed and seeding data**, which is what will make salons actually stick.

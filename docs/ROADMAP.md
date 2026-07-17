# Chairful — Feature Roadmap (post-SalonOX gap review)

_Companion to [`STRATEGY.md`](STRATEGY.md) — don't read this without that. This file takes the
Jul 2026 SalonOX competitive check and sorts every gap into: build now for free, needs a paid
third party later, or deliberately not building. Nothing here overrides the Phase 1–4 roadmap in
STRATEGY.md; it slots into it._

## Ship now — pure software, no new paid service, extends the existing roadmap

These cost dev time only. Each maps to a phase already committed to in STRATEGY.md, so building
them isn't scope creep — it's finishing what's already planned.

| Feature | Extends | Why it's free |
|---|---|---|
| **Auto customer profiles** (visit history, last service, spend-to-date on the customer card) | Phase 2 | Already have booking history in Postgres — this is a query + a screen, no external call |
| **Quick-rebook** ("book the same again" from a past booking) | Phase 2 | Reuses the existing booking creation endpoint with pre-filled fields |
| **Day-of status** (waiting → in-progress → done on today's bookings) | Phase 2 | New enum + a status-update endpoint, same pattern as existing booking routes |
| **Morning briefing card** (today's appointments + revenue-vs-goal + top at-risk) | Phase 1 ("Now") | Composes data three endpoints already return; just a new Home card |
| **Simple CSV/PDF report export** | Phase 3 (profit dashboard) | Formatting existing Insights data, no external service |
| **Payment-method log on checkout** (mark a booking Cash/Card/UPI — no actual processing) | Not yet in strategy, but closes SalonOX's biggest real gap | Just a field on the booking, not a payment gateway integration |
| **Client self-booking link** (a public page/deep link so a customer can book without the owner's app) | Not yet in strategy | Reuses the existing booking backend behind one new public, unauthenticated route + a lightweight page — no paid hosting or SaaS needed beyond what's already running |

Recommended build order: **payment-method log → client self-booking link → quick-rebook → day-of
status → morning briefing → auto customer profiles → CSV export.** The first two close the two
gaps a solo owner actually feels in week one; the rest are strict wins already on the roadmap.

## Needs a paid third party — don't start until there's budget or a clear ROI case

| Feature | Blocker |
|---|---|
| **Automated WhatsApp reminders** (vs. today's manual-tap "Remind" deep link) | Needs Meta WhatsApp Business API approval + per-conversation cost. Already flagged as pending in `login_screen.dart` (`kForgotPasswordEnabled`) for the same reason — same account unblocks both. |
| **SMS reminders** | Per-message cost via a gateway (MSG91/Twilio/etc.) — SalonOX has this, but STRATEGY.md's "Risks & counters" already treats WhatsApp-API cost as the one to watch first; SMS is a second, separate cost on top |
| **Real card/UPI payment processing** (vs. the free payment-method *log* above) | Needs a payment gateway (Razorpay/PayU) — no fixed fee, but requires business KYC/registration and takes a revenue share per transaction. Worth it once there's real transaction volume, not before. |

## Deliberately not building — SalonOX has it, we don't want it

STRATEGY.md is explicit: *"We are not another booking app."* The moat is retention intelligence
for a 2–15 chair salon, not platform breadth. These SalonOX features target a different buyer
(salon groups, Zenoti-scale operations) and building them would dilute the pitch, not strengthen
it:

- **Multi-branch dashboard** — our buyer runs one location
- **Inventory / retail stock tracking** — out of scope for the retention thesis
- **Memberships / prepaid packages** — a Phase-3+ "money & growth" idea at best, not urgent
- **GST-compliant invoicing** — real need eventually, but not what wins the first sale
- **Role-based permission tiers** (manager/staff/admin) — our staff model (active/inactive +
  can-set-own-price) is intentionally simple for a small team; granular RBAC is enterprise-shaped

## One line for STRATEGY.md's "Risks & counters"

Both paid-third-party blockers above (WhatsApp API, SMS) are the same class of risk STRATEGY.md
already flags — "WhatsApp API cost/policy → tiered messaging." When that account gets set up,
unblock both the forgot-password OTP flow *and* automated reminders in the same pass.

# Chairful — Product Strategy: How We Win

_Grounded in the Jul 2026 competitive research. See [`positioning-and-naming`] context and
`docs/HANDOFF.md`. Battlecard: https://claude.ai/code/artifact/414ad50a-cb03-46e1-80a0-38e75cd91499_

_**2026-07-16 update:** platform breadth (multi-branch, inventory, full staff CRM) is now an
explicit second pillar alongside retention — see "Where we play" and Phase 5 below. This was a
deliberate pivot, made with eyes open on the tradeoff: it moves Chairful onto ground where
Zenoti/SalonOX have years of depth, instead of only competing on the retention wedge where they're
weak. The bet is that retention intelligence remains the differentiator that gets a salon to
switch, while platform breadth removes the "but we'll outgrow it" objection and lets Chairful land
salon groups, not just solo chairs. Retention is still the moat (see below) — breadth is table
stakes to keep growing accounts, not a replacement thesis.]_

## Thesis (one line)
**Chairful keeps every chair full — at one location or twenty.** It tells a salon owner *which
regulars are slipping away* and *wins them back in one tap*, and it scales from a solo chair to a
salon group without a re-platform. Retention intelligence is still what makes a salon switch to us;
platform breadth is what keeps them from outgrowing us.

## Where we play
Two segments, one product:
- **Core (land):** India SMB salons (2–15 chairs). Priced out of Zenoti (₹8k–15k), underserved by
  reminder-only tools (MioSalon, Dingg, Cleomitra). The owner is both buyer and daily user.
- **Expand:** salon groups/chains (2+ locations) who've outgrown spreadsheets-per-branch but find
  Zenoti/SalonOX overpriced and over-complicated for their size. This is the segment Phase 5 exists
  for — same retention intelligence, now with branch-level oversight.

## The moat (why it compounds)
Booking + WhatsApp are commodities. The defensible layer is a **data flywheel**: more bookings →
sharper churn prediction → better-timed win-backs → more recovered revenue → stickier owner.
Bolt-on reminders can't replicate the intelligence that decides *who to message and when*.
Multi-branch/inventory don't deepen this moat — they're explicitly the *removal of a growth
ceiling*, not a second moat. Don't let Phase 5 work crowd out Phase 4 (the actual moat).

## Roadmap — each phase answers a competitor
| Phase | Ship | Beats |
|---|---|---|
| **1 · Own "retention"** ✅ | Retention report · churn-risk auto-list · 1-tap WhatsApp win-back · morning briefing (goals·at-risk·today) | Nobody in India SMB owns this headline |
| **2 · Effortless ops** ✅ | Auto customer profiles · quick-rebook · day-of statuses (confirmed/in-progress/done) · payment-method log | MioSalon/Dingg on delight |
| **3 · Money & growth** | Auto review requests · referrals · profit dashboard (expenses) · CSV export ✅ · goal pacing ✅ | Fresha/StyleSeat on marketing |
| **4 · Deepen moat** | Demand forecasting · peer benchmarking · WhatsApp automation engine | Everyone — hard to copy |
| **5 · Platform & scale** *(new)* | Full staff CRM (profiles, performance, commission payout, role-based permissions) · multi-branch (salon-switching, per-branch staff/schedule/reporting, consolidated owner view) · inventory (retail stock, low-stock alerts) | SalonOX/Zenoti on breadth — the segment-expand play, not the core wedge |

Phase 5 is sequenced last on purpose: it's the biggest architectural lift (multi-branch touches
nearly every existing screen and endpoint — today one owner account = one salon everywhere) and it
serves the *expand* segment, not the *land* segment. Shipping it before Phase 4 would mean chasing
platform breadth before the retention moat is fully deep — do Phase 4 in parallel or first where
possible.

## Pricing (land & expand)
- **FREE** — bookings + basics (get in the door)
- **PRO ₹999/mo** — retention + WhatsApp win-back (beat Cleomitra's ₹999 anchor on value)
- **PREMIUM ₹2,999/mo** — full analytics + staff CRM + profit (1/5th of Zenoti)
- **SCALE** *(new, Phase 5)* — multi-branch + inventory + consolidated reporting, priced per
  branch. Undercut Zenoti/SalonOX's per-location cost while matching their breadth for this tier.
- Pitch **value, not features**: "recovers more than it costs" (no-shows saved + customers
  reactivated) for PRO/PREMIUM; "one login, every branch, still 1/5th of Zenoti" for SCALE.

## Beat each rival (talk track)
- **Fresha** → India-local (₹/GST/WhatsApp), no marketplace commission, deeper churn analytics.
- **Zenoti** → 1/5th price, 10-min setup, built for the small salon they ignore — and now scales
  with a growing group instead of forcing a re-platform to Zenoti later.
- **SalonOX** → same multi-branch/inventory breadth, but retention intelligence is the product,
  not a bolt-on feature; India-priced from day one instead of USD pricing on Indian testimonials.
- **MioSalon / Salonist** → modern app + retention intelligence vs feature-broad/dated UI.
- **Dingg** → match polish, beat on intelligence + automation.
- **Cleomitra** → messaging is a feature for us; the analytics is the product.

## Scoreboard (are we winning?)
Rebooking rate ↑ · churn % ↓ · **₹ recovered via win-back** · no-show rate ↓ · **D30 owner retention**.
Phase 5 adds: **% of accounts on 2+ branches**, **SCALE-tier conversion rate** — track separately
from the core scoreboard so platform breadth doesn't get credit for retention-moat wins or vice versa.

## Risks & counters
- Fresha/Zenoti move down-market → out-local + out-price.
- WhatsApp API cost/policy → tiered messaging.
- Owner tech-aversion → the "automatic, zero-effort" features are the antidote.
- **New (Phase 5): breadth work displaces moat work.** Multi-branch/inventory are big enough to
  consume every engineering cycle for a while — explicitly protect time for Phase 4 (demand
  forecasting, peer benchmarking, WhatsApp automation) so the actual differentiator doesn't stall
  while Chairful catches up on table-stakes breadth.
- **New (Phase 5): re-architecture risk.** Multi-branch changes the core assumption (one owner =
  one salon) that every existing screen/endpoint is built on. Plan this as its own migration, not
  an incremental feature — get it wrong and every other feature built on top inherits the bug.

## Now (Phase 5 execution order — current focus)
1. **Staff CRM** — lowest architectural risk of the three (no re-scoping of existing screens),
   ship first: full profiles, performance tracking (bookings/revenue per stylist — data already
   exists), commission/payout tracking (commission rates already in schema, never surfaced),
   role-based permissions (manager/staff/owner tiers).
2. **Multi-branch** — the re-architecture. Do this before inventory, since inventory should be
   branch-scoped from day one rather than retrofitted.
3. **Inventory** — retail stock + low-stock alerts, branch-scoped once multi-branch lands.

## Done (Phase 1–3, this session)
Payment-method log · client self-booking page · quick-rebook · day-of status · morning briefing ·
auto customer profiles · CSV export — see `docs/ROADMAP.md` for the "zero budget" build-out these
came from.

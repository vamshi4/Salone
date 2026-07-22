# Manual Testing Checklist — salon_admin_app_v4_1

Every screen and feature flow in the app, as a checklist. **Update this file whenever a new
feature or screen is added** — add a new section/checkbox rather than starting a separate list.
Check items off as you verify them; uncheck and note the date if something regresses.

App under test: `mobile/salon_admin_app_v4_1`. Release build tested against production
(`https://api.slotvibe.buzz`) unless noted otherwise.

---

## 1. Auth — first launch, signup, login

- [ ] Fresh install → login screen shown (not crashed, not blank)
- [ ] Language switcher (🌐 top-right of login) → picks a different language → login screen text
      updates immediately
- [ ] "New here? Create account" → signup flow starts
- [ ] Signup step 1 (basics): country picker sets currency/phone format; language picker
- [ ] Signup step 2 (salon details): owner name, salon name, address, "Use my current location"
      (grants permission → fills address)
- [ ] Signup step 3 (color): pick one of 5 theme colors, preview updates live
- [ ] Submit signup → account created → lands on Home
- [ ] Signup with a phone number that's already registered → clear error, not a crash
- [ ] Log out → log back in with phone + password → lands on Home
- [ ] Wrong password → clear error message, no crash
- [ ] "Continue with Google" on login → real Google account picker appears → signs in (only if
      the Google account is already linked to an existing owner account)
- [ ] "Continue with Google" on signup → creates a new account, auto-fills owner name from Google
      profile

## 2. Home screen

- [ ] Header shows today's date + salon name; avatar (initial letter) top-right
- [ ] Tap avatar → opens Account screen
- [ ] Branch switcher pill under the header shows current branch name + "N · Switch branch"
- [ ] Morning briefing card renders (or is absent gracefully if nothing to brief)
- [ ] Today's stat card: revenue vs. goal bar, "No appointments logged yet" when empty
- [ ] "New booking" button opens the New Booking sheet
- [ ] Quick actions: Add staff / Add service / Products — each opens the right screen/sheet
- [ ] Low-stock alert card appears only when a product is at/below its threshold; tapping it opens
      Products filtered to low-stock
- [ ] "Logged today" list shows completed walk-ins; each row shows customer, service, stylist,
      payment method
- [ ] Pull-to-refresh reloads data without error
- [ ] **All-branches mode**: switch to "All branches" → Home shows combined stats; "New booking"
      and "Add staff"/"Add service" quick actions prompt to pick a branch first instead of opening
      directly

## 3. Bookings screen

- [ ] Search box filters by customer or service name
- [ ] Filter chips: "This week" / "All time", "All staff" / a specific stylist
- [ ] "Needs action" section lists PENDING bookings with count
- [ ] PENDING booking → **Reject** → moves to cancelled, disappears from Needs action
- [ ] PENDING booking → **Confirm** → becomes CONFIRMED (blue "Scheduled" pill)
- [ ] CONFIRMED booking → **Start** button → becomes IN_PROGRESS (violet "In progress" pill)
- [ ] IN_PROGRESS booking → **Done** button → becomes COMPLETED, appears in Home's "Logged today"
- [ ] Customer-proposed reschedule request → shows requested new time + Accept/Reject buttons;
      Accept applies the new time, Reject discards it
- [ ] "New" button opens the New Booking sheet (see §4)
- [ ] Tap a booking's customer name → opens customer profile sheet (visit history, quick-rebook)
- [ ] **All-branches mode**: "New" prompts to pick a branch first; each booking row shows its
      branch name

## 4. New Booking sheet

- [ ] Toggle: "Done now" vs. "Schedule for later"
- [ ] Customer name/phone fields; recent-customer autocomplete suggestions appear and are tappable
- [ ] Stylist dropdown lists only active staff for the current branch
- [ ] Service checkboxes; selecting multiple updates the running total price live
- [ ] **Done now** path: payment method segmented control (Cash/Card/UPI) appears, is required
- [ ] **Schedule for later** path: available time slots load for the chosen stylist/date; picking
      a slot enables submit
- [ ] Submit → booking appears correctly (COMPLETED immediately for "Done now", PENDING/CONFIRMED
      for scheduled)
- [ ] Cancel/dismiss the sheet without submitting → no partial data saved

## 5. Staff screen

- [ ] Search box filters staff by name
- [ ] Filter chips: All / Active / Inactive
- [ ] Staff card shows branch name (in all-branches mode) + services or "Not active"
- [ ] "Add staff" → full setup flow: name, phone, starter service name + price, working days,
      open/close time → creates stylist + service + default hours in one step
- [ ] Tap a staff card → opens Manage Staff sheet
- [ ] **Manage Staff sheet — profile**: edit name/phone, save
- [ ] **Manage Staff sheet — pay type**: switch between Commission / Salary / Both; Commission
      shows a commission-% field, Salary shows a monthly-amount field, Both shows both
- [ ] **Manage Staff sheet — working hours**: each day of the week has its own toggle + two time
      chips (open/close); changing one day does NOT affect other days; tapping a time chip opens
      the native time picker
- [ ] **Manage Staff sheet — active/inactive toggle**: switching to inactive hides the stylist from
      new-booking stylist pickers but keeps their history
- [ ] Payout icon (next to staff card's overflow menu) → opens Payout sheet
- [ ] **Payout sheet — Commission/Both staff**: shows period earnings + unpaid-since-last-payout
      total; "Mark as paid" clears the unpaid total and adds a payout history row
- [ ] **Payout sheet — Salary/Both staff**: shows this month's salary status; "Pay salary" button
      pays it, becomes disabled/shows "Paid" once already paid this calendar month; trying to pay
      twice in the same month is blocked
- [ ] Payout history list shows past payouts, newest first, with the right label (booking count vs.
      "salary — <month>")
- [ ] **All-branches mode**: "Add staff" prompts to pick a branch first

## 6. Insights screen

- [ ] Two tabs: Earnings / Retention — switching is instant, no reload flicker
- [ ] **Earnings tab**: period selector (Today / This week / This month); revenue total; vs. prior
      period comparison chip (up/down %); top services ranking; by-staff ranking
- [ ] **Earnings tab**: CSV export button → produces a file and opens the native share sheet
- [ ] **Retention tab**: cohorts (Regulars / New / Came back / Stopped coming) with counts
- [ ] **Retention tab**: "Missed customers" list with a WhatsApp "Remind" button per row → opens
      WhatsApp with a pre-filled message (only if WhatsApp is installed)
- [ ] **Retention tab**: reactivated-customers count/summary this month
- [ ] FREE-plan salon → Retention tab shows an upgrade-to-PRO prompt instead of real data
- [ ] Tap a customer name anywhere in Insights → opens their profile sheet
- [ ] **All-branches mode**: Insights shows a "pick a branch" placeholder instead of a tab (this
      screen is inherently single-branch)

## 7. Services screen

- [ ] Search box filters by service name
- [ ] Category filter chips (derived from the salon's actual categories) + "All"
- [ ] "Add service" → name, category, price, duration, optional staff assignment → saves and
      appears in the grouped list
- [ ] Tap a service → edit sheet pre-filled → save updates it; delete removes it (confirm dialog)
- [ ] "Add common services" (starter pack button, shown when the catalog is sparse) → bulk-adds a
      default set
- [ ] **All-branches mode / no branch selected**: shows a "pick a branch" placeholder

## 8. Products screen

- [ ] Search box filters by product name
- [ ] Filter chips: All / Low stock
- [ ] "Add product" → name, category, SKU (optional), price, stock qty, low-stock threshold → saves
- [ ] Tap a product → edit sheet pre-filled → save updates it; delete removes it
- [ ] Product at/below its low-stock threshold shows a visual low-stock indicator
- [ ] Reached via Home's low-stock card → arrives pre-filtered to "Low stock"

## 9. Account screen

- [ ] Header shows avatar, salon name, "Owner since <date>"
- [ ] Plan card shows FREE/PRO/PREMIUM status; FREE shows an "Upgrade" pill
- [ ] **Booking link section**: one card per branch, each with a real QR code, the `/book/:salonId`
      link, Copy button (shows "Link copied" toast), Share button (opens native share sheet with
      correct pre-filled text)
- [ ] Theme color picker → 5 options, selecting one re-themes the whole app immediately, persists
      across restart
- [ ] Salon profile fields: owner name, phone, email, salon name, address, "Use my current
      location", daily revenue goal → Save Details persists all of them
- [ ] Country/currency picker → changes displayed currency symbol app-wide
- [ ] Language picker → changes app language immediately, persists across restart
- [ ] Change password: wrong current password → clear error; success → can log in with new
      password next time
- [ ] "Link Google account" → links successfully; account can now also log in via Google
- [ ] Sign out → returns to login screen, session cleared (relaunch doesn't auto-login)

## 10. Branch switcher (header bar, every tab)

- [ ] Tap the branch pill anywhere → opens the switcher sheet
- [ ] Single-branch owner sees just their one branch (no confusing "switch" UI)
- [ ] Multi-branch owner sees every branch as a card with today's stats
      (`N logged · revenue · staff count`)
- [ ] "All branches" card (only shown when >1 branch) → switches into combined view
- [ ] Selecting a specific branch card → switches to that branch, header updates, all tabs' data
      updates
- [ ] "Add branch" → creates a new branch, appears in the switcher immediately

## 11. Public booking page (customer-facing — no login, separate from the app)

Test by opening a branch's `/book/:salonId` link (from the Account screen's Copy/Share) in a
regular browser, not the app.

- [ ] Page loads: salon name/address, name field, phone field, email field (optional), stylist
      dropdown, services checklist with price/duration, date/time picker
- [ ] Submitting with required fields missing → clear inline error, no crash
- [ ] Selecting services updates nothing visually wrong (no verify-phone UI should appear — that
      feature was removed)
- [ ] Submit with valid data → "Request sent" success screen
- [ ] The resulting booking appears in the app under Bookings → Needs action, **on the same branch
      the link belonged to** (switch branches in the app if it's not showing — see §10)
- [ ] Submitting a 4th pending request from the same phone number at the same salon → blocked with
      a clear "too many pending requests" message (abuse guard, max 3)
- [ ] Opening `/book/<invalid-salon-id>` → friendly "Salon not found" page, not a raw error

## 12. Cross-cutting / general

- [ ] Force-update screen appears if the backend's minimum version is bumped above this build's
      version (not expected to trigger normally — only test if `SALON_ADMIN_MIN_VERSION` changes)
- [ ] Every screen: pull-to-refresh works without error
- [ ] Every list screen: empty state looks intentional (not a blank white screen)
- [ ] Every sheet/bottom-modal: Delete button (where present) is fully visible above the phone's
      on-screen nav bar, not clipped
- [ ] No screen crashes when reached via a pushed/modal route (this was a real bug class earlier —
      see `docs/HANDOFF.md` if something crashes specifically when opened from a bottom sheet)
- [ ] Rotate/backgrounds-and-resumes the app mid-flow → no data loss/crash on return

---

<!-- Add new sections above this line as features ship. Keep the same checkbox format so this
     stays scannable as a running QA list, not a changelog (see DAILY_UPDATES.md for that). -->

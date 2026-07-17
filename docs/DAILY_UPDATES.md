# Daily Updates

Plain-language summary of what got done each day, newest first. Point any new chat at this file
and ask "what's the latest" to catch up without re-reading the whole session.

---

## 2026-07-17

**1. Translated everything into all 24 languages.** 89 phrases added across the last several
sessions (staff pay, branches, inventory, etc.) were English-only until now — every other language
just silently fell back to English on screen. All 89 are now translated into all 24 supported
languages and verified building cleanly.

**2. Fixed the recurring build warning.** Upgraded the sharing library (used for the "export CSV"
feature) to a newer version that resolves a Kotlin build-tool warning that showed up on every
single build. Confirmed CSV export still works after the upgrade (you tested it yourself).

**3. Confirmed Google Sign-In is already fully live in production** — turns out this was set up in
an earlier session already; no further work needed there. (Corrects what I said yesterday — I'd
incorrectly flagged it as "local only.")

**4. Fixed the dead "Commission %" field in the admin console.** The "Commission %" field on a
salon in the super-admin tool looked editable and functional, but nothing in the booking system
actually read it — editing it silently did nothing. Now it works as intended: it sets the default
commission rate applied to new staff added to that salon (both via "Add staff" and "Make
exclusive"). Salons that never touched this field are unaffected — still default to 70%, exactly
as before. Verified live: a salon with the field set to 15% now gets new staff at 15%, an untouched
salon still gets 70%, confirmed via direct API calls against the local backend + database checks
(test data cleaned up afterward). Note: a separate background session had earlier attempted this
fix but got it wrong (rewrote commission math on a stale, pre-multi-branch code snapshot) — that
change was discarded and this is a fresh, correct fix.

**5. Built a "scan to book" QR code + link, so customers can book without your staff typing
anything in.** Every branch now has its own shareable link and QR code, shown on the Account
screen with Copy/Share buttons. Scanning it (or opening the link) opens a simple booking page —
customer picks a stylist, service, and time, enters their name/phone/optional email, and submits.
It shows up in your app exactly like any other booking request, waiting for you to confirm it —
just make sure you're viewing the right branch when checking (see gotcha below). Verified live on
your phone: QR codes render correctly for both branches, Copy and Share both work, and two real
test bookings made through the page showed up correctly in the app.

**6. Added, then removed, a "verify your phone" step on the booking page.** You asked for this,
then asked me to take it back out — it's fully removed now (no OTP step, no verify button, just
name/phone/optional email like before). Nothing was left half-done.

**Gotcha found while testing #5:** if you scan/open one branch's booking link but the app is
currently showing a *different* branch, the new booking won't appear until you switch to the
right branch (or select "All branches"). Not a bug — just a reminder to check which branch you're
viewing.

**Can this be released to the Play Store now? No — not yet.** Everything above is built and
tested on this computer only. Before it can go live for real customers:
1. None of this week's work is saved to git yet (needs your go-ahead).
2. The live production server still has old code from before all of this — it needs to be
   updated with everything from this week.
3. The version of the app tested this week was built to talk to this computer only (via a local
   test connection) — a real release build needs to point at the real server instead.
4. The app's version number hasn't been bumped — needed before any Play Store upload.
5. This would be the **first time** the new redesigned app (the one with branches, staff pay
   types, etc.) replaces the one real customers currently have — worth treating as a deliberate
   decision, not something to do quietly.

**Still open:**
- Nothing from any session has been committed to git yet — `salon_admin_app_v4_1` (where all the
  Phase 5 + salary/branch work lives) has zero commit history, only exists on this computer. This
  is the biggest outstanding risk and hasn't been resolved yet.
- Nothing is deployed to the live production server — see the release checklist above.
- The new "this month's salary" screen for salary-paid staff was tested via direct API calls, not
  seen live in the app yet.
- A background task to let owners reactivate staff they've turned off was started in an earlier
  session — status still unconfirmed.

---

## 2026-07-16

**1. Fixed a crash bug found during testing.** The new Products screen (and 4 other spots) crashed
immediately when opened — a Flutter-specific bug where a certain kind of screen loses access to
shared app data. Fixed in all 5 places it showed up.

**2. Tested everything built in earlier sessions (Staff CRM, multi-branch, inventory) live on the
phone** — all confirmed working: inventory/low-stock, staff payouts, active/inactive toggle,
branch switcher, add-branch.

**3. Google Sign-In — set up for local testing only.** Backend now accepts real Google logins when
running on this computer. **Not yet live for real users** — still needs the same setup done on the
production server, plus a proper app release build.

**4. Staff pay type — commission, salary, or both.** Owners can now mark a staff member as
salary-only, commission-only, or a mix of both, and set the commission % and monthly salary
amount themselves. Previously commission was stuck at a fixed default with no way to change it.

**5. Six small UI fixes:**
- Hid two staff permission toggles that don't do anything yet (no stylist-facing app exists to use
  them)
- Branch switcher is now a clearly-tappable button instead of plain text
- Working hours: pick times with a clock picker instead of typing, and each day of the week is
  now independently editable (before, picking multiple days always gave them the same hours)
- Fixed "Delete" buttons that were hidden underneath the phone's on-screen back/home buttons
- Added a search box to the Staff list

**6. Branch comparison + "All branches" view.** The branch switcher now shows each branch's
today's revenue/bookings/staff count side by side. New "All branches" option shows combined totals
across every branch on Home, Bookings, and Staff.

**Still to do / known gaps:**
- Google Sign-In button was never actually tapped through on the phone (backend was tested, the
  actual sign-in flow wasn't)
- The new salary pay type's "pay this month's salary" screen was tested via direct API calls, not
  seen live in the app
- Nothing from today is deployed — it all only exists on this development computer
- A separate background task was started earlier to let owners reactivate staff they've turned
  off — status not confirmed

---

<!-- Add new entries above this line, newest at the top. One entry per day, plain language, no
     jargon — this file is for the person reading it, not for coordinating between chats
     (see WORKLOG.md for that). -->

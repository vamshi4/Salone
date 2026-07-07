# Salon Admin QA Checklist

Use this checklist on the physical Android device for the salon owner app.

Backend URL for current local testing:

- `http://192.168.68.57:3000`
- If Wi-Fi routing is unstable, use USB with `adb reverse tcp:3000 tcp:3000` and run the app against `http://127.0.0.1:3000`

## Pre-check

- [ ] Backend is running on port `3000`
- [ ] Phone is connected with `adb devices`
- [ ] Salon admin app opens on the owner login screen

## 1. Signup

- [ ] Tap `New salon? Create account`
- [ ] Enter owner name
- [ ] Enter salon name
- [ ] Enter salon address
- [ ] Enter phone number
- [ ] Tap `Create account`
- [ ] App reaches dashboard without hanging on `Creating...`
- [ ] Salon name appears in the app bar

Expected:

- Dashboard loads
- No raw Dio/HTTP error text is shown

## 2. Login / Logout

- [ ] Tap `Sign out`
- [ ] App returns to owner login
- [ ] Enter the same owner phone
- [ ] Tap `Sign in`
- [ ] Dashboard opens again

Expected:

- Session clears on logout
- Session restores correctly after login

## 3. Dashboard

- [ ] `Bookings` tab is visible
- [ ] `Staff` tab is visible
- [ ] Metrics cards render
- [ ] Refresh button works

Expected:

- No blank screen
- No endless loading spinner

## 4. Add First Staff

- [ ] Open `Staff`
- [ ] Tap `Add first staff` or `Add staff`
- [ ] Enter staff name
- [ ] Enter staff phone
- [ ] Enter first service
- [ ] Enter price
- [ ] Submit `Create staff setup`
- [ ] Staff card appears

Expected:

- New staff shows in staff list
- No bottom overflow

## 5. Edit Staff

- [ ] Tap `Edit` on the created staff member
- [ ] Change name or phone
- [ ] Save
- [ ] Reopen manage sheet
- [ ] Confirm updated value is still present

Expected:

- Edit persists after sheet close/reopen

## 6. Add More Services

- [ ] In manage staff sheet, add second service
- [ ] Enter service name
- [ ] Enter service price
- [ ] Tap `Add service`
- [ ] Confirm new service appears
- [ ] Edit a service
- [ ] Delete a service

Expected:

- Multiple services are supported
- Edit/delete works without breaking the sheet

## 7. Availability

- [ ] Add weekly hours if missing
- [ ] Remove one availability row
- [ ] Add it again

Expected:

- Availability list updates correctly
- No duplicate/broken rows

## 8. Manual Booking

- [ ] Go to `Bookings`
- [ ] Tap `New`
- [ ] Choose staff
- [ ] Choose service
- [ ] Enter customer name
- [ ] Enter customer phone
- [ ] Pick date/time
- [ ] Create booking

Expected:

- Booking appears in queue
- Dashboard booking counts update

## 9. Booking Actions

- [ ] If a `PENDING` booking exists, confirm it
- [ ] If another test booking exists, reject/cancel it
- [ ] Pull to refresh

Expected:

- Status badge updates correctly
- Booking remains visible in the right section

## 10. Persistence

- [ ] Close app completely
- [ ] Reopen app
- [ ] Confirm salon still exists
- [ ] Confirm staff still exists
- [ ] Confirm services still exist
- [ ] Confirm bookings still exist

Expected:

- Data remains after reopen

## Pass / Fail Summary

Mark each section:

- Signup: `PASS / FAIL / POLISH`
- Login / Logout: `PASS / FAIL / POLISH`
- Dashboard: `PASS / FAIL / POLISH`
- Add First Staff: `PASS / FAIL / POLISH`
- Edit Staff: `PASS / FAIL / POLISH`
- Add More Services: `PASS / FAIL / POLISH`
- Availability: `PASS / FAIL / POLISH`
- Manual Booking: `PASS / FAIL / POLISH`
- Booking Actions: `PASS / FAIL / POLISH`
- Persistence: `PASS / FAIL / POLISH`

## Known Focus Areas

These are the first things to watch closely:

- Signup getting stuck on `Creating...`
- Staff setup bottom overflow on small screens
- Multiple service handling in manage staff
- Manual booking creation after fresh salon signup
- Dashboard refresh after changes

# Salone Flows

## Booking

```text
Customer selects service(s)
Customer selects backend availability slot
Customer sends request
Backend creates booking as PENDING
Stylist/Admin confirms or rejects
```

## Customer-Initiated Reschedule

```text
Booking must be CONFIRMED
Customer opens booking detail
Customer requests new backend availability slot
Backend sets:
  status = PENDING_RESCHEDULE
  proposedDateTime = selected slot
  rescheduleProposedBy = CUSTOMER
Stylist/Admin accepts:
  slotStart/slotEnd move to proposedDateTime
  status = CONFIRMED
Stylist/Admin rejects:
  original slot remains
  status = CONFIRMED
```

## Stylist-Initiated Reschedule

```text
Stylist opens booking
Stylist suggests backend availability slot
Backend sets:
  status = PENDING_RESCHEDULE
  proposedDateTime = selected slot
  rescheduleProposedBy = STYLIST
Customer accepts:
  slotStart/slotEnd move to proposedDateTime
  status = CONFIRMED
Customer rejects:
  original slot remains
  status = CONFIRMED
Customer notification badge:
  shows only when provider proposed a new time
```

## Stylist Availability

```text
Stylist opens Hours tab
Stylist adds weekly working hours
Stylist blocks specific date/time slots
Customer and reschedule slot pickers use backend availability
Backend still rejects stale or conflicting slots
```

## Salon Admin Queue

```text
Admin opens Bookings tab
Admin filters by needs action, pending, reschedule, confirmed, completed, cancelled, or all
Admin sees filtered results grouped into Needs action, Today, Upcoming, and History
Admin confirms/rejects pending bookings
Admin accepts/rejects customer reschedule requests
```

## Stylist Queue

```text
Stylist opens Bookings tab
Bookings are grouped into Needs action, Today, Upcoming, and History
Needs action includes pending bookings and customer reschedule requests
Cards explain why action is needed
Stylist confirms/rejects requests or proposes reschedule
```

## Local Mobile API

Phone builds must use current PC Wi-Fi IP:

```powershell
flutter run -d ed083e3d --dart-define=API_URL=http://YOUR_PC_IP:3000
```

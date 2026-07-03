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
```

## Local Mobile API

Phone builds must use current PC Wi-Fi IP:

```powershell
flutter run -d ed083e3d --dart-define=API_URL=http://YOUR_PC_IP:3000
```


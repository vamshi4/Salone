# GlamBook Implementation Status

Last updated: July 2, 2026

## Current Product Flow

The app is now closer to the intended salon marketplace flow:

1. Customer discovers salons or stylists.
2. Customer opens stylist or salon details.
3. Customer selects a service, time, and booking location.
4. Customer sends a booking request.
5. Stylist/master can confirm the request or suggest a new time.
6. If rescheduled, customer must accept or reject the new time.
7. Salon admin can monitor bookings and manage staff permission settings.

## What Is Working

### Backend

- Health endpoint is working.
- Salon listing API is working.
- Stylist listing API is working.
- Booking creation is working.
- Booking status updates are working.
- Stylist booking list is working.
- Salon booking list is working.
- Stylist service create/update/delete API is working.
- Backend availability slot API is working.
- Backend availability supports multiple selected services and combined duration.
- Backend rejects bookings that conflict with existing pending/confirmed bookings.
- Backend rejects bookings outside stylist working hours or blocked time.
- Reschedule now stores proposed time separately until customer accepts.
- Home service distance check endpoint exists.
- Exclusive stylist logic exists.
- Staff price permission toggle exists.

### Customer App

- Professional Discover screen with search, filters, tabs, and bottom navigation.
- Stylists tab loads real stylists from backend.
- Salons tab loads real salons from backend.
- Stylist profile screen exists.
- Salon detail and salon booking flow exists.
- Booking flow includes service, time, location, summary, and confirm button.
- Booking flow loads valid slots from backend availability.
- Booking flow supports selecting multiple services.
- Booking success screen now says request sent / waiting for provider acceptance.
- Booking history screen exists.
- Booking detail screen exists.
- Reschedule confirmation flow exists in customer bookings.
- Bell notification center shows pending reschedule actions.
- Retry button exists after network errors.
- UI font was cleaned up with bundled app font.

### Stylist App

- Dashboard screen exists.
- Bookings tab shows real assigned bookings.
- Settings tab exists.
- Stylist can confirm pending bookings.
- Stylist can suggest a reschedule time.
- Stylist reschedule sheet loads valid backend availability slots.
- Stylist can reject pending requests.
- Stylist can add and edit services with duration and price.
- Stylist can remove unused services.
- Service price editing respects salon admin `canSetOwnPrice`.
- Home service toggle is disabled for salon-exclusive stylists.
- Base price is visible.
- UI font was cleaned up with bundled app font.

### Salon Admin App

- Admin dashboard exists.
- Salon booking list is shown.
- Staff list is shown.
- Staff permission toggle works.
- UI font was cleaned up with bundled app font.
- Refresh action exists.

## Extra Work Added Beyond The Initial Demo

- Request-based booking instead of instant confirmed booking.
- New booking status: `PENDING_RESCHEDULE`.
- Customer accept/reject reschedule flow.
- Stylist/master reschedule action.
- Customer booking history screen.
- Customer booking detail screen.
- Customer notification center for reschedule actions.
- Backend availability and conflict enforcement.
- Customer and stylist apps now use backend slots instead of fake local slots.
- Customer multi-service booking selection.
- Salon admin booking list API.
- Stylist Services & Pricing management.
- Customer booking price now uses selected service price.
- Better network error states with retry.
- Real mobile device testing over Wi-Fi backend URL.
- Android APK builds for customer, stylist, and admin apps.
- Cleaner UI direction across all three apps.

## Known Gaps

These are still not complete enough for a full product flow:

1. Push notifications.
   - Customer now has in-app notification center.
   - Real push notifications are not implemented.

2. Full stylist availability management UI.
   - Backend availability exists.
   - Stylist still needs a dedicated screen to set weekly hours and blocked time.

3. Admin booking actions.
   - Admin can view bookings, but does not yet manage booking statuses deeply.
   - Admin should see pending, confirmed, rescheduled, cancelled, completed.

4. Real authentication.
   - Current flow is still demo-user based.
   - Need phone OTP/login and role-based sessions.

5. Payment and commission flow.
   - Booking price is visible.
   - Actual payment, commission, refund, payout, and no-show handling are not complete.

6. Reviews and flagging.
   - Rating display exists.
   - Real reviews and review-flag workflow are not complete.

## Recommended Next Task

Build the Stylist Availability and Queue flow next.

Reason:

- Stylist can currently suggest a simple next-hour reschedule.
- The app still needs real available slots and conflict prevention.
- This is required before booking volume becomes realistic.

Required behavior:

1. Stylist sets working hours.
2. Stylist blocks unavailable slots.
3. Customer only sees valid available slots.
4. Reschedule uses a selectable available slot, not automatic next hour.
5. Backend prevents double booking.

## Suggested Implementation Order

1. Add stylist availability/calendar queue.
2. Improve Salon Admin booking management.
3. Add real push notifications.
4. Add real login/OTP and user roles.

## Current Testing Notes

- Backend works when phone and PC are on the same Wi-Fi.
- If the phone is on a different network, the app cannot reach the local backend.
- Physical Android phone was used for testing.
- If network changes, rebuild/run apps with the current PC IP address:

```powershell
flutter run --dart-define=API_URL=http://YOUR_PC_IP:3000
```

## Short Meta AI Message

Backend and customer/stylist/admin apps are partially wired. We added request-based booking, stylist confirm/reschedule, customer accept/reject reschedule, real booking lists, salon admin booking list, and cleaner mobile UI. Next priority is Stylist Services & Pricing: stylist must add/edit service name, duration, and price, respecting salon admin `canSetOwnPrice`. Then customer booking should use those real services.

Update: Stylist Services & Pricing is now implemented. The next priority is Customer Booking Detail plus Notification Center so reschedule/confirm actions feel like a complete customer flow.

Update: Customer Booking Detail and in-app Notification Center are now implemented. The next priority is Stylist Availability and Queue.

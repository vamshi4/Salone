# Salon Marketplace Mobile Apps V2

## Setup on Windows

1. Install Flutter: https://docs.flutter.dev/get-started/install/windows
2. Install Android Studio for emulator

```powershell
# Customer App
cd customer_app
flutter pub get
flutter run --dart-define=API_URL=http://10.0.2.2:3000

# For physical device, use your PC IP:
flutter run --dart-define=API_URL=http://192.168.1.100:3000
```

## Key Logic

### StylistsTab
- Shows `Ravi at Glamour` if `registrationType == SALON_EXCLUSIVE`
- Hides home service chip if exclusive
- Price shows single value if exclusive, range if independent

### BookingScreen
- Calls `/v2/bookings/check-home-service` before allowing home booking
- Shows error if >5km or exclusive stylist
- Travel fee ₹100 from API response

### Salon Admin
- Toggle `canSetOwnPrice` per stylist
- Calls PATCH `/api/v2/salons/{id}/stylists/{id}`

## Test Full Flow

1. Backend running: `docker-compose up -d` in backend folder
2. Start Android emulator
3. `flutter run` in customer_app
4. Make stylist exclusive via API, see name change in app
5. Toggle home service, see 5km validation
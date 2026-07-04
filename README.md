# GlamBook / Salone

Salon and stylist marketplace prototype with:

- Backend API: `backend/`
- Customer app: `mobile/customer_app/`
- Stylist app: `mobile/stylist_app/`
- Salon admin app: `mobile/salon_admin_app/`
- Current progress notes: `IMPLEMENTATION_STATUS.md`

Production status: see `docs/PRODUCTION_READINESS.md`. The current app is a working MVP/demo, not yet safe for real public users.

## Backend

```powershell
cd backend
npm install
docker-compose up -d --build
```

Health check:

```powershell
Invoke-WebRequest http://localhost:3000/health -UseBasicParsing
```

## Customer App

```powershell
cd mobile/customer_app
flutter pub get
flutter run --dart-define=API_URL=http://YOUR_PC_IP:3000
```

## Stylist App

```powershell
cd mobile/stylist_app
flutter pub get
flutter run --dart-define=API_URL=http://YOUR_PC_IP:3000
```

## Salon Admin App

```powershell
cd mobile/salon_admin_app
flutter pub get
flutter run --dart-define=API_URL=http://YOUR_PC_IP:3000
```

For a physical Android phone, `YOUR_PC_IP` must be the current Wi-Fi IP of the backend machine.

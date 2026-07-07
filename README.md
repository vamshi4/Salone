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

For production-style auth enforcement set `AUTH_REQUIRED=true`, a strong `JWT_SECRET`, and disable demo tokens with `DEMO_AUTH_ENABLED=false`.

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

## Preflight Check

Run the full local verification pass before handing work over:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\preflight.ps1
```

Include the core salon admin workflow smoke test:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\preflight.ps1 -RunSmoke
```

To also launch the salon admin app on a connected Android phone:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\preflight.ps1 -RunSalonAdmin -DeviceId ed083e3d
```

## Maestro UI Flow

Maestro config and flows live in `.maestro/`.

Run the salon admin UI flow on a connected Android device:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\run-maestro-salon-admin.ps1 -DeviceId ed083e3d
```

Current flow covers:
- salon signup
- add first staff
- add starter service
- open manage staff
- add another service

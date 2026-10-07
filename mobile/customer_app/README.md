# GlamBook customer app

Customer discovery, booking, booking history, and reschedule demo for the
Chairful marketplace backend.

## Run on the physical Android device

Start the local backend on port 3000, connect the phone over USB, then run:

```powershell
adb -s ed083e3d reverse tcp:3000 tcp:3000
flutter pub get
flutter analyze
flutter run -d ed083e3d --dart-define=API_URL=http://127.0.0.1:3000
```

Customers create an account or sign in with phone and password. The session
token is stored in Android secure storage.

## Release bundle

Copy `android/key.properties.example` to `android/key.properties`, provide the
upload keystore and credentials, then run:

```powershell
flutter build appbundle --release --dart-define=API_URL=https://api.slotvibe.buzz
```

Release builds intentionally fail when `android/key.properties` is missing.
The existing Chairful key can instead be selected with the
`CHAIRFUL_KEY_PROPERTIES` environment variable.

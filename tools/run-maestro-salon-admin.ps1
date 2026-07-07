param(
  [string]$DeviceId = "ed083e3d"
)

$ErrorActionPreference = "Stop"
$appId = "com.example.salon_admin_app"

Write-Host ""
Write-Host "==> Checking Maestro CLI" -ForegroundColor Cyan
$maestro = Get-Command maestro -ErrorAction SilentlyContinue
if (-not $maestro) {
  throw "Maestro CLI is not installed or not on PATH. Install it first, then rerun this script."
}

Write-Host ""
Write-Host "==> Waking device $DeviceId and clearing app state" -ForegroundColor Cyan
$env:ANDROID_SERIAL = $DeviceId
adb -s $DeviceId shell input keyevent KEYCODE_WAKEUP | Out-Null
adb -s $DeviceId shell wm dismiss-keyguard | Out-Null
adb -s $DeviceId shell input keyevent 82 | Out-Null
Start-Sleep -Seconds 1
adb -s $DeviceId shell am force-stop $appId | Out-Null
adb -s $DeviceId shell pm clear $appId | Out-Host

Write-Host ""
Write-Host "==> Prelaunching app on device $DeviceId" -ForegroundColor Cyan
adb -s $DeviceId shell monkey -p $appId -c android.intent.category.LAUNCHER 1 | Out-Host
Start-Sleep -Seconds 4

Write-Host ""
Write-Host "==> Running salon admin Maestro flow on device $DeviceId" -ForegroundColor Cyan
maestro test --udid $DeviceId .maestro\salon-admin-signup-and-staff.yaml

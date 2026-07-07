param(
  [string]$DeviceId = "",
  [switch]$RunSalonAdmin,
  [switch]$RunSmoke
)

$ErrorActionPreference = "Stop"

function Step($message) {
  Write-Host ""
  Write-Host "==> $message" -ForegroundColor Cyan
}

function Resolve-WifiIp {
  $configs = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object {
      $_.IPAddress -notlike "127.*" -and
      $_.IPAddress -notlike "169.254.*" -and
      $_.PrefixOrigin -ne "WellKnown"
    } |
    Sort-Object InterfaceMetric

  $wifi = $configs | Where-Object { $_.InterfaceAlias -like "*Wi-Fi*" } | Select-Object -First 1
  if ($wifi) { return $wifi.IPAddress }

  $first = $configs | Select-Object -First 1
  if ($first) { return $first.IPAddress }

  throw "Could not find a usable IPv4 address."
}

function Run-Step($workdir, $command) {
  Push-Location $workdir
  try {
    Invoke-Expression $command
  } finally {
    Pop-Location
  }
}

Step "Backend build"
Run-Step "D:\vamshi\Salone\backend" "npm run build"

Step "Customer app analyze"
Run-Step "D:\vamshi\Salone\mobile\customer_app" "flutter analyze"

Step "Stylist app analyze"
Run-Step "D:\vamshi\Salone\mobile\stylist_app" "flutter analyze"

Step "Salon admin app analyze"
Run-Step "D:\vamshi\Salone\mobile\salon_admin_app" "flutter analyze"

Step "Backend health"
$health = Invoke-WebRequest "http://localhost:3000/health" -UseBasicParsing
if ($health.StatusCode -ne 200) {
  throw "Backend health check failed with status $($health.StatusCode)"
}
Write-Host "Backend healthy." -ForegroundColor Green

$ip = Resolve-WifiIp
Write-Host "Detected API URL: http://$ip`:3000" -ForegroundColor Green

if ($RunSmoke) {
  Step "Salon admin smoke test"
  Run-Step "D:\vamshi\Salone" "powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\smoke-salon-admin.ps1 -BaseUrl http://localhost:3000"
}

if ($RunSalonAdmin) {
  if (-not $DeviceId) {
    throw "Pass -DeviceId when using -RunSalonAdmin."
  }

  Step "Launching salon admin app on device $DeviceId"
  Run-Step "D:\vamshi\Salone\mobile\salon_admin_app" "flutter run -d $DeviceId --dart-define=API_URL=http://$ip`:3000"
}

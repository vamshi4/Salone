$ErrorActionPreference = "Stop"

$baseUrl = "http://localhost:3000"

function Pass($message) {
  Write-Host "[PASS] $message" -ForegroundColor Green
}

function Fail($message) {
  Write-Host "[FAIL] $message" -ForegroundColor Red
  exit 1
}

function Invoke-Json($method, $path, $body = $null) {
  $params = @{
    Uri = "$baseUrl$path"
    Method = $method
    ContentType = "application/json"
  }

  if ($null -ne $body) {
    $params.Body = ($body | ConvertTo-Json -Depth 8)
  }

  Invoke-RestMethod @params
}

try {
  $health = Invoke-Json Get "/health"
  if ($health.status -ne "ok") { Fail "Backend health did not return ok" }
  Pass "Backend health"

  $stylists = @(Invoke-Json Get "/api/v2/stylists")
  if ($stylists.Count -lt 1) { Fail "No stylists returned" }

  $ravi = $stylists | Where-Object { $_.user.name -eq "Ravi" } | Select-Object -First 1
  if ($null -eq $ravi) { Fail "Ravi was not returned by /api/v2/stylists" }
  Pass "Ravi returned by stylist API"

  $independent = Invoke-Json Post "/api/v2/stylists/$($ravi.id)/make-independent"
  if ($independent.registrationType -ne "INDEPENDENT") { Fail "Ravi did not become INDEPENDENT" }
  if ($independent.homeServiceEnabled -ne $true) { Fail "Ravi home service was not enabled" }
  Pass "Make Ravi independent"

  $nearBody = @{
    stylistId = $ravi.id
    customerLat = 17.457
    customerLng = 78.350
  }
  $near = Invoke-Json Post "/api/v2/bookings/check-home-service" $nearBody
  if ($near.eligible -ne $true) { Fail "Home service near check was not eligible" }
  Pass "Home service allowed within 5km"

  $aliasNear = Invoke-Json Post "/v2/bookings/check-home-service" $nearBody
  if ($aliasNear.eligible -ne $true) { Fail "Flutter /v2 booking alias did not work" }
  Pass "Flutter /v2 booking alias"

  try {
    $farBody = @{
      stylistId = $ravi.id
      customerLat = 17.520
      customerLng = 78.430
    }
    Invoke-Json Post "/api/v2/bookings/check-home-service" $farBody | Out-Null
    Fail "Home service over 5km unexpectedly passed"
  } catch {
    Pass "Home service blocked over 5km"
  }

  $salons = @(Invoke-Json Get "/api/v2/salons")
  if ($salons.Count -lt 1) { Fail "No salons returned" }
  $salon = $salons | Where-Object { $_.name -eq "Glamour Salon" } | Select-Object -First 1
  if ($null -eq $salon) { $salon = $salons[0] }

  $exclusive = Invoke-Json Post "/api/v2/salons/$($salon.id)/stylists/$($ravi.id)/make-exclusive"
  if ($exclusive.registrationType -ne "SALON_EXCLUSIVE") { Fail "Ravi did not become SALON_EXCLUSIVE" }
  if ($exclusive.homeServiceEnabled -ne $false) { Fail "Exclusive Ravi still has home service enabled" }
  Pass "Make Ravi exclusive"

  try {
    Invoke-Json Post "/api/v2/bookings/check-home-service" $nearBody | Out-Null
    Fail "Exclusive stylist home service unexpectedly passed"
  } catch {
    Pass "Exclusive stylist blocks home service"
  }

  $finalStylists = @(Invoke-Json Get "/api/v2/stylists")
  $finalRavi = $finalStylists | Where-Object { $_.id -eq $ravi.id } | Select-Object -First 1
  if ($finalRavi.registrationType -ne "SALON_EXCLUSIVE") { Fail "Final Ravi state is not exclusive" }
  Pass "Final stylist API state"

  Write-Host ""
  Write-Host "ALL MOBILE BACKEND FLOWS PASSED" -ForegroundColor Green
} catch {
  Fail $_.Exception.Message
}

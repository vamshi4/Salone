param(
  [string]$BaseUrl = "http://localhost:3000"
)

$ErrorActionPreference = "Stop"

function Step($message) {
  Write-Host ""
  Write-Host "==> $message" -ForegroundColor Cyan
}

function PostJson($url, $body, $headers = @{}) {
  Invoke-RestMethod -Method Post -Uri $url -ContentType "application/json" -Body ($body | ConvertTo-Json -Depth 8) -Headers $headers
}

function GetJson($url, $headers = @{}) {
  Invoke-RestMethod -Method Get -Uri $url -Headers $headers
}

$suffix = Get-Date -Format "yyyyMMddHHmmss"
$ownerPhone = "91$suffix"
$staffPhone = "81$suffix"
$customerPhone = "71$suffix"

Step "Signup salon owner"
$signup = PostJson "$BaseUrl/api/v2/auth/salon-signup" @{
  ownerName = "Smoke Owner $suffix"
  phone = $ownerPhone
  salonName = "Smoke Salon $suffix"
  address = "Smoke Address $suffix"
}

if (-not $signup.token) {
  throw "Signup did not return a token."
}

$auth = @{ Authorization = "Bearer $($signup.token)" }
$salonId = $signup.salon.id

Step "Create staff"
$stylist = PostJson "$BaseUrl/api/v2/stylists" @{
  name = "Smoke Stylist $suffix"
  phone = $staffPhone
  registrationType = "SALON_EXCLUSIVE"
  homeServiceEnabled = $false
  independentBookingEnabled = $false
  basePrice = 49900
} $auth

Step "Attach staff to salon"
[void](PostJson "$BaseUrl/api/v2/salons/$salonId/stylists/$($stylist.id)/make-exclusive" @{} $auth)

Step "Create service"
$service = PostJson "$BaseUrl/api/v2/stylists/$($stylist.id)/services" @{
  name = "Smoke Haircut $suffix"
  category = "Salon"
  duration = 60
  basePrice = 49900
} $auth

Step "Add working hours"
foreach ($day in 1..6) {
  [void](PostJson "$BaseUrl/api/v2/stylists/$($stylist.id)/availability" @{
    dayOfWeek = $day
    startTime = "09:00"
    endTime = "18:00"
  } $auth)
}

Step "Load available slots"
$slotDate = (Get-Date).AddDays(1)
while ($slotDate.DayOfWeek -eq [DayOfWeek]::Sunday) {
  $slotDate = $slotDate.AddDays(1)
}
$dateText = $slotDate.ToString("yyyy-MM-dd")
$availability = GetJson "$BaseUrl/api/v2/stylists/$($stylist.id)/availability?date=$dateText&serviceId=$($service.id)" $auth
if (-not $availability.slots -or $availability.slots.Count -eq 0) {
  throw "No slots returned for smoke test."
}

$dateTime = $availability.slots[0].dateTime

Step "Create manual booking"
$booking = PostJson "$BaseUrl/api/v2/bookings/salon-manual" @{
  salonId = $salonId
  stylistId = $stylist.id
  serviceId = $service.id
  dateTime = $dateTime
  customerName = "Smoke Customer $suffix"
  customerPhone = $customerPhone
} $auth

if ($booking.status -ne "CONFIRMED") {
  throw "Expected CONFIRMED booking, got $($booking.status)"
}

Step "Verify salon dashboard bookings"
$bookings = GetJson "$BaseUrl/api/v2/salons/$salonId/bookings" $auth
$match = $bookings | Where-Object { $_.id -eq $booking.id }
if (-not $match) {
  throw "Created booking was not returned in salon bookings."
}

Write-Host ""
Write-Host "Salon admin smoke test passed." -ForegroundColor Green
Write-Host "Salon: $($signup.salon.name)" -ForegroundColor Green
Write-Host "Staff: $($stylist.user.name)" -ForegroundColor Green
Write-Host "Service: $($service.name)" -ForegroundColor Green
Write-Host "Booking: $($booking.id)" -ForegroundColor Green


import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

/// Captures the device's current GPS location and a readable address.
/// Returns null if location services are off or permission is denied.
Future<({double lat, double lng, String address})?> pickCurrentLocation() async {
  if (!await Geolocator.isLocationServiceEnabled()) return null;
  var perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
    return null;
  }
  final pos = await Geolocator.getCurrentPosition();
  String address = '';
  try {
    // Reverse-geocode over HTTP (OpenStreetMap Nominatim) — no native plugin.
    final res = await Dio().get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {
        'lat': pos.latitude,
        'lon': pos.longitude,
        'format': 'json',
        'zoom': 18,
      },
      options: Options(headers: {'User-Agent': 'ChairfulSalonApp/1.0'}),
    );
    final display = res.data is Map ? res.data['display_name'] : null;
    if (display is String) address = display;
  } catch (_) {
    // Reverse-geocoding is best-effort; coordinates are still captured.
  }
  return (lat: pos.latitude, lng: pos.longitude, address: address);
}

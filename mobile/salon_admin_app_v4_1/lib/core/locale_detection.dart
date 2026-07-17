import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

import 'prefs.dart';

/// Best-effort country detection for first-launch defaults only. Tries GPS
/// first — most accurate for where the user actually *is* right now, since
/// a phone's OS locale can be stale if someone is traveling — then falls
/// back to the device's OS language/region setting. Returns null if neither
/// signal resolves to one of [kCountries] (location denied/off, network
/// failure, or the detected country isn't one this app has a market entry
/// for), in which case the caller keeps the existing default.
///
/// Runs at most once per install (see AppPrefs.hasDetectedLocale) — every
/// picker in the app (signup, Account, Login) still lets the user override
/// this guess at any time.
Future<String?> detectCountryCode() async {
  final gpsCode = await _detectCountryFromGps();
  if (gpsCode != null && kCountries.any((c) => c.code == gpsCode)) return gpsCode;

  final localeCode = PlatformDispatcher.instance.locale.countryCode;
  if (localeCode != null && kCountries.any((c) => c.code == localeCode)) return localeCode;

  return null;
}

Future<String?> _detectCountryFromGps() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      return null;
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(timeLimit: Duration(seconds: 6)),
    );
    final res = await Dio().get(
      'https://nominatim.openstreetmap.org/reverse',
      queryParameters: {'lat': pos.latitude, 'lon': pos.longitude, 'format': 'json'},
      options: Options(
        headers: {'User-Agent': 'ChairfulSalonApp/1.0'},
        sendTimeout: const Duration(seconds: 6),
        receiveTimeout: const Duration(seconds: 6),
      ),
    );
    final address = res.data is Map ? res.data['address'] : null;
    final code = address is Map ? address['country_code'] : null;
    return code is String && code.isNotEmpty ? code.toUpperCase() : null;
  } catch (_) {
    // Best-effort only; caller falls back to device locale.
    return null;
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

/// This build's version. Keep in sync with pubspec.yaml `version:`.
/// The backend's `salonAdminMinVersion` is compared against this to force
/// updates (see [UpdateRequiredScreen]).
const appVersion = '3.0.0';

String? _sessionToken;

/// Returns true when [current] is a lower semver than [min] (x.y.z).
bool isVersionLower(String current, String min) {
  List<int> parse(String v) => v
      .split('.')
      .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
      .toList();
  final c = parse(current);
  final m = parse(min);
  for (var i = 0; i < 3; i++) {
    final cv = i < c.length ? c[i] : 0;
    final mv = i < m.length ? m[i] : 0;
    if (cv != mv) return cv < mv;
  }
  return false;
}

Future<String?> authToken() async {
  if (_sessionToken != null) return _sessionToken;
  final prefs = await SharedPreferences.getInstance();
  _sessionToken = prefs.getString('salon_admin_token');
  return _sessionToken;
}

Future<void> saveAuthToken(String token) async {
  _sessionToken = token;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('salon_admin_token', token);
}

Future<void> clearAuthToken() async {
  _sessionToken = null;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('salon_admin_token');
}

/// Authenticated Dio client. Attaches the saved bearer token to every
/// request except login (there's no token yet at that point).
Dio api() {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('/auth/login')) {
            final token = await authToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
      ),
    );
}

/// Unauthenticated client, only for login/signup where no token exists yet.
Dio anonApi() => Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

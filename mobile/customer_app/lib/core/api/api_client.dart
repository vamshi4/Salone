import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');
  static const _storage = FlutterSecureStorage();
  static String? _token;
  static String? customerName;
  static String? customerPhone;

  static Future<bool> initialize() async {
    _token = await _storage.read(key: 'customer_token');
    customerName = await _storage.read(key: 'customer_name');
    customerPhone = await _storage.read(key: 'customer_phone');
    return _token != null;
  }

  static Future<void> login(String phone, String password) async {
    final response = await _publicDio().post('/api/v2/auth/login', data: {
      'phone': phone,
      'password': password,
      'role': 'CUSTOMER',
    });
    await _saveSession(response.data);
  }

  static Future<void> signup(String name, String phone, String password) async {
    final response =
        await _publicDio().post('/api/v2/auth/customer-signup', data: {
      'name': name,
      'phone': phone,
      'password': password,
    });
    await _saveSession(response.data);
  }

  static Future<void> logout() async {
    _token = null;
    customerName = null;
    customerPhone = null;
    await _storage.deleteAll();
  }

  static Future<void> _saveSession(dynamic data) async {
    _token = data['token'] as String;
    customerName = data['user']['name'] as String?;
    customerPhone = data['user']['phone'] as String?;
    await _storage.write(key: 'customer_token', value: _token);
    await _storage.write(key: 'customer_name', value: customerName);
    await _storage.write(key: 'customer_phone', value: customerPhone);
  }

  static Dio _publicDio() => Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ));

  final Dio _dio = _publicDio()
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (_token != null) options.headers['Authorization'] = 'Bearer $_token';
      handler.next(options);
    }));

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);
  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);
}

import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');
  static Future<String>? _token;
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('/auth/demo-token')) {
            options.headers['Authorization'] = 'Bearer ${await _authToken()}';
          }
          handler.next(options);
        },
      ),
    );

  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);
  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  static Future<String> _authToken() {
    return _token ??= Dio(BaseOptions(baseUrl: baseUrl))
        .post(
          '/api/v2/auth/demo-token',
          data: {
            'phone': 'customer-demo',
            'name': 'Demo Customer',
            'role': 'CUSTOMER',
          },
        )
        .then((res) => res.data['token'] as String);
  }
}

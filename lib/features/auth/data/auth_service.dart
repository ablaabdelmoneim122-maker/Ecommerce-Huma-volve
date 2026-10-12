import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(PrettyDioLogger(requestBody: true));

  /// returns access_token
  Future<String> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return res.data['access_token'];
    } on DioException catch (e) {
      throw _handle(e);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      await _dio.post(
        '/users/',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'avatar': 'https://picsum.photos/800',
        },
      );
    } on DioException catch (e) {
      throw _handle(e);
    }
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final res = await _dio.get(
        '/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return res.data;
    } on DioException catch (e) {
      throw _handle(e);
    }
  }

  String _handle(DioException e) {
    if (e.response?.statusCode == 401) return 'Wrong email or password';
    if (e.type == DioExceptionType.connectionError)
      return 'No internet connection';
    return e.response?.data?['message']?.toString() ?? 'Something went wrong';
  }
}

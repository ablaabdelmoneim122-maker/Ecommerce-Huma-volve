import 'package:dio/dio.dart';


abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<void> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<String> login(String email, String password) async {
    final res = await _dio.post('/auth/login',
        data: {'email': email, 'password': password});
    return res.data['access_token'];
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await _dio.post('/users/', data: {
      'name': name,
      'email': email,
      'password': password,
      'avatar': 'https://picsum.photos/800',
    });
  }
}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _key = 'access_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _cached;

  Future<void> save(String token) async {
    _cached = token;
    await _storage.write(key: _key, value: token);
  }

  Future<String?> read() async => _cached ??= await _storage.read(key: _key);

  Future<void> clear() async {
    _cached = null;
    await _storage.delete(key: _key);
  }
}
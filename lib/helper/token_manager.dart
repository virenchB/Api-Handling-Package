import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  // Store token securely
  Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Retrieve token securely
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // Delete token securely
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

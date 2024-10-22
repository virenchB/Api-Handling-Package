import 'dart:convert';

import 'package:api_handling_package/helper/api_handler.dart';

import '../helper/encryption_helper.dart';
import '../helper/token_manager.dart';

class Auth {
  final String baseUrl;
  final String apiKey;
  final List<String> allowedSHA1Certificates;
  final TokenManager tokenManager;

  Auth(this.baseUrl, this.apiKey, this.allowedSHA1Certificates,
      this.tokenManager);

  Future<void> login(
    String phoneNumber,
    EncryptionHelper encryptionHelper,
  ) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'phoneNumber': phoneNumber});

    final encryptedBody = encryptionHelper.encryptData(body);

    final response = await ApiHandler.post(
        url, encryptedBody, apiKey, allowedSHA1Certificates);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = (responseData as Map)['token'].toString();
      await tokenManager.storeToken(token);
    } else {
      throw Exception('Login failed');
    }
  }
}

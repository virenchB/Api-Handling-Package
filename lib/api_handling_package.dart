import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api/auth.dart';
import 'helper/encryption_helper.dart';
import 'helper/token_manager.dart';

class Cred {
  factory Cred() {
    return _instance;
  }

  Cred._internal();
  static final Cred _instance = Cred._internal();

  late Auth auth;
  late TokenManager tokenManager;
  late EncryptionHelper encryptionHelper;

  Future<void> initialize({
    required String baseUrl,
    required String apiKey,
    required List<String> allowedSHA1Certificates,
  }) async {
    // Step 1: Initialize token manager and APIs
    tokenManager = TokenManager();
    auth = Auth(baseUrl, apiKey, allowedSHA1Certificates, tokenManager);

    if (kDebugMode) {
      print('Cred package initialized successfully.');
    }
  }

  Future<void> fetchEncryptionKeyForLoginOrSignup(
      String baseUrl,
      String apiKey,
      ) async {
    final url = Uri.parse('$baseUrl/get-encryption-key');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final encryptionKey = (responseData as Map)['encryptionKey'].toString();
      final iv = responseData['iv'].toString();

      // Initialize encryption helper
      encryptionHelper = EncryptionHelper(encryptionKey, iv);
    } else {
      throw Exception('Failed to fetch encryption key: ${response.statusCode}');
    }
  }

  Future<String?> getToken() async {
    return tokenManager.getToken();
  }
}

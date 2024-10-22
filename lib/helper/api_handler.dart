import 'package:crypto/crypto.dart' show sha1;
import 'package:http/http.dart' as http;

class ApiHandler {
  static Future<http.Response> get(
    Uri url,
    String apiKey,
    List<String> allowedSHA1Certificates, {
    String? token,
  }) async {
    final response = await http.get(url, headers: _buildHeaders(apiKey, token));
    _verifyCertificate(response, allowedSHA1Certificates);
    return response;
  }

  static Future<http.Response> post(
    Uri url,
    String? body,
    String apiKey,
    List<String> allowedSHA1Certificates, {
    String? token,
  }) async {
    final response =
        await http.post(url, headers: _buildHeaders(apiKey, token), body: body);
    _verifyCertificate(response, allowedSHA1Certificates);
    return response;
  }

  static Map<String, String> _buildHeaders(String apiKey, String? token) {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Example of simple certificate validation using SHA-1
  static void _verifyCertificate(
    http.Response response,
    List<String> allowedSHA1Certificates,
  ) {
    final certHash = sha1.convert(response.bodyBytes).toString().toUpperCase();
    if (!allowedSHA1Certificates.contains(certHash)) {
      throw Exception('SSL Certificate mismatch: certificate not trusted.');
    }
  }
}

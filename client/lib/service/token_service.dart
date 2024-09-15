import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TokenService {
  static const String ACCESS_TOKEN_KEY = 'access_token';
  static const String REFRESH_TOKEN_KEY = 'refresh_token';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<bool> hasValidToken() async {
    await dotenv.load(fileName: '.env');
    try {
      String? accessToken = await getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      print('token: $accessToken');

      final response = await http.get(
        Uri.parse('${dotenv.get("SERVER_URL")}/login/check/user'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error checking token: $e');
      return false;
    }
  }

  static Future<void> saveTokens(
      {required String accessToken, required String refreshToken}) async {
    await _storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await _storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
  }

  static Future<void> deleteTokens() async {
    await _storage.delete(key: ACCESS_TOKEN_KEY);
    await _storage.delete(key: REFRESH_TOKEN_KEY);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: ACCESS_TOKEN_KEY);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: REFRESH_TOKEN_KEY);
  }
}

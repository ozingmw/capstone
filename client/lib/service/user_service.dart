import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> readUser() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/read'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return jsonDecode(response.body);
  }

  Future<bool> updateNickname(String nickname) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/update/nickname'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'nickname': nickname,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> updatePhoto(String photoUrl) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/user/update/photo'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'photo_url': photoUrl,
      }),
    );
    return response.statusCode == 200;
  }
}

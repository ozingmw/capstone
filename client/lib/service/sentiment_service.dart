import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SentimentService {
  SentimentService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> readSentimentMonth(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/sentiment/monthly'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': date,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> readSentimentHalfYear(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/sentiment/halfyear'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': date,
      }),
    );
    return jsonDecode(response.body);
  }
}

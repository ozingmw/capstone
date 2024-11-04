import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuoteService {
  QuoteService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> readQuote(String sentiment) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/quote/read/gpt'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'sentiment': sentiment,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> readQuotePig() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/quote/read/gpt'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'sentiment': "기쁨",
      }),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

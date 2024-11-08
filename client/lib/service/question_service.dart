import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuestionService {
  QuestionService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> readQuestion() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse('${dotenv.get("SERVER_URL")}/question/read_random'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

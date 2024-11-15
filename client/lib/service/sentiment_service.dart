import 'dart:convert';
import 'package:dayclover/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SentimentService {
  static const String monthlyEndpoint = 'monthly';
  static const String halfYearEndpoint = 'halfyear';
  static const String weeklyEndpoint = 'weekly';

  SentimentService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> getSentiment(
      String endPoint, DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/sentiment/$endPoint'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({'date': DateFormat('yyyy-MM-dd').format(date)}),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

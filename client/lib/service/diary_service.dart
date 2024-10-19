import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DiaryService {
  DiaryService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> analyzeEmotion(String diary) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/analyze'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'diary_content': diary,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createDiary({
    required String diary,
    required String sentimentUser,
    required String sentimentModel,
    DateTime? daytime,
  }) async {
    Map<String, dynamic> body = {
      'diary_content': diary,
      'sentiment_user': sentimentUser,
      'sentiment_model': sentimentModel,
      if (daytime != null) 'daytime': daytime,
    };
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/create'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> readDiary(String date) async {
    String? accessToken = await TokenService.getAccessToken();

    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/today'),
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

  Future<Map<String, dynamic>> readDiaryWeek(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/weekly'),
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

  Future<Map<String, dynamic>> readDiaryMonth(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();

    String dateString = date.toIso8601String();

    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/monthly'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': dateString,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateDiary({
    required DateTime date,
    String? diaryContent,
    String? sentimentModel,
    String? sentimentUser,
  }) async {
    String? accessToken = await TokenService.getAccessToken();

    Map<String, dynamic> body = {
      'date': date,
      if (diaryContent != null) 'diary_content': diaryContent,
      if (sentimentModel != null) 'sentiment_model': sentimentModel,
      if (sentimentUser != null) 'sentiment_user': sentimentUser,
    };

    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/update'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }
}

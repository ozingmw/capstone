import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DiaryService {
  DiaryService() {
    dotenv.load(fileName: '.env');
  }

  Future<int> analyzeEmotion(String diary) async {
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

  Future<Map<String, dynamic>> writeDiary(
      String diary, int sentimentUser, int sentimentModel) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/write'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'sentiment_user': sentimentUser,
        'sentiment_model': sentimentModel,
        'diary_content': diary,
      }),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> readDiary(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read'),
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
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/monthly'),
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

  Future<Map<String, dynamic>> modifyDiary(String diary) async {
    // 이부분하고 서버쪽하고 수정해야함
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.put(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/modify'),
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
}

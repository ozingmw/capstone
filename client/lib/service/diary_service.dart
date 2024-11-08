import 'dart:convert';

import 'package:client/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DiaryService {
  DiaryService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, dynamic>> analyzeEmotion(String diary) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/analyze'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'diary_content': diary,
      }),
    );
    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> createDiary({
    required String diary,
    required String sentiment,
    required int isDiary,
    String? daytime,
  }) async {
    Map<String, dynamic> body = {
      'diary_content': diary,
      'sentiment': sentiment,
      'is_diary': isDiary,
      if (daytime != null) 'daytime': daytime.toString(),
    };
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/create'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );
    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> readDiary(String date) async {
    String? accessToken = await TokenService.getAccessToken();

    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/today'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': date,
      }),
    );
    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> readDiaryWeek(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/weekly'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': date,
      }),
    );
    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> readDiaryMonth(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();

    String formattedDate = DateFormat("yyyy-MM-dd").format(date);

    // print(formattedDate);

    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/read/monthly'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'date': formattedDate,
      }),
    );
    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> updateDiary({
    String? diaryContent,
    String? sentiment,
    int? isDiary,
    required String? date,
  }) async {
    String? accessToken = await TokenService.getAccessToken();

    Map<String, dynamic> body = {
      'date': date,
      if (diaryContent != null) 'diary_content': diaryContent,
      if (sentiment != null) 'sentiment': sentiment,
      if (isDiary != null) 'isDiary': isDiary,
    };

    print("요청 본문: ${jsonEncode(body)}");

    final response = await http.patch(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/update'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(body),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${utf8.decode(response.bodyBytes)}");

    // return jsonDecode(response.body);
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> pigAlert() async {
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.get(
      Uri.parse('${dotenv.get("SERVER_URL")}/diary/pig'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

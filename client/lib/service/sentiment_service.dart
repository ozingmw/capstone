import 'dart:convert';
import 'package:client/service/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SentimentService {
  static const String monthlyEndpoint = 'monthly';
  static const String halfYearEndpoint = 'halfyear';
  static const String weeklyEndpoint = 'weekly';

  SentimentService() {
    dotenv.load(fileName: '.env');
  }

  Future<Map<String, double>> countSentiments(
      String endpoint, DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    String today =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    try {
      final response = await http.post(
        Uri.parse('${dotenv.get("SERVER_URL")}/sentiment/$endpoint'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept-Charset": "utf-8",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({'date': today}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load sentiments: ${response.body}');
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      Map<String, int> sentimentCount = {
        '기쁨': 0,
        '당황': 0,
        '분노': 0,
        '불안': 0,
        '상처': 0,
        '슬픔': 0,
      };

      if (jsonResponse.containsKey('res')) {
        var sentimentCounts = jsonResponse['res']['sentiment_counts'];

        sentimentCount.forEach((key, value) {
          sentimentCount[key] = sentimentCounts[key] ?? 0;
        });
      }

      int totalCount = sentimentCount.values.reduce((a, b) => a + b);

      if (endpoint == monthlyEndpoint || endpoint == halfYearEndpoint) {
        return sentimentCount.map((key, value) {
          double percentage = totalCount > 0 ? (value / totalCount) : 0;
          return MapEntry(key, (percentage * 100).roundToDouble() / 10);
        });
      }

      return sentimentCount
          .map((key, value) => MapEntry(key, value.toDouble()));
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  Future<Map<String, double>> countSentimentsWeekly(DateTime date) async {
    String? accessToken = await TokenService.getAccessToken();
    String today =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    try {
      final response = await http.post(
        Uri.parse('${dotenv.get("SERVER_URL")}/sentiment/$weeklyEndpoint'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept-Charset": "utf-8",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({'date': today}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load sentiments: ${response.body}');
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));

      Map<String, int> sentimentCount = {
        '기쁨': 0,
        '당황': 0,
        '분노': 0,
        '불안': 0,
        '상처': 0,
        '슬픔': 0,
      };

      if (jsonResponse.containsKey('res')) {
        var sentimentCounts = jsonResponse['res']['sentiment_counts'];
        sentimentCount.forEach((key, value) {
          sentimentCount[key] = sentimentCounts[key] ?? 0;
        });
      }

      int totalCount = sentimentCount.values.reduce((a, b) => a + b);

      return sentimentCount.map((key, value) {
        double percentage = totalCount > 0 ? (value / totalCount) * 100 : 0;
        return MapEntry(key, (percentage * 10).roundToDouble() / 10);
      });
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  Future<Map<String, double>> average(DateTime date) async {
    Map<String, double> monthlyData =
        await countSentiments(monthlyEndpoint, date);
    Map<String, double> halfYearData =
        await countSentiments(halfYearEndpoint, date);

    Map<String, double> averageSentiments = {};
    double totalSum = 0.0;

    monthlyData.forEach((key, value) {
      double halfYearValue = halfYearData[key] ?? 0.0;
      double sum = value + halfYearValue;
      averageSentiments[key] = sum;
      totalSum += sum;
    });

    return averageSentiments.map((key, value) {
      double percentage = totalSum > 0 ? (value / totalSum) * 100 : 0;
      return MapEntry(key, (percentage * 10).roundToDouble() / 10);
    });
  }
}

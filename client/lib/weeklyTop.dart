// weekly_top_emotion.dart
import 'package:flutter/material.dart';
import 'package:client/service/sentiment_service.dart';

class WeeklyTopEmotion extends StatefulWidget {
  const WeeklyTopEmotion({super.key});

  @override
  _WeeklyTopEmotionState createState() => _WeeklyTopEmotionState();
}

class _WeeklyTopEmotionState extends State<WeeklyTopEmotion> {
  final SentimentService sentimentService = SentimentService();
  late Future<Map<String, double>> weeklyDataFuture;

  @override
  void initState() {
    super.initState();
    weeklyDataFuture = _loadWeeklyData(); // 주간 데이터 로드
  }

  Future<Map<String, double>> _loadWeeklyData() async {
    DateTime currentDate = DateTime.now();
    return await sentimentService.countSentimentsWeekly(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: weeklyDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("데이터를 불러오는 데 실패했습니다.");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("데이터가 없습니다.");
        } else {
          Map<String, double> weeklyData = snapshot.data!;

          // 가장 큰 값의 감정 찾기
          String topEmotion = weeklyData.keys.first;
          double maxValue = weeklyData[topEmotion]!;
          weeklyData.forEach((emotion, value) {
            if (value > maxValue) {
              topEmotion = emotion;
              maxValue = value;
            }
          });

          // 감정에 따른 색상 설정
          Color iconColor;
          switch (topEmotion) {
            case '기쁨':
              iconColor = Colors.green;
              break;
            case '당황':
              iconColor = Colors.yellow;
              break;
            case '분노':
              iconColor = Colors.red;
              break;
            case '불안':
              iconColor = Colors.orange;
              break;
            case '상처':
              iconColor = Colors.purple;
              break;
            case '슬픔':
              iconColor = Colors.blue;
              break;
            default:
              iconColor = Colors.white;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.filter_vintage, color: iconColor, size: 40),
              const SizedBox(width: 8),
              Text(
                "$topEmotion: ${maxValue.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          );
        }
      },
    );
  }
}

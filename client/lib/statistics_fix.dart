import 'package:client/service/sentiment_service_fix.dart';
import 'package:client/widgets/bottom_navi_fix.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:client/service/user_service.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final UserService _userService = UserService();
  final SentimentService _sentimentService = SentimentService();

  Map<String, dynamic>? userData;
  Map<String, dynamic>? sentimentDataWeekly;
  Map<String, dynamic>? sentimentDataMonthly;
  Map<String, dynamic>? sentimentDataHalfyear;
  bool isLoading = true;
  String? error;

  final List<Color> gradientColors = [
    const Color(0xff23b6e6), // 첫 번째 색
    const Color(0xff02d39a), // 두 번째 색
  ];

  final List<String> sentiments = [
    '기쁨',
    '당황',
    '분노',
    '불안',
    '상처',
    '슬픔',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final userFuture = _userService.readUser();
    final sentimentWeeklyFuture =
        _sentimentService.getSentiment('weekly', DateTime.now());
    final sentimentMonthlyFuture =
        _sentimentService.getSentiment('monthly', DateTime.now());
    final sentimentHalfyearFuture =
        _sentimentService.getSentiment('halfyear', DateTime.now());

    // 병렬로 데이터 로드
    final results = await Future.wait([
      userFuture,
      sentimentWeeklyFuture,
      sentimentMonthlyFuture,
      sentimentHalfyearFuture,
    ]);

    setState(() {
      userData = results[0];
      sentimentDataWeekly = results[1];
      sentimentDataMonthly = results[2];
      sentimentDataHalfyear = results[3];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('오류가 발생했습니다: $error'));
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 100,
        title: Transform(
          transform: Matrix4.translationValues(40.0, 20.0, 0.0),
          child: const Text(
            "감정통계",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 이름 표시
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Hello! ${userData?['res']['nickname']}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const DesignedTextBox(text: "๑일주일 최고감정"),
              const SizedBox(height: 10),
              SizedBox(
                height: 90,
                child: WeeklyTopEmotion(sentimentData: sentimentDataWeekly!),
              ),
              const SizedBox(height: 10),
              const DesignedTextBox(text: "๑1개월과 6개월 평균"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, // 아이템들을 왼쪽 정렬
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 8,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "1개월",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // 아이템 사이에 간격을 추가
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 8,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "6개월",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // 아이템 사이에 간격을 추가
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors, // gradientColors를 여기 사용
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "평균",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              EmotionGraphWidget(
                sentimentDataMonthly: sentimentDataMonthly,
                sentimentDataHalfyear: sentimentDataHalfyear,
                gradientColors: gradientColors,
              ),
              const SizedBox(height: 20),
              for (String sentiment in sentiments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10), // 박스들 사이 간격
                  child: SentimentBox(
                    sentiment: sentiment,
                    sentimentDataMonthly: sentimentDataMonthly,
                    sentimentDataHalfyear: sentimentDataHalfyear,
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavi(
        currentScreen: 'statistics',
      ),
    );
  }
}

class DesignedTextBox extends StatelessWidget {
  final String text;

  const DesignedTextBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // 텍스트 주위에 패딩을 추가
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 189, 255, 131).withOpacity(0.3), // 배경색
        borderRadius: BorderRadius.circular(12.0), // 모서리 둥글게
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(104, 128, 128, 128), // 그림자 색상
            spreadRadius: 2, // 그림자의 퍼짐
            blurRadius: 5, // 그림자의 흐림
            offset: Offset(0, 3), // 그림자의 위치
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
    );
  }
}

class WeeklyTopEmotion extends StatelessWidget {
  final Map<String, dynamic> sentimentData;

  WeeklyTopEmotion({
    super.key,
    required this.sentimentData,
  });

  final Map<String, Color> sentimentColors = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  (String, int, double) _calculateTopEmotion() {
    final Map<String, dynamic> counts =
        sentimentData['res']['sentiment_counts'] as Map<String, dynamic>;

    int totalCount = 0;
    String topEmotion = '';
    int maxCount = 0;

    counts.forEach((emotion, count) {
      totalCount += (count as int);
      if (count > maxCount) {
        maxCount = count;
        topEmotion = emotion;
      }
    });

    double percentage = totalCount > 0 ? (maxCount / totalCount) * 100 : 0.0;

    return (topEmotion, maxCount, percentage);
  }

  @override
  Widget build(BuildContext context) {
    final (topEmotion, count, percentage) = _calculateTopEmotion();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_vintage,
                color: sentimentColors[topEmotion],
                size: 40,
              ),
              const SizedBox(width: 8),
              Text(
                '$topEmotion: ${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 24,
                  color: sentimentColors[topEmotion]?.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmotionGraphWidget extends StatelessWidget {
  final Map<String, dynamic>? sentimentDataMonthly;
  final Map<String, dynamic>? sentimentDataHalfyear;
  final List<Color> gradientColors;

  const EmotionGraphWidget({
    super.key,
    required this.sentimentDataMonthly,
    required this.sentimentDataHalfyear,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final emotions = ['기쁨', '당황', '분노', '불안', '상처', '슬픔'];

    double calculateRatio(Map<String, dynamic> data, String emotion) {
      final emotionCount = data[emotion] ?? 0;
      final total =
          data.values.fold<int>(0, (sum, value) => sum + (value as int));
      return total > 0 ? emotionCount / total : 0.0;
    }

    final monthlyRatios = emotions
        .map((e) =>
            calculateRatio(sentimentDataMonthly!['res']['sentiment_counts'], e))
        .toList();
    final halfyearRatios = emotions
        .map((e) => calculateRatio(
            sentimentDataHalfyear!['res']['sentiment_counts'], e))
        .toList();
    final averageRatios = List.generate(emotions.length,
        (index) => (monthlyRatios[index] + halfyearRatios[index]) / 2);

    return Column(
      children: [
        const SizedBox(height: 20),
        SizedBox(
          height: 200, // 300에서 200으로 수정
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  tooltipMargin: 6,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final index = touchedSpot.x.toInt();
                      String period = '';
                      String value = '';

                      // 데이터 라인별로 다른 텍스트 표시
                      if (touchedSpot.barIndex == 0) {
                        // 월간 데이터
                        period = '1개월';
                        value =
                            '${(monthlyRatios[index] * 100).toStringAsFixed(1)}%';
                      } else if (touchedSpot.barIndex == 1) {
                        // 6개월 데이터
                        period = '6개월';
                        value =
                            '${(halfyearRatios[index] * 100).toStringAsFixed(1)}%';
                      } else {
                        // 평균 데이터는 표시하지 않음
                        return null;
                      }

                      return LineTooltipItem(
                        '$period: $value',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  // 터치 이벤트 처리
                },
              ),
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 && value < emotions.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            emotions[value.toInt()],
                            style: const TextStyle(
                              fontSize: 12, // 글씨 크기를 10에서 12로 증가
                              fontWeight: FontWeight.bold, // 글씨를 진하게 설정
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 32, // x축 레이블을 위한 공간 확보
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 0.2,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4), // 오른쪽 여백 추가
                        child: Text(
                          '${(value * 100).toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
              minX: 0,
              maxX: emotions.length - 1,
              minY: 0,
              maxY: 1,
              lineBarsData: [
                // 월간 데이터 (파란색)
                LineChartBarData(
                  spots: List.generate(
                    emotions.length,
                    (index) => FlSpot(index.toDouble(), monthlyRatios[index]),
                  ),
                  color: Colors.blue,
                  barWidth: 3, // 선 굵기 증가
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 6,
                      color: Colors.blue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                ),
                // 6개월 데이터 (빨간색)
                LineChartBarData(
                  spots: List.generate(
                    emotions.length,
                    (index) => FlSpot(index.toDouble(), halfyearRatios[index]),
                  ),
                  color: Colors.red,
                  barWidth: 3, // 선 굵기 증가
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 6,
                      color: Colors.red,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                ),
                // 평균 데이터 (초록색)
                LineChartBarData(
                  spots: List.generate(
                    emotions.length,
                    (index) => FlSpot(index.toDouble(), averageRatios[index]),
                  ),
                  color: Colors.green.withOpacity(0.5), // 투명도 추가
                  barWidth: 1, // 선 굵기 감소
                  dotData: const FlDotData(show: false), // 점 제거
                  belowBarData: BarAreaData(
                    // 아래 영역 채우기 추가
                    show: true,
                    color: Colors.green.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SentimentBox extends StatelessWidget {
  final String sentiment;
  final Map<String, dynamic>? sentimentDataMonthly;
  final Map<String, dynamic>? sentimentDataHalfyear;

  SentimentBox({
    super.key,
    required this.sentiment,
    required this.sentimentDataMonthly,
    required this.sentimentDataHalfyear,
  });

  final Map<String, Color> sentimentColors = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  double calculateRatio(Map<String, dynamic> data, String emotion) {
    final emotionCount = data[emotion] ?? 0;
    final total =
        data.values.fold<int>(0, (sum, value) => sum + (value as int));
    return total > 0 ? emotionCount / total : 0.0;
  }

  String getPercentage(double ratio) {
    return '${(ratio * 100).toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final monthlyRatio = calculateRatio(
        sentimentDataMonthly!['res']['sentiment_counts'], sentiment);
    final halfyearRatio = calculateRatio(
        sentimentDataHalfyear!['res']['sentiment_counts'], sentiment);
    final averageRatio = (monthlyRatio + halfyearRatio) / 2;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(204, 184, 180, 216),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 첫 번째 그룹: 감정 텍스트 + 아이콘
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      sentiment,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.filter_vintage,
                    color: sentimentColors[sentiment],
                    size: 40,
                  ),
                ],
              ),
            ),

            // 두 번째 그룹: 1,6개월 통계
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1개월: ${getPercentage(monthlyRatio)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "6개월: ${getPercentage(halfyearRatio)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 세 번째 그룹: 평균
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "평균",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    getPercentage(averageRatio),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

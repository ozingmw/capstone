import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:client/service/sentiment_service.dart'; // SentimentService 가져오기
import 'lineTitles.dart'; // LineTitles 가져오기

class EmotionGraphWidget extends StatefulWidget {
  const EmotionGraphWidget({super.key});

  @override
  State<EmotionGraphWidget> createState() => _EmotionGraphWidgetState();
}

class _EmotionGraphWidgetState extends State<EmotionGraphWidget> {
  final SentimentService sentimentService = SentimentService();
  List<FlSpot> monthlySpots = [];
  List<FlSpot> halfYearlySpots = [];
  List<FlSpot> averageSpots = [];

  Map<String, double> monthlyData = {};
  Map<String, double> halfYearData = {};

  @override
  void initState() {
    super.initState();
    _loadEmotionData();
  }

  Future<void> _loadEmotionData() async {
    DateTime now = DateTime.now();

// 데이터 로드
    monthlyData = await sentimentService.countSentiments(
        SentimentService.monthlyEndpoint, now);
    halfYearData = await sentimentService.countSentiments(
        SentimentService.halfYearEndpoint, now);
    print("Monthly Data: $monthlyData");
    print("Half Yearly Data: $halfYearData");

// 데이터로 FlSpot 리스트 생성
    setState(() {
      monthlySpots = _createSpots(monthlyData);
      halfYearlySpots = _createSpots(halfYearData);
      averageSpots = _calculateAverageSpots();
    });
  }

  List<FlSpot> _createSpots(Map<String, double> data) {
    final emotions = ['기쁨', '당황', '분노', '불안', '상처', '슬픔'];
    double total = data.values.fold(0, (sum, count) => sum + count);

    return emotions.asMap().entries.map((entry) {
      int index = entry.key;
      String emotion = entry.value;
      double percentage = total > 0 ? data[emotion]! / total : 0;
      return FlSpot(index.toDouble(), percentage);
    }).toList();
  }

  List<FlSpot> _calculateAverageSpots() {
// 각 x 좌표별로 monthlySpots와 halfYearlySpots의 평균을 계산
    List<FlSpot> averageSpots = [];
    for (int i = 0; i < monthlySpots.length; i++) {
      double averageY = (monthlySpots[i].y + halfYearlySpots[i].y) / 2;
      averageSpots.add(FlSpot(i.toDouble(), averageY));
    }
    return averageSpots;
  }

  int _formatPercentage(double percentage) {
// percentage를 100으로 곱해 소수점 두 자리로 확장
    double value = percentage * 100;
// 0.5를 더하여 반올림
    return (value + 0.5).toInt();
  }

  final List<Color> gradientColors = [
    const Color(0xff23b6e6).withOpacity(0.2), // 첫 번째 색
    const Color(0xff02d39a).withOpacity(0.2), // 두 번째 색
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: monthlySpots,
            isCurved: false,
            color: Colors.blue,
            barWidth: 5,
          ),
          LineChartBarData(
            spots: halfYearlySpots,
            isCurved: false,
            color: Colors.red,
            barWidth: 5,
          ),
          LineChartBarData(
            spots: averageSpots,
            isCurved: true,
            barWidth: 1, // 평균 그래프 표시
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: LineTitles.getTitlesData().bottomTitles,
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        minY: 0,
        maxY: 1,
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(
          show: true,
          horizontalInterval: 0.5,
          verticalInterval: 1,
          drawVerticalLine: true,
          drawHorizontalLine: true,
        ),
        clipData: const FlClipData.all(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              final List<LineTooltipItem> tooltipItems = [];

              for (var touchedSpot in touchedSpots) {
                final String emotion =
                    ['기쁨', '당황', '분노', '불안', '상처', '슬픔'][touchedSpot.x.toInt()];

                // Monthly 데이터만 해당하는 경우
                if (touchedSpot.barIndex == 0) {
                  double totalMonthly =
                      monthlyData.values.fold(0, (sum, count) => sum + count);
                  final double monthlyPercentage = totalMonthly > 0
                      ? (monthlyData[emotion]! / totalMonthly)
                      : 0;
                  int monthlyPercentageInt =
                      _formatPercentage(monthlyPercentage);

                  tooltipItems.add(
                    LineTooltipItem(
                      '$emotion: $monthlyPercentageInt%',
                      const TextStyle(color: Colors.blue),
                    ),
                  );
                }
                // HalfYear 데이터만 해당하는 경우
                else if (touchedSpot.barIndex == 1) {
                  double totalHalfYear =
                      halfYearData.values.fold(0, (sum, count) => sum + count);
                  final double halfYearPercentage = totalHalfYear > 0
                      ? (halfYearData[emotion]! / totalHalfYear)
                      : 0;
                  int halfYearPercentageInt =
                      _formatPercentage(halfYearPercentage);

                  tooltipItems.add(
                    LineTooltipItem(
                      '$emotion: $halfYearPercentageInt%',
                      const TextStyle(color: Colors.red),
                    ),
                  );
                }
                // average 데이터에 대해서는 빈 tooltipItem을 추가
                else if (touchedSpot.barIndex == 2) {
                  tooltipItems.add(const LineTooltipItem('', TextStyle()));
                }
              }

              // 터치된 스팟과 툴팁 아이템 개수 출력
              print('Touched Spots Count: ${touchedSpots.length}');
              print('Tooltip Items Count: ${tooltipItems.length}');
              return tooltipItems;
            },
          ),
        ),
      ),
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:client/service/user_service.dart';
import 'package:client/service/sentiment_service.dart'; // UserService 추가
import 'widgets/bottomNavi.dart';
import './gin2.dart';
import './main2.dart';
import './lineChart.dart';
import './mySentiment.dart';
import 'weeklyTop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/gin2': (context) => const gin2(),
        '/main2': (context) => const main2(
              text: '',
            ),
      },
      home: const MyEmotion(),
    );
  }
}

class MyEmotion extends StatefulWidget {
  const MyEmotion({super.key});

  @override
  State<MyEmotion> createState() => _MyEmotionState();
}

class _MyEmotionState extends State<MyEmotion> {
  String nickname = 'User'; // 닉네임 초기값 설정
  final UserService userService = UserService(); // UserService 인스턴스 생성
  final SentimentService sentimentService =
      SentimentService(); // SentimentService 인스턴스 생성
  Map<String, double> averageSentiments = {}; // 평균 감정 값 저장

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadAverageSentiments(); // initState에서 닉네임을 불러오는 함수 호출
  }

  Future<void> _loadNickname() async {
    try {
      final userData = await userService.readUser();
      final loadedNickname = userData['res']['nickname'] ?? 'User';
      setState(() {
        nickname = loadedNickname; // 서버에서 가져온 닉네임을 업데이트
      });
    } catch (error) {
      print('Error loading nickname: $error');
    }
  }

  Future<void> _loadAverageSentiments() async {
    try {
      DateTime currentDate = DateTime.now(); // 현재 날짜 사용
      averageSentiments =
          await sentimentService.average(currentDate); // 평균 값 가져오기
      setState(() {}); // 상태 업데이트
    } catch (error) {
      print('Error loading average sentiments: $error');
    }
  }

  final List<Color> gradientColors = [
    const Color(0xff23b6e6), // 첫 번째 색
    const Color(0xff02d39a), // 두 번째 색
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // MediaQuery로 화면 크기 가져오기

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          transform: Matrix4.translationValues(50.0, 10.0, 0.0),
          child: const Text(
            "감정통계",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02), // 'SizedBox'로 오타 수정
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Hello, $nickname", // 닉네임을 표시
                        style: const TextStyle(
                          color: Colors.black, // White -> Black 수정 (더 잘 보이도록)
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // 텍스트 주위에 패딩을 추가
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 189, 255, 131)
                      .withOpacity(0.3), // 배경색
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
                child: const Text(
                  "๑일주일 최고감정",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 90,
                child: WeeklyTopEmotion(),
              ),

              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0), // 텍스트 주위에 패딩을 추가
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 189, 255, 131)
                      .withOpacity(0.3), // 배경색
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
                child: const Text(
                  "๑1개월과 6개월 평균",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),

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

              const SizedBox(
                height: 200,
                width: double.infinity,
                child: EmotionGraphWidget(),
              ),

              const SizedBox(height: 20),
              mySentiment(
                sentiment: "기쁨",
                amount: averageSentiments['기쁨'] ?? 0.0,
                icon: Icons.filter_vintage,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 10),
              mySentiment(
                sentiment: "당황",
                amount: averageSentiments['당황'] ?? 0.0,
                icon: Icons.filter_vintage,
                iconColor: Colors.yellow,
              ),
              const SizedBox(height: 10),
              mySentiment(
                  sentiment: "분노",
                  amount: averageSentiments['분노'] ?? 0.0,
                  icon: Icons.filter_vintage,
                  iconColor: Colors.red),
              const SizedBox(height: 10),
              mySentiment(
                sentiment: "불안",
                amount: averageSentiments['불안'] ?? 0.0,
                icon: Icons.filter_vintage,
                iconColor: Colors.orange,
              ),
              const SizedBox(height: 10),
              mySentiment(
                sentiment: "상처",
                amount: averageSentiments['상처'] ?? 0.0,
                icon: Icons.filter_vintage,
                iconColor: Colors.purple,
              ),
              const SizedBox(height: 10),
              mySentiment(
                sentiment: "슬픔",
                amount: averageSentiments['슬픔'] ?? 0.0,
                icon: Icons.filter_vintage,
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

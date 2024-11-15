import 'package:dayclover/extension/string_extension.dart';
import 'package:dayclover/recommend_quote.dart';
import 'package:dayclover/service/diary_service.dart';
import 'package:flutter/material.dart';

class DiaryAnalyze extends StatefulWidget {
  final String diaryContent;
  final DateTime selectedDay;
  final String currentQuestion;

  const DiaryAnalyze(
      {super.key,
      required this.diaryContent,
      required this.selectedDay,
      required this.currentQuestion});

  @override
  State<DiaryAnalyze> createState() => _DiaryAnalyzeState();
}

class _DiaryAnalyzeState extends State<DiaryAnalyze>
    with SingleTickerProviderStateMixin {
  DiaryService diaryService = DiaryService();
  String? emotion;
  bool isLoading = true;
  bool isSelecting = false; // 감정 선택 모드인지 확인하는 변수
  int currentIndex = 0; // 현재 선택된 감정의 인덱스
  String? originalEmotion; // 원래 감정을 저장할 변수 추가
  late AnimationController _controller;

  final List<String> emotions = ['기쁨', '당황', '분노', '불안', '상처', '슬픔'];
  final List<String> feelingComment = [
    '오늘도 행복한 하루 보내셨나요?',
    '지금은 조금 당황스러워도\n곧 괜찮아질 거에요.',
    '오늘 화나는 일이 있으시군요!',
    '우리 함께 감정을 추스려봐요.',
    '상처를 함께 치료해봐요!',
    '가끔은 슬퍼해도 괜찮아요!'
  ];
  Map<String, MaterialColor> feelingColorMap = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 애니메이션 반복 설정 (점점 빨라졌다가 느려지는 효과)
    _controller.repeat(reverse: true);

    analyzeEmotionData();
  }

  Future<void> analyzeEmotionData() async {
    setState(() {
      isLoading = true;
      emotion = null;
    });

    try {
      final result = await diaryService.analyzeEmotion(widget.diaryContent);
      setState(() {
        // result가 null이거나 result['res']['sentiment']가 'error'인 경우 처리
        if (result['res']['sentiment'] == 'error') {
          emotion = 'error';
        } else {
          emotion = result['res']['sentiment'];
        }
        isLoading = false;
      });
    } catch (e) {
      print('감정 분석 중 오류 발생: $e');
      setState(() {
        emotion = 'error';
        isLoading = false;
      });
    }
  }

  Widget buildEmotionSelector() {
    if (!isSelecting) {
      return Icon(
        Icons.filter_vintage,
        color: feelingColorMap[emotion],
        size: 150,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: () {
            setState(() {
              currentIndex =
                  (currentIndex - 1 + emotions.length) % emotions.length;
              emotion = emotions[currentIndex];
            });
          },
        ),
        Icon(
          Icons.filter_vintage,
          color: feelingColorMap[emotions[currentIndex]],
          size: 150,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: () {
            setState(() {
              currentIndex = (currentIndex + 1) % emotions.length;
              emotion = emotions[currentIndex];
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // 좌우 정렬을 위해 변경
                children: [
                  // 뒤로가기 버튼
                  if (isSelecting)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSelecting = false;
                          emotion = originalEmotion;
                        });
                      },
                      child: const Text('뒤로'),
                    )
                  else
                    const SizedBox(), // 빈 공간 유지
                  // 완료 버튼
                  if (!isLoading)
                    TextButton(
                      onPressed: () {
                        diaryService.createDiary(
                          diary: widget.diaryContent,
                          sentiment: emotion!,
                          isDiary: 1,
                          questionContent: widget.currentQuestion,
                          daytime: widget.selectedDay,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendQuote(
                              emotion: emotion!,
                              selectedDay: widget.selectedDay,
                            ),
                          ),
                        );
                      },
                      child: const Text('완료'),
                    ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        isSelecting
                            ? feelingComment[currentIndex].insertZwj()
                            : '당신의 감정은',
                        style: const TextStyle(fontSize: 30),
                        textAlign: TextAlign.center, // 여러 줄 텍스트의 중앙 정렬을 위해
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? RotationTransition(
                              turns: CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeInOut,
                              ),
                              child: const Icon(
                                Icons.filter_vintage,
                                color: Colors.grey,
                                size: 150,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isSelecting)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      setState(() {
                                        currentIndex = (currentIndex -
                                                1 +
                                                emotions.length) %
                                            emotions.length;
                                        emotion = emotions[currentIndex];
                                      });
                                    },
                                  ),
                                Icon(
                                  Icons.filter_vintage,
                                  // error인 경우 회색으로 표시
                                  color: emotion == 'error'
                                      ? Colors.grey
                                      : feelingColorMap[emotion],
                                  size: 150,
                                ),
                                if (isSelecting)
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios,
                                        textDirection: TextDirection.rtl),
                                    onPressed: () {
                                      setState(() {
                                        currentIndex = (currentIndex + 1) %
                                            emotions.length;
                                        emotion = emotions[currentIndex];
                                      });
                                    },
                                  ),
                              ],
                            ),
                      const SizedBox(height: 30),
                      Text(
                        isLoading
                            ? '감정 분석중...'
                            : emotion == 'error'
                                ? '감정을 분석할 수 없어요.\n감정을 선택 해 주세요.'
                                : emotion ?? '분석 실패',
                        style: const TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      if (!isLoading && !isSelecting)
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isSelecting = true;
                                  originalEmotion = emotion;
                                  currentIndex = emotions.indexOf(emotion!);
                                });
                              },
                              child: const Text('다른 감정인가요?'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

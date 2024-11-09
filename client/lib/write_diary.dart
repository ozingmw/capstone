import 'package:client/analyze_diary.dart';
import 'package:client/extension/string_extension.dart';
import 'package:client/read_diary.dart';
import 'package:client/service/diary_service_fix.dart';
import 'package:client/service/question_service.dart';
import 'package:client/widgets/OutlineCircleButton.dart';
import 'package:client/widgets/bottom_navi_fix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:intl/intl.dart';

class WriteDiary extends StatefulWidget {
  final DateTime selectedDay;

  const WriteDiary({super.key, required this.selectedDay});

  @override
  State<WriteDiary> createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary>
    with SingleTickerProviderStateMixin {
  final DiaryService diaryService = DiaryService();
  final QuestionService questionService = QuestionService(); // 추가
  final TextEditingController _controller = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation; // 추가

  late Future<bool> _checkDiaryFuture;

  String currentQuestion = ''; // 추가

  Map<String, MaterialColor> feelingColorMap = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  bool isDiary = true;
  bool _isSaved = false;

  String _originalText = ''; // 원본 텍스트를 저장할 변수 추가

  @override
  void initState() {
    super.initState();
    _checkDiaryFuture = _checkExistingDiary();
    _loadQuestion();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // 시간을 좀 더 길게 조정
      vsync: this,
    );

    // 펄스 애니메이션 추가
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // 애니메이션 반복 설정
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && _isSaved) {
        _animationController.forward();
      }
    });

    _checkExistingDiary();
  }

  Future<void> _loadQuestion() async {
    try {
      final question = await questionService.readQuestion();
      setState(() {
        currentQuestion = question['res']['question_content'];
      });
    } catch (e) {
      setState(() {
        currentQuestion = '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?';
      });
    }
  }

  Future<bool> _checkExistingDiary() async {
    try {
      final diary = await diaryService.readDiary(widget.selectedDay);
      return diary['res'] != null;
    } catch (e) {
      return false;
    }
  }

  void _handleEdit() {
    setState(() {
      _originalText = _controller.text; // 수정 전 텍스트 저장
      _isSaved = false;
      _animationController.stop();
      _animationController.reset();
    });
  }

  void _handleSave() {
    // 텍스트가 비어있는지 확인
    if (_controller.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('입력 필요'),
            content: const Text('텍스트를 입력한 후 저장 버튼을 눌러주세요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    // 수정 모드에서 텍스트가 변경되지 않았는지 확인
    if (_originalText.isNotEmpty && _originalText == _controller.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text('변경된 내용이 없습니다.'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSaved = true;
                    _animationController.reset();
                    _animationController.forward();
                  });
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    // 기존 저장 로직
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('저장 완료'),
          content: const Text('저장을 완료했습니다.\n하단 아이콘을 눌러 감정 스템프를 받아주세요!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isSaved = true;
                  _originalText = ''; // 원본 텍스트 초기화
                });
                _animationController.forward();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _handleFinalSave() {
    if (_isSaved) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryAnalyze(
            diaryContent: _controller.text,
            selectedDay: widget.selectedDay,
            currentQuestion: isDiary ? '' : currentQuestion,
          ),
        ),
      );
    } else {
      // 텍스트가 있는지 확인
      if (_controller.text.trim().isNotEmpty) {
        // 저장되지 않은 텍스트가 있다면 팝업창 표시
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('저장 필요'),
              content: const Text('텍스트를 저장하지 않고 페이지를 이동하면 내용이 사라져요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 팝업창 닫기
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 팝업창 닫기
                    _controller.clear(); // 텍스트 초기화
                    setState(() {
                      isDiary = !isDiary; // 모드 전환
                    });
                  },
                  child: const Text('이동'),
                ),
              ],
            );
          },
        );
      } else {
        // 텍스트가 없다면 바로 모드 전환
        setState(() {
          isDiary = !isDiary;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _checkDiaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            // 일기가 존재할 경우 즉시 ReadDiary 반환
            return ReadDiary(selectedDay: widget.selectedDay);
          }

          // 일기가 없는 경우 원래 페이지 표시
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: isDiary == true,
                      child: const Text(
                        '일기 작성',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isDiary == false,
                      child: const Text(
                        '문답 작성',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('dd').format(widget.selectedDay)} 일',
                                style: const TextStyle(
                                  decorationColor: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              Text(
                                DateFormat('EEEE').format(widget.selectedDay),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _isSaved ? _handleEdit : _handleSave,
                          child: Text(_isSaved ? '수정' : '저장'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5.0),
                      child: SizedBox(
                        height: 60, // 문구의 높이만큼 고정된 공간 확보
                        child: Visibility(
                          visible: isDiary == false,
                          maintainSize: true, // 크기 유지
                          maintainAnimation: true,
                          maintainState: true,
                          child: Text(
                            currentQuestion.insertZwj(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        SizedBox(
                          width: 450,
                          height: 400,
                          child: TextField(
                            controller: _controller,
                            enabled: !_isSaved,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 145, 171, 145),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16.0),
                              hintText: '오늘의 오늘의 일기를 작성해 주세요...',
                              // hintText: '여기에 텍스트를 입력하세요.',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        _isSaved
                            ? Positioned(
                                bottom: 10, // 화면 하단으로부터의 거리
                                right: 10, // 화면 우측으로부터의 거리
                                child: ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: GestureDetector(
                                    onTap: _handleFinalSave,
                                    child: CircularText(
                                      children: [
                                        TextItem(
                                          text: Text(
                                            "Day".toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          space: 35,
                                          startAngle: -90,
                                          startAngleAlignment:
                                              StartAngleAlignment.center,
                                          direction:
                                              CircularTextDirection.clockwise,
                                        ),
                                        TextItem(
                                          text: Text(
                                            "Clover".toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          space: 30,
                                          startAngle: 90,
                                          startAngleAlignment:
                                              StartAngleAlignment.center,
                                          direction: CircularTextDirection
                                              .anticlockwise,
                                        ),
                                      ],
                                      radius: 30,
                                      position: CircularTextPosition.inside,
                                      backgroundPaint: Paint()
                                        ..color = Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                              )
                            : Positioned(
                                bottom: 10, // 화면 하단으로부터의 거리
                                right: 10, // 화면 우측으로부터의 거리
                                child: OutlineCircleButton(
                                  radius: 65.0,
                                  borderSize: 2.0,
                                  borderColor: Colors.black45,
                                  foregroundColor: Colors.white,
                                  onTap: _handleFinalSave,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.swap_horiz,
                                          size: 40,
                                          color: Color.fromARGB(
                                              255, 145, 171, 145)),
                                      const SizedBox(height: 4),
                                      // 아이콘과 텍스트 사이의 간격
                                      Visibility(
                                        visible: isDiary == true,
                                        child: const Text(
                                          '문답작성',
                                          style: TextStyle(
                                            fontSize: 12, // 글자 크기 조정
                                            color: Colors.black,
                                            height: 0.3, // 줄 간격 조정
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isDiary == false,
                                        child: const Text(
                                          '일기작성',
                                          style: TextStyle(
                                            fontSize: 12, // 글자 크기 조정
                                            color: Colors.black,
                                            height: 0.3, // 줄 간격 조정
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const BottomNavi(
              currentScreen: "write",
            ),
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottomNavi.dart';
import 'widgets/OutlineCircleButton.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:client/diaryAnalysis_3.dart';
import './class/diary_data.dart';
import 'package:intl/intl.dart';
import 'package:client/service/diary_service.dart';

class diaryWrite extends StatefulWidget {
  final bool editMod;

  const diaryWrite({super.key, this.editMod = false});

  @override
  State<diaryWrite> createState() => _diaryWriteState();
}

class _diaryWriteState extends State<diaryWrite>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  var now = DateTime.now();
  bool editMod = false;
  int currentPageNum = 0;
  final DiaryService diaryService = DiaryService();

  @override
  void initState() {
    super.initState();
    // AnimationController 초기화
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // 반복 애니메이션 설정

    // 스케일 애니메이션 초기화
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    editMod = widget.editMod;

    _controller.text =
        Provider.of<DiaryData1>(context, listen: false).diaryText;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentPageNum = Provider.of<DiaryData1>(context).pagenum;
    print('페이지 넘버: $currentPageNum');
  }

  void _showEmptyTextAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('입력 필요'),
          content: const Text('텍스트를 입력한 후 저장 버튼을 눌러주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _afterWrite() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('저장 완료'),
          content: Text(
            Provider.of<DiaryData1>(context).feelingColor == null
                ? '저장을 완료했습니다.\n하단 아이콘을 눌러 감정 스템프를 받아주세요!'
                : '저장을 완료했습니다.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                // 여기서 listen: false를 명시적으로 추가합니다.
                Provider.of<DiaryData1>(context, listen: false)
                    .updateDiaryText(_controller.text);
                Provider.of<DiaryData1>(context, listen: false)
                    .updatePageNum(currentPageNum);

                try {
                  // 비동기 호출을 await로 대기
                  await diaryService.createDiary(
                    diary: Provider.of<DiaryData1>(context, listen: false)
                        .diaryText,
                    sentimentUser: "기쁨",
                    sentimentModel: "기쁨",
                  );
                  print('성공');
                } catch (e) {
                  // 예외 발생 시 실패 처리
                  print('실패: $e');
                }

                Navigator.of(context).pop();

                editMod = false;

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => diary3(text: _controller.text),
                //   ),
                // );
              },
            ),
          ],
        );
      },
    );
  }

  void _changemode() {
    if (currentPageNum == 0) {
      Provider.of<DiaryData1>(context, listen: false).updatePageNum(1);
    } else {
      Provider.of<DiaryData1>(context, listen: false).updatePageNum(0);
    }
  }

  void _showNoChangesAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('수정 없음'),
          content: const Text('텍스트를 수정하지 않았습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Provider.of<DiaryData1>(context, listen: false)
                    .updateDiaryText(_controller.text);
                Navigator.of(context).pop();
                editMod = false;
              },
            ),
          ],
        );
      },
    );
  }

  void _onSaveButtonPressed() {
    if (_controller.text.isEmpty) {
      _showEmptyTextAlert();
    } else if (_controller.text ==
        Provider.of<DiaryData1>(context, listen: false).diaryText) {
      _showNoChangesAlert();
    } else {
      _afterWrite();
      print('텍스트 저장됨: ${_controller.text}');
    }
  }

  void _oneditButtonPressed() {
    setState(() {
      editMod = true; // 수정 모드 활성화
      _controller.text = Provider.of<DiaryData1>(context, listen: false)
          .diaryText; // 기존 텍스트 불러오기
      print('editMod 값: $editMod');
    });
  }

  void _beforechange() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('저장 필요'),
            content: const Text('텍스트를 저장하지 않고 페이지를 이동하면 내용이 사라져요.'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('이동'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controller.clear();
                  _changemode();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    _animationController.dispose(); // 애니메이션 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaryData1 = Provider.of<DiaryData1>(context, listen: true);
    String formatDate = DateFormat('dd').format(now);
    String formatDay = DateFormat('EEEE').format(now);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                visible: currentPageNum == 1,
                child: const Text(
                  '문답 작성',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Visibility(
                visible: currentPageNum == 0,
                child: const Text(
                  '일기 작성', // pagenum이 0일 때 표시될 텍스트
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 키보드가 올라올 때 화면 크기 조정
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // 전체 콘텐츠를 스크롤 가능하게 만듭니다.
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
                          '$formatDate 일',
                          style: const TextStyle(
                            // decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255, 0, 0, 0),
                            // decorationThickness: 2,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Text(
                          formatDay,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(), // 남은 공간을 모두 차지하여 오른쪽으로 정렬
                  Visibility(
                    visible:
                        Provider.of<DiaryData1>(context).diaryText.isEmpty ||
                            editMod,
                    child: TextButton(
                      onPressed: _onSaveButtonPressed,
                      child: const Text('저장'),
                    ),
                  ),
                  Visibility(
                    visible:
                        Provider.of<DiaryData1>(context).diaryText.isNotEmpty &&
                            !editMod,
                    child: TextButton(
                      onPressed: _oneditButtonPressed,
                      child: const Text('수정'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: diaryData1.pagenum == 1,
                child: const Text(
                  '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                  Container(
                      width: 450,
                      height: 400,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 145, 171, 145),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: Provider.of<DiaryData1>(context)
                                .diaryText
                                .isEmpty,
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '여기에 텍스트를 입력하세요.',
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Provider.of<DiaryData1>(context)
                                .diaryText
                                .isNotEmpty,
                            child: editMod // 수정 모드인지 확인
                                ? TextField(
                                    controller:
                                        _controller, // 기존 텍스트를 수정 가능하게 표시
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    Provider.of<DiaryData1>(context)
                                        .diaryText, // 수정 모드가 아니면 기존 텍스트를 보여줌
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ],
                      )),

                  // 감정이 있는 경우
                  if (Provider.of<DiaryData1>(context).feelingColor !=
                      null) ...[
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: OutlineCircleButton(
                        radius: 65.0,
                        borderSize: 2.0,
                        borderColor: Colors.black45,
                        foregroundColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Null 체크 후 아이콘 표시
                            Icon(Icons.filter_vintage,
                                color: Provider.of<DiaryData1>(context)
                                    .feelingColor,
                                size: 40),
                            const SizedBox(height: 5),
                            Text(
                              Provider.of<DiaryData1>(context).feelingText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                height: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // 감정이 null인 경우
                  if (Provider.of<DiaryData1>(context).feelingColor ==
                      null) ...[
                    Visibility(
                      visible:
                          Provider.of<DiaryData1>(context).diaryText.isEmpty ||
                              editMod,
                      child: Positioned(
                        bottom: 10, // 화면 하단으로부터의 거리
                        right: 10, // 화면 우측으로부터의 거리
                        child: OutlineCircleButton(
                          radius: 65.0,
                          borderSize: 2.0,
                          borderColor: Colors.black45,
                          foregroundColor: Colors.white,
                          onTap: () {
                            if (_controller.text.isNotEmpty) {
                              _beforechange();
                            } else {
                              _changemode();
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.swap_horiz,
                                  size: 40,
                                  color: Color.fromARGB(255, 145, 171, 145)),
                              const SizedBox(height: 4), // 아이콘과 텍스트 사이의 간격
                              Visibility(
                                visible: currentPageNum == 0,
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
                                visible: currentPageNum == 1,
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
                      ),
                    ),
                  ],

                  // diaryText가 비어 있지 않은 경우
                  if (Provider.of<DiaryData1>(context).feelingColor == null &&
                      !editMod) ...[
                    Visibility(
                      visible:
                          Provider.of<DiaryData1>(context).diaryText.isNotEmpty,
                      child: Positioned(
                        bottom: 10, // 화면 하단으로부터의 거리
                        right: 10, // 화면 우측으로부터의 거리
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const diaryAnalysis(), // 원래는 diary4로 가야함
                                ),
                              );
                            },
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
                                  direction: CircularTextDirection.clockwise,
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
                                  direction:
                                      CircularTextDirection.anticlockwise,
                                ),
                              ],
                              radius: 30,
                              position: CircularTextPosition.inside,
                              backgroundPaint: Paint()
                                ..color = Colors.grey.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

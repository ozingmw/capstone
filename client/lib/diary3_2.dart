import 'package:flutter/material.dart';
import 'diary2.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import 'widgets/OutlineCircleButton.dart';
import 'package:client/diary3.dart';
import 'package:flutter_circular_text/circular_text.dart';
import './gin2.dart';
import './main2.dart';
import './diary1.dart';
import './diary5.dart';

class diary3_2 extends StatefulWidget {
  final String text;

  const diary3_2({super.key, required this.text});

  @override
  State<diary3_2> createState() => _Diary3_2State();
}

class _Diary3_2State extends State<diary3_2>  with SingleTickerProviderStateMixin{
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          title: const Text('감정 분석'),
          content: const Text('저장을 완료했습니다.\n하단 아이콘을 눌러 감정 스템프를 받아주세요!'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => diary3(text: _controller.text),
                  ),
                );
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
    } else {
      _afterWrite();
      print('텍스트 저장됨: ${_controller.text}');
    }
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => diary2()),
                  );
                },
              )
            ],
          );
        });
  }

  void _changeoption() {
    if (_controller.text.isNotEmpty) {
      _beforechange();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => diary2()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar 제목 설정
        title: const Text('문답 작성'),
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
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '10',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 0, 0, 0),
                        decorationThickness: 2,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const Text(
                    '화요일',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(), // 남은 공간을 모두 차지하여 오른쪽으로 정렬
                  TextButton(
                    onPressed: () { Navigator.pop(context); },
                    child: const Text('수정'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
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
                    child: Text(_controller.text),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => diary5(), // 원래는 diary4 임
                                ),
                              );
                            },
                            child: CircularText(
                              children: [
                                TextItem(
                                  text: Text(
                                    "Day".toUpperCase(),
                                    style: TextStyle(
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
                                    style: TextStyle(
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
                        );
                      },
                    ),
                  ),
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

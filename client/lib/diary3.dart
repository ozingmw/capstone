import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottomNavi.dart';
import 'package:flutter_circular_text/circular_text.dart';
import './class/diary_data.dart';
import './diaryWrite.dart';
import './diary5.dart';

class diary3 extends StatefulWidget {
  final String text;

  const diary3({super.key, required this.text});

  @override
  State<diary3> createState() => _diary3State();
}

class _diary3State extends State<diary3> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentPageNum = 0;
  String diaryText = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentPageNum = Provider.of<DiaryData1>(context).pagenum;

    setState(() {
      diaryText = Provider.of<DiaryData1>(context).diaryText;
    });
  }

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

  @override
  Widget build(BuildContext context) {

    final diaryData1 = Provider.of<DiaryData1>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                visible: diaryData1.pagenum == 1,
                child: const Text(
                  '문답 작성',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Visibility(
                visible: diaryData1.pagenum == 0,
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      print('페이지 번호_diary3: ${currentPageNum}');
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => diaryWrite(editMod: false,)),
                    );},
                    child: const Text('수정'),
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
                                  builder: (context) => const diary5(), // 원래는 diary4로 가야함
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

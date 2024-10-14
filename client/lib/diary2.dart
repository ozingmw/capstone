import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottomNavi.dart';
import 'widgets/OutlineCircleButton.dart';
import './diary1.dart';
import 'package:client/diary3.dart';
import './class/diary_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: diary1(),
    );
  }
}

class diary2 extends StatefulWidget {
  const diary2({super.key});

  @override
  State<diary2> createState() => _diary2State();
}

class _diary2State extends State<diary2> {
  final TextEditingController _controller = TextEditingController();

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
                Provider.of<DiaryData1>(context, listen: false).updateDiary8Text(_controller.text);
                Provider.of<DiaryData1>(context, listen: false).updatePageNum(0);

                Navigator.of(context).pop();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => diary3(text: _controller.text),
                //   ),
                // );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => diary3(text: _controller.text)),
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
                    MaterialPageRoute(builder: (context) => diary1()),
                  );
                },
              ),
            ],
          );
        },
    );
  }

  void _changeoption() {
    if (_controller.text.isNotEmpty) {
      _beforechange();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => diary1()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기 작성'),
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
                    onPressed: _onSaveButtonPressed,
                    child: const Text('저장'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: OutlineCircleButton(
                      radius: 65.0,
                      borderSize: 2.0,
                      borderColor: Colors.black45,
                      foregroundColor: Colors.white,
                      onTap: () => _changeoption(),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_horiz,
                              size: 40,
                              color: Color.fromARGB(255, 145, 171, 145)),
                          SizedBox(height: 4),
                          Text(
                            '문답작성',
                            style: TextStyle(
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

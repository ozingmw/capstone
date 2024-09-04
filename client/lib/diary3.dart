import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import 'widgets/OutlineCircleButton.dart';
import './gin2.dart';
import './main2.dart';
import './diary1.dart';

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
        '/gin3': (context) => const gin3(),
        '/main2': (context) => const main2(),
        '/diary1': (context) => const Diary1(),
      },
      home: const diary3(),
    );
  }
}

class diary3 extends StatefulWidget {
  const diary3({super.key});

  @override
  State<diary3> createState() => _diary2State();
}

class _diary2State extends State<diary3> {
  final TextEditingController _titleController = TextEditingController(text: "초기설정값임");
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
                      controller: _titleController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        // hintText: '여기에 텍스트를 입력하세요.',
                        // hintStyle: TextStyle(color: Colors.black54),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_horiz, size: 40, color: Color.fromARGB(255, 145, 171, 145)),
                          const SizedBox(height: 4),
                          const Text(
                            '문답작성',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              height: 0.3,
                            ),
                          ),
                        ],
                      ),
                      radius: 65.0,
                      borderSize: 2.0,
                      borderColor: Colors.black45,
                      foregroundColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Diary1(),),);
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

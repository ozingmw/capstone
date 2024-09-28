import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'diary2.dart';
import 'widgets/bottomNavi.dart';
import 'widgets/OutlineCircleButton.dart';
import './class/diary_data.dart';

class diary8 extends StatefulWidget {
  final String text;
  const diary8({super.key, required this.text});

  @override
  State<diary8> createState() => _diary8State();
}

class _diary8State extends State<diary8> {
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
    final diary8Text = Provider.of<DiaryData1>(context).diary8Text;


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
                    onPressed: () {},
                    child: const Text('수정'),
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
                    child: Text(diary8Text),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: OutlineCircleButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_vintage, color: Colors.green, size: 40),
                          const SizedBox(height: 5),
                          const Text(
                            '행복',
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

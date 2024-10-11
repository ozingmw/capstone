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
  bool _isEditing = false; // 텍스트 수정 모드인지 여부

  @override
  void initState() {
    super.initState();
    _controller.text = Provider.of<DiaryData1>(context, listen: false).diaryText; // 초기 텍스트 설정
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing; // 수정 모드 전환
    });

    if (!_isEditing) {
      // 수정 모드 종료 시 텍스트 저장
      Provider.of<DiaryData1>(context, listen: false).updateDiaryText(_controller.text);
    }
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
                  MaterialPageRoute(builder: (context) => diary2(text: '',)),
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
        MaterialPageRoute(builder: (context) => diary2(text: '',)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryData1 = Provider.of<DiaryData1>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('문답 작성', style: TextStyle(fontSize: 30)),
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
                      _controller.text = Provider.of<DiaryData1>(context, listen: false).diaryText;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => diary2(
                            text: _controller.text,
                          ),
                        ),
                      );
                    }, // 수정 모드 전환
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
                    child: _isEditing // 수정 모드일 때 TextField 표시
                        ? TextField(
                      controller: _controller,
                      maxLines: null, // 여러 줄 입력 가능
                      decoration: const InputDecoration(
                        hintText: "여기에 텍스트를 입력하세요...",
                        border: InputBorder.none,
                      ),
                    )
                        : Text(diaryData1.diaryText), // 수정 모드가 아닐 때 텍스트 표시
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

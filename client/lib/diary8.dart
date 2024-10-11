import 'package:client/diaryWrite.dart';
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
  Widget build(BuildContext context) {
    final diaryData1 = Provider.of<DiaryData1>(context);

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
                      _controller.text = Provider.of<DiaryData1>(context, listen: false).diaryText;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => diaryWrite(
                            editMod: true,
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

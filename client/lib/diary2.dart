import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import 'widgets/OutlineCircleButton.dart';
import './gin2.dart';
import './main2.dart';

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
      },
      home: const Diary1(),
    );
  }
}

class Diary1 extends StatefulWidget {
  const Diary1({super.key});

  @override
  State<Diary1> createState() => _Diary1State();
}

class _Diary1State extends State<Diary1> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(// AppBar 제목 설정
      ),
      // 키보드가 올라올 때 화면 크기 조정
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView( // 전체 콘텐츠를 스크롤 가능하게 만듭니다.
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
                    child: const Text('저장'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // const Text(
              //   '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //   ),
              // ),
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
                      maxLines: null, // 여러 줄 입력을 허용
                      decoration: const InputDecoration(
                        border: InputBorder.none, // 기본 테두리 제거
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
                    bottom: 10, // 화면 하단으로부터의 거리
                    right: 10, // 화면 우측으로부터의 거리
                    child: OutlineCircleButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_horiz, size: 40, color: Color.fromARGB(255, 145, 171, 145)),
                          const SizedBox(height: 4), // 아이콘과 텍스트 사이의 간격
                          const Text(
                            '문답작성',
                            style: TextStyle(
                              fontSize: 12, // 글자 크기 조정
                              color: Colors.black,
                              height: 0.3, // 줄 간격 조정
                            ),
                          ),
                        ],
                      ),

                      radius: 65.0, // 버튼 크기 조정
                      borderSize: 2.0, // 테두리 두께 조정
                      borderColor: Colors.black45, // 테두리 색상
                      foregroundColor: Colors.white, // 버튼 배경 색상
                      onTap: () async {
                        // 버튼 클릭 시 동작
                        print('버튼 클릭됨');
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

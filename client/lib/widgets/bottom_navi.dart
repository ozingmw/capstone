import 'package:dayclover/main_screen.dart';
import 'package:dayclover/mypage.dart';
import 'package:dayclover/statistics.dart';
import 'package:dayclover/write_diary.dart';
import 'package:flutter/material.dart';

class BottomNavi extends StatelessWidget {
  final String currentScreen; // 현재 화면을 나타내는 변수 추가

  const BottomNavi({
    super.key,
    required this.currentScreen, // 생성자에서 현재 화면 정보를 받음
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                if (currentScreen != 'main') {
                  // 현재 화면이 메인이 아닐 때만 네비게이션 수행
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                }
              },
              child: Icon(
                Icons.home,
                size: 45,
                color: currentScreen == 'main'
                    ? Colors.blue
                    : Colors.black, // 현재 화면 표시를 위한 색상 변경
              ),
            ),
            InkWell(
              onTap: () {
                if (currentScreen != 'write') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => WriteDiary(
                        selectedDay: DateTime.now(),
                      ),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.edit,
                size: 45,
                color: currentScreen == 'write' ? Colors.blue : Colors.black,
              ),
            ),
            // 나머지 아이콘들도 동일한 방식으로 수정
            InkWell(
              onTap: () {
                if (currentScreen != 'statistics') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Statistics(),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.assessment,
                size: 45,
                color:
                    currentScreen == 'statistics' ? Colors.blue : Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                if (currentScreen != 'mypage') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Mypage(),
                    ),
                  );
                }
              },
              child: Icon(
                Icons.person,
                size: 45,
                color: currentScreen == 'mypage' ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

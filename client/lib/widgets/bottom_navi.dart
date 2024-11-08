import 'package:flutter/material.dart';
import 'package:client/main1.dart';
import 'package:client/mypagelast.dart';
import 'package:client/diaryWrite_1.dart';
import 'package:client/statistics.dart';

class BottomNavi extends StatelessWidget {
  const BottomNavi({
    super.key,
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const main1()),
                );
              },
              child: const Icon(
                Icons.home,
                size: 45,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const diaryWrite(
                            editMod: false,
                          )),
                );
              },
              child: const Icon(
                Icons.edit,
                size: 45,
              ),
            ),
            // 주석 처리된 부분 제거 또는 수정
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyEmotion()),
                );
              },
              child: const Icon(
                Icons.assessment,
                size: 45,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              },
              child: const Icon(
                Icons.person,
                size: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
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
      home: const diary1(),
    );
  }
}

class diary1 extends StatefulWidget {
  const diary1({super.key});

  @override
  State<diary1> createState() => _diary1State();
}

class _diary1State extends State<diary1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                const Icon(
                  Icons.swap_horiz,
                  size: 45,
                ),
                const Spacer(), // 남은 공간을 모두 차지하여 오른쪽으로 정렬됩니다.
                TextButton(
                  onPressed: () {},
                  child: const Text('저장'),
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
            const SizedBox(height: 40),
            Container(
              width: 450,
              height: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 145, 171, 145),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import 'widgets/textbox_widget.dart';
import './gin2.dart';
import './main2.dart';
import './diary3.dart'; // diary3를 import

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
        '/diary3': (context) => const diary3(text: ''),  // text는 나중에 동적으로 넘김
      },
      home: const diary7(),
    );
  }
}

class diary7 extends StatefulWidget {
  const diary7({super.key});

  @override
  State<diary7> createState() => _diary7State();
}

class _diary7State extends State<diary7> {
  final TextEditingController _controller = TextEditingController(); // TextController 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    // 저장 버튼을 누르면 diary3으로 이동하면서 텍스트 전달
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => diary3(
                          text: _controller.text,  // 입력한 텍스트를 전달
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextboxWidget(
                      whatDidYouSay: '행복은 간단한 것들에서 비롯된다.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

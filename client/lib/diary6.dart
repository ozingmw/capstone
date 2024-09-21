import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import './gin2.dart';
import './main2.dart';
import './diary7.dart';

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
        '/diary7': (context) => const diary7(),
      },
      home: const diary6(),
    );
  }
}

class diary6 extends StatefulWidget {
  const diary6({super.key});

  @override
  State<diary6> createState() => _diary6State();
}

class _diary6State extends State<diary6> {
  List<MaterialColor> iconColor = [
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.blue
  ];
  List feeling_Comment = [
    '은서님,\n오늘도 행복한 하루 보내셨나요?',
    '은서님,\n오늘 화나는 일이 있으시군요!',
    '은서님,\n우리 함께 감정을 추스려봐요.',
    '은서님,\n오늘은 어떤 놀라운 일이\n있으셨는지 궁금해요.',
    '은서님,\n가끔은 우울해도 괜찮아요!'
  ];
  List feeling_Label = ['기쁨', '분노', '혐오', '놀람', '슬픔'];
  int currentColorIndex = 0;

  Icon feeling = Icon(Icons.filter_vintage, color: Colors.green, size: 150);

  void colorChange() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % iconColor.length;
      feeling = Icon(Icons.filter_vintage,
          color: iconColor[currentColorIndex], size: 150);
    });
  }

  void recolorChange() {
    setState(() {
      currentColorIndex = (currentColorIndex - 1) % iconColor.length;
      feeling = Icon(Icons.filter_vintage,
          color: iconColor[currentColorIndex], size: 150);
    });
  }

  final TextEditingController _controller = TextEditingController();

  void _onSaveButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('감정 저장'),
          content: const Text('오늘의 감정이 저장되었어요.\n확인을 누르면 오늘의 문구를 추천해드릴게요.'),
          actions: <Widget>[
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: const Text('괜찮아요'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();  // 현재 페이지를 종료
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => diary7()), // Diary7이 클래스일 경우 괄호 없이
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(height: 50),
                  const Spacer(),
                  TextButton(
                    onPressed: _onSaveButtonPressed,
                    child: const Text('저장'),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        feeling_Comment[currentColorIndex],
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 45),
                            onPressed: () => colorChange(),
                          ),
                          const SizedBox(width: 10),
                          feeling,
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 45),
                            onPressed: () => recolorChange(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        feeling_Label[currentColorIndex],
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

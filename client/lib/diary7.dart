import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './class/diary_data.dart';
import 'diary8.dart';
import 'widgets/textbox_widget.dart';

class diary7 extends StatefulWidget {
  const diary7({super.key});

  @override
  State<diary7> createState() => _diary7State();
}

class _diary7State extends State<diary7> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = Provider.of<DiaryData1>(context, listen: false).diaryText; // 초기 텍스트 설정
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => diary8(
                          text: _controller.text,
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

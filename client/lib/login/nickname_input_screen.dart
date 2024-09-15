import 'package:flutter/material.dart';
import 'package:client/login/additional_options_screen.dart';

class NicknameInputScreen extends StatefulWidget {
  const NicknameInputScreen({super.key});

  @override
  _NicknameInputState createState() => _NicknameInputState();
}

class _NicknameInputState extends State<NicknameInputScreen> {
  final TextEditingController _nicknameController = TextEditingController();

  void _onNextPressed() {
    final nickname = _nicknameController.text;

    if (nickname.isEmpty) {
      // 닉네임이 비어 있으면 경고 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
    } else {
      // 닉네임이 입력되었으면 gin3 페이지로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => AdditionalOptionsScreen(nickname: nickname)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '닉네임',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름을 입력하세요',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // 이전 페이지로 돌아가기
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: _onNextPressed,
                  icon: const Icon(Icons.arrow_forward_ios),
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

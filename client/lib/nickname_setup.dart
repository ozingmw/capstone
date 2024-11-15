import 'package:dayclover/additional_setup.dart';
import 'package:flutter/material.dart';

class NicknameSetup extends StatefulWidget {
  const NicknameSetup({super.key});

  @override
  NicknameInputState createState() => NicknameInputState();
}

class NicknameInputState extends State<NicknameSetup> {
  final TextEditingController _nicknameController = TextEditingController();
  final int maxLength = 20; // 최대 글자 수 설정
  int currentLength = 0; // 현재 글자 수를 저장할 변수

  @override
  void initState() {
    super.initState();
    // 텍스트 변경 리스너 추가
    _nicknameController.addListener(() {
      setState(() {
        currentLength = _nicknameController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final nickname = _nicknameController.text;

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해주세요.')),
      );
    } else if (nickname.length > maxLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임은 20자를 초과할 수 없습니다.')),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => AdditionalSetup(nickname: nickname)),
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
              maxLength: maxLength, // 최대 글자 수 제한
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '이름을 입력하세요',
                counterText: '$currentLength/$maxLength', // 실시간 글자 수 표시
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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

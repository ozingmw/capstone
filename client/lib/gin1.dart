import 'package:flutter/material.dart';
import 'package:client/main1.dart';
import 'package:client/gin2.dart';
import 'package:client/service/login_service.dart';

class gin1 extends StatelessWidget {
  gin1({super.key});

  final GoogleLoginService _googleLoginService = GoogleLoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                '데이클로버와 함께 일상을 기록해보세요!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                dynamic loginResult = await _googleLoginService.handleSignIn();
                if (loginResult is Map &&
                    loginResult.containsKey('is_nickname')) {
                  bool isNickname = loginResult['is_nickname'];
                  if (isNickname) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const main1()),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const gin2()),
                    );
                  }
                } else {
                  print('로그인 실패');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인에 실패했습니다.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 30.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                  Text('Google 아이디로 로그인'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const gin2()),
                );
              },
              icon: const Icon(Icons.account_circle),
              label: const Text('비회원 로그인'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 70.0, vertical: 30.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

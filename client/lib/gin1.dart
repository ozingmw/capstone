import 'package:client/gin3.dart';
import 'package:flutter/material.dart';
// import 'widgets/gin_widget.dart';
import './gin2.dart';
import './service/login/google_login_service.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/gin2': (context) => const gin2(),
        '/gin3': (context) => const gin3(),
      },
      home: gin1(),
    );
  }
}

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
                bool loginResult = await _googleLoginService.handleSignIn();
                if (loginResult) {
                  print('로그인 성공');
                  // 로그인 성공 시 처리
                  // 예: 메인 페이지로 이동
                  Navigator.pushReplacementNamed(context, '/gin2');
                } else {
                  print('로그인 실패');
                  // 로그인 실패 시 처리
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

            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/gin2');
            //   },
            //   icon: const Icon(Icons.account_circle),
            //   label: const Text('Google 아이디로 로그인'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 30.0, vertical: 30.0),
            //     textStyle: const TextStyle(fontSize: 18),
            //   ),
            // ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/gin2');
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

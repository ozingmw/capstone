import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '소셜 로그인 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  StartPage({super.key});

  Future<void> _handleSignIn(BuildContext context) async {
    await dotenv.load(fileName: '.env');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        String serverUrl = dotenv.get("SERVER_URL");

        // 백엔드로 ID 토큰 전송
        final response = await http.post(
          Uri.parse('$serverUrl/login/google/ios'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'token': googleAuth.idToken}),
        );

        final Map<String, dynamic> res = jsonDecode(response.body);
        String accessToken = res['access_token'];
        bool userExist = res['user_exist'];

        if (response.statusCode == 200) {
          // 로그인 성공, 메인 페이지로 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        } else {
          // 에러 처리
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인에 실패했습니다.')),
          );
        }
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시작 페이지')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Google로 로그인'),
          onPressed: () => _handleSignIn(context),
        ),
      ),
    );
  }
}

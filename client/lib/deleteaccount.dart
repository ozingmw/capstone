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
        // '/gin3': (context) => const gin3(),
        '/main2': (context) => const main2(text: '',),
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
      appBar: AppBar(
        title: const Text('Diary Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: Center(
        child: const Text('Welcome to the diary page!'),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원탈퇴'),
          content: const Text('정말로 회원탈퇴 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                // 여기서 회원탈퇴 로직을 실행합니다.
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    // 실제 회원탈퇴 로직을 처리하는 부분입니다.
    // 서버에 API 요청을 보내거나 로컬 데이터베이스에서 사용자 데이터를 삭제할 수 있습니다.

    // 예시: 사용자가 탈퇴 후에 메인 화면으로 돌아가도록 함
    Navigator.of(context).pop(); // 다이얼로그 닫기
    Navigator.of(context).pushReplacementNamed('/main2');

    // 서버 API 호출 예시:
    // ApiService.deleteUserAccount().then((success) {
    //   if (success) {
    //     // 성공적으로 탈퇴가 이루어졌을 때 처리
    //     Navigator.of(context).pushReplacementNamed('/login');
    //   } else {
    //     // 실패했을 때 처리 (예: 에러 메시지 표시)
    //   }
    // });
  }
}

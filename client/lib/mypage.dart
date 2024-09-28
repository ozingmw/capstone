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
        '/main2': (context) => const main2(),
      },
      home: const mypage(),
    );
  }
}

class mypage extends StatefulWidget {
  const mypage({super.key});

  @override
  State<mypage> createState() => _mypageState();
}

class _mypageState extends State<mypage> {
  String userName = '홍길동'; // 기본 사용자 이름
  TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = userName; // 닉네임 텍스트 필드에 기본 사용자 이름 설정
  }

  void _updateNickname() {
    setState(() {
      userName = _nicknameController.text;
    });

    // 여기서 닉네임을 서버에 업데이트하는 코드를 추가할 수 있습니다.
    print('닉네임이 변경되었습니다: $userName');
  }

  void _deleteAccount() {
    // 실제 회원 탈퇴 로직을 여기에 추가합니다.
    // 예: API를 호출하여 회원 탈퇴 처리
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('회원 탈퇴'),
        content: Text('정말로 회원 탈퇴를 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 회원 탈퇴 처리 로직
              print('회원 탈퇴가 처리되었습니다.');
            },
            child: Text('확인'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 이름 표시
            Text(
              '$userName님',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // 닉네임 수정 텍스트 필드와 버튼
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임 수정',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateNickname,
              child: Text('확인'),
            ),
            SizedBox(height: 20),
            // 회원 탈퇴 버튼
            ElevatedButton(
              onPressed: _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 버튼 색상 변경
              ),
              child: Text('회원 탈퇴'),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const bottomNavi(), // 여기에 적절한 Bottom Navigation Widget을 추가하세요
    );
  }
}

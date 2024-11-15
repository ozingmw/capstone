import 'package:dayclover/main_screen.dart';
import 'package:dayclover/nickname_setup.dart';
import 'package:flutter/material.dart';
import 'package:dayclover/service/login_service.dart';
import 'package:dayclover/service/user_service.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final GoogleLoginService _googleLoginService = GoogleLoginService();
  final GuestLoginService _guestLoginService = GuestLoginService();
  final UserService _userService = UserService();

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
                    if (loginResult['user_data']['disabled'] == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('경고'),
                            content: const Text(
                                '계정이 비활성화되었습니다.\n복구를 누르시면 계정이 복구됩니다.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('취소'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('확인'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  if (await _userService.enableUser()) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('알림'),
                                          content: const Text(
                                              '계정이 복구되었습니다. 다시 로그인해 주세요.'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('오류'),
                                          content: const Text(
                                              '계정 복구에 실패했습니다. 다시 시도해 주세요.'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('확인'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NicknameSetup()),
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
              onPressed: () async {
                dynamic loginResult = await _guestLoginService.handleSignIn();
                if (loginResult is Map &&
                    loginResult.containsKey('is_nickname')) {
                  bool isNickname = loginResult['is_nickname'];
                  if (isNickname) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NicknameSetup()),
                    );
                  }
                } else {
                  print('로그인 실패');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인에 실패했습니다.')),
                  );
                }
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

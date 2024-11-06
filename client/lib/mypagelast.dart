import 'package:client/loading.dart';
import 'package:client/main.dart';
import 'package:client/service/user_service.dart';
import 'package:client/service/token_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './gin2.dart';
import './main2.dart';
import 'widgets/bottomNavi.dart';

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
        '/main2': (context) => const main2(),
      },
      home: const Mypage(),
    );
  }
}

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  int charCount = 0;
  bool isEditing = false;

  String? nickname;
  final TextEditingController _nicknameController =
      TextEditingController(); // 초기화 시 nickname을 설정

  final UserService userService = UserService();

  bool isDeleting = false;

  bool isMember(String? email) {
    return email != null && email.contains('@gmail.com');
  }

  Future<void> _handleDelete() async {
    setState(() {
      isDeleting = true;
    });

    final result = await userService.deleteUser();

    setState(() {
      isDeleting = false;
    });

    if (result) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AuthWrapper()));
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const AuthWrapper()),
      //     (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('탈퇴 실패')),
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      await TokenService.clearToken(); // TokenService의 logout 메서드 호출
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      print('로그아웃 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃 실패')),
      );
    }
  }

  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      final userData = await userService.readUser();
      if (userData['res'] == null) {
        return {
          'res': {
            'gender': '',
            'email': '',
            'nickname': '',
          }
        }; // userData나 res가 null일 경우 빈 맵 반환
      }
      final nickname = userData['res']['nickname'] ?? 'Unk';
      _nicknameController.text = nickname;
      return userData;
    } catch (error) {
      print('Error fetching user data: $error');
      return {'error': 'Failed to fetch user data'};
    }
  }

  Future<void> _saveNickname() async {
    try {
      bool success = await userService.updateNickname(_nicknameController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('닉네임이 변경되었습니다')),
        );
        await _loadUserData(); // 업데이트된 데이터를 다시 불러옴
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('닉네임 변경에 실패했습니다')),
        );
      }
    } catch (error) {
      print('닉네임 저장 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $error')),
      );
    }
  }

  void _showDeleteWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: Text(
              '${_nicknameController.text}님의 데이터가 전부 사라집니다. 그래도 탈퇴 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                _handleDelete(); // 탈퇴 기능 실행
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: Text('로그아웃시 ${_nicknameController.text}님의 데이터가 사라집니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                _handleDelete(); // 로그아웃 시 탈퇴 기능 실행
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          transform: Matrix4.translationValues(50.0, 10.0, 0.0),
          child: const Text(
            "마이페이지",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            final email = userData['res']['email'] ?? 'Unknown'; // 이메일 불러오기
            bool member = isMember(email); // 회원여부 확인
            // final birthdate = userData['res']['birthdate'] ?? 'Unknown';
            // final gender = userData['res']['gender'] ?? 'Unknown';
            // final email = userData['res']['email'] ?? 'Unknown';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 1.0,
                      width: 700.0,
                      color: Colors.black,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(-25.0, 20.0),
                          child: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image.asset('assets/images/User.png'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30.0),
                            const SizedBox(height: 5.0),
                            const SizedBox(height: 5.0),
                            Text(
                              '성별: ${userData['res']['gender']}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 80.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(-25.0, -150.0),
                          child: SizedBox(
                            width: 100.0,
                            height: 300.0,
                            child: Image.asset('assets/images/Message.png'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: const Offset(0.0, -90.0),
                                child: Text(
                                  '이메일: ${userData['res']['email']}',
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 0.0),
                              TextField(
                                maxLength: 15,
                                decoration: const InputDecoration(
                                    hintText: '닉네임을 입력하세용!!'),
                                controller: _nicknameController,
                                enabled: isEditing,
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () =>
                                              setState(() => isEditing = true),
                                          child: const Text('수정'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isEditing = false;
                                              _saveNickname();
                                            });
                                          },
                                          child: const Text('저장'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor:
                                                  const Color.fromARGB(
                                                      255, 28, 160, 2)),
                                          onPressed: isDeleting
                                              ? null
                                              : () async {
                                                  if (member) {
                                                    // 회원일 경우 로그아웃
                                                    await _handleLogout();
                                                  } else {
                                                    // 비회원일 경우 회원탈퇴 기능 실행
                                                    _showLogoutWarningDialog();
                                                  }
                                                },
                                          child: const Text('로그아웃'),
                                        ),
                                        if (member)
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.black),
                                            onPressed: isDeleting
                                                ? null
                                                : _showDeleteWarningDialog,
                                            child: const Text('회원탈퇴'),
                                          ),
                                      ],
                                    ),

                                    // TextButton(
                                    //   style: TextButton.styleFrom(
                                    //     foregroundColor: Colors.red, // 텍스트 색상
                                    //   ),
                                    //   onPressed:
                                    //       isDeleting ? null : _handleDelete,
                                    //   child: Text(
                                    //     isDeleting ? '회원탈퇴' : '회원탈퇴',
                                    //     style: const TextStyle(
                                    //         color: Colors
                                    //             .red), // 텍스트 스타일에서 색상도 동일하게 설정
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-25.0, -240.0),
                          child: SizedBox(
                            width: 100.0,
                            height: 140.0,
                            child: Image.asset('assets/images/User_alt.png'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

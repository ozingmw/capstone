import 'package:client/extension/string_extension.dart';
import 'package:client/main.dart';
import 'package:client/service/user_service.dart';
import 'package:client/service/token_service.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_navi.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MypageState();
}

class _MypageState extends State<MyPage> {
  int charCount = 0;
  bool isEditing = false;

  String? nickname;
  final TextEditingController _nicknameController = TextEditingController();

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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('탈퇴 실패')),
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      await TokenService.clearToken();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
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
        };
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
        await _loadUserData();
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
              '${_nicknameController.text}님의 데이터가 전부 사라집니다. 그래도 탈퇴 하시겠습니까?\n14일 이전에 재로그인시 복구가 가능합니다.'
                  .insertZwj()),
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
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업닫기
                _handleDelete(); // 로그아웃 시 탈퇴기능 실행
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
                            Text(
                              '성별: ${userData['res']['gender']}',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(-25.0, 20.0),
                          child: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Image.asset('assets/images/Message.png'),
                          ),
                        ),
                        const SizedBox(width: 10.0), // 아이콘과 텍스트 사이 간격
                        Expanded(
                          // 텍스트가 남은 공간을 차지하도록 Expanded를 사용
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30.0),
                              Text(
                                '이메일: ${userData['res']['email']}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                softWrap: true, // 텍스트가 길어지면 자동으로 줄 바꿈
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 아이콘과 텍스트 필드가 가로로 정렬된 부분
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40.0, // 아이콘 크기
                              height: 40.0,
                              child: Image.asset('assets/images/User_alt.png'),
                            ),
                            const SizedBox(width: 10.0), // 아이콘과 텍스트 필드 사이의 간격
                            Expanded(
                              // Expanded를 사용해서 텍스트 필드가 남은 공간을 차지하도록
                              child: TextField(
                                maxLength: 15,
                                decoration: const InputDecoration(
                                  hintText: '닉네임을 입력하세요!',
                                ),
                                controller: _nicknameController,
                                enabled: isEditing,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10.0), // 텍스트 필드와 버튼 사이의 간격

                        // 버튼들을 오른쪽 끝에 가로로 정렬
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40.0), // 왼쪽 여백 설정 (원하는 경우)
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // 버튼들을 오른쪽 끝에 정렬
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    setState(() => isEditing = true),
                                child: const Text('수정'),
                              ),
                              const SizedBox(width: 10.0), // 버튼 사이 간격
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
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end, // 버튼들을 우측 정렬
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 28, 160, 2),
                                  ),
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
                                const SizedBox(height: 10), // 버튼 사이 간격
                                if (member)
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: isDeleting
                                        ? null
                                        : _showDeleteWarningDialog,
                                    child: const Text('회원탈퇴'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No user data found'));
          }
        },
      ),
      bottomNavigationBar: const BottomNavi(),
    );
  }
}

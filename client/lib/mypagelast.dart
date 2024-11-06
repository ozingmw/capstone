import 'package:client/service/user_service.dart';
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
        '/main2': (context) => const main2(text: '',),
      },
      home: const DiaryPage(),
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  int charCount = 0;
  bool isEditing = false;
  String? nickname;
  final TextEditingController _nicknameController =
      TextEditingController(); // 초기화 시 nickname을 설정

  final UserService userService = UserService();

  Future<Map<String, dynamic>> _loadUserData() async {
    try {
      final userData = await userService.readUser();
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
        print('닉네임 변경 완료');
        await _loadUserData();
      } else {
        print('닉네임 변경 실패');
      }
    } catch (error) {
      print('닉네임 저장 실패: $error');
    }
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
            final birthdate = userData['res']['birthdate'] ?? 'Unknown';
            final gender = userData['res']['gender'] ?? 'Unknown';
            final email = userData['res']['email'] ?? 'Unknown';

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
                            Text(
                              '생년월일: $birthdate',
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '성별: $gender',
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
                                  '이메일: $email',
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
                                child: Row(
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

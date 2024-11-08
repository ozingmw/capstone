import 'package:client/announcement.dart';
import 'package:client/help.dart';
import 'package:client/main_fix.dart';
import 'package:client/service/token_service.dart';
import 'package:client/service/user_service_fix.dart';
import 'package:client/widgets/bottom_navi_fix.dart';
import 'package:flutter/material.dart';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  final UserService _userService = UserService();
  final TextEditingController _nicknameController =
      TextEditingController(); // 추가

  Map<String, dynamic>? userData;
  bool isLoading = false;
  bool isEditingNickname = false; // 추가: 닉네임 수정 모드 상태
  bool isNicknameLoading = false;
  bool isEditingGenderAge = false;
  bool isGenderAgeLoading = false;
  String selectedGender = 'M'; // 기본값 M으로 설정
  int selectedAge = 20; // 기본값 20으로 설정

  @override
  void initState() {
    super.initState();
    _loadUserData(); // initState에서 유저 데이터 로드 함수 호출
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true; // 로딩 시작
      });

      // UserService에서 유저 데이터를 가져옴
      final data = await _userService.readUser();

      setState(() {
        userData = data;
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 에러 발생시에도 로딩 상태 해제
      });
      // 에러 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사용자 정보를 불러오는데 실패했습니다.'),
        ),
      );
    }
  }

  // 닉네임 업데이트 함수 추가
  Future<void> _updateNickname() async {
    try {
      setState(() {
        isNicknameLoading = true; // 전체 화면이 아닌 닉네임 부분만 로딩 상태로
      });

      await _userService.updateNickname(_nicknameController.text);

      // 업데이트된 유저 정보 다시 로드
      final data = await _userService.readUser();

      setState(() {
        userData = data;
        isEditingNickname = false;
        isNicknameLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임이 성공적으로 변경되었습니다.')),
      );
    } catch (e) {
      setState(() {
        isNicknameLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임 변경에 실패했습니다.')),
      );
    }
  }

  Future<void> _updateGenderAge() async {
    try {
      setState(() {
        isGenderAgeLoading = true;
      });

      await _userService.updateGender(selectedGender == 'M' ? true : false);
      await _userService.updateAge("$selectedAge대");

      // 업데이트된 유저 정보 다시 로드
      final data = await _userService.readUser();

      setState(() {
        userData = data;
        isEditingGenderAge = false;
        isGenderAgeLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('성별과 나이가 성공적으로 변경되었습니다.')),
      );
    } catch (e) {
      setState(() {
        isGenderAgeLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('성별과 나이 변경에 실패했습니다.')),
      );
    }
  }

  Future<void> _handleDeleteAccount() async {
    try {
      await _userService.deleteUser();
      await TokenService.deleteTokens();

      // 컨텍스트가 마운트되어 있는지 확인
      if (!mounted) return;

      // 메인 화면으로 이동하고 이전 스택 모두 제거
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // 에러 처리
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원 탈퇴 처리 중 오류가 발생했습니다.')),
      );
    }
  }

  Future<void> _handleLogout() async {
    try {
      final bool isGuestUser =
          !userData!['res']['email'].toString().contains('gmail.com');

      if (isGuestUser) {
        await _userService.deleteUser();
      }

      await TokenService.deleteTokens();

      if (!mounted) return;

      // 메인 화면으로 이동하고 이전 스택 모두 제거
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃 처리 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  Widget _buildNicknameSection() {
    return Expanded(
      child: isNicknameLoading
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : isEditingNickname
              ? TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  userData!['res']['nickname'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        toolbarHeight: 100,
        title: Transform(
          transform: Matrix4.translationValues(40.0, 20.0, 0.0),
          child: const Text(
            "마이페이지",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 40.0, top: 20.0),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/User_alt.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 15),
                  _buildNicknameSection(), // 수정된 부분
                  IconButton(
                    icon: Icon(
                      isEditingNickname ? Icons.check : Icons.edit,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      if (isEditingNickname) {
                        // 체크 버튼을 눌렀을 때
                        _updateNickname();
                      } else {
                        // 수정 버튼을 눌렀을 때
                        setState(() {
                          isEditingNickname = true;
                          _nicknameController.text =
                              userData!['res']['nickname'];
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // 세로 방향 중앙 정렬
                children: [
                  Image.asset(
                    'assets/images/Message.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    // Text 위젯을 Expanded로 감싸서 남은 공간을 모두 사용하도록 함
                    child: Text(
                      userData!['res']['email'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      softWrap: true, // 자동 줄바꿈 활성화
                      overflow: TextOverflow.visible, // 텍스트가 넘칠 경우 표시 방식
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/User.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 15),
                  if (isGenderAgeLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (isEditingGenderAge)
                    Expanded(
                      child: Row(
                        children: [
                          // 성별 선택 드롭다운
                          DropdownButton<String>(
                            value: selectedGender,
                            items: ['M', 'F'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value == 'M' ? '남성' : '여성'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          // 나이 선택
                          Expanded(
                            child: DropdownButton<int>(
                              value: selectedAge,
                              items: List.generate(83, (index) => index + 18)
                                  .map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value세'),
                                );
                              }).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedAge = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '성별: ${userData!['res']['gender'] == null || userData!['res']['gender'] == '' ? '미설정' : userData!['res']['gender'] == 'M' ? '남성' : '여성'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '나이: ${userData!['res']['age'] == null || userData!['res']['age'] == '' ? '미설정' : '${userData!['res']['age']}세'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      isEditingGenderAge ? Icons.check : Icons.edit,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      if (isEditingGenderAge) {
                        _updateGenderAge();
                      } else {
                        setState(() {
                          isEditingGenderAge = true;
                          // 수정 모드로 들어갈 때 기본값 설정
                          selectedGender = userData!['res']['gender'] ?? 'M';
                          selectedAge = userData!['res']['age'] ?? 20;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // 배경을 투명하게 설정
                      barrierColor: Colors.transparent, // 배리어를 투명하게 설정
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0), // 오른쪽에서
                            end: Offset.zero, // 왼쪽으로
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: const Announcement(),
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(
                      double.infinity, 60), // 버튼의 너비를 화면 크기에 맞추고, 높이는 60으로 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
                    side: const BorderSide(
                        color: Colors.black, width: 1), // 테두리 추가
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                  children: [
                    Text(
                      '공지사항',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 20), // 오른쪽 화살표 아이콘
                  ],
                ),
              ),
            ),
            // 도움말 버튼
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.transparent,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: const Help(),
                        );
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '도움말',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 20),
                  ],
                ),
              ),
            ),

            // 간격 추가
            const SizedBox(height: 30),

            // 로그아웃과 회원탈퇴 버튼을 위한 Row
            // 로그아웃과 회원탈퇴 버튼을 위한 Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                children: [
                  // 로그아웃 버튼 (모든 사용자에게 표시)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final bool isGoogleUser = userData!['res']['email']
                            .toString()
                            .contains('gmail.com');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('로그아웃'),
                              content: Text(
                                isGoogleUser
                                    ? '로그아웃 하시겠습니까?'
                                    : '로그아웃 하시겠습니까?\n게스트 계정은 로그아웃시 데이터가 사라집니다.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                  },
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 다이얼로그 닫기
                                    _handleLogout(); // 로그아웃 처리
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.red, // 확인 버튼 색상을 빨간색으로
                                  ),
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red, width: 1),
                        ),
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // 구글 로그인 사용자인 경우에만 회원탈퇴 버튼 표시
                  if (userData!['res']['email']
                      .toString()
                      .contains('gmail.com')) ...[
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('회원 탈퇴'),
                                content: const Text(
                                    '정말로 탈퇴하시겠습니까?\n탈퇴 후에는 복구가 불가능합니다.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      _handleDeleteAccount(); // 회원 탈퇴 처리
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          Colors.red, // 확인 버튼 색상을 빨간색으로
                                    ),
                                    child: const Text('확인'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                        child: const Text(
                          '회원탈퇴',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavi(
        currentScreen: "mypage",
      ),
    );
  }
}

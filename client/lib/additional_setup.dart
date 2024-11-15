import 'package:dayclover/extension/string_extension.dart';
import 'package:dayclover/main_screen.dart';
import 'package:dayclover/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:dayclover/widgets/dropdown_widget.dart';

class AdditionalSetup extends StatefulWidget {
  final String nickname;

  const AdditionalSetup({super.key, required this.nickname});

  @override
  AdditionalOptionsScreenState createState() => AdditionalOptionsScreenState();
}

class AdditionalOptionsScreenState extends State<AdditionalSetup> {
  bool isMaleChecked = false;
  bool isFemaleChecked = false;
  String? selectedDropdownValue;

  void _onMaleChanged(bool? value) {
    setState(() {
      if (value == true) {
        isMaleChecked = true;
        isFemaleChecked = false;
      } else {
        isMaleChecked = false;
      }
    });
  }

  void _onFemaleChanged(bool? value) {
    setState(() {
      if (value == true) {
        isFemaleChecked = true;
        isMaleChecked = false;
      } else {
        isFemaleChecked = false;
      }
    });
  }

  Future<void> _showSkipDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(
            '성별 및 나이와 같은 개인정보 이용 동의시 더욱 디테일한 서비스를 이용할 수 있습니다.\n\n스킵하시겠습니까?'
                .insertZwj(),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
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
                Navigator.of(context).pop(); // 다이얼로그 닫기
                UserService userService = UserService();
                bool success =
                    await userService.updateNickname(widget.nickname);
                if (success) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update nickname')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SKIP 버튼 (1)
              Flexible(
                flex: 1,
                child: Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: _showSkipDialog,
                      child: const Text('SKIP'),
                    ),
                  ],
                ),
              ),

              // 여백
              Flexible(
                flex: 1,
                child: Container(),
              ),

              // 성별 섹션 (3)
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 성별 선택 박스를 SizedBox로 감싸서 크기 고정
                    Center(
                      child: SizedBox(
                        height: 60, // 고정된 높이
                        width: 300, // 고정된 너비
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: isMaleChecked,
                                onChanged: _onMaleChanged,
                                semanticLabel: '남자',
                              ),
                              const Text('남자'),
                              const SizedBox(width: 50),
                              Checkbox(
                                value: isFemaleChecked,
                                onChanged: _onFemaleChanged,
                                semanticLabel: '여자',
                              ),
                              const Text('여자'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 나이 섹션 (3)
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '나이',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 나이 선택 박스를 SizedBox로 감싸서 크기 고정
                    Center(
                      child: SizedBox(
                        height: 60, // 고정된 높이
                        width: 300, // 고정된 너비
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MyDropdown(
                            onChanged: (value) {
                              setState(() {
                                selectedDropdownValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 안내 문구 (2)
              const Flexible(
                flex: 2,
                child: Center(
                  child: Text(
                    "성별 및 나이와 같은 개인정보 이용 동의시 더욱 디테일한 서비스를 이용할 수 있습니다.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // 네비게이션 버튼 (2)
              Flexible(
                flex: 2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 40,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        // 성별과 나이가 모두 선택되지 않았을 때
                        if ((!isMaleChecked && !isFemaleChecked) ||
                            selectedDropdownValue == null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('알림'),
                                content: const Text('성별과 나이를 모두 입력해주세요.'),
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
                          return; // 더 이상 진행하지 않고 함수 종료
                        }

                        // 모든 정보가 입력되었을 때 실행되는 기존 코드
                        UserService userService = UserService();
                        bool successNickname =
                            await userService.updateNickname(widget.nickname);
                        bool successAge =
                            await userService.updateAge(selectedDropdownValue!);
                        bool successGender =
                            await userService.updateGender(isMaleChecked);

                        if (successGender && successAge && successNickname) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update user info')),
                          );
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:client/extension/string_extension.dart';
import 'package:client/main_screen.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/dropdown_widget.dart';

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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
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
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: _showSkipDialog, // 스킵 버튼 클릭 시 다이얼로그 표시
                  child: const Text('SKIP'),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              '성별',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
            const SizedBox(height: 20),
            const Text(
              '나이',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
            const SizedBox(height: 80),
            const Center(
              child: Text(
                "성별 및 나이와 같은 개인정보 이용 동의시 더욱 디테일한 서비스를 이용할 수 있습니다.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      UserService userService = UserService();
                      bool successNickname =
                          await userService.updateNickname(widget.nickname);
                      bool successAge =
                          await userService.updateAge(selectedDropdownValue!);
                      bool successGender =
                          await userService.updateGender(isMaleChecked);

                      if (successGender && successAge && successNickname) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
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
    );
  }
}

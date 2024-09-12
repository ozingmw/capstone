import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/dropdown_widget.dart';
import 'package:client/main1.dart';

class AdditionalOptionsScreen extends StatefulWidget {
  final String nickname;

  const AdditionalOptionsScreen({super.key, required this.nickname});

  @override
  _AdditionalOptionsScreenState createState() =>
      _AdditionalOptionsScreenState();
}

class _AdditionalOptionsScreenState extends State<AdditionalOptionsScreen> {
  bool isMaleChecked = false;
  bool isFemaleChecked = false;

  void _onMaleChanged(bool? value) {
    setState(() {
      if (value == true) {
        isMaleChecked = true;
        isFemaleChecked = false; // Female 체크박스 해제
      } else {
        isMaleChecked = false;
      }
    });
  }

  void _onFemaleChanged(bool? value) {
    setState(() {
      if (value == true) {
        isFemaleChecked = true;
        isMaleChecked = false; // Male 체크박스 해제
      } else {
        isFemaleChecked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Row(
              children: [
                const Spacer(), // Spacer로 TextButton을 오른쪽으로 밀기
                TextButton(
                  onPressed: () {},
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
              child: const Center(child: MyDropdown()),
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
                      Navigator.pop(context); // 이전 페이지로 돌아가기
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    iconSize: 40,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      UpdateUser updateUser = UpdateUser();
                      bool success =
                          await updateUser.updateNickname(widget.nickname);
                      if (success) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const main1()),
                        );
                      } else {
                        // 실패 시 사용자에게 알림 처리 (예: 에러 메시지 표시)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to update nickname')),
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

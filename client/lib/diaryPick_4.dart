import 'package:client/diaryAnalysis_3.dart';
import 'package:client/diaryText_5.dart';
import 'package:client/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './diaryDone_6.dart';
import 'class/diary_data.dart';

class diaryPick extends StatefulWidget {
  const diaryPick({super.key});

  @override
  State<diaryPick> createState() => _diaryPickState();
}

class _diaryPickState extends State<diaryPick> {
  final UserService userService = UserService();

  Future<String> _fetchUserData() async {
    try {
      final userData = await userService.readUser();
      return userData['res']['nickname'] ?? 'Unknown'; // 닉네임이 없을 경우 'Unknown' 반환
    } catch (error) {
      print('Error fetching user data: $error');
      return 'Error loading nickname'; // 오류 발생 시 메시지 반환
    }
  }

  List<MaterialColor> iconColor = [
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.blue
  ];
  List feeling_Comment = [
    '\n오늘도 행복한 하루 보내셨나요?',
    '\n오늘 화나는 일이 있으시군요!',
    '\n우리 함께 감정을 추스려봐요.',
    '\n오늘은 어떤 놀라운 일이\n있으셨는지 궁금해요.',
    '\n가끔은 우울해도 괜찮아요!'
  ];
  List feeling_Label = ['행복', '분노', '혐오', '놀람', '슬픔'];
  int currentColorIndex = 0;

  Icon Feeling = Icon(Icons.filter_vintage, color: Colors.green, size: 150);

  void colorChange() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % iconColor.length;
      Feeling = Icon(Icons.filter_vintage,
          color: iconColor[currentColorIndex], size: 150);
    });
  }

  void recolorChange() {
    setState(() {
      currentColorIndex = (currentColorIndex - 1) % iconColor.length;
      Feeling = Icon(Icons.filter_vintage,
          color: iconColor[currentColorIndex], size: 150);
    });
  }

  void _onSaveButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('감정 저장'),
          content: const Text(
              '오늘의 감정이 저장되었어요.\n확인을 누르면 오늘의 문구를 추천해드릴게요.'),
          actions: <Widget>[
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: const Text('괜찮아요'),
                  onPressed: () {
                    Provider.of<DiaryData1>(context, listen: false)
                        .updateFeeling(iconColor[currentColorIndex]);
                    print('감정 아이콘: ${iconColor[currentColorIndex]}');

                    Provider.of<DiaryData1>(context, listen: false)
                        .updatefeelingText(feeling_Label[currentColorIndex]);
                    print('감정 텍스트: ${feeling_Label[currentColorIndex]}');

                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => diaryDone(text: '')),
                    );
                  },
                ),
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Provider.of<DiaryData1>(context, listen: false)
                        .updateFeeling(iconColor[currentColorIndex]);
                    print('감정 아이콘: ${iconColor[currentColorIndex]}');

                    Provider.of<DiaryData1>(context, listen: false)
                        .updatefeelingText(feeling_Label[currentColorIndex]);
                    print('감정 텍스트: ${feeling_Label[currentColorIndex]}');

                    Navigator.of(context).pop(); // 현재 페이지를 종료
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const diaryText()), // Diary7이 클래스일 경우 괄호 없이
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('일기 선택'),
        ),
        body: FutureBuilder<String>(
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터가 로드 중일 때 로딩 인디케이터 표시
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // 오류 발생 시 오류 메시지 표시
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // 사용자 닉네임이 성공적으로 로드된 경우
              String nickname = snapshot.data ?? 'Unknown';

              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 100),
                        IconButton(
                          icon: const Icon(Icons.navigate_before),
                          tooltip: 'Next page',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => diaryAnalysis()),
                            );
                          },
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _onSaveButtonPressed,
                          child: const Text('저장'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              nickname.isEmpty ? '닉네임?' : nickname,
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios, size: 45),
                                  onPressed: () => colorChange(),
                                ),
                                const SizedBox(width: 10),
                                Feeling,
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios, size: 45),
                                  onPressed: () => recolorChange(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text(
                              feeling_Label[currentColorIndex],
                              style: TextStyle(fontSize: 30),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

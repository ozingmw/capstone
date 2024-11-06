import 'package:client/diaryWrite_1.dart';
import 'package:client/service/diary_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'main3.dart';
import 'widgets/bottomNavi.dart';
import 'widgets/OutlineCircleButton.dart';
import './class/diary_data.dart';

class main2 extends StatefulWidget {
  final String text;
  final DateTime? selectedDay;
  const main2({super.key, required this.text, DateTime? whatDay, this.selectedDay});

  @override
  State<main2> createState() => _main2State();
}

class _main2State extends State<main2> {
  final TextEditingController _controller = TextEditingController();
  final DiaryService diaryService = DiaryService();
  var now = DateTime.now();
  bool _isEditing = false; // 텍스트 수정 모드인지 여부

  Future<Map<String, dynamic>> _fetchUserData(String day) async {
    try {
      final diaryData = await diaryService.readDiary(day);
      print('날짜: $day');

      // 필요한 모든 정보를 맵으로 반환
      return {
        'diary_content': diaryData['res'][0]['diary_content'] ?? 'Unknown',
        'sentiment': diaryData['res'][0]['sentiment'] ?? 'Unknown',
        'isDiary' : diaryData['res'][0]['is_diary'] ?? 0,
          };
    } catch (error) {
      print('Error fetching user data: $error');
      return {
        'error': 'Error loading diary',
      }; // 오류 발생 시 메시지 반환
    }
  }


  @override
  Widget build(BuildContext context) {
    final diaryData1 = Provider.of<DiaryData1>(context);
    String formatDate = widget.selectedDay == null
        ? DateFormat('dd').format(DateTime.now())
        : DateFormat('dd').format(widget.selectedDay!);
    String formatDay = widget.selectedDay == null
        ? DateFormat('EEEE').format(DateTime.now())
        : DateFormat('EEEE').format(widget.selectedDay!);
    String formattedDate = widget.selectedDay != null
        ? DateFormat('yyyy-MM-dd').format(widget.selectedDay!)
        : '';

    Map<String, MaterialColor> feelingColorMap = {
      '기쁨': Colors.green,
      '당황': Colors.yellow,
      '분노': Colors.red,
      '불안': Colors.orange,
      '상처': Colors.purple,
      '슬픔': Colors.blue,
    };


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                visible: diaryData1.pagenum == 1,
                child: const Text(
                  '문답 작성',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Visibility(
                visible: diaryData1.pagenum == 0,
                child: const Text(
                  '일기 작성', // pagenum이 0일 때 표시될 텍스트
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(formattedDate), // 비동기 데이터 가져오기
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 로딩 인디케이터
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 에러 처리
          } else {
            final diaryEntry = snapshot.data;

            String diaryText = diaryEntry?['diary_content']; // 데이터 가져오기
            String sentiment = diaryEntry?['sentiment'] ?? '내용 없음';
            bool isDiary = diaryEntry?['isDiary'] ?? 1;

            print(isDiary);

            MaterialColor iconColor = feelingColorMap[sentiment] ?? Colors.grey; // 기본 색상 설정

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${formatDate} 일',
                                style: const TextStyle(
                                  decorationColor: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              Text(
                                formatDay,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            _controller.text = diaryText; // 수정 모드일 때 텍스트 필드에 내용 설정
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => main3(
                                  editMod: true,
                                  selectedDay: widget.selectedDay,
                                  diarytext: diaryText,
                                  sentiment: sentiment,
                                ),
                              ),
                            );
                          },
                          child: const Text('수정'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: diaryData1.pagenum == 1,
                      child: const Text(
                        '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Stack(
                      children: [
                        Container(
                          width: 450,
                          height: 400,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 145, 171, 145),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: _isEditing // 수정 모드일 때 TextField 표시
                              ? TextField(
                            controller: _controller,
                            maxLines: null, // 여러 줄 입력 가능
                            decoration: const InputDecoration(
                              hintText: "여기에 텍스트를 입력하세요...",
                              border: InputBorder.none,
                            ),
                          )
                              : Text(diaryText), // 수정 모드가 아닐 때 텍스트 표시
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: OutlineCircleButton(
                            radius: 65.0,
                            borderSize: 2.0,
                            borderColor: Colors.black45,
                            foregroundColor: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.filter_vintage,
                                    color: iconColor,
                                    size: 40),
                                const SizedBox(height: 5),
                                Text(
                                  sentiment,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    height: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

import 'package:client/extension/string_extension.dart';
import 'package:client/service/diary_service_fix.dart';
import 'package:client/widgets/OutlineCircleButton.dart';
import 'package:client/widgets/bottom_navi_fix.dart';
import 'package:client/edit_diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadDiary extends StatefulWidget {
  final DateTime selectedDay;
  const ReadDiary({super.key, required this.selectedDay});

  @override
  State<ReadDiary> createState() => _ReadDiaryState();
}

class _ReadDiaryState extends State<ReadDiary> {
  final DiaryService diaryService = DiaryService();
  final TextEditingController _controller = TextEditingController();

  bool isDiary = false;
  Map<String, dynamic>? _diaryData;
  Map<String, MaterialColor> feelingColorMap = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    _loadDiaryData(); // 위젯이 처음 생성될 때 실행
  }

  _loadDiaryData() async {
    final diaryData = await diaryService.readDiary(widget.selectedDay);

    setState(() {
      _diaryData = diaryData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: _diaryData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                                  '${DateFormat('dd').format(widget.selectedDay)} 일',
                                  style: const TextStyle(
                                    decorationColor:
                                        Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                Text(
                                  DateFormat('EEEE').format(widget.selectedDay),
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
                              _controller.text =
                                  _diaryData?['res']['diary_content'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDiary(
                                    selectedDay: widget.selectedDay,
                                  ),
                                ),
                              );
                            },
                            child: const Text('수정'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_diaryData?['res']['question_content'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5.0),
                          child: Text(
                            "${_diaryData!['res']['question_content']}"
                                .insertZwj(),
                            style: const TextStyle(
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
                              child: Text(
                                  "${_diaryData?['res']['diary_content']}"
                                      .insertZwj())),
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
                                  Icon(
                                    Icons.filter_vintage,
                                    color: feelingColorMap[_diaryData?['res']
                                        ['sentiment']],
                                    size: 40,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    _diaryData?['res']['sentiment'],
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
              ),
        bottomNavigationBar: const BottomNavi(
          currentScreen: "write",
        ),
      ),
    );
  }
}

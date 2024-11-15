import 'package:auto_size_text/auto_size_text.dart';
import 'package:dayclover/extension/string_extension.dart';
import 'package:dayclover/read_diary.dart';
import 'package:dayclover/service/diary_service.dart';
import 'package:dayclover/widgets/OutlineCircleButton.dart';
import 'package:dayclover/widgets/bottom_navi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDiary extends StatefulWidget {
  final DateTime selectedDay;

  const EditDiary({super.key, required this.selectedDay});

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  final DiaryService diaryService = DiaryService();
  final TextEditingController _controller = TextEditingController();

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
    _loadDiaryData();
  }

  _loadDiaryData() async {
    final diaryData = await diaryService.readDiary(widget.selectedDay);

    setState(() {
      _diaryData = diaryData;
      _controller.text = diaryData['res']['diary_content'] ?? ''; // 컨트롤러 초기값 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('일기 수정'),
        ),
        resizeToAvoidBottomInset: true,
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
                            onPressed: () async {
                              await diaryService.updateDiary(
                                diaryContent: _controller.text,
                                date: widget.selectedDay,
                                sentiment: _diaryData?['res']['sentiment'],
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadDiary(
                                    selectedDay: widget.selectedDay,
                                  ),
                                ),
                              );
                            },
                            child: const Text('저장'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_diaryData?['res']['question_content'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 5.0),
                          child: AutoSizeText(
                            "${_diaryData!['res']['question_content']}"
                                .insertZwj(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            minFontSize: 12, // 최소 폰트 사이즈
                            maxLines: null, // 줄 수 제한 없음
                            overflow: TextOverflow.visible, // 텍스트가 잘리지 않고 모두 표시
                          ),
                        ),
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          SizedBox(
                            width: 450,
                            height: 400,
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              expands:
                                  true, // TextField가 SizedBox 크기에 맞게 확장되도록 설정
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 145, 171, 145),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16.0),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.transparent, // 배경을 투명하게
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          bottom: 300, // 동그라미 아이콘 위에 위치하도록 조정
                                          right: 10, // 오른쪽 정렬
                                          child: Container(
                                            width: 150, // 적절한 너비로 조정
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child:
                                                ListWheelScrollView.useDelegate(
                                              itemExtent: 50,
                                              perspective: 0.005,
                                              diameterRatio: 1.2,
                                              physics:
                                                  const FixedExtentScrollPhysics(),
                                              childDelegate:
                                                  ListWheelChildLoopingListDelegate(
                                                children: feelingColorMap
                                                    .entries
                                                    .map((entry) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _diaryData?['res']
                                                                ['sentiment'] =
                                                            entry.key;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Row의 크기를 내용물에 맞게 조정
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .filter_vintage,
                                                            color: entry.value,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            entry.key,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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

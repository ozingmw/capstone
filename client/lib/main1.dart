import 'package:client/diaryDone_6.dart';
import 'package:client/service/diary_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/class/DiaryFormat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class/diary_data.dart';
import 'package:client/diaryWrite_1.dart';
import 'widgets/gin_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/bottomNavi.dart';
import './main2.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DiaryData1(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: main1(),
    );
  }
}

class main1 extends StatefulWidget {
  const main1({super.key});

  @override
  State<main1> createState() => _MainScreenState();
}

class _MainScreenState extends State<main1> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  bool _isWeekView = false;
  final DiaryService diaryService = DiaryService();
  final DiaryService readDiaryMonth = DiaryService();
  final UserService userService = UserService();
  final Map<DateTime, List<String>> _events = {};
  String selectedText = 'dd';
  List<DiaryFormat> diaryFormat = [];



  // final Map<DateTime, List<String>> _events = {
  //
  //   DateTime.utc(2024, 8, 18): ['Test Event 1'],
  //   DateTime.utc(2024, 8, 20): ['Test Event 2'],
  //
  // };


  Future<Object> _fetchUserData() async {
    List<String> daytime = [];
    List<String> content = [];
    List<String> feelingColor = [];
    Color C = Colors.green;

    _events.clear();
    diaryFormat.clear();

    try {
      final userData = await readDiaryMonth.readDiaryMonth(_focusedDay);

      for (var diary in userData['res']) {
        daytime.add(diary['daytime']);
      }

      for (var diary in userData['res']) {
        content.add(diary['diary_content']);
      }

      for (var diary in userData['res']) {
        feelingColor.add(diary['sentiment_user']);
      }

      for (int i =0;i<daytime.length;i++) {
        final parsedDate = DateTime.parse(daytime[i]);

        _events.addAll({
          parsedDate.toUtc(): [content[i]],
        });

        diaryFormat.add(DiaryFormat(
          date: parsedDate.toUtc(),
          content: content[i],
          color: feelingColor[i],
        ),
        );

      }

      print(userData);

      return diaryFormat; // 데이터가 있는 경우 daytimes 반환
    } catch (error) {
      print('Error fetching user data: $error');
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }


  // Future<String> _fetchUserData() async {
  //   try {
  //     final userData = await userService.readUser();
  //     selectedText = userData['res']['nickname'];
  //     print('닉네임: ${selectedText}');
  //     return userData['res']['nickname'] ?? 'Unknown'; // 닉네임이 없을 경우 'Unknown' 반환
  //   } catch (error) {
  //     print('Error fetching user data: $error');
  //     return 'Error loading nickname'; // 오류 발생 시 메시지 반환
  //   }
  // }

  // ValueNotifier to hold the list of events for the selected day
  final ValueNotifier<List<String>> _selectedEvents = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: FutureBuilder<Object>(
            future: _fetchUserData(), // 사용자 데이터를 불러오는 Future 함수
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // 로딩 중일 때 로딩 인디케이터 표시
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // 오류가 발생한 경우
                return Text('Error: ${snapshot.error}');
              } else {
                // 성공적으로 데이터를 불러온 경우 달력을 표시
                return Center(
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Color.fromARGB(255, 244, 229, 30),
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      const LoginWidget(loginText: 'Clover Stamp', off: 0),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 175, 76, 76), size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 175, 119, 76), size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 175, 165, 76), size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 76, 140, 175), size: 40),
                          Icon(Icons.filter_vintage, color: Colors.green, size: 40),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 223, 233, 223),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(8, 8),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(50, 20, 50, 30),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2022, 10, 16),
                          lastDay: DateTime.utc(2027, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          calendarFormat: _calendarFormat,
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              if (isSameDay(_selectedDay, selectedDay) ||
                                  isSameDay(selectedDay, DateTime.now())) {
                                _fetchUserData();
                                _isWeekView = !_isWeekView;
                                _calendarFormat = _isWeekView
                                    ? CalendarFormat.week
                                    : CalendarFormat.month;
                                _focusedDay = _isWeekView
                                    ? _getFirstDayOfWeek(selectedDay)
                                    : _focusedDay;
                                if (_isWeekView) {
                                  _selectedDay = selectedDay;
                                } else {
                                  _selectedDay = null;
                                }
                              } else {
                                _selectedDay = selectedDay;
                                _focusedDay = _getFirstDayOfWeek(selectedDay);
                                _calendarFormat = CalendarFormat.week;
                                _isWeekView = true;
                              }
                              _updateSelectedEvents(selectedDay);
                            });
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _selectedDay = null;
                              _focusedDay = focusedDay;
                              _updateSelectedEvents(_selectedDay);
                            });
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          eventLoader: (day) => _events[_normalizeDate(day)] ?? [],
                          calendarBuilders: CalendarBuilders(
                            dowBuilder: (context, day) {
                              switch (day.weekday) {
                                case 1:
                                  return const Center(
                                    child: Text(
                                      '월',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                case 2:
                                  return const Center(
                                    child: Text(
                                      '화',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                case 3:
                                  return const Center(
                                    child: Text(
                                      '수',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                case 4:
                                  return const Center(
                                    child: Text(
                                      '목',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                case 5:
                                  return const Center(
                                    child: Text(
                                      '금',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                case 6:
                                  return const Center(
                                    child: Text(
                                      '토',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  );
                                case 7:
                                  return const Center(
                                    child: Text(
                                      '일',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  );
                                default:
                                  return const Center(
                                    child: Text(
                                      '월',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                              }
                            },
                              markerBuilder: (context, date, events) {
                                if (events.isNotEmpty) {
                                  // 이 날짜에 해당하는 감정 색을 저장할 변수
                                  Color markerColor = Colors.grey;

                                  // 현재 날짜에 해당하는 diaryFormat 항목을 찾아서 해당 색을 사용
                                  for (var diary in diaryFormat) {
                                    if (diary.date.isAtSameMomentAs(date)) { // 현재 date와 diary의 date가 일치하는지 확인
                                      String d = diary.color;

                                      if (d.contains('기쁨')) {
                                        markerColor = Colors.green; // 기쁨일 경우 초록색
                                      } else if (d.contains('슬픔')) {
                                        markerColor = const Color.fromARGB(255, 76, 140, 175); // 슬픔일 경우 색상
                                      } else if (d.contains('분노')) {
                                        markerColor = const Color.fromARGB(255, 175, 76, 76); // 분노일 경우 색상
                                      } else if (d.contains('불안')) {
                                        markerColor = const Color.fromARGB(255, 175, 119, 76); // 불안일 경우 색상
                                      } else if (d.contains('상처')) {
                                        markerColor = Colors.red; // 상처일 경우 빨간색
                                      } else if (d.contains('당황')) {
                                        markerColor = const Color.fromARGB(255, 175, 165, 76); // 당황일 경우 색상
                                      }
                                      // 해당 날짜에 대한 감정 색이 정해지면 반복을 종료
                                      break;
                                    }
                                  }

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: events.asMap().entries.map((entry) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                        child: Container(
                                          width: 7.0,
                                          height: 7.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: markerColor, // 이 날짜에 맞는 색으로 설정
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                                return const SizedBox();
                              },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<List<String>>(
                          valueListenable: _selectedEvents,
                          builder: (context, value, _) {
                            return ListView.builder(
                              itemCount: value.length + 1, // 일기 내용 수 + 1 (일기쓰기 버튼)
                              itemBuilder: (context, index) {
                                if (index < value.length) {
                                  // 기존 일기 내용
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 70.0,
                                          vertical: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius: BorderRadius.circular(12.0),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => main2(
                                                      selectedDay:_selectedDay,
                                                      whatDay: _selectedDay,
                                                      text: value[index],
                                                    )));
                                          },
                                          title: Center(child: Text(value[index])),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  // 일기쓰기 버튼
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 70.0,
                                      vertical: 10.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Colors.black,
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => diaryWrite(selectedDay:_selectedDay)));
                                      },
                                      title: const Center(
                                        child: Text(
                                          '일기쓰기',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                );
              }
            },
          ),

          bottomNavigationBar: const bottomNavi(),
        )
    );
  }

  void _updateSelectedEvents(DateTime? selectedDay) {
    if (selectedDay != null) {
      final events = _events[_normalizeDate(selectedDay)] ?? [];
      _selectedEvents.value = events;
    } else {
      _selectedEvents.value = [];
    }
  }

  DateTime _getFirstDayOfWeek(DateTime date) {
    final weekday = date.weekday;
    final daysToSubtract = (weekday % 7);
    final firstDayOfWeek = date.subtract(Duration(days: daysToSubtract));
    return DateTime.utc(
        firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
  }

  bool isSameDay(DateTime? day1, DateTime day2) {
    if (day1 == null) return false;
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }
}

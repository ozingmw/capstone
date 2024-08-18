import 'package:client/gin3.dart';
import 'package:flutter/material.dart';
import 'widgets/gin_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import './gin2.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/gin2': (context) => const gin2(),
        '/gin3': (context) => const gin3(),
      },
      home: const main1(),
    );
  }
}

class main1 extends StatefulWidget {
  const main1({super.key});

  @override
  State<main1> createState() => _main1State();
}

class _main1State extends State<main1> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; // 현재 포커스된 날짜를 저장하는 변수
  DateTime? _selectedDay;
  bool _isWeekView = false;

  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 8, 18): ['Test Event 1'], // 특정 날짜에 이벤트 추가
    DateTime.utc(2024, 8, 20): ['Test Event 2'], // 또 다른 날짜에 이벤트 추가
  };

  @override
  Widget build(BuildContext context) {
    // print(_focusedDay);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // 아이콘을 오른쪽 끝에 배치
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
            const SizedBox(height: 50),
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
                focusedDay: _focusedDay, // 현재 포커스된 날짜
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                calendarFormat: _calendarFormat, // 달력 모양
                onDaySelected: (selectedDay, focusedDay) {
                  // 날짜를 선택
                  setState(() {
                    if (isSameDay(_selectedDay, selectedDay) ||
                        isSameDay(selectedDay, DateTime.now())) {
                      // 선택된 날짜가 이전에 선택된 날짜와 같거나 오늘 날짜와 같으면 달력 형식 변경
                      _isWeekView = !_isWeekView; // 주 단위 보기 상태 토글
                      _calendarFormat = _isWeekView
                          ? CalendarFormat.week
                          : CalendarFormat.month;
                      _focusedDay = _isWeekView
                          ? _getFirstDayOfWeek(selectedDay)
                          : DateTime.now(); // 포커스된 날짜 설정
                      if (_isWeekView) {
                        _selectedDay = selectedDay;
                      } else {
                        _selectedDay = null;
                      }
                    } else {
                      _selectedDay = selectedDay;
                      _focusedDay = _getFirstDayOfWeek(
                          selectedDay); // 선택된 날짜가 포함된 주의 첫 번째 날로 설정
                      _calendarFormat = CalendarFormat.week; // 주 보기로 변경
                      _isWeekView = true; // 주 단위 보기 상태 활성화
                    }
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay; // 페이지 변경 시 포커스된 날짜 업데이트
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format; // 형식 변경
                  });
                },

                eventLoader: (day) {
                  print("Loading events for: $day");
                  return _events[_normalizeDate(day)] ?? [];
                },

                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events.asMap().entries.map((entry) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Container(
                              width: 7.0,
                              height: 7.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
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
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Icon(
              Icons.home,
              size: 45,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/gin3');
              },
              child: const Icon(
                Icons.edit,
                size: 45,
              ),
            ),
            const Icon(
              Icons.assessment,
              size: 45,
            ),
            const Icon(
              Icons.person,
              size: 45,
            ),
          ]),
        ),
      ),
    );
  }

  // 선택된 날짜가 포함된 주의 첫 번째 날을 반환하는 함수
  DateTime _getFirstDayOfWeek(DateTime date) {
    // `date.weekday`가 1이면 월요일, 7이면 일요일입니다.
    // 여기서는 일요일을 주의 첫 날로 가정합니다.
    final weekday = date.weekday;
    final daysToSubtract = (weekday % 7); // 일요일을 기준으로 설정
    final firstDayOfWeek = date.subtract(Duration(days: daysToSubtract));
    return DateTime.utc(
        firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
  }

  // 두 날짜가 같은 날인지 확인하는 함수
  bool isSameDay(DateTime? day1, DateTime day2) {
    if (day1 == null) return false;
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }
}

DateTime _normalizeDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

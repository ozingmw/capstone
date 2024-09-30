import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class/diary_data.dart';
import 'main.dart';
import 'widgets/gin_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'widgets/bottomNavi.dart';
import './main2.dart';
import './diary1.dart';

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

  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 8, 18): ['Test Event 1'],
    DateTime.utc(2024, 8, 20): ['Test Event 2'],
  };

  // ValueNotifier to hold the list of events for the selected day
  final ValueNotifier<List<String>> _selectedEvents = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
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
                      _isWeekView = !_isWeekView;
                      _calendarFormat = _isWeekView
                          ? CalendarFormat.week
                          : CalendarFormat.month;
                      _focusedDay = _isWeekView
                          ? _getFirstDayOfWeek(selectedDay)
                          : DateTime.now();
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
                    _focusedDay = focusedDay;
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
            Expanded(
              child: ValueListenableBuilder<List<String>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
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
                                        builder: (context) => const main2()));
                              },
                              title: Center(child: Text(value[index])),
                            ),
                          ),
                          Container(
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
                                        builder: (context) => diary1()));
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
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
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

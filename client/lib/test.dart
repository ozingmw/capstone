import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main1(),
    );
  }
}

class Main1 extends StatefulWidget {
  const Main1({super.key});

  @override
  State<Main1> createState() => _Main1State();
}

class _Main1State extends State<Main1> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  bool _isWeekView = false;

  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 8, 18): ['Test Event 1'],
    DateTime.utc(2024, 8, 20): ['Test Event 2'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Example')),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime.utc(2022, 10, 16),
          lastDay: DateTime.utc(2027, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          calendarFormat: _calendarFormat,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (isSameDay(_selectedDay, selectedDay) ||
                  isSameDay(selectedDay, DateTime.now())) {
                _isWeekView = !_isWeekView;
                _calendarFormat =
                    _isWeekView ? CalendarFormat.week : CalendarFormat.month;
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
                      padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
    );
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

import 'package:dayclover/pig.dart';
import 'package:dayclover/read_diary.dart';
import 'package:dayclover/write_diary.dart';
import 'package:dayclover/service/diary_service.dart';
import 'package:dayclover/widgets/bottom_navi.dart';
import 'package:dayclover/widgets/gin_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final DiaryService diaryService = DiaryService();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool hasAlert = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  Map<String, dynamic>? _diaryData;
  String? selectedDiaryContent;
  bool isWriteButtonVisible = false;

  final Map<String, Color> sentimentColors = {
    '기쁨': Colors.green,
    '당황': Colors.yellow,
    '분노': Colors.red,
    '불안': Colors.orange,
    '상처': Colors.purple,
    '슬픔': Colors.blue,
  };

  Map<DateTime, List<String>> _events = {};

  // 이벤트 로더 함수
  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _loadDiaryData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _checkPigAlert();
  }

  // _loadDiaryData 함수 수정
  Future<void> _loadDiaryData() async {
    final data = await diaryService.readDiaryMonth(_focusedDay);
    setState(() {
      _diaryData = data;
      _events = {}; // 이벤트 초기화

      // 데이터를 이벤트로 변환
      if (data['res'] is List) {
        for (var entry in data['res']) {
          final date = DateTime.parse(entry['daytime']);
          final dateKey = DateTime(date.year, date.month, date.day);
          _events[dateKey] = [...(_events[dateKey] ?? []), entry['sentiment']];
        }
      }
    });
  }

  Future<bool> _shouldShowAlert() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckedDate = prefs.getString('lastCheckedDate');
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";

    if (lastCheckedDate == null) return true;

    return lastCheckedDate != todayString;
  }

  Future<void> _checkPigAlert() async {
    try {
      final shouldShow = await _shouldShowAlert();
      if (!shouldShow) {
        setState(() {
          hasAlert = false;
        });
        _animationController.reset();
        return;
      }

      final response = await diaryService.pigAlert();
      setState(() {
        hasAlert = response['res']['alert'] ?? false;
      });
      if (hasAlert) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.reset();
      }
    } catch (error) {
      print('Error checking pig alert: $error');
    }
  }

  Future<void> _handleAlertClick() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";

    await prefs.setString('lastCheckedDate', todayString);

    setState(() {
      hasAlert = false;
    });
    _animationController.reset();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PigPage()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: _diaryData == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                RotationTransition(
                                  turns: _rotationAnimation,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.notifications_active,
                                      color: Color.fromARGB(255, 244, 229, 30),
                                      size: 40,
                                    ),
                                    onPressed: _handleAlertClick,
                                  ),
                                ),
                                if (hasAlert)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                              ],
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
                              color: Color.fromARGB(255, 175, 76, 76),
                              size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 175, 119, 76),
                              size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 175, 165, 76),
                              size: 40),
                          Icon(Icons.filter_vintage,
                              color: Color.fromARGB(255, 76, 140, 175),
                              size: 40),
                          Icon(Icons.filter_vintage,
                              color: Colors.green, size: 40),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          availableGestures: AvailableGestures.none,
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;

                              _loadDiaryData();

                              // 선택된 날짜의 일기 데이터 확인
                              final selectedDate = DateTime(selectedDay.year,
                                  selectedDay.month, selectedDay.day);
                              final diaryEntry =
                                  (_diaryData?['res'] as List?)?.firstWhere(
                                (entry) => DateTime.parse(entry['daytime'])
                                    .isAtSameMomentAs(selectedDate),
                                orElse: () => null,
                              );

                              _calendarFormat = CalendarFormat.twoWeeks;

                              if (diaryEntry != null) {
                                // 일기가 있는 경우
                                selectedDiaryContent =
                                    diaryEntry['diary_content'];
                                isWriteButtonVisible = false;
                              } else {
                                // 일기가 없는 경우
                                selectedDiaryContent = null;
                                isWriteButtonVisible = true;
                              }
                            });
                          },
                          onPageChanged: (focusedDay) {
                            setState(() {
                              _focusedDay = focusedDay;
                            });
                            _loadDiaryData(); // 페이지 변경 시 데이터 로드
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          eventLoader: _getEventsForDay,
                          calendarStyle: const CalendarStyle(
                            markersMaxCount: 1,
                            markerSize: 8.0,
                            markerDecoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              if (events.isEmpty) return const SizedBox();
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: events.map((sentiment) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
                                    width: 6.0,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sentimentColors[sentiment] ??
                                          Colors.grey,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_selectedDay != null) ...[
                        const SizedBox(height: 20),
                        if (selectedDiaryContent != null) ...[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_selectedDay!.year}년 ${_selectedDay!.month}월 ${_selectedDay!.day}일의 일기',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(selectedDiaryContent!),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ReadDiary(
                                                  selectedDay: _selectedDay!)));
                                    },
                                    child: const Text('일기 보기'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (isWriteButtonVisible) ...[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WriteDiary(
                                            selectedDay: _selectedDay!,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            child: const Text(
                              '일기 작성하기',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: const BottomNavi(
          currentScreen: "main",
        ),
      ),
    );
  }
}

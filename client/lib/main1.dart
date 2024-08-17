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

class main1 extends StatelessWidget {
  const main1({super.key});

  @override
  Widget build(BuildContext context) {
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
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

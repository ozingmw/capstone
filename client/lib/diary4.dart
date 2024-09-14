import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import './gin2.dart';
import './main2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/gin2': (context) => const gin2(),
        '/gin3': (context) => const gin3(),
        '/main2': (context) => const main2(),
      },
      home: const diary4(),
    );
  }
}

class diary4 extends StatefulWidget {
  const diary4({super.key});

  @override
  State<diary4> createState() => _diary4State();
}

class _diary4State extends State<diary4> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  Icon(Icons.filter_vintage, color: Colors.green, size: 150),
                  SizedBox(height: 30),
                  Text(
                    '감정을 분석 중입니다',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

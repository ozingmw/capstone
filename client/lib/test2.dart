import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import './gin2.dart';
import './main2.dart';
import 'package:flutter_circular_text/circular_text.dart';

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
      home: const diary1(),
    );
  }
}

class diary1 extends StatefulWidget {
  const diary1({super.key});

  @override
  State<diary1> createState() => _diary1State();
}

class _diary1State extends State<diary1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body:CircularText(
          children: [
            TextItem(
              text: Text(
                "Day".toUpperCase(),
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              space: 35,
              startAngle: -90,
              startAngleAlignment: StartAngleAlignment.center,
              direction: CircularTextDirection.clockwise,
            ),
            TextItem(
              text: Text(
                "Clover".toUpperCase(),
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              space: 30,
              startAngle: 90,
              startAngleAlignment: StartAngleAlignment.center,
              direction: CircularTextDirection.anticlockwise,
            ),
          ],
          radius: 125,
          position: CircularTextPosition.inside,
          backgroundPaint: Paint()..color = Colors.grey.shade200,
        ),
    );
  }
}
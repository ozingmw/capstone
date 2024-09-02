import 'package:flutter/material.dart';
import 'package:client/gin1.dart';
import 'package:client/gin3.dart';
import 'package:client/gin2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayClover',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/gin2': (context) => const gin2(),
        '/gin3': (context) => const gin3(),
      },
      home: gin1(),
    );
  }
}

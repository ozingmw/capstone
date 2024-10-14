import 'dart:async';

import 'package:client/diaryAnalysis_3.dart';
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
    return const MaterialApp(
      home: diaryLoading(),
    );
  }
}

class diaryLoading extends StatefulWidget {
  const diaryLoading({super.key});

  @override
  State<diaryLoading> createState() => _diaryLoadingState();
}

class _diaryLoadingState extends State<diaryLoading> {
  @override
  void initState() {
    super.initState();
    // 2초 뒤 화면 이동
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const diaryAnalysis()));
    });
  }

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

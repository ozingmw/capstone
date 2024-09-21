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
        // '/gin3': (context) => const gin3(),
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
    return const Scaffold();
  }
}

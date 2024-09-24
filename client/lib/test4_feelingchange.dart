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
      home: const test4(),
    );
  }
}

class test4 extends StatefulWidget {
  const test4({super.key});

  @override
  State<test4> createState() => _test4State();
}

class _test4State extends State<test4> {
  List<MaterialColor> iconColor = [Colors.red, Colors.orange, Colors.yellow, Colors.blue, Colors.green];
  int currentColorIndex = 0 ;

  Icon feeling = const Icon(Icons.filter_vintage, color: Colors.green, size: 150);

  void colorChange() {
    setState(() {
      currentColorIndex = (currentColorIndex + 1) % iconColor.length;
      feeling = Icon(Icons.filter_vintage, color: iconColor[currentColorIndex], size: 150);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            iconSize: 40,
            icon: feeling,
            onPressed: () => colorChange(),
          ),
        ],
    );
  }
}

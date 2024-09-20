import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import 'widgets/textbox_widget.dart';
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
      home: const diary7(),
    );
  }
}

class diary7 extends StatefulWidget {
  const diary7({super.key});

  @override
  State<diary7> createState() => _diary7State();
}

class _diary7State extends State<diary7> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  Spacer(),
                  Text('완료'),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextboxWidget(whatDidYouSay: '행복은 간단한 것들에서 비롯된다.',),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

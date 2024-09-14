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
  List _pickfeeling = [0,1,2,3,4,5,6];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
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
                      Text(
                        '당신의 감정은',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios, size: 50),
                          SizedBox(width: 20),
                          Icon(Icons.filter_vintage, color: Colors.green, size: 150),
                          SizedBox(width: 20),
                          Icon(Icons.arrow_forward_ios, size: 50),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        '행복',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 50),
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

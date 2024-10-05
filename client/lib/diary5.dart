import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import './gin2.dart';
import './main2.dart';
import './diary6.dart';
import './diary7.dart';
import './diary8.dart';

class diary5 extends StatefulWidget {
  const diary5({super.key});

  @override
  State<diary5> createState() => _diary5State();
}

class _diary5State extends State<diary5> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => diary7(),
                        ),
                      );
                    },
                    child: const Text('완료'),
                  ),
                ],
              ),
              Expanded(
                child: Center( 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '당신의 감정은',
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.filter_vintage, color: Colors.green, size: 150),
                      const SizedBox(height: 30),
                      const Text(
                        '행복',
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => diary6()),
                              );
                            },
                            child: const Text('다른 감정인가요?'),
                          ),
                        ],
                      ),
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

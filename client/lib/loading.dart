import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
                  Text(
                    'DAYCLOVER',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  Icon(Icons.filter_vintage, color: Colors.green, size: 150),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

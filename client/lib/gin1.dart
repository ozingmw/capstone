import 'package:flutter/material.dart';
import 'widgets/gin_widget.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 70),
                  const Text(
                    'WELCOME',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Please login to continue',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  const LoginWidget(
                      loginText: 'Login with Google',
                      icon: Icons.account_circle,
                      off: 0),
                  const SizedBox(height: 10),
                  const LoginWidget(
                      loginText: '비회원 로그인', icon: Icons.account_circle, off: 1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

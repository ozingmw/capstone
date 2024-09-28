import 'package:client/diary2.dart';
import 'package:flutter/material.dart';
import 'package:client/service/token_service.dart';
import 'package:client/main1.dart';
import 'package:client/gin1.dart';
import 'package:provider/provider.dart';
import './class/diary_data.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DiaryData1(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'DayClover',
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    bool isExistingUser = await TokenService.hasValidToken();
    if (isExistingUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const main1()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => gin1()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

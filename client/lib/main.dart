import 'package:flutter/material.dart';
import 'package:client/service/token_service.dart';
import 'package:client/main1.dart';
import 'package:client/gin1.dart';
import 'package:provider/provider.dart';
import './class/diary_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => DiaryData1(),
    child: const MyApp(),
  ));
}

clearSecureStorageOnReinstall() async {
  String key = 'hasRunBefore';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(key) != true) {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();
    prefs.setBool(key, true);
  }
}

class HeartPainter extends CustomPainter {
  final Color color;

  HeartPainter({this.color = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    final double width = size.width;
    final double height = size.height;

    path.moveTo(width / 2, height * 0.3);
    path.cubicTo(width * 0.2, height * 0.1, -width * 0.25, height * 0.6,
        width / 2, height);
    path.cubicTo(width * 1.25, height * 0.6, width * 0.8, height * 0.1,
        width / 2, height * 0.3);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    clearSecureStorageOnReinstall();
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

class _AuthWrapperState extends State<AuthWrapper>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isIncreasing = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );
    }).toList();

    _startAnimation();
    _checkAuthStatus();
  }

  void _startAnimation() async {
    while (mounted && _isLoading) {
      if (_isIncreasing) {
        for (int i = 0; i < 4; i++) {
          if (!mounted || !_isLoading) return;
          await _controllers[i].forward();
          await Future.delayed(const Duration(milliseconds: 100));
        }
        _isIncreasing = false;
      } else {
        for (int i = 3; i >= 0; i--) {
          if (!mounted || !_isLoading) return;
          await _controllers[i].reverse();
          await Future.delayed(const Duration(milliseconds: 100));
        }
        _isIncreasing = true;
      }
    }
  }

  void _checkAuthStatus() async {
    // 2초에서 5초 사이의 랜덤한 시간 생성
    final random = Random();
    final randomSeconds = 2 + random.nextInt(4); // 2에서 5초 사이

    // 랜덤한 시간만큼 대기
    Future.delayed(Duration(seconds: randomSeconds), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // 토큰 확인
    bool isExistingUser = await TokenService.hasValidToken();

    // 랜덤한 시간만큼 대기
    await Future.delayed(Duration(seconds: randomSeconds));

    if (mounted) {
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
  }

  @override
  void dispose() {
    _isLoading = false;
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'DAYCLOVER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 70,
                    top: 75,
                    child: Transform.rotate(
                      angle: -pi / 4,
                      child: FadeTransition(
                        opacity: _animations[0],
                        child: CustomPaint(
                          size: const Size(30, 35),
                          painter: HeartPainter(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 70,
                    top: 75,
                    child: Transform.rotate(
                      angle: pi / 4,
                      child: FadeTransition(
                        opacity: _animations[1],
                        child: CustomPaint(
                          size: const Size(30, 35),
                          painter: HeartPainter(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 70,
                    bottom: 61,
                    child: Transform.rotate(
                      angle: 3 * pi / 4,
                      child: FadeTransition(
                        opacity: _animations[2],
                        child: CustomPaint(
                          size: const Size(30, 35),
                          painter: HeartPainter(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 70,
                    bottom: 61,
                    child: Transform.rotate(
                      angle: -3 * pi / 4,
                      child: FadeTransition(
                        opacity: _animations[3],
                        child: CustomPaint(
                          size: const Size(30, 35),
                          painter: HeartPainter(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

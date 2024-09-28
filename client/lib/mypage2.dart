import 'package:flutter/material.dart';
// import 'widgets/bottomNavi.dart';
// import 'package:client/gin3.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          transform: Matrix4.translationValues(50.0, 10.0, 0.0),
          child: Text(
            "마이페이지",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile text
            const Text(
              "profile",
              style: TextStyle(
                fontSize: 20.0, // Adjust font size as needed
                color: Colors.black,
              ),
            ),
            // Thin white line (Container) below the "profile" text
            Container(
              height: 1.0,
              width: 700.0,
              color: Colors.black,
            ),
            // Use Transform to move the image to the left
            Transform.translate(
              offset: const Offset(
                  -25.0, 0.0), // Move the image to the left by 20 pixels
              child: SizedBox(
                // SizedBox를 사용하여 명확한 크기 제공
                width: 100.0,
                height: 100.0,
                child: Image.asset('assets/images/User.png'),
              ),
            ),

            Transform.translate(
              offset: const Offset(
                  -25.0, 0.0), // Move the image to the left by 20 pixels
              child: SizedBox(
                // SizedBox를 사용하여 명확한 크기 제공
                width: 100.0,
                height: 300.0,
                child: Image.asset('assets/images/Message.png'),
              ),
            ),
            SizedBox(height: 50.0), // Add space before the second line
            Container(
              height: 1.0,
              width: 700.0,
              color: Colors.black,
            ),

            // Additional content can go here
          ],
        ),
      ),
    );
  }
}

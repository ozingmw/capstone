import 'package:flutter/material.dart';
import 'widgets/bottomNavi.dart';
import 'package:client/gin3.dart';
import './gin2.dart';

class main2 extends StatefulWidget {
  const main2({super.key});

  @override
  State<main2> createState() => _main2State();
}

class _main2State extends State<main2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 기능
            },
          ),
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 145, 171, 145),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '10',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '화요일',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '비가 내리는 날, 우울함이 더해졌다. 마음이 침울하고 무기력함이 밀려오는 것 같았다. 마음 한구석에는 그 울적한 기운이 여전히 머물러 있었다. 나 자신을 힘들게 하는 이 우울함 속에서도, 어쩌면 이것 역시 삶의 한 부분이고 지나갈 일이겠지 싶었다. 하지만 그 순간에는 해결할 수 없는 어떤 무거운 짐처럼 느껴졌다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

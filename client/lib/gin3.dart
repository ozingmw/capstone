import 'package:flutter/material.dart';
import 'widgets/dropdown_widget.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: [
              Row(
                children: [
                  const Spacer(), // Spacer로 TextButton을 오른쪽으로 밀기
                  TextButton(
                    onPressed: () {},
                    child: const Text('SKIP'),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                '성별',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(value: true, onChanged: null, semanticLabel: '남자'),
                    Text('남자'),
                    SizedBox(width: 50),
                    Checkbox(value: true, onChanged: null, semanticLabel: '여자'),
                    Text('여자'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '나이',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: MyDropdown()),
              ),
              const SizedBox(height: 80),
              const Center(
                  child:
                      Text("성별 및 나이와 같은 개인정보 이용 동의시 더욱 디테일한 서비스를 이용할 수 있습니다.")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios),
                      iconSize: 40,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios),
                      iconSize: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

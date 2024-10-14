import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './diaryPick_4.dart';
import './diaryText_5.dart';
import 'class/diary_data.dart';

class diaryAnalysis extends StatefulWidget {
  const diaryAnalysis({super.key});

  @override
  State<diaryAnalysis> createState() => _diaryAnalysisState();
}

class _diaryAnalysisState extends State<diaryAnalysis> {
  Color feelingColor = Colors.green;
  String feelingText = '행복';

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

                      Provider.of<DiaryData1>(context, listen: false)
                          .updateFeeling(feelingColor);
                      print('감정 색: ${feelingColor}');

                      Provider.of<DiaryData1>(context, listen: false)
                          .updatefeelingText(feelingText);
                      print('감정 텍스트: ${feelingText}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => diaryText(),
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
                      Icon(Icons.filter_vintage, color: feelingColor, size: 150),
                      const SizedBox(height: 30),
                      Text(
                        feelingText,
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
                                MaterialPageRoute(builder: (context) => diaryPick()),
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

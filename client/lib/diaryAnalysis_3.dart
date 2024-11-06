import 'package:client/service/diary_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final DiaryService diaryService = DiaryService();
  Color feelingColor = Colors.green;
  String feelingText = '기쁨';

  @override
  Widget build(BuildContext context) {
    DateTime? diarydate = Provider.of<DiaryData1>(context, listen: false).toCreateDiray;
    String formattedDate = diarydate != null ? DateFormat('yyyy-MM-dd').format(diarydate) : '';

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
                    onPressed: () async {

                      Provider.of<DiaryData1>(context, listen: false)
                          .updateFeeling(feelingColor);
                      print('감정 색: ${feelingColor}');

                      Provider.of<DiaryData1>(context, listen: false)
                          .updatefeelingText(feelingText);
                      print('감정 텍스트: ${feelingText}');

                      try {
                        // 비동기 호출을 await로 대기
                        await diaryService.createDiary(
                          diary: Provider.of<DiaryData1>(context, listen: false)
                              .diaryText,
                          sentiment: Provider.of<DiaryData1>(context, listen: false)
                              .feelingText,
                          isDiary: Provider.of<DiaryData1>(context, listen: false)
                              .pagenum,
                          daytime: formattedDate,

                        );
                        print('성공');
                      } catch (e) {
                        // 예외 발생 시 실패 처리
                        print('실패: $e');
                        print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).diaryText}');
                        print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).feelingText}');
                        print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).pagenum}');
                        print('실패 텍스트: $formattedDate');
                      }

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
                            onPressed: () async {

                              try {
                                // 비동기 호출을 await로 대기
                                await diaryService.createDiary(
                                  diary: Provider.of<DiaryData1>(context, listen: false)
                                      .diaryText,
                                  sentiment: feelingText,
                                  isDiary: Provider.of<DiaryData1>(context, listen: false)
                                      .pagenum,
                                  daytime: formattedDate,

                                );
                                print('성공');
                              } catch (e) {
                                // 예외 발생 시 실패 처리
                                print('실패: $e');
                                print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).diaryText}');
                                print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).feelingText}');
                                print('실패 텍스트: ${Provider.of<DiaryData1>(context, listen: false).pagenum}');
                                print('실패 텍스트: $formattedDate');
                              }

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

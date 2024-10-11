import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottomNavi.dart';
import 'widgets/OutlineCircleButton.dart';
import 'package:client/diary3.dart';
import './class/diary_data.dart';

class diary extends StatefulWidget {
  const diary({super.key});

  @override
  State<diary> createState() => _diaryState();
}

class _diaryState extends State<diary> {
  final TextEditingController _controller = TextEditingController();
  bool editMod = false;
  int currentPageNum = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    currentPageNum = Provider.of<DiaryData1>(context).pagenum;
    print('페이지 넘버: ${currentPageNum}');
  }

  void _showEmptyTextAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('입력 필요'),
          content: const Text('텍스트를 입력한 후 저장 버튼을 눌러주세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _afterWrite() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('저장 완료'),
          content: const Text('저장을 완료했습니다.\n하단 아이콘을 눌러 감정 스템프를 받아주세요!'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                // 여기서 listen: false를 명시적으로 추가합니다.
                Provider.of<DiaryData1>(context, listen: false).updateDiaryText(_controller.text);
                Provider.of<DiaryData1>(context, listen: false).updatePageNum(currentPageNum);

                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => diary3(text: _controller.text),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  void _changemode() {
    if (currentPageNum == 0) {
      Provider.of<DiaryData1>(context, listen: false).updatePageNum(1);
    } else {
      Provider.of<DiaryData1>(context, listen: false).updatePageNum(0);
    }
  }

  void _showNoChangesAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('수정 없음'),
          content: const Text('텍스트를 수정하지 않았습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSaveButtonPressed() {
    if (_controller.text.isEmpty) {
      _showEmptyTextAlert();
    } else if (_controller.text == Provider.of<DiaryData1>(context, listen: false).diaryText) {
      _showNoChangesAlert();
    } else {
      _afterWrite();
      print('텍스트 저장됨: ${_controller.text}');
    }
  }

  void _beforechange() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('저장 필요'),
            content: const Text('텍스트를 저장하지 않고 페이지를 이동하면 내용이 사라져요.'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('이동'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _controller.clear();
                  _changemode();
                },
              )
            ],
          );
        });
  }

  void _changeoption() {
    if (_controller.text.isNotEmpty) {
      _beforechange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final diaryData1 = Provider.of<DiaryData1>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Visibility(
                visible: currentPageNum == 1,
                child: const Text(
                  '문답 작성',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Visibility(
                visible: currentPageNum == 0,
                child: const Text(
                  '일기 작성', // pagenum이 0일 때 표시될 텍스트
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // 키보드가 올라올 때 화면 크기 조정
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // 전체 콘텐츠를 스크롤 가능하게 만듭니다.
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      '10',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Color.fromARGB(255, 0, 0, 0),
                        decorationThickness: 2,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  const Text(
                    '화요일',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(), // 남은 공간을 모두 차지하여 오른쪽으로 정렬
                  TextButton(
                    onPressed: _onSaveButtonPressed,
                    child: const Text('저장'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: diaryData1.pagenum == 1,
                child: const Text(
                  '올해 꼭 이루고 싶은 소원 세가지는 무엇인가요?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Stack(
                children: [
                  Container(
                      width: 450,
                      height: 400,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 145, 171, 145),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: Provider.of<DiaryData1>(context)
                                .diaryText
                                .isEmpty,
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '여기에 텍스트를 입력하세요.',
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Visibility(
                              visible: Provider.of<DiaryData1>(context)
                                  .diaryText
                                  .isNotEmpty,
                              child: Text(
                                  Provider.of<DiaryData1>(context).diaryText)),
                        ],
                      )),
                  Positioned(
                    bottom: 10, // 화면 하단으로부터의 거리
                    right: 10, // 화면 우측으로부터의 거리
                    child: OutlineCircleButton(
                      radius: 65.0,
                      // 버튼 크기 조정
                      borderSize: 2.0,
                      // 테두리 두께 조정
                      borderColor: Colors.black45,
                      // 테두리 색상
                      foregroundColor: Colors.white,
                      // 버튼 배경 색상
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          _beforechange();
                        } else {
                          _changemode();
                        }
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.swap_horiz,
                              size: 40,
                              color: Color.fromARGB(255, 145, 171, 145)),
                          SizedBox(height: 4), // 아이콘과 텍스트 사이의 간격
                          Text(
                            '일기작성',
                            style: TextStyle(
                              fontSize: 12, // 글자 크기 조정
                              color: Colors.black,
                              height: 0.3, // 줄 간격 조정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const bottomNavi(),
    );
  }
}

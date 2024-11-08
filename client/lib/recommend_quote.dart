import 'package:client/extension/string_extension.dart';
import 'package:client/read_diary.dart';
import 'package:client/service/quote_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/widgets/textbox_widget.dart';
import 'package:flutter/material.dart';

class RecommendQuote extends StatefulWidget {
  final String emotion; // emotion 변수 추가
  const RecommendQuote({super.key, required this.emotion});

  @override
  State<RecommendQuote> createState() => _RecommendQuoteState();
}

class _RecommendQuoteState extends State<RecommendQuote> {
  String quote = '';
  String nickname = '';
  bool isLoading = true; // 로딩 상태를 관리할 변수 추가

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    final userService = UserService();
    final user = await userService.readUser();

    setState(() {
      isLoading = true; // 로딩 시작
      nickname = user['res']['nickname'];
    });

    final quoteService = QuoteService();
    final fetchedQuote = await quoteService.readQuote(widget.emotion);

    setState(() {
      quote = fetchedQuote['res']['quote_content'];
      isLoading = false; // 로딩 완료
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReadDiary(selectedDay: DateTime.now()),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(), // 로딩 인디케이터 추가
                          const SizedBox(height: 20),
                          Text(
                            '$nickname님을 위한 글귀를 생성중이에요...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextboxWidget(
                            whatDidYouSay: quote.insertZwj(),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
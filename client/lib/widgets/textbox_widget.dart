import 'package:flutter/material.dart';

class TextboxWidget extends StatelessWidget {
  final String whatDidYouSay;

  const TextboxWidget({
    super.key,
    required this.whatDidYouSay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 145, 171, 145),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 수정된 부분
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                whatDidYouSay,
                textAlign: TextAlign.center, // 수정된 부분
                style: const TextStyle( // 수정된 부분
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
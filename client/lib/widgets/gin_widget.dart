import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  final String loginText;
  // final IconData icon;
  final double off;

  const LoginWidget({
    super.key,
    required this.loginText,
    // required this.icon,
    required this.off,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.translate(
          offset: Offset(0, off),
          child: Container(
            width: 350,
            height: 80,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 145, 171, 145),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: [
                  // Icon(icon,
                  //     color: const Color.fromARGB(255, 154, 180, 156),
                  //     size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      loginText,
                      textAlign: TextAlign.center, // 텍스트 가운데 정렬
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

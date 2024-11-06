import 'package:flutter/material.dart';

class mySentiment extends StatelessWidget {
  final String sentiment;
  final double amount;
  final IconData icon;
  final Color iconColor;

  const mySentiment({
    super.key,
    required this.sentiment,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = '${amount.toStringAsFixed(1)}%';

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(204, 184, 180, 216),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      sentiment,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 50), // 텍스트와 아이콘 사이 간격
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 50,
                    ),
                  ),
                  const Text(
                    "평균",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15, // 작은 글씨 크기
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10), // 간격 추가
            Text(
              displayAmount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 29,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

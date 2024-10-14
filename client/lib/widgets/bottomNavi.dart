import 'package:flutter/material.dart';
import 'package:client/main1.dart';
import 'package:client/diary1.dart';
import 'package:client/mypagelast.dart';

class bottomNavi extends StatelessWidget {
  const bottomNavi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const main1()),
              );
            },
            child: const Icon(
              Icons.home,
              size: 45,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(

                MaterialPageRoute(
                    builder: (context) => const diary1()),
              );
            },
            child: const Icon(
              Icons.edit,
              size: 45,
            ),
          ),
          const Icon(
            Icons.assessment,
            size: 45,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DiaryPage()),
              );
            },
            child: const Icon(
              Icons.person,
              size: 45,
            ),
          )
        ]),
      ),
    );
  }
}

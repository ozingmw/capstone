import 'package:flutter/material.dart';

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
          const Icon(
            Icons.home,
            size: 45,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/gin3');
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
          const Icon(
            Icons.person,
            size: 45,
          ),
        ]),
      ),
    );
  }
}

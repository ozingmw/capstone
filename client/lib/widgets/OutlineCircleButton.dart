import 'package:flutter/material.dart';

class OutlineCircleButton extends StatelessWidget {
  const OutlineCircleButton({
    super.key,
    this.onTap,
    this.borderSize = 0.5,
    this.radius = 50.0, // 기본값을 50.0으로 변경
    this.borderColor = Colors.black45,
    this.foregroundColor = Colors.white,
    this.child,
  });

  final void Function()? onTap;
  final double radius;
  final double borderSize;
  final Color borderColor;
  final Color foregroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderSize),
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: child ?? const SizedBox(),
          ),
        ),
      ),
    );
  }
}

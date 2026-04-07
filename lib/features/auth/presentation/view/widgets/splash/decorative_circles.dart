import 'package:flutter/material.dart';

class DecorativeCircles extends StatelessWidget {
  final double top;
  final double right;
  final double size;
  final double alpha;
  const DecorativeCircles(
      {super.key,
      required this.top,
      required this.right,
      required this.size,
      required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: alpha),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

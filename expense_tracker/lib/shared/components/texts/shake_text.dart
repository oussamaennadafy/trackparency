import 'package:flutter/material.dart';
import 'dart:math' show pi, sin;

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  });

  /// convert 0-1 to 0-1-0
  double shake(double animation) {
    const double leftShift = 0.3;
    return 2 * (0.5 - (0.5 - curve.transform(animation)).abs()) * sin(animation * pi) - leftShift * (1 - animation);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}

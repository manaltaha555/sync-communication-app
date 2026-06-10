import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';

class GradientBorderPainter extends CustomPainter {
  final double strokeWidth;

  GradientBorderPainter({this.strokeWidth = 1.5});

  @override
  void paint(Canvas canvas, Size size) {
    final context = AppKey.navigatorKey.currentContext;
    if (context == null) return;
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = context.mainLinearGradient.createShader(rect);

    final radius = (size.shortestSide / 2) - (strokeWidth / 2);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}

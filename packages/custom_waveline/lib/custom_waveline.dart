library custom_waveline;

import 'dart:math';

import 'package:flutter/widgets.dart';

class CustomWaveline extends CustomPainter {
  final double curveWidth;
  final double curveHeight;
  final double strokeWidth;
  final Color color;

  CustomWaveline({
    super.repaint,
    required this.curveWidth,
    required this.curveHeight,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / curveWidth;
    final midH = size.height / 2;

    final path = Path();
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    path.moveTo(
      0,
      midH,
    );

    print(curveWidth);
    print(1 / (unit / size.width));

    for (int i = 0; i < size.width; i++) {
      path.lineTo(
        i.toDouble(),
        midH + curveHeight / 2 * sin(2 * pi * i / curveWidth),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';

import '../models/snow_ball.dart';

class SnowPainter extends CustomPainter {
  final List<SnowBall> snows;
  final bool isRunning;
  final Color snowColor;

  SnowPainter({
    required this.isRunning,
    required this.snows,
    required this.snowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    paint = Paint()
      ..shader = LinearGradient(
        colors: [snowColor, Colors.white60],
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromCircle(
        center: const Offset(0, 0),
        radius: 15,
      ));

    for (int i = 0; i < snows.length; i++) {
      SnowBall snow = snows[i];
      canvas.drawCircle(Offset(snow.x, snow.y), snow.radius, paint);
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => isRunning;
}

import 'dart:math';

import 'package:flutter/material.dart';

import '../models/snow_ball.dart';
import '../painter/snow_painter.dart';

class SnowWidget extends StatefulWidget {
  final int totalSnow;
  final double speed;
  final bool isRunning;
  final double maxRadius;
  final Color snowColor;

  const SnowWidget({
    Key? key,
    required this.totalSnow,
    required this.speed,
    required this.isRunning,
    required this.snowColor,
    this.maxRadius = 4,
  }) : super(key: key);

  _SnowWidgetState createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation animation;

  double W = 0;
  double H = 0;

  final Random _rnd = Random();
  final List<SnowBall> _snows = [];
  double angle = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize snowballs and start animation in didChangeDependencies
    if (_snows.isEmpty) {
      init();
    }
  }

  init() {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;

    controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        vsync: this,
        duration: const Duration(milliseconds: 2000))
      ..addListener(() {
        if (mounted) {
          setState(() {
            update();
          });
        }
      });

    controller.repeat();
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  _createSnowBall() async {
    for (int i = 0; i < widget.totalSnow; i++) {
      final double radius = _rnd.nextDouble() * widget.maxRadius + 2;
      final double generatedRadius = _rnd.nextDouble() * widget.speed;
      final double speed =
          generatedRadius >= (widget.maxRadius - widget.maxRadius / 4)
              ? generatedRadius
              : generatedRadius / 3;

      final double x = _rnd.nextDouble() * W;
      final double y = _rnd.nextDouble() * H;

      _snows.add(
        SnowBall(
          x: x,
          y: -y,
          radius: radius,
          density: speed,
        ),
      );
    }
  }

  update() async {
    angle += 0.01;

    if (widget.totalSnow != _snows.length) {
      await _createSnowBall();
    }

    for (int i = 0; i < widget.totalSnow; i++) {
      SnowBall snow = _snows[i];

      snow.y +=
          (cos(angle + _rnd.nextDouble() + snow.density) + snow.radius / 2)
                  .abs() *
              widget.speed;
      snow.x += sin(_rnd.nextDouble() + snow.radius) * 2 * widget.speed;

      if (snow.x > W + (snow.radius * 2) ||
          snow.x < -(snow.radius * 2) ||
          snow.y > H) {
        if (i % 4 > 0) {
          _snows[i] = SnowBall(
              x: _rnd.nextDouble() * W,
              y: -10,
              radius: snow.radius,
              density: snow.density);
        } else if (i % 5 > 0) {
          _snows[i] = SnowBall(
              x: (_rnd.nextDouble() * W) - _rnd.nextDouble() * 10,
              y: 0,
              radius: snow.radius,
              density: snow.density);
        } else {
          // If the flake is exiting
          if (sin(angle) > 0) {
            // From the left
            _snows[i] = SnowBall(
                x: -5,
                y: _rnd.nextDouble() * H,
                radius: snow.radius,
                density: snow.density);
          } else {
            // From the right
            _snows[i] = SnowBall(
                x: W + 5,
                y: _rnd.nextDouble() * H,
                radius: snow.radius,
                density: snow.density);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      /// update Boundaries when Constraints change
      W = constraints.maxWidth;
      H = constraints.maxHeight;

      return CustomPaint(
        willChange: widget.isRunning,
        isComplex: true,
        size: Size.infinite,
        painter: SnowPainter(
          isRunning: widget.isRunning,
          snows: _snows,
          snowColor: widget.snowColor,
        ),
      );
    });
  }
}

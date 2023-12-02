import 'dart:math';

import 'package:flutter/material.dart';

import '../models/snow_ball.dart';
import '../painter/snow_painter.dart';

class SnowWidget extends StatefulWidget {
  ///
  /// Give the amount of particles to display on the screen
  ///
  final int totalSnow;

  ///
  /// Give the speed of the snow particles
  /// note that the velocity of each ball will depend on the its size
  /// (radius)
  /// The bigger snow balls will fall faster and the smaller snow balls will
  /// fall slower
  ///
  final double speed;

  ///
  /// Tells whether the animation is starting or not
  ///
  final bool isRunning;

  ///
  /// Give the max radius size of the snow ball object
  ///
  final double maxRadius;

  ///
  /// Give the main color of the Snowball
  ///
  final Color snowColor;

  ///
  /// Display the linear gradient with  [snowColor] and [Colors.white60] on the snowball
  /// if true else just display given [snowColor]
  ///
  final bool hasSpinningEffect;

  ///
  /// Start the snowing animation from the top if set to true
  /// otherwise start from the whole screens boundaries
  ///
  final bool startSnowing;

  const SnowWidget({
    Key? key,
    required this.totalSnow,
    required this.speed,
    required this.isRunning,
    required this.snowColor,
    this.maxRadius = 4,
    this.hasSpinningEffect = true,
    this.startSnowing = false,
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
  void didUpdateWidget(covariant SnowWidget oldWidget) {
    if (_hasParametersChanged(oldWidget)) {
      print("didUpdateWidget");
      init(hasInit: true, previousTotalSnow: oldWidget.totalSnow);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize snowballs and start animation in didChangeDependencies
    if (_snows.isEmpty) {
      print(
          "Initialize snowballs and start animation in didChangeDependencies");
      init();
    }
  }

  bool _hasParametersChanged(covariant SnowWidget oldWidget) {
    // check only parameters that are used for initialization
    return oldWidget.startSnowing != widget.startSnowing ||
        oldWidget.totalSnow != widget.totalSnow ||
        oldWidget.maxRadius != widget.maxRadius ||
        oldWidget.snowColor != widget.snowColor;
  }

  Future<void> _replaceSnowBallWithNewParameters(int previousTotalSnow) async {
    List<SnowBall> copySnow = _snows;

    for (int i = 0; i < previousTotalSnow; i++) {
      final SnowBall snow = copySnow.elementAt(i);
      final double radius = _rnd.nextDouble() * widget.maxRadius + 2;
      final double generatedRadius = _rnd.nextDouble() * widget.speed;
      final double speed =
          generatedRadius >= (widget.maxRadius - widget.maxRadius / 4)
              ? generatedRadius
              : generatedRadius / 3;

      _snows[i] = SnowBall(
        x: snow.x,
        y: snow.y,
        radius: radius,
        density: speed,
      );
    }
  }

  init({bool hasInit = false, int previousTotalSnow = 0}) async {
    W = MediaQuery.of(context).size.width;
    H = MediaQuery.of(context).size.height;

    if (hasInit) {
      /// only reset balls after the first init is done
      await _replaceSnowBallWithNewParameters(previousTotalSnow);
      final int newTotalSnow = widget.totalSnow - previousTotalSnow;
      if (newTotalSnow > 0) {
        await _createSnowBall(newBallToAdd: newTotalSnow);
      }
    } else {
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
  }

  @override
  dispose() {
    controller.dispose();

    super.dispose();
  }

  Future<void> _createSnowBall({required int newBallToAdd}) async {
    final int inverseYAxis = widget.startSnowing ? -1 : 1;

    for (int i = 0; i < newBallToAdd; i++) {
      final double radius = _rnd.nextDouble() * widget.maxRadius + 2;
      final double generatedRadius = _rnd.nextDouble() * widget.speed;
      final double speed =
          generatedRadius >= (widget.maxRadius - widget.maxRadius / 4)
              ? generatedRadius
              : generatedRadius / 3;

      final double x = _rnd.nextDouble() * W;

      /// if [widget.startSnowing] is true the we reverse the Y axis to give
      /// the feeling of starting snow.
      /// otherwise just keep the Y axis as is.
      final double y = _rnd.nextDouble() * H * inverseYAxis;

      _snows.add(
        SnowBall(
          x: x,
          y: y,
          radius: radius,
          density: speed,
        ),
      );
    }
  }

  update() async {
    angle += 0.01;

    if (widget.totalSnow != _snows.length) {
      await _createSnowBall(newBallToAdd: widget.totalSnow);
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
          hasSpinningEffect: widget.hasSpinningEffect,
        ),
      );
    });
  }
}

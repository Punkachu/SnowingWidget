import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../widget/snowing.dart';

class StoryBookApp extends StatelessWidget {
  StoryBookApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Storybook(
      wrapperBuilder: (BuildContext _, Widget? child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
      ),
      initialStory: "Snowing Widget",
      stories: <Story>[
        Story(
            name: "Snowing Widget",
            description: 'Snow ball generated',
            builder: (BuildContext context) {
              final double width = context.knobs
                  .sliderInt(label: "width", initial: 2000, min: 200, max: 4000)
                  .toDouble();

              final double height = context.knobs
                  .sliderInt(
                      label: "height", initial: 2000, min: 200, max: 4000)
                  .toDouble();

              final int snowBalls = context.knobs.sliderInt(
                label: "Number of ball",
                min: 50,
                max: 500,
              );

              final double speed = context.knobs
                      .sliderInt(label: "Speed", initial: 2, min: 1, max: 100) /
                  100;

              final double radius = context.knobs
                  .sliderInt(label: "Radius", initial: 5, min: 1, max: 60)
                  .toDouble();

              final bool spinning =
                  context.knobs.boolean(label: "Can Spin ?", initial: true);

              return Scaffold(
                body: Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF002C7E),
                        Color(0xFF0D0C2F),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: SnowWidget(
                          isRunning: true,
                          totalSnow: snowBalls,
                          speed: 0.1 + speed,
                          maxRadius: radius,
                          snowColor: Colors.white,
                          hasSpinningEffect: spinning,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../widget/snow_widget.dart';

class StoryBookApp extends StatelessWidget {
  StoryBookApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    List<MaterialColor> colors = [];
    colors.add(const MaterialColor(
      500,
      <int, Color>{
        500: Color(0xFFFFFFFF),
      },
    ));
    colors.addAll(Colors.primaries);

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
                min: 0,
                max: 500,
                initial: 50,
              );

              final double speed = context.knobs
                      .sliderInt(label: "Speed", initial: 2, min: 1, max: 100) /
                  100;

              final double radius = context.knobs
                  .sliderInt(label: "Radius", initial: 5, min: 1, max: 60)
                  .toDouble();

              final bool spinning =
                  context.knobs.boolean(label: "Can Spin ?", initial: true);

              final bool startSnowing = context.knobs
                  .boolean(label: "Start Snowing ?", initial: true);

              final int indexColors = context.knobs.sliderInt(
                  label: "Snow Colors", initial: 0, max: colors.length - 1);

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
                        child: Transform.rotate(
                          angle: 360,
                          child: SnowWidget(
                            isRunning: true,
                            totalSnow: snowBalls,
                            speed: 0.1 + speed,
                            maxRadius: radius,
                            snowColor: indexColors == 0
                                ? Colors.white
                                : colors[indexColors],
                            hasSpinningEffect: spinning,
                            startSnowing: startSnowing,
                          ),
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

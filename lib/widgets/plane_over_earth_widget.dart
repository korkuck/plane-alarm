import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class PlaneOverEarthWidget extends StatefulWidget {
  const PlaneOverEarthWidget({super.key});

  @override
  State<PlaneOverEarthWidget> createState() => _PlaneOverEarthWidgetState();
}

class _PlaneOverEarthWidgetState extends State<PlaneOverEarthWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _bobbingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _bobbingAnimation = Tween<Offset>(
      begin: Offset(0, -0.1), // slight upward
      end: Offset(0, 0.1), // slight downward
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const earthSvg = 'assets/earth-globe-global-svgrepo-com.svg';
    const airplaneSvg = 'assets/airplane-best.svg';

    final double earthSize = 240;
    final double dx = 0;
    final double dy = -earthSize / 2 - 20;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: BlocBuilder<FlightDetailsCubit, FlightDetailsState>(
            builder: (context, state) {
              double stateProgressDegrees = 0.0;
              if (state is FlightDetailsLoaded) {
                stateProgressDegrees = state.flightDetails.progressPercentRaw;
              }
              final angleRadians =
                  (stateProgressDegrees / 100 * 360) * pi / 180;

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        earthSvg,
                        height: earthSize,
                        width: earthSize,
                        semanticsLabel: 'Earth',
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: angleRadians),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, animatedAngle, child) {
                          return Transform.rotate(
                            angle: animatedAngle,
                            child: Transform.translate(
                              offset: Offset(dx, dy),
                              child: SlideTransition(
                                position: _bobbingAnimation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          airplaneSvg,
                          height: 64,
                          width: 64,
                          semanticsLabel: 'Airplane',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MySmallText('$stateProgressDegrees%'),
                      MySmallText('done'),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

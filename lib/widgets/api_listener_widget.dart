import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/pages/home_page.dart';
import 'package:plane_alarm/services/notification_service.dart';

import '../variables/global_variables.dart';

class ApiListenerWidget extends StatelessWidget {
  const ApiListenerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FlightDetailsCubit>().initialize(
      kDebugMode == true ? globalInitialCallsign : "",
    );
    Timer.periodic(const Duration(minutes: globalRefreshDelayMinutes), (_) {
      context.read<FlightDetailsCubit>().refreshCubit();
    });

    return BlocListener<FlightDetailsCubit, FlightDetailsState>(
      listener: (context, state) {
        if (state is FlightDetailsLoaded) {
          final progress = (state.flightDetails.progressPercentRaw).round();
          showProgressStatusBarNotification(progress);
        }
      },
      child: const MyHomePage(title: 'Plane Alarm'),
    );
  }
}

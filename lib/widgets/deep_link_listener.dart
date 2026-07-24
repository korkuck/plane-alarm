import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/deep_link_cubit.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';

class DeepLinkListener extends StatelessWidget {
  final Widget child;

  const DeepLinkListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeepLinkCubit, DeepLinkState>(
      listener: (context, state) {
        if (state is DeepLinkCallsignReceived) {
          final String callsign = state.callsign;
          context.read<FlightDetailsCubit>().setTargetCallsign(callsign);
          debugPrint('Received callsign: $callsign');
        }
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/widgets/delay_widget.dart';
import 'package:plane_alarm/widgets/my_text.dart';

// ...existing code...
class ArrivalInfoWidget extends StatelessWidget {
  const ArrivalInfoWidget({super.key});

  bool _checkIfDelayed(int delayMinutes) {
    return delayMinutes > 15;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightDetailsCubit, FlightDetailsState>(
      builder: (context, state) {
        if (state is FlightDetailsLoading) {
          return const CircularProgressIndicator();
        }

        if (state is FlightDetailsError) {
          return MyBoldText('Error: ${state.message}', color: Colors.red);
        }

        if (state is FlightDetailsLoaded) {
          final arrivalDateLocal =
              state.flightDetails.estimatedInLocal ??
              state.flightDetails.scheduledInLocal;
          if (arrivalDateLocal == null) {
            return const MyBoldText('Arrival time not available');
          }
          final isDelayed = _checkIfDelayed(
            state.flightDetails.arrivalDelayMinutes ?? 0,
          );
          final formattedTime =
              '${arrivalDateLocal.hour.toString().padLeft(2, '0')}:${arrivalDateLocal.minute.toString().padLeft(2, '0')}';
          return Stack(
            children: [
              if (isDelayed)
                Positioned(
                  right: 60,
                  bottom: 32,
                  child: DelayWidget(
                    state.flightDetails.arrivalDelayMinutes ?? 0,
                  ),
                )
              else
                Container(),
              Column(
                children: [
                  const MySmallText('Arriving at'),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child:
                              isDelayed
                                  ? MyBoldTextAlert(formattedTime.toString())
                                  : MyBoldText(formattedTime.toString()),
                        ),
                        Positioned(
                          left: 40,
                          child: Icon(Icons.alarm, size: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return MyBoldText('N/A');
      },
    );
  }
}

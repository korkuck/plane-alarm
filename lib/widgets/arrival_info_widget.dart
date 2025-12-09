import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/widgets/my_text.dart';

// ...existing code...
class ArrivalInfoWidget extends StatelessWidget {
  const ArrivalInfoWidget({super.key});

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
          final arrivalDateRaw = state.data['scheduledInRaw'];
          if (arrivalDateRaw != null) {
            final arrivalDateTime = DateTime.parse(arrivalDateRaw).toLocal();
            final formattedTime =
                '${arrivalDateTime.hour.toString().padLeft(2, '0')}:${arrivalDateTime.minute.toString().padLeft(2, '0')}';
            return Column(
              children: [
                const MySmallText('Arriving at'),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(child: MyBoldText(formattedTime.toString())),
                      Positioned(left: 40, child: Icon(Icons.alarm, size: 40)),
                    ],
                  ),
                ),
              ],
            );
          }

          return MyBoldText('N/A');
        }
        return const MyBoldText('No flight data provided');
      },
    );
  }
}

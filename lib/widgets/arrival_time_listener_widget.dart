import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_destination_cubit.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class ArrivalTimeListenerWidget extends StatelessWidget {
  const ArrivalTimeListenerWidget({super.key});

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
            return MyBoldText(formattedTime.toString());
          }

          return MyBoldText('N/A');
        }
        return const MyBoldText('No flight data provided');
      },
    );
  }
}

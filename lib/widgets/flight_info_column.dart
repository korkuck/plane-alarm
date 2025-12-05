import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/variables/global_variables.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class FlightInfoColumn extends StatelessWidget {
  const FlightInfoColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightDetailsCubit, FlightDetailsState>(
      builder: (context, state) {
        final columnData = {
          'Callsign': ['--'],
          'Date of departure': ['--', '--'],
          'From': ['--', '--'],
          'To': ['--', '--'],
        };

        if (state is FlightDetailsError) {
          return MyBoldText('Error: ${state.message}', color: Colors.red);
        }

        if (state is FlightDetailsLoaded) {
          final data = state.data;
          columnData['Callsign'] = [data['callsign'] ?? 'N/A'];
          columnData['Date of departure'] = [
            data['scheduledOutRaw'] != null
                ? data['scheduledOutRaw'].toString().split('T')[0]
                : 'N/A',
            data['scheduledOutRaw'] != null
                ? data['scheduledOutRaw']
                    .toString()
                    .split('T')[1]
                    .substring(0, 5)
                : 'N/A',
          ];
          columnData['From'] = [
            data['originName'] ?? 'N/A',
            data['originIcao'] ?? 'N/A',
          ];
          columnData['To'] = [
            data['destinationName'] ?? 'N/A',
            data['destinationIcao'] ?? 'N/A',
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColumnItem("Callsign", columnData['Callsign']!, Icons.share),
            ColumnItem(
              "Date of departure",
              columnData['Date of departure']!,
              Icons.calendar_month,
            ),
            ColumnItem("From", columnData['From']!, Icons.pin_drop_outlined),
            ColumnItem("To", columnData['To']!, Icons.pin_drop_rounded),
          ],
        );
      },
    );
  }
}

class ColumnItem extends StatelessWidget {
  final String smallText;
  final List<String> boldTexts;
  final IconData icon;

  const ColumnItem(this.smallText, this.boldTexts, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [MySmallText(smallText), _buildBoldTextRow()],
        ),
        const Spacer(),
        Icon(icon, size: 36),
      ],
    );
  }

  Row _buildBoldTextRow() {
    final List<Widget> widgets = [];

    for (int i = 0; i < boldTexts.length; i++) {
      if (i > 0) {
        widgets.add(const SizedBox(width: 10));
        widgets.add(const MyBoldText('|'));
        widgets.add(const SizedBox(width: 10));
      }
      widgets.add(MyBoldText(boldTexts[i]));
    }

    return Row(children: widgets);
  }
}

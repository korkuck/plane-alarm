import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
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
            data['originIata'] ?? 'N/A',
            data['originName'] ?? 'N/A',
          ];
          columnData['To'] = [
            data['destinationIata'] ?? 'N/A',
            data['destinationName'] ?? 'N/A',
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
            ColumnItem(
              "From",
              columnData['From']!,
              Icons.pin_drop_outlined,
              shouldMarquee: true,
            ),
            ColumnItem(
              "To",
              columnData['To']!,
              Icons.pin_drop_rounded,
              shouldMarquee: true,
            ),
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
  final bool? shouldMarquee;

  static const double spacingWidth = 10.0;

  const ColumnItem(
    this.smallText,
    this.boldTexts,
    this.icon, {
    this.shouldMarquee = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [MySmallText(smallText), _buildBoldTextRow()],
          ),
        ),
        SizedBox(width: spacingWidth),
        Icon(icon, size: 36),
      ],
    );
  }

  Row _buildBoldTextRow() {
    final List<Widget> widgets = [];
    for (int i = 0; i < boldTexts.length - 1; i++) {
      widgets.add(MyBoldText(boldTexts[i]));
      widgets.add(const SizedBox(width: spacingWidth));
      widgets.add(const MyBoldText('|'));
      widgets.add(const SizedBox(width: spacingWidth));
    }
    widgets.add(
      Expanded(
        child:
            shouldMarquee == false
                ? MyBoldText(boldTexts[boldTexts.length - 1])
                : Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    //TODO: Adjust height, for whatever reason ROW height is fontsize + 10
                    height: MyBoldText.defaultFontSize + 10,
                    child: Marquee(
                      text: '${boldTexts[boldTexts.length - 1]} + ',
                      style: MyBoldText.defaultStyle,
                      velocity: 20,
                      startPadding: spacingWidth,
                      startAfter: Duration(seconds: 2),
                    ),
                  ),
                ),
      ),
    );
    return Row(children: widgets);
  }
}

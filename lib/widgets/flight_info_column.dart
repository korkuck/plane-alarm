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
        bool isDiverted = false;

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
          columnData['Date of departure'] = _assignDepartureDate(data);
          columnData['From'] = [
            data['originIata'] ?? 'N/A',
            data['originName'] ?? 'N/A',
          ];
          columnData['To'] = [
            data['destinationIata'] ?? 'N/A',
            data['destinationName'] ?? 'N/A',
          ];
          isDiverted = data['diverted'] ?? false;
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
              isDiverted: isDiverted,
            ),
          ],
        );
      },
    );
  }

  String _formatDate(dynamic rawDate) => rawDate.toString().split('T')[0];
  String _formatTime(dynamic rawDate) =>
      rawDate.toString().split('T')[1].substring(0, 5);

  List<String> _assignDepartureDate(Map<String, dynamic> data) {
    final actualOut = data['actualOutRaw'];
    final scheduledOut = data['scheduledOutRaw'];
    if (actualOut is String && actualOut.isNotEmpty) {
      return [
        _formatDate(data['actualOutRaw']),
        _formatTime(data['actualOutRaw']),
      ];
    }
    if (scheduledOut is String && scheduledOut.isNotEmpty) {
      return [
        _formatDate(data['scheduledOutRaw']),
        _formatTime(data['scheduledOutRaw']),
      ];
    }
    return ['N/A', 'N/A'];
  }
}

class ColumnItem extends StatelessWidget {
  final String smallText;
  final List<String> boldTexts;
  final IconData icon;
  final bool shouldMarquee;
  final bool isDiverted;

  static const double spacingWidth = 10.0;

  const ColumnItem(
    this.smallText,
    this.boldTexts,
    this.icon, {
    this.shouldMarquee = false,
    this.isDiverted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [MySmallText(smallText), _buildBoldTextRow(isDiverted)],
          ),
        ),
        SizedBox(width: spacingWidth),
        Icon(icon, size: 36, color: isDiverted ? Colors.red : Colors.black),
      ],
    );
  }

  Row _buildBoldTextRow(bool isDiverted) {
    final List<Widget> widgets = [];
    for (int i = 0; i < boldTexts.length - 1; i++) {
      widgets.add(_chooseText(boldTexts[i], isDiverted));
      widgets.add(const SizedBox(width: spacingWidth));
      widgets.add(_chooseText('|', isDiverted));
      widgets.add(const SizedBox(width: spacingWidth));
    }
    widgets.add(
      Expanded(
        child:
            shouldMarquee == false
                ? _chooseText(boldTexts.last, isDiverted)
                : SizedBox(
                  height:
                      MyBoldText.defaultFontSize * 1.3, // Approx line height
                  child: Marquee(
                    text: '${boldTexts.last} + ',
                    style:
                        isDiverted
                            ? MyBoldTextAlert.defaultStyle
                            : MyBoldText.defaultStyle,
                    velocity: 20,
                    startPadding: 0,
                    startAfter: Duration(seconds: 2),
                  ),
                ),
      ),
    );
    return Row(children: widgets);
  }

  Widget _chooseText(String text, bool isDiverted) {
    if (isDiverted) {
      return MyBoldTextAlert(text);
    }
    return MyBoldText(text);
  }
}

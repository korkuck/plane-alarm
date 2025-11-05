import 'package:flutter/material.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class FlightInfoColumn extends StatelessWidget {
  const FlightInfoColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColumnItem("Callsign", ["RYR1PA", "FR704"], Icons.share),
        ColumnItem("Date of departure", [
          "23.05.2025",
          "11:25",
        ], Icons.calendar_month),
        ColumnItem("From", ["Chopin Airport", "EPWA"], Icons.pin_drop_outlined),
        ColumnItem("To", ["Goeteborg", "ESGG"], Icons.pin_drop_rounded),
      ],
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

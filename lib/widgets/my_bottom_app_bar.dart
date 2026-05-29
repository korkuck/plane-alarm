import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/theme/my_colors.dart';
import 'package:plane_alarm/widgets/debug_options_popup.dart';
import 'package:plane_alarm/widgets/my_text.dart';
import 'package:plane_alarm/widgets/share_flight_widget.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap:
          (value) => {
            if (value == 0) {_showSearchNewCallsign(context)},
            if (value == 1) {_showShareFlight(context)},
            if (value == 2) {_showDebugOptions(context)},
          },
      backgroundColor: MyColors.backgroundMint,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find New Flight',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Share Flight Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Debug options',
        ),
      ],
    );
  }

  void _showSearchNewCallsign(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newCallsign = '';
        return AlertDialog(
          title: const MyBoldText('Enter New Callsign'),
          content: TextField(
            onChanged: (value) {
              newCallsign = value;
            },
            decoration: const InputDecoration(hintText: "e.g., RYR541A"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                context.read<FlightDetailsCubit>().setTargetCallsign(
                  newCallsign.toUpperCase(),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showShareFlight(BuildContext context) {
    showDialog(context: context, builder: (_) => ShareFlightWidget());
  }

  void _showDebugOptions(BuildContext context) {
    showDialog(context: context, builder: (_) => DebugOptionsPopup());
  }
}

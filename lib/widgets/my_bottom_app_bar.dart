import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/theme/my_colors.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap:
          (value) => {
            if (value == 0) {_showSearchNewCallsign(context)},
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
          label: 'Shate Flight Info',
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

  void _showDebugOptions(BuildContext context) {
    showDialog(context: context, builder: (_) => const _DebugPopup());
  }
}

class _DebugPopup extends StatelessWidget {
  const _DebugPopup();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _item(
              context,
              'Delay +20 min',
              () => context.read<FlightDetailsCubit>().manualDelay(20),
            ),
            _item(
              context,
              'Change destination to EPKT',
              () => context.read<FlightDetailsCubit>().manualChangeDestination(
                'KTW',
                'Katowice',
              ),
            ),
            _item(context, 'Induce emergency', () {}),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String text, VoidCallback onType) {
    return InkWell(
      onTap: () {
        onType();
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Center(child: MySmallText(text, color: Colors.black)),
      ),
    );
  }
}

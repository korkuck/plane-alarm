import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap:
          (value) => {
            if (value == 0) {_showSearchNewCallsign(context)},
          },
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Find New Flight',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Shate Flight Info',
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
}

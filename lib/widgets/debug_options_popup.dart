import 'package:flutter/material.dart';
import 'package:plane_alarm/cubit/flight_details_cubit.dart';
import 'package:plane_alarm/services/resource_cleaner_service.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class DebugOptionsPopup extends StatelessWidget {
  final FlightDetailsCubit flightDetailsCubit;

  const DebugOptionsPopup({super.key, required this.flightDetailsCubit});

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
              () async => flightDetailsCubit.manualDelay(20),
            ),
            _item(
              context,
              'Change destination to EPKT',
              () async =>
                  flightDetailsCubit.manualChangeDestination('KTW', 'Katowice'),
            ),
            _item(context, 'Induce emergency', () async {}),
            _item(
              context,
              'Stop background tracking, clear cache',
              () async =>
                  await stopCallsignTrackingFromUi(context, flightDetailsCubit),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String text,
    Future<void> Function() onType,
  ) {
    return InkWell(
      onTap: () async {
        await onType();
        if (!context.mounted) return;
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

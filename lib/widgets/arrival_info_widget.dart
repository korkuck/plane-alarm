import 'package:flutter/material.dart';
import 'package:plane_alarm/widgets/my_text.dart';

// ...existing code...
class ArrivalInfoWidget extends StatelessWidget {
  const ArrivalInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MySmallText('Arriving at'),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(child: MyBoldText('14:30')),
              Positioned(left: 40, child: Icon(Icons.alarm, size: 40)),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plane_alarm/widgets/my_text.dart';

class DelayWidget extends StatelessWidget {
  final int delayMinutes;

  const DelayWidget(this.delayMinutes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(child: MySmallTextAlert('DELAY +$delayMinutes min')),
    );
  }
}

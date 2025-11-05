import 'package:flutter/material.dart';
import 'package:plane_alarm/theme/my_colors.dart';

class MyBoldText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const MyBoldText(
    this.text, {
    this.color = MyColors.textBlue,
    this.fontSize = 24.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MySmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const MySmallText(
    this.text, {
    this.color = MyColors.textGrey,
    this.fontSize = 12.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

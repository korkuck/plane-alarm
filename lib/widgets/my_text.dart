import 'package:flutter/material.dart';
import 'package:plane_alarm/theme/my_colors.dart';

class MyBoldText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextOverflow? overflow;

  static const TextStyle defaultStyle = TextStyle(
    color: MyColors.textBlue,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  static const double defaultFontSize = 24.0;

  const MyBoldText(
    this.text, {
    this.color = MyColors.textBlue,
    this.fontSize = defaultFontSize,
    this.overflow,
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
        overflow: overflow,
      ),
    );
  }
}

class MySmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextOverflow? overflow;

  const MySmallText(
    this.text, {
    this.color = MyColors.textGrey,
    this.fontSize = 12.0,
    this.overflow,
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
        overflow: overflow,
      ),
    );
  }
}

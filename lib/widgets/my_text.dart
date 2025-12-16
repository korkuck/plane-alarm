import 'package:flutter/material.dart';
import 'package:plane_alarm/theme/my_colors.dart';

class MyBoldText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

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
    this.shadows,
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
        shadows: shadows,
      ),
    );
  }
}

class MySmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;

  static const double smallFontSize = 12.0;

  const MySmallText(
    this.text, {
    this.color = MyColors.textGrey,
    this.fontSize = smallFontSize,
    this.overflow,
    this.shadows,
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
        shadows: shadows,
      ),
    );
  }
}

class MyBoldTextAlert extends MyBoldText {
  const MyBoldTextAlert(
    super.text, {
    super.color = Colors.red,
    super.fontSize = MyBoldText.defaultFontSize,
    super.overflow,
    super.shadows = const [
      Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
    ],
    super.key,
  });

  static const TextStyle defaultStyle = TextStyle(
    color: Colors.red,
    fontSize: MyBoldText.defaultFontSize,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
    ],
  );
}

class MySmallTextAlert extends MySmallText {
  const MySmallTextAlert(
    super.text, {
    super.color = Colors.red,
    super.fontSize = MySmallText.smallFontSize,
    super.overflow,
    super.key,
  });
}

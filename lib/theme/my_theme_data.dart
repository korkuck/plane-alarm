import 'package:flutter/material.dart';
import 'package:plane_alarm/theme/my_colors.dart';

class MyThemeData {
  static final ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.textBlue),
    scaffoldBackgroundColor: MyColors.backgroundWhite,
    useMaterial3: true,
  );
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class MyChipTheme {
  MyChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Mycolors.grey.withValues(alpha: 0.4),
    labelStyle: TextStyle(color: Mycolors.black),
    selectedColor: Mycolors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: Mycolors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Mycolors.grey.withValues(alpha: 0.4),
    labelStyle: TextStyle(color: Mycolors.white),
    selectedColor: Mycolors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: Mycolors.white,
  );
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/widgets_theme/OutLineButtonTheme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/appbar_theme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/bottom_sheet_theme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/checkBox_theme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/chip_theme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/elevatedButtonTheme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/inputDecorationTheme.dart';
import 'package:whats_app/utiles/theme/widgets_theme/text_theme.dart';

class Mytheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Nunito",
    brightness: Brightness.light,
    primaryColor: Mycolors.primary,
    disabledColor: Mycolors.grey,
    textTheme: MyTextTheme.lightTextTheme,
    chipTheme: MyChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Mycolors.white,
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    checkboxTheme: MyCheckboxTheme.lightCheckBoxTheme,
    bottomSheetTheme: MyBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlineButtonTheme.lightOutlineButtonTheme,
    inputDecorationTheme: MyInputDecorationTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Nunito",
    brightness: Brightness.dark,
    primaryColor: Mycolors.primary,
    disabledColor: Mycolors.grey,
    textTheme: MyTextTheme.darkTextTheme,
    chipTheme: MyChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Mycolors.black,
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    checkboxTheme: MyCheckboxTheme.darkCheckBoxTheme,
    bottomSheetTheme: MyBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlineButtonTheme.darkOutlineButtonTheme,
    inputDecorationTheme: MyInputDecorationTheme.darkInputDecorationTheme,
  );
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Mycolors.light,
      backgroundColor: Mycolors.primary,
      disabledForegroundColor: Mycolors.darkGrey,
      disabledBackgroundColor: Mycolors.buttonDisabled,
      side: BorderSide(color: Mycolors.light),
      padding: EdgeInsets.symmetric(vertical: Mysize.buttonHeight),
      textStyle: TextStyle(
        fontSize: 16,
        color: Mycolors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mysize.buttonRadius),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: Mycolors.light,
      backgroundColor: Mycolors.primary,
      disabledForegroundColor: Mycolors.darkGrey,
      disabledBackgroundColor: Mycolors.buttonDisabled,
      side: BorderSide(color: Mycolors.light),
      padding: EdgeInsets.symmetric(vertical: Mysize.buttonHeight),
      textStyle: TextStyle(
        fontSize: 16,
        color: Mycolors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mysize.buttonRadius),
      ),
    ),
  );
}

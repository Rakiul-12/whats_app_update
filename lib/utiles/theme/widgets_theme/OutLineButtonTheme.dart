import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class MyOutlineButtonTheme {
  MyOutlineButtonTheme._();

  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Mycolors.dark,
      side: const BorderSide(color: Mycolors.borderPrimary),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Mycolors.black,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Mysize.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mysize.buttonRadius),
      ),
    ),
  );

  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Mycolors.light,
      side: const BorderSide(color: Mycolors.borderPrimary),
      textStyle: const TextStyle(
        fontSize: 16,
        color: Mycolors.textWhite,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Mysize.buttonHeight,
        horizontal: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Mysize.buttonRadius),
      ),
    ),
  );
}

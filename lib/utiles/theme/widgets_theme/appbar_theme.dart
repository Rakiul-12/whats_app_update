import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static final lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Mycolors.black, size: Mysize.iconMd),
    actionsIconTheme: const IconThemeData(
      color: Mycolors.black,
      size: Mysize.iconMd,
    ),
    titleTextStyle: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.black,
    ),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Mycolors.white, size: Mysize.iconMd),
    actionsIconTheme: IconThemeData(color: Mycolors.white, size: Mysize.iconMd),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.white,
    ),
  );
}

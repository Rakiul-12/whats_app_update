import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class MyTextTheme {
  MyTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Mycolors.dark,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.dark,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Mycolors.dark,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.dark,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.dark,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Mycolors.dark,
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.dark,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.dark,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.dark.withValues(alpha: 0.5),
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.dark,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.dark.withValues(alpha: 0.5),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Mycolors.light,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.light,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Mycolors.light,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Mycolors.light,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.light,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Mycolors.light,
    ),

    bodyLarge: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.light,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.light,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Mycolors.light.withValues(alpha: 0.5),
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.light,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Mycolors.light.withValues(alpha: 0.5),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class MyInputDecorationTheme {
  MyInputDecorationTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Mycolors.darkGrey,
    suffixIconColor: Mycolors.darkGrey,
    labelStyle: const TextStyle().copyWith(
      fontSize: Mysize.fontSizeMd,
      color: Mycolors.black,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: Mysize.fontSizeSm,
      color: Mycolors.black,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Mycolors.black.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: Mycolors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: Mycolors.darkGrey,
    suffixIconColor: Mycolors.darkGrey,
    labelStyle: const TextStyle().copyWith(
      fontSize: Mysize.fontSizeMd,
      color: Mycolors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: Mysize.fontSizeSm,
      color: Mycolors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Mycolors.white.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: Mycolors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(Mysize.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: Mycolors.warning),
    ),
  );
}

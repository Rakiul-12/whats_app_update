import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class MyBottomSheetTheme {
  MyBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Mycolors.white,
    modalBackgroundColor: Mycolors.white,
    constraints: BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Mycolors.black,
    modalBackgroundColor: Mycolors.black,
    constraints: BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

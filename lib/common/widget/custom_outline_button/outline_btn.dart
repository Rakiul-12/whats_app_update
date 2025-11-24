import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class Custom_button extends StatelessWidget {
  const Custom_button({super.key, required this.text, required this.icon});

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return SizedBox(
      height: Mysize.buttonHeight * 3,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? Mycolors.borderPrimary : Mycolors.textPrimary,
            width: 1.5,
          ),
          shadowColor: isDark ? Mycolors.borderPrimary : Mycolors.textPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: Mysize.sm),
            Text(text),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class MyCircularIcon extends StatelessWidget {
  const MyCircularIcon({
    super.key,
    this.width,
    this.height,
    this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,
    this.size = Mysize.iconMd,
  });

  final double? width, height, size;
  final IconData? icon;
  final Color? color, backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunction.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (backgroundColor != null)
            ? backgroundColor
            : dark
            ? Mycolors.dark.withValues(alpha: .9)
            : Mycolors.light.withValues(alpha: .9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: size),
      ),
    );
  }
}

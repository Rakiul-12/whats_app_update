import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/device_helper.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    bool dark = MyHelperFunction.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Mysize.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Iconsax.arrow_left,
                  color: dark ? Mycolors.white : Mycolors.dark,
                ),
              )
            : leadingIcon != null
            ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
            : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MyDeviceHelper.getAppBarHeight());
}

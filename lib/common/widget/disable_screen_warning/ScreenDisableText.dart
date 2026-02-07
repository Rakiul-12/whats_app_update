import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class ScreenDisableWarningText extends StatelessWidget {
  const ScreenDisableWarningText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            MyImage.lockAnimation,
            width: Get.width * 0.8,
            height: Get.height * 0.2,
            fit: BoxFit.contain,
          ),

          SizedBox(height: Mysize.spaceBtwInputFields),
          Text(
            "This screen is currently disabled \n We are working to fix it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Mycolors.light,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

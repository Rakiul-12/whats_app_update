import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class MyAnimationLoader extends StatelessWidget {
  final String text;
  final String animation;
  final bool showActionButton;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const MyAnimationLoader({
    super.key,
    required this.text,
    this.animation = MyImage.loadingAnimation,
    this.showActionButton = false,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Animation
            Lottie.asset(animation, width: Get.width * 0.8),
            const SizedBox(height: Mysize.defaultSpace),

            /// Title
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Mysize.defaultSpace),

            showActionButton
                ? SizedBox(
                    width: 250,
                    child: OutlinedButton(
                      onPressed: onActionPressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Mycolors.dark,
                      ),
                      child: Text(
                        actionText!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(color: Mycolors.light),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

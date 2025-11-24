import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/common/widget/button/MyElevatedButton.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/authentication/screens/log_in_screen/log_in_screen.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class welcome_screen extends StatelessWidget {
  const welcome_screen({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = MyHelperFunction.isDarkMode(context);
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: Mysize.iconLg),
        child: MyElevatedButton(
          onPressed: () => Get.to(() => Log_in_screen()),
          text: MyText.welcome_screen_btn_text,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Center(
        child: Padding(
          padding: MyPadding.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // welcome image
              Image.asset(MyImage.onWelcomeScreen),

              SizedBox(height: Mysize.spaceBtwItems),

              // welcome text
              Text(
                MyText.welcome_text,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: Mysize.spaceBtwItems),

              // privacy policy text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: dark ? Mycolors.light : Colors.black,
                    height: 1.8,
                  ),
                  children: [
                    TextSpan(text: 'Read out '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: Mycolors.primary),
                    ),
                    TextSpan(text: '. Tap “Agree and continue”\n'),
                    TextSpan(text: 'to accept the '),
                    TextSpan(
                      text: 'Terms of Service.',
                      style: TextStyle(color: Mycolors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

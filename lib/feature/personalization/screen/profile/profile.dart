import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/common/widget/button/MyElevatedButton.dart';
import 'package:whats_app/common/widget/profile_picture/custom_profile_picture.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/NavBar/navbar.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class profile_screen extends StatelessWidget {
  const profile_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        // margin: EdgeInsets.only(bottom: Mysize.iconLg),
        child: MyElevatedButton(
          onPressed: () => Get.offAll(() => navigationMenuScreen()),
          text: "Next",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: Center(
        child: Padding(
          padding: MyPadding.screenPadding,
          child: Padding(
            padding: const EdgeInsets.only(top: 20 * 2),
            child: Column(
              children: [
                // profile picture
                Text(
                  MyText.profile_picture,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: Mysize.spaceBtwSections),

                // Profile picture
                Profile_picture(radius: 40 * 2, icon: Iconsax.edit),

                SizedBox(height: Mysize.spaceBtwSections * 2),

                // Name_filed
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter your name...",
                    suffixIcon: Icon(Iconsax.emoji_happy),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

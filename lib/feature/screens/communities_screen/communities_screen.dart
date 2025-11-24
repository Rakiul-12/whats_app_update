import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_app/common/widget/button/MyElevatedButton.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/screens/communities_screen/widgets/text_section.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class communities_screen extends StatelessWidget {
  const communities_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(
          "Communities",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),

      body: Padding(
        padding: MyPadding.screenPadding,
        child: Column(
          children: [
            // Animation_section
            Padding(
              padding: const EdgeInsets.only(top: Mysize.md),
              child: Center(
                child: Lottie.asset(
                  MyImage.onCommunityScreen,
                  width: Mysize.animationwidth,
                  height: Mysize.animationHeight,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ),
            ),
            SizedBox(height: Mysize.spaceBtwSections),
            // Text_section
            text_section_on_community(),

            SizedBox(height: Mysize.spaceBtwItems),

            // Button
            MyElevatedButton(
              onPressed: () {},
              text: MyText.community_screen_4th_btn_text,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_app/common/widget/button/MyElevatedButton.dart';
import 'package:whats_app/common/widget/disable_screen_warning/ScreenDisableText.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/screens/communities_screen/widgets/text_section.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isScreenDisabled = true;
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(
          "Communities",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),

      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: isScreenDisabled,
            child: Opacity(
              opacity: isScreenDisabled ? 0.4 : 1,
              child: Padding(
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
            ),
          ),
          if (isScreenDisabled) ScreenDisableWarningText(),
        ],
      ),
    );
  }
}

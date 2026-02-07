import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/common/widget/custom_outline_button/outline_btn.dart';
import 'package:whats_app/common/widget/disable_screen_warning/ScreenDisableText.dart';
import 'package:whats_app/common/widget/section_heading/section_heading.dart';
import 'package:whats_app/common/widget/status_widget/update_screen_status_widget.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/screens/update_screen/widgets/fing_channel_section.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyHelperFunction.isDarkMode(context);

    final bool isScreenDisabled = true;

    return Scaffold(
      //App bar
      appBar: AppBar(
        title: Text(
          MyText.Update,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [Icon(Icons.search), Icon(Icons.more_vert)],
      ),

      //FLOATING BUTTONS
      floatingActionButton: AbsorbPointer(
        absorbing: isScreenDisabled,
        child: Opacity(
          opacity: isScreenDisabled ? 0.4 : 1,
          child: _floatingButtons(isDark),
        ),
      ),

      body: Stack(
        children: [
          //disable contant
          AbsorbPointer(
            absorbing: isScreenDisabled,
            child: Opacity(
              opacity: isScreenDisabled ? 0.4 : 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: MyPadding.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status title
                      Text(
                        MyText.Update_status,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: Mysize.spaceBtwInputFields),

                      // Status widget
                      status_widget(),
                      SizedBox(height: Mysize.spaceBtwSections),

                      // Channels section
                      Text(
                        MyText.Channels,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: Mysize.sm),
                      Text(MyText.stay_update_text),
                      SizedBox(height: Mysize.spaceBtwItems),

                      // Find channel
                      MySectionHeading(title: MyText.find_channel),
                      SizedBox(height: Mysize.spaceBtwItems),
                      find_channel_section(),

                      // Buttons
                      Custom_button(
                        icon: Iconsax.activity,
                        text: "Explore more",
                      ),
                      SizedBox(height: Mysize.spaceBtwItems),
                      Custom_button(icon: Iconsax.add, text: "Create Channel"),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // disabled overlay
          if (isScreenDisabled) ScreenDisableWarningText(),
        ],
      ),
    );
  }
}

// floating button widget
Widget _floatingButtons(bool isDark) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // Edit button
      SizedBox(
        height: 40,
        width: 40,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: isDark ? Mycolors.light : Mycolors.dark,
          ),
          child: Icon(
            Iconsax.edit_2,
            size: Mysize.iconMd,
            color: isDark ? Mycolors.dark : Mycolors.light,
          ),
        ),
      ),

      SizedBox(height: Mysize.sm),

      // Camera button
      SizedBox(
        height: Mysize.floatingButtonHeight,
        width: Mysize.anotherfloatingButtonWidth,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: const Color.fromARGB(255, 2, 173, 65),
          ),
          child: Icon(
            Icons.camera_enhance_rounded,
            size: Mysize.iconMd,
            color: isDark ? Mycolors.dark : Mycolors.light,
          ),
        ),
      ),
    ],
  );
}

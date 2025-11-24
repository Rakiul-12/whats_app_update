import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class text_section_on_community extends StatelessWidget {
  const text_section_on_community({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text_section
        Text(
          MyText.community_screen_1st_text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: Mysize.sm),
        Text(textAlign: TextAlign.center, MyText.community_screen_2nd_text),

        SizedBox(height: Mysize.sm),
        // Text with button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              MyText.community_screen_3rd_text,
              style: TextStyle(color: Mycolors.buttonPrimary),
            ),
            SizedBox(width: Mysize.xs),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: Mysize.buttonRadius,
              color: Mycolors.buttonPrimary,
            ),
          ],
        ),
      ],
    );
  }
}

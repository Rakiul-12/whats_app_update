import 'package:flutter/material.dart';
import 'package:whats_app/common/widget/profile_picture/custom_profile_picture.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class status_widget extends StatelessWidget {
  const status_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Profile_picture(radius: 30, icon: Icons.add),
        SizedBox(width: Mysize.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MyText.add_status,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Text(MyText.Disappeares_test),
          ],
        ),
      ],
    );
  }
}

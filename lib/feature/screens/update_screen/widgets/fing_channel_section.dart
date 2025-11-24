import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/const/text.dart';

class find_channel_section extends StatelessWidget {
  const find_channel_section({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(height: Mysize.sm),
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      padding: EdgeInsets.only(right: 5),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 3),
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(MyImage.onProfileScreen),
          ),
          title: Text(
            maxLines: 1,
            MyText.channel_name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Text("150k followrs"),
          trailing: SizedBox(
            width: 90,
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color.fromARGB(255, 52, 97, 69),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                "Follow",
                style: TextStyle(fontSize: 14, color: Mycolors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class Calls_list extends StatelessWidget {
  const Calls_list({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: Mysize.sm),
      shrinkWrap: true,
      itemCount: 14,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 3),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(MyImage.onProfileScreen),
          ),
          title: Text(
            "Rakibul Islam",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: isDark ? Mycolors.borderPrimary : Mycolors.textPrimary,
            ),
          ),
          subtitle: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            "Today, 10:27 am",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: isDark ? Mycolors.borderPrimary : Mycolors.textPrimary,
            ),
          ),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.call)),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/common/widget/appbar/MyAppBar.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/utiles/theme/const/image.dart';

class openProfile extends StatelessWidget {
  const openProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments as UserModel;
    return Scaffold(
      appBar: MyAppbar(
        title: Text(
          "Profile photo",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.download_sharp)),
        ],
        showBackArrow: true,
      ),
      body: Center(
        child: Hero(
          tag: user.id,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 180),
            child: user.profilePicture.isNotEmpty
                ? CachedNetworkImage(
                    key: ValueKey(user.profilePicture),
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: user.profilePicture,
                    placeholder: (_, __) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (c, url, err) =>
                        CircleAvatar(child: Icon(Iconsax.user)),
                  )
                : Image.asset(
                    MyImage.onProfileScreen,
                    key: ValueKey('default'),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}

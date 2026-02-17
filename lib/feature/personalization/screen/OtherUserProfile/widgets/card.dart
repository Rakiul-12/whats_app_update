import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/common/widget/CustomCard/MyCustomCard.dart';
import 'package:whats_app/common/widget/ZegoCallBtn/ZegoCallBtn.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';

class OtherUserCard extends StatelessWidget {
  const OtherUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments as UserModel;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // message card
        MyCustomCard(
          user: user,
          onTap: () => Get.to(ChattingScreen(), arguments: user),
          child: Column(
            children: [
              SizedBox(height: 5),
              Icon(
                Iconsax.message,
                color: const Color.fromARGB(255, 58, 195, 65),
              ),
              SizedBox(height: Mysize.sm),
              Text("Message"),
            ],
          ),
        ),
        SizedBox(width: Mysize.md),

        // audio call card
        MyCustomCard(
          user: user,
          child: Column(
            children: [
              ZegoCallInvitationButton(
                otherUser: user,
                isVideo: false,
                icon: Iconsax.call,
                color: Color.fromARGB(255, 58, 195, 65),
                text: "audio",
              ),
              Text("Audio call"),
            ],
          ),
        ),
        SizedBox(width: Mysize.md),

        // video call card
        MyCustomCard(
          user: user,
          child: Column(
            children: [
              ZegoCallInvitationButton(
                otherUser: user,
                isVideo: true,
                icon: Iconsax.video,
                color: const Color.fromARGB(255, 58, 195, 65),
                text: 'video',
              ),
              Text("Video call"),
            ],
          ),
        ),
      ],
    );
  }
}

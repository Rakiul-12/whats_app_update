import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/common/widget/chatting_app_bar/chatting_app_bar.dart';
import 'package:whats_app/feature/Chatting_screen/widget/message_card.dart';
import 'package:whats_app/feature/Chatting_screen/widget/text_field.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/feature/authentication/backend/chatController/ChatController.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattingScreen extends StatelessWidget {
  const ChattingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = MyHelperFunction.isDarkMode(context);

    // User passed from chat list
    final UserModel otherUser = Get.arguments as UserModel;

    // Create ChatController for this screen
    Get.put(ChatController(otherUser));

    final allMessage = Messagerepository.GetAllMessage(otherUser);

    return Scaffold(
      appBar: ChatAppBar(
        name: otherUser.username,
        subtitle: otherUser.isOnline ? "Online" : "Offline",
        avatarImage: otherUser.profilePicture.isNotEmpty
            ? NetworkImage(otherUser.profilePicture)
            : AssetImage(MyImage.onProfileScreen),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// messages list
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: allMessage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Say hi 👋, no messages yet"),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index].data();
                      return MessageCard(message: msg);
                    },
                  );
                },
              ),
            ),

            /// bottom input
            Text_filed(),
          ],
        ),
      ),
    );
  }
}

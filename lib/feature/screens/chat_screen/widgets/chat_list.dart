import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/data/repository/user/UserRepository.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class chat_screen_chat_list extends StatelessWidget {
  const chat_screen_chat_list({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRepository());
    final isDark = MyHelperFunction.isDarkMode(context);
    final messageRepo = Get.put(Messagerepository());
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.getAllUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final docs = snapshot.data!.docs;

          // Convert each document to UserModel
          final List<UserModel> users = docs
              .map((doc) => UserModel.fromSnapshot(doc))
              .toList();

          return ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: Mysize.spaceBtwInputFields),
            itemCount: users.length,
            itemBuilder: (context, index) {
  final user = users[index];
  final String myId = FirebaseAuth.instance.currentUser!.uid;

  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: Messagerepository.GetLastMessage(user),
    builder: (context, lastSnap) {
      String subtitleText = user.about;     
      String timeText = '';                
      FontWeight nameWeight = FontWeight.normal;

      if (lastSnap.hasData && lastSnap.data!.docs.isNotEmpty) {
        final lastDoc = lastSnap.data!.docs.first;
        final data = lastDoc.data();

        final String lastMsg = (data['msg'] ?? '').toString();
        final dynamic sentTime = data['sent'];
        final String read = (data['read'] ?? '').toString();
        final String fromId = (data['fromId'] ?? '').toString();
        final String toId = (data['toId'] ?? '').toString();

        // show last message text
        subtitleText = lastMsg;

        // formatted time of last message
        timeText = Messagerepository.getFormattedTime(
          context: context,
          time: sentTime,
        );

        // unread message check
        final bool isUnread = (toId == myId) && read.isEmpty;
        nameWeight = isUnread ? FontWeight.bold : FontWeight.normal;
      }

      return ListTile(
        onTap: () {
          Get.to(() => const ChattingScreen(), arguments: user);
        },
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: user.profilePicture.isNotEmpty
              ? NetworkImage(user.profilePicture)
              : const AssetImage(MyImage.onProfileScreen) as ImageProvider,
        ),

        // bold if last message is unread
        title: Text(
          user.username,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: isDark
                    ? Mycolors.borderPrimary
                    : Mycolors.textPrimary,
                fontWeight: nameWeight,
              ),
        ),

        // LAST MESSAGE  ABOUT
        subtitle: Text(
          subtitleText,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: isDark
                    ? Mycolors.borderPrimary
                    : Mycolors.textPrimary,
              ),
        ),

        // TIME 
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeText,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: isDark
                        ? Mycolors.borderPrimary
                        : Mycolors.textPrimary,
                  ),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: const BoxDecoration(
                color: Mycolors.success,
                shape: BoxShape.circle,
              ),
              child: const Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
},

          );
        },
      ),
    );
  }
}

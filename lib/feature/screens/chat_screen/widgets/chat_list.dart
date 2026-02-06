import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/data/repository/user/UserRepository.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:whats_app/feature/authentication/backend/chat_list_controller/chatListController.dart';
import 'package:whats_app/feature/screens/chat_screen/widgets/user_profile_dialog.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class ChatScreenChatList extends StatelessWidget {
  const ChatScreenChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRepository());
    final isDark = MyHelperFunction.isDarkMode(context);
    final String myId = FirebaseAuth.instance.currentUser!.uid;
    final chatListController = Get.put(ChatListController());

    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.getAllUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No chats"));
          }

          final allUsers = snapshot.data!.docs
              .map((doc) => UserModel.fromSnapshot(doc))
              .where((u) => u.id != myId)
              .toList();

          //  deleted chat
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(myId)
                .collection('deleted_chats')
                .snapshots(),
            builder: (context, deletedSnap) {
              final deletedIds = deletedSnap.hasData
                  ? deletedSnap.data!.docs.map((e) => e.id).toSet()
                  : <String>{};

              final users = allUsers
                  .where((user) => !deletedIds.contains(user.id))
                  .toList();

              if (users.isEmpty) {
                return Center(child: Text("No chats"));
              }

              return ListView.separated(
                separatorBuilder: (_, __) =>
                    SizedBox(height: Mysize.spaceBtwInputFields),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: Messagerepository.GetLastMessage(user),
                    builder: (context, lastSnap) {
                      String subtitleText = user.about;
                      String timeText = '';
                      FontWeight nameWeight = FontWeight.normal;

                      // logic for subtitle text with message type
                      if (lastSnap.hasData && lastSnap.data!.docs.isNotEmpty) {
                        final data = lastSnap.data!.docs.first.data();

                        final String msg = data['msg'] ?? '';
                        final dynamic sentTime = data['sent'];
                        final String read = data['read'] ?? '';
                        final String toId = data['toId'] ?? '';
                        final String type = data['type'] ?? 'text';

                        final Map<String, dynamic> deletedBy =
                            data['deletedBy'] ?? {};
                        final bool isDeletedForMe = deletedBy[myId] == true;

                        if (isDeletedForMe) {
                          subtitleText = user.about;
                        } else {
                          if (type == 'image') {
                            subtitleText = "📸 Image";
                          } else if (type == 'call') {
                            subtitleText = "📞 Call";
                          } else {
                            subtitleText = msg;
                          }
                        }

                        timeText = Messagerepository.getLastMessageTime(
                          context: context,
                          time: sentTime,
                        );

                        if (toId == myId && read.isEmpty) {
                          nameWeight = FontWeight.bold;
                        }
                      }

                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: Messagerepository.getUnreadMessage(user),
                        builder: (context, unreadSnap) {
                          final unreadCount = unreadSnap.data?.docs.length ?? 0;

                          final hasUnread = unreadCount > 0;

                          return ListTile(
                            onLongPress: () {
                              chatListController.selectUser(user);
                            },
                            onTap: () =>
                                Get.to(() => ChattingScreen(), arguments: user),
                            leading: GestureDetector(
                              onTap: () => showUesrDialog(context, user),
                              child: Hero(
                                tag: user.id,
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      user.profilePicture.isNotEmpty
                                      ? NetworkImage(user.profilePicture)
                                      : AssetImage(MyImage.onProfileScreen),
                                ),
                              ),
                            ),
                            title: Text(
                              user.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontWeight: hasUnread
                                        ? FontWeight.bold
                                        : nameWeight,
                                    color: isDark
                                        ? Mycolors.borderPrimary
                                        : Mycolors.textPrimary,
                                  ),
                            ),
                            subtitle: Text(
                              subtitleText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: hasUnread
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(timeText),
                                if (hasUnread)
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Mycolors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
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
              );
            },
          );
        },
      ),
    );
  }
}

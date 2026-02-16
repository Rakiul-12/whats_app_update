import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/feature/screens/chat_screen/controller/searchController.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class ChatSearchResults extends StatelessWidget {
  const ChatSearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatSearchController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: CircularProgressIndicator(
              color: Mycolors.success,
              strokeWidth: 1,
            ),
          ),
        );
      }

      if (controller.error.value != null) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Text(controller.error.value!),
        );
      }

      if (controller.results.isEmpty) {
        return SizedBox.shrink();
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.results.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = controller.results[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: (user.profilePicture.isNotEmpty)
                  ? NetworkImage(user.profilePicture)
                  : null,
              child: (user.profilePicture.isEmpty) ? Icon(Icons.person) : null,
            ),
            title: Text(user.username),
            subtitle: Text(user.about),
            onTap: () {
              Get.to(ChattingScreen(), arguments: user);
            },
          );
        },
      );
    });
  }
}

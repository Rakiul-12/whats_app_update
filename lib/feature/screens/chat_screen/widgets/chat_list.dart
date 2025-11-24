import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class chat_screen_chat_list extends StatelessWidget {
  const chat_screen_chat_list({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = MyHelperFunction.isDarkMode(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.to(() => ChattingScreen()),
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              SizedBox(height: Mysize.defaultSpace),
          shrinkWrap: true,
          itemCount: 14,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 24,
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
                "Hi,there! I'm using whatsApp.",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: isDark ? Mycolors.borderPrimary : Mycolors.textPrimary,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time at the top
                  Text(
                    "12:45 AM",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: isDark
                          ? Mycolors.borderPrimary
                          : Mycolors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Unread message count bubble at the bottom
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
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
        ),
      ),
    );
  }
}

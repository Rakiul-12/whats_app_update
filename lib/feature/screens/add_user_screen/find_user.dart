import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/common/widget/appbar/MyAppBar.dart';
import 'package:whats_app/feature/Chatting_screen/chatting_screen.dart';
import 'package:whats_app/feature/authentication/backend/find_user/find_user_controller.dart';

class FindUser extends StatelessWidget {
  const FindUser({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FindUserController());

    return Scaffold(
      appBar: MyAppbar(
        title: Text(
          "Find user",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadAllAndFilter,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text(controller.status.value),
              ],
            ),
          );
        }

        return ListView(
          children: [
            // ✅ TOP: Users using this app
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(
                "Users using this app (${controller.registeredUsers.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            if (controller.registeredUsers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(controller.status.value),
              )
            else
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.registeredUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final u = controller.registeredUsers[index];
                    final name = u.username.isEmpty ? "Unknown" : u.username;

                    return InkWell(
                      onTap: () {
                        Get.to(() => const ChattingScreen(), arguments: u);
                      },
                      child: Container(
                        width: 140,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black12,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : "?",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 14),
            const Divider(height: 1),

            // ✅ FULL CONTACTS LIST
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(
                "All contacts (${controller.contacts.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            if (controller.contacts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text("No contacts found"),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.contacts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final contact = controller.contacts[index];
                  final name = contact.displayName.isEmpty
                      ? "Unknown"
                      : contact.displayName;
                  final phone = controller.firstPhone(contact);

                  final isReg = controller.isRegisteredContact(contact);

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                      ),
                    ),
                    title: Text(name),
                    subtitle: Text(phone.isEmpty ? "No phone number" : phone),
                    trailing: isReg ? const Text("Registered") : const Text(""),
                    onTap: isReg
                        ? () {
                            final user = controller.matchedUser(contact);
                            if (user != null) {
                              Get.to(
                                () => const ChattingScreen(),
                                arguments: user,
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
          ],
        );
      }),
    );
  }
}

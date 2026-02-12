import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/feature/NavBar/widgets/callCount.dart';
import 'package:whats_app/feature/NavBar/widgets/navbarController.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class NavigationMenuScreen extends StatelessWidget {
  const NavigationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunction.isDarkMode(context);

    final nav = Get.put(NavigationController());

    final missedCallsStream = nav.missedRejectedBadgeCount();

    return Scaffold(
      body: Obx(() => nav.screens[nav.selectedIndex.value]),
      bottomNavigationBar: StreamBuilder<int>(
        stream: missedCallsStream,
        builder: (context, snap) {
          final count = snap.data ?? 0;

          return Obx(
            () => NavigationBar(
              indicatorColor: dark
                  ? const Color.fromARGB(255, 2, 173, 65).withValues(alpha: .4)
                  : Mycolors.dark.withValues(alpha: .1),
              selectedIndex: nav.selectedIndex.value,
              onDestinationSelected: (index) async {
                nav.selectedIndex.value = index;

                if (index == 3) {
                  await nav.markAllBadCallsSeen();
                }
              },
              destinations: [
                const NavigationDestination(
                  icon: Icon(Iconsax.message),
                  label: "Chats",
                ),
                const NavigationDestination(
                  icon: Icon(Iconsax.message_square4),
                  label: "Updates",
                ),
                const NavigationDestination(
                  icon: Icon(Iconsax.people),
                  label: "Communities",
                ),
                Stack(
                  children: [
                    NavigationDestination(
                      icon: NavBadgeIcon(icon: Iconsax.call, count: count),
                      label: "Calls",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

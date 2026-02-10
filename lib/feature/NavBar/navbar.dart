import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:whats_app/feature/screens/calls_screen/calls_screen.dart';
import 'package:whats_app/feature/screens/chat_screen/chat_screen.dart';
import 'package:whats_app/feature/screens/communities_screen/communities_screen.dart';
import 'package:whats_app/feature/screens/update_screen/update_screen.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class NavigationMenuScreen extends StatelessWidget {
  const NavigationMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = MyHelperFunction.isDarkMode(context);
    final nav = Get.put(NavigationController());
    final myId = FirebaseAuth.instance.currentUser!.uid;

    //  count missed calls
    final missedCallsStream = FirebaseFirestore.instance
        .collection(MyKeys.callCollection)
        .where("participants", arrayContains: myId)
        .where("status", isEqualTo: "missed")
        .snapshots()
        .map((s) => s.docs.length);

    return Scaffold(
      body: Obx(() => nav.screens[nav.selectedIndex.value]),
      bottomNavigationBar: StreamBuilder<int>(
        stream: missedCallsStream,
        builder: (context, snap) {
          final count = snap.data ?? 0;

          return Obx(
            () => NavigationBar(
              elevation: 0,
              selectedIndex: nav.selectedIndex.value,
              backgroundColor: dark ? Mycolors.dark : Mycolors.light,
              indicatorColor: dark
                  ? Color.fromARGB(255, 2, 173, 65).withValues(alpha: .2)
                  : Mycolors.dark.withValues(alpha: .1),
              onDestinationSelected: (index) => nav.selectedIndex.value = index,
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

                NavigationDestination(
                  icon: _NavBadgeIcon(icon: Iconsax.call, count: count),
                  label: "Calls",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    ChatScreen(),
    UpdateScreen(),
    CommunitiesScreen(),
    CallScreen(),
  ];
}

class _NavBadgeIcon extends StatelessWidget {
  const _NavBadgeIcon({required this.icon, required this.count});

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              height: 18,
              padding: EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 215, 23, 23),
                shape: BoxShape.circle,
              ),
              child: Text(
                count > 99 ? "99+" : count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

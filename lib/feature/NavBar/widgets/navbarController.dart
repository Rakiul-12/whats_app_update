import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/screens/calls_screen/calls_screen.dart';
import 'package:whats_app/feature/screens/chat_screen/chat_screen.dart';
import 'package:whats_app/feature/screens/communities_screen/communities_screen.dart';
import 'package:whats_app/feature/screens/update_screen/update_screen.dart';
import 'package:whats_app/utiles/const/keys.dart';

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();

  final RxInt selectedIndex = 0.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<Widget> screens = [
    ChatScreen(),
    UpdateScreen(),
    CommunitiesScreen(),
    CallScreen(),
  ];

  Future<void> markAllBadCallsSeen() async {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    final snap = await _db
        .collection(MyKeys.callCollection)
        .where("participants", arrayContains: myId)
        .get();

    final batch = _db.batch();

    for (final doc in snap.docs) {
      final d = doc.data();

      final status = (d["status"] ?? "").toString().toLowerCase();
      final receiverId = (d["receiverId"] ?? "").toString();

      // ✅ only incoming calls
      if (receiverId != myId) continue;

      final isBad =
          status == "missed" || status == "rejected" || status == "declined";
      if (!isBad) continue;

      final seenBy = Map<String, dynamic>.from(d["seenBy"] ?? {});
      if (seenBy[myId] == true) continue;

      batch.update(doc.reference, {"seenBy.$myId": true});
    }

    await batch.commit();
  }

  Stream<int> missedRejectedBadgeCount() {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    return _db
        .collection(MyKeys.callCollection)
        .where("participants", arrayContains: myId)
        .snapshots()
        .map((s) {
          int count = 0;

          for (final doc in s.docs) {
            final d = doc.data();

            final status = (d["status"] ?? "").toString().toLowerCase();
            final receiverId = (d["receiverId"] ?? "").toString();

            // ✅ only incoming calls
            if (receiverId != myId) continue;

            final isBad =
                status == "missed" ||
                status == "rejected" ||
                status == "declined";
            if (!isBad) continue;

            final seenBy = Map<String, dynamic>.from(d["seenBy"] ?? {});
            final isSeen = seenBy[myId] == true;

            if (!isSeen) count++;
          }

          return count;
        });
  }
}

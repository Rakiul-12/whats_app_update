import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/personalization/Model/MessageModel.dart';

class Messagerepository extends GetxController {
  static Messagerepository get instance => Get.find();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Firebase Messaging instance
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static late UserModel me;

  /// Call this after  UserModel
  Future<void> getFirebaseMessageToken() async {
    await fMessaging.requestPermission();

    final t = await fMessaging.getToken();
    if (t != null) {
      me.pushToken = t;
      print('FCM Token: $t');
    }
  }

  /// Get all messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage() {
    return _firestore.collection("message").snapshots();
  }

  /// Build conversation ID between current user and another user
  static String getConversationID(String otherUserId) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    // Sort IDs in a stable way so both users get the same conversation ID
    return currentUid.hashCode <= otherUserId.hashCode
        ? "${currentUid}_$otherUserId"
        : "${otherUserId}_$currentUid";
  }

  // getAllMessage
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetAllMessage(
    UserModel user,
  ) {
    final cid = getConversationID(user.id);

    return FirebaseFirestore.instance
        .collection("chats")
        .doc(cid)
        .collection("messages")
        .orderBy("sent", descending: true)
        .snapshots();
  }

  // sent message
  static Future<void> sendMessage(
    UserModel chatUser,
    String msg,
    Type type,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    final message = Message(
      told: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: currentUid,
      sent: time,
    );

    final String cid = getConversationID(chatUser.id);

    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(cid)
        .collection('messages');

    await ref.doc(time).set(message.toJson());
  }

  // getFormattedTime
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // updateMessageReadStatus
  static Future<void> updateMessageReadStatus(Message message) async {
    FirebaseFirestore.instance
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // GetLastMessage
  static Stream<QuerySnapshot<Map<String, dynamic>>> GetLastMessage(
    UserModel user,
  ) {
    return FirebaseFirestore.instance
        .collection("chats/${getConversationID(user.id)}/messages/")
        .orderBy("sent", descending: true)
        .limit(1)
        .snapshots();
  }

  static String getLastMessageTime({
    required BuildContext context,
    required String time,
    bool showYear = false,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return showYear
        ? "${sent.day} ${_getMonth(sent)} ${sent.year}"
        : "${sent.day} ${_getMonth(sent)}";
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
    }
    return "";
  }

  // getLastMessageday
  static String getLastMessageday({
    required BuildContext context,
    required String time,
  }) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.month == sent.month && now.year == sent.year) {}
    return "${sent.day} ${_getMonth(sent)}";
  }
}

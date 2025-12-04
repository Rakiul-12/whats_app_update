import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/binding/binding.dart';
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
    final myId = FirebaseAuth.instance.currentUser!.uid;
    return myId.hashCode <= otherUserId.hashCode
        ? '${myId}_$otherUserId'
        : '${otherUserId}_$myId';
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
    MessageType type,
  ) async {
    final timeId = DateTime.now().millisecondsSinceEpoch.toString();
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    final cid = getConversationID(chatUser.id);

    await FirebaseFirestore.instance
        .collection('chats/$cid/messages')
        .doc(timeId)
        .set({
          'toId': chatUser.id,
          'fromId': currentUid,
          'msg': msg,
          'read': '',
          'type': type.name,
          'sent': FieldValue.serverTimestamp(),
        });
  }

  // getFormattedTime
  static String getFormattedTime({
    required BuildContext context,
    required dynamic time,
  }) {
    final dt = _parseTime(time);
    if (dt == null) return '';

    return TimeOfDay.fromDateTime(dt).format(context);
  }

  static DateTime? _parseTime(dynamic time) {
    if (time == null) return null;

    if (time is Timestamp) {
      return time.toDate();
    }

    if (time is String) {
      final ms = int.tryParse(time);
      if (ms != null) {
        return DateTime.fromMillisecondsSinceEpoch(ms);
      }
      // try ISO string
      try {
        return DateTime.parse(time);
      } catch (_) {
        return null;
      }
    }

    if (time is DateTime) {
      return time;
    }

    return null;
  }

  // getLastMessageday
  static String getLastMessageday({
    required BuildContext context,
    required dynamic time,
  }) {
    final dt = _parseTime(time);
    if (dt == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(dt.year, dt.month, dt.day);

    final diff = today.difference(thatDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7 && diff > 1) {
      // Mon, Tue, ...
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dt.weekday - 1];
    }
    // fallback: dd/MM/yy
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year.toString().substring(2)}';
  }

  // updateMessageReadStatus
  static Future<void> markMessageAsRead(
    String otherUserId,
    String messageId,
  ) async {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    final cid = getConversationID(
      otherUserId,
    ); // make sure this uses a String id

    await FirebaseFirestore.instance
        .collection('chats/$cid/messages')
        .doc(messageId)
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
}

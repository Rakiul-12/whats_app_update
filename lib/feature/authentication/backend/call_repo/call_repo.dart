import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:whats_app/binding/enum.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/timeFormate.dart';
import 'package:whats_app/utiles/const/keys.dart';

class CallRepo extends GetxController {
  static CallRepo get instance => Get.find<CallRepo>();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _safe(String? value) {
    if (value == null) return null;
    final string = value.trim();
    return string.isEmpty ? null : string;
  }

  // save call status in db
  Future<void> upsertCall({
    required String callId,
    required String callerId,
    required String receiverId,
    required AppCallType callType,
    required AppCallStatus status,

    String? receiverImage,
    String? callerImage,
    String? callerName,
    String? callerPhone,
    String? receiverName,
    String? receiverPhone,
    int? startedAt,
    int? endedAt,
    int? durationSec,
  }) async {
    final doc = _db.collection(MyKeys.callCollection).doc(callId);
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.runTransaction((tx) async {
      final snap = await tx.get(doc);

      final statusLower = status.name.toLowerCase();
      final isBadStatus =
          statusLower == "missed" ||
          statusLower == "rejected" ||
          statusLower == "declined";

      final data = <String, dynamic>{
        "callId": callId,
        "callerId": callerId,
        "receiverId": receiverId,
        "participants": [callerId, receiverId],

        "callType": callType.name,
        "status": status.name,

        "startedAt": startedAt,
        "endedAt": endedAt,
        "durationSec": durationSec ?? 0,

        "updatedAt": now,
        "updatedAtText": CallFormat.timeFromMillis(now),
      };

      if (!snap.exists) {
        data["createdAt"] = now;
      } else if (!(snap.data() ?? {}).containsKey("createdAt")) {
        data["createdAt"] = now;
      }
      data["createdAtText"] = CallFormat.timeFromMillis(data["createdAt"]);

      if (endedAt != null) {
        data["endedAtText"] = CallFormat.timeFromMillis(endedAt);
      }

      if (!snap.exists) {
        data["seenBy"] = <String, bool>{};
      }

      if (isBadStatus) {
        if (!snap.exists) {
          data["seenBy"] = <String, bool>{};
        } else if ((snap.data() ?? {})["seenBy"] == null) {
          data["seenBy"] = <String, bool>{};
        }
      }

      final CallerName = _safe(callerName);
      final CallerPhone = _safe(callerPhone);
      final ReceiverName = _safe(receiverName);
      final ReceiverPhone = _safe(receiverPhone);
      final CallerImage = _safe(callerImage);
      final ReceiverImage = _safe(receiverImage);

      if (CallerName != null) data["callerName"] = CallerName;
      if (CallerPhone != null) data["callerPhone"] = CallerPhone;
      if (ReceiverName != null) data["receiverName"] = ReceiverName;
      if (ReceiverPhone != null) data["receiverPhone"] = ReceiverPhone;
      if (CallerImage != null) data["callerImage"] = CallerImage;
      if (ReceiverImage != null) data["receiverImage"] = ReceiverImage;

      tx.set(doc, data, SetOptions(merge: true));
    });
  }

  ///  save call status for chat screen
  // Future<void> saveCallMessage({
  //   required String conversationId,
  //   required String fromId,
  //   required String toId,
  //   required AppCallType callType,
  //   required AppCallStatus status,
  //   required int timeMs,
  //   required int durationSec,
  //   required String callId,
  // }) async {

  //   final ref = _db
  //       .collection(MyKeys.chatCollection)
  //       .doc(conversationId)
  //       .collection('messages')
  //       .doc();

  //   await ref.set({
  //     "id": ref.id,
  //     "type": "call",

  //     "callType": callType.name,
  //     "callStatus": status.name,
  //     "callId": callId,
  //     "durationSec": durationSec,

  //     "fromId": fromId,
  //     "toId": toId,

  //     "sent": timeMs,
  //     "sentText": CallFormat.timeFromMillis(timeMs),

  //     "message": callType == AppCallType.audio ? "Voice call" : "Video call",

  //     "read": "",
  //   });
  // }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/timeFormate.dart';

enum MessageType { text, image, call }

enum AppCallType { audio, video }

enum AppCallStatus { ringing, answered, ended, missed, rejected, canceled }

class CallRepo {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String conversationId(String a, String b) {
    final list = [a, b]..sort();
    return "${list[0]}_${list[1]}";
  }

  static String? _safe(String? v) {
    if (v == null) return null;
    final s = v.trim();
    return s.isEmpty ? null : s;
  }

  static Future<void> upsertCall({
    required String callId,
    required String callerId,
    required String receiverId,
    required AppCallType callType,
    required AppCallStatus status,
    String? callerName,
    String? callerPhone,
    String? receiverName,
    String? receiverPhone,
    int? startedAt,
    int? endedAt,
    int? durationSec,
  }) async {
    final doc = _db.collection("calls").doc(callId);
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.runTransaction((tx) async {
      final snap = await tx.get(doc);

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
        data["createdAtText"] = CallFormat.timeFromMillis(now);
      }

      if (endedAt != null) {
        data["endedAtText"] = CallFormat.timeFromMillis(endedAt);
      }

      final cn = _safe(callerName);
      final cp = _safe(callerPhone);
      final rn = _safe(receiverName);
      final rp = _safe(receiverPhone);

      if (cn != null) data["callerName"] = cn;
      if (cp != null) data["callerPhone"] = cp;
      if (rn != null) data["receiverName"] = rn;
      if (rp != null) data["receiverPhone"] = rp;

      tx.set(doc, data, SetOptions(merge: true));
    });
  }

  static Future<void> saveCallMessage({
    required String conversationId,
    required String fromId,
    required String toId,
    required AppCallType callType,
    required AppCallStatus status,
    required int timeMs,
    required int durationSec,
    required String callId,
  }) async {
    final ref = _db
        .collection("chats")
        .doc(conversationId)
        .collection("messages")
        .doc();

    await ref.set({
      "id": ref.id,
      "type": "call",

      "callType": callType.name,
      "callStatus": status.name,
      "callId": callId,

      "fromId": fromId,
      "toId": toId,

      "sent": timeMs,
      "sentText": CallFormat.timeFromMillis(timeMs),

      "durationSec": durationSec,
      "message": callType == AppCallType.audio ? "Audio call" : "Video call",
      "read": "",
    });
  }
}

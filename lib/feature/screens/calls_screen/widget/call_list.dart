import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/timeFormate.dart';

class Calls_list extends StatelessWidget {
  const Calls_list({super.key});

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    final stream = FirebaseFirestore.instance
        .collection("calls")
        .where("participants", arrayContains: myId)
        .orderBy("callId", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(child: Text("No calls yet..."));
        }

        final docs = snap.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final d = docs[index].data();

            final callerId = (d["callerId"] ?? "").toString();
            final receiverId = (d["receiverId"] ?? "").toString();
            final isOutgoing = callerId == myId;

            final otherId = isOutgoing ? receiverId : callerId;

            // try Firestore name fields first
            final otherNameFromCall = isOutgoing
                ? _safeText(d["receiverName"])
                : _safeText(d["callerName"]);

            final status = (d["status"] ?? "").toString().toLowerCase();
            final callType = (d["callType"] ?? "audio")
                .toString()
                .toLowerCase();
            final isVideo = callType == "video";

            final isMissed = status == "missed";
            final isRejected = status == "rejected";

            final directionIcon = isOutgoing
                ? Icons.call_made
                : Icons.call_received;
            final directionColor = (isMissed || isRejected)
                ? Colors.redAccent
                : Colors.green;

            final timeMs = d["endedAt"] ?? d["createdAt"] ?? d["updatedAt"];
            final timeText = CallFormat.whatsappTime(timeMs);
            final subtitle = "${_statusText(status)} • $timeText";

            return FutureBuilder<String>(
              future: _resolveName(otherNameFromCall, otherId),
              builder: (context, nameSnap) {
                final otherName = (nameSnap.data ?? otherId).trim();

                return ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    child: Text(
                      otherName.isNotEmpty ? otherName[0].toUpperCase() : "?",
                    ),
                  ),
                  title: Text(
                    otherName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(directionIcon, size: 16, color: directionColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    isVideo ? Icons.videocam : Icons.call,
                    color: (isMissed || isRejected)
                        ? Colors.redAccent
                        : Colors.green,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> _resolveName(String nameFromCall, String uid) async {
    if (nameFromCall.trim().isNotEmpty) return nameFromCall.trim();
    if (uid.trim().isEmpty) return "";

    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    final data = userDoc.data();
    final username = (data?["username"] ?? data?["name"] ?? "")
        .toString()
        .trim();
    return username.isNotEmpty ? username : uid;
  }

  String _safeText(dynamic v) {
    final s = (v ?? "").toString().trim();
    return s;
  }

  String _statusText(String status) {
    switch (status) {
      case "missed":
        return "Missed";
      case "rejected":
        return "Declined";
      case "canceled":
        return "Canceled";
      case "ended":
        return "Call";
      case "answered":
        return "Answered";
      case "ringing":
        return "Calling…";
      default:
        return "Call";
    }
  }
}

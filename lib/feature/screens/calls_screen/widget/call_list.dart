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
        .orderBy("createdAt", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return const Center(child: Text("No calls yet..."));
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

            final otherName = isOutgoing
                ? _safeText(d["receiverName"], receiverId)
                : _safeText(d["callerName"], callerId);

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
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Row(
                children: [
                  Icon(directionIcon, size: 16, color: directionColor),
                  SizedBox(width: 6),
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
  }

  String _safeText(dynamic v, String fallback) {
    final s = (v ?? "").toString().trim();
    return s.isEmpty ? fallback : s;
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

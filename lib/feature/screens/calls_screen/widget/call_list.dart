import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/common/widget/ZegoCallBtn/ZegoCallBtn.dart';
import 'package:whats_app/common/widget/style/screen_padding.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/timeFormate.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';
import 'package:whats_app/utiles/theme/const/image.dart';
import 'package:whats_app/utiles/theme/const/sizes.dart';
import 'package:whats_app/utiles/theme/helpers/helper_function.dart';

class Callslist extends StatelessWidget {
  const Callslist({super.key});

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    final isDark = MyHelperFunction.isDarkMode(context);

    final stream = FirebaseFirestore.instance
        .collection(MyKeys.callCollection)
        .where("participants", arrayContains: myId)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Mycolors.success,
            ),
          );
        }

        if (snap.hasError) {
          return Center(child: Text("Firestore error:\n${snap.error}"));
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
          return Center(child: Text(MyKeys.callScreenNoReasultText));
        }

        final docs = [...snap.data!.docs];

        // docs.sort((a, b) {
        //   int getTime(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        //     final data = doc.data();
        //     final v =
        //         data["updatedAt"] ?? data["createdAt"] ?? data["endedAt"] ?? 0;
        //     if (v is Timestamp) return v.millisecondsSinceEpoch;
        //     if (v is int) return v;
        //     return int.tryParse(v.toString()) ?? 0;
        //   }

        //   return getTime(b).compareTo(getTime(a));
        // });

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 7),
          itemCount: docs.length,
          separatorBuilder: (_, __) => SizedBox(height: 2),
          itemBuilder: (context, index) {
            final data = docs[index].data();

            final callerId = (data["callerId"] ?? "").toString();
            final receiverId = (data["receiverId"] ?? "").toString();

            final isOutgoing = callerId == myId;
            final isIncoming = receiverId == myId;

            final otherName = isOutgoing
                ? _safeText(data["receiverName"], receiverId)
                : _safeText(data["callerName"], callerId);

            final receiverImage = isOutgoing
                ? (data["receiverImage"] ?? "").toString()
                : (data["callerImage"] ?? "").toString();

            final status = (data["status"] ?? "").toString().toLowerCase();
            final callType = (data["callType"] ?? "audio")
                .toString()
                .toLowerCase();
            final isVideo = callType == "video";

            final isMissed = status == "missed";
            final isRejected = status == "rejected" || status == "declined";

            final bool isRed = isIncoming && (isMissed || isRejected);

            final directionIcon = isOutgoing
                ? Icons.call_made
                : Icons.call_received;
            final directionColor = isRed ? Mycolors.error : Colors.green;

            final timeMs =
                data["endedAt"] ?? data["createdAt"] ?? data["updatedAt"];
            final timeText = CallFormat.whatsappTime(timeMs);

            final subtitle = "${_statusText(status)} • $timeText";
            final textColor = isRed
                ? Mycolors.error
                : isDark
                ? Mycolors.light
                : Mycolors.dark;

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),

              // on call button tap
              onTap: () {
                final user = _userFromCall(data, isOutgoing);

                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (_) {
                    return Padding(
                      padding: MyPadding.screenPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ZegoCallInvitationButton(
                              otherUser: user,
                              isVideo: false,
                              icon: Icons.call,
                              text: "audio",
                              size: 20,
                            ),
                            title: Text(
                              MyKeys.callBottomSheetAudioCallText,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(MyKeys.callBottomSheetText),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ZegoCallInvitationButton(
                              otherUser: user,
                              isVideo: true,
                              icon: Icons.videocam,
                              text: "video",
                              size: 20,
                            ),
                            title: Text(
                              MyKeys.callBottomSheetVideoCallText,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(MyKeys.callBottomSheetText),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                );
              },

              leading: CircleAvatar(
                radius: 24,
                backgroundImage: receiverImage.isNotEmpty
                    ? NetworkImage(receiverImage)
                    : AssetImage(MyImage.onProfileScreen) as ImageProvider,
              ),

              title: Text(
                otherName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, color: textColor),
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
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),

              trailing: Icon(
                isVideo ? Icons.videocam : Icons.call,
                color: isRed ? Colors.redAccent : Mycolors.success,
              ),
            );
          },
        );
      },
    );
  }

  UserModel _userFromCall(Map<String, dynamic> d, bool isOutgoing) {
    return UserModel(
      id: (isOutgoing ? d["receiverId"] : d["callerId"]).toString(),
      username: isOutgoing
          ? (d["receiverName"] ?? "User").toString()
          : (d["callerName"] ?? "User").toString(),
      phoneNumber: (isOutgoing ? d["receiverPhone"] : d["callerPhone"])
          .toString(),
      profilePicture: "",
      email: '',
      about: '',
      createdAt: '',
      isOnline: true,
      pushToken: '',
      lastActive: '',
    );
  }

  String _safeText(dynamic v, String fallback) {
    final safeText = (v ?? "").toString().trim();
    return safeText.isEmpty ? fallback : safeText;
  }

  String _statusText(String status) {
    switch (status) {
      case "missed":
        return "Missed";
      case "rejected":
      case "declined":
        return "Declined";
      case "canceled":
        return "Canceled";
      case "ended":
      case "answered":
        return "Call";
      case "ringing":
        return "Calling…";
      default:
        return "Call";
    }
  }
}

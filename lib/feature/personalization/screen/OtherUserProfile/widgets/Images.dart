import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/utiles/theme/const/colors.dart';

class ChatImages extends StatelessWidget {
  const ChatImages({super.key, required this.otherUserId});

  final String otherUserId;

  String _conversationId(String userID) {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    return myId.hashCode <= otherUserId.hashCode
        ? '${myId}_$otherUserId'
        : '${otherUserId}_$myId';
  }

  @override
  Widget build(BuildContext context) {
    final cid = _conversationId(otherUserId);

    final stream = FirebaseFirestore.instance
        .collection(MyKeys.chatCollection)
        .doc(cid)
        .collection(MyKeys.messageCollection)
        .where("type", isEqualTo: "image")
        .orderBy("sent", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Mycolors.success,
            strokeWidth: 1,
          );
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Text("No Images...");
        }

        return SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final url = (data["msg"] ?? "").toString().trim();
              if (url.isEmpty) return SizedBox.shrink();

              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.all(12),
                          child: InteractiveViewer(
                            child: Image.network(url, fit: BoxFit.contain),
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

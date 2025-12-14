import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({
    super.key,
    required this.otherUser,
    required this.isVideoCall,
  });

  final UserModel otherUser;
  final bool isVideoCall;

  @override
  Widget build(BuildContext context) {
    // current user
    final current = FirebaseAuth.instance.currentUser!;
    final String myId = current.uid;
    final String myName = current.displayName ?? 'User';

    // use your existing conversationID as callID
    final String callID = Messagerepository.getConversationID(otherUser.id);

    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 1791254756,
        appSign:
            "6d100a52da23818ae74db2848a4e1dc0d91f09cf1842555b040626051b51ca93",
        userID: myId,
        userName: myName,
        callID: callID,
        config: isVideoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
      ),
    );
  }
}

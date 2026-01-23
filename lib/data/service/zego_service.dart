import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:whats_app/binding/enum.dart' as enums;
import 'package:whats_app/feature/authentication/backend/call_repo/call_repo.dart'
    as repo;

class ZegoService {
  ZegoService._();
  static final ZegoService instance = ZegoService._();

  bool _inited = false;

  late String _myId;
  late String _myName;
  late String _myPhone;

  String? _lastOutgoingCallId;
  final Map<String, Map<String, dynamic>> _callData = {};

  Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
    required String userId,
    required String userName,
    String userPhone = "",
  }) {
    return initIfNeeded(
      navigatorKey: navigatorKey,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
    );
  }

  Future<void> initIfNeeded({
    required GlobalKey<NavigatorState> navigatorKey,
    required String userId,
    required String userName,
    required String userPhone,
  }) async {
    if (_inited) return;

    _myId = userId.trim();
    _myName = userName.trim().isEmpty ? "Guest" : userName.trim();
    _myPhone = userPhone.trim();

    if (_myId.isEmpty) return;

    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1791254756,
      appSign:
          "6d100a52da23818ae74db2848a4e1dc0d91f09cf1842555b040626051b51ca93",
      userID: _myId,
      userName: _myName,
      plugins: [ZegoUIKitSignalingPlugin()],
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallSent:
            (callID, caller, zegoCallType, callees, customData) async {
              _lastOutgoingCallId = callID;

              final data = _safeDecode(customData) ?? {};
              _callData[callID] = data;

              final toId =
                  (data["toId"] ?? (callees.isNotEmpty ? callees.first.id : ""))
                      .toString()
                      .trim();

              final bool isVideo =
                  (data["callType"]?.toString().toLowerCase() == "video");

              final enums.AppCallType ct = isVideo
                  ? enums.AppCallType.video
                  : enums.AppCallType.audio;

              final receiverName = (data["toName"] ?? "").toString().trim();
              final receiverPhone = (data["toPhone"] ?? "").toString().trim();

              await repo.CallRepo.instance.upsertCall(
                callId: callID,
                callerId: _myId,
                receiverId: toId,
                callType: ct,
                status: enums.AppCallStatus.ringing,
                callerName: _myName,
                callerPhone: _myPhone,
                receiverName: receiverName.isEmpty ? null : receiverName,
                receiverPhone: receiverPhone.isEmpty ? null : receiverPhone,
              );
            },

        onOutgoingCallTimeout: (callID, callees, isVideoCall) async {
          final now = DateTime.now().millisecondsSinceEpoch;
          final data = _callData[callID] ?? {};

          final toId =
              (data["toId"] ?? (callees.isNotEmpty ? callees.first.id : ""))
                  .toString()
                  .trim();

          final enums.AppCallType ct = isVideoCall
              ? enums.AppCallType.video
              : enums.AppCallType.audio;

          final receiverName = (data["toName"] ?? "").toString().trim();
          final receiverPhone = (data["toPhone"] ?? "").toString().trim();

          await repo.CallRepo.instance.upsertCall(
            callId: callID,
            callerId: _myId,
            receiverId: toId,
            callType: ct,
            status: enums.AppCallStatus.missed,
            endedAt: now,
            durationSec: 0,
            callerName: _myName,
            callerPhone: _myPhone,
            receiverName: receiverName.isEmpty ? null : receiverName,
            receiverPhone: receiverPhone.isEmpty ? null : receiverPhone,
          );
        },

        onOutgoingCallCancelButtonPressed: () async {
          final callID = _lastOutgoingCallId;
          if (callID == null) return;

          final now = DateTime.now().millisecondsSinceEpoch;
          final data = _callData[callID] ?? {};

          final toId = (data["toId"] ?? "").toString().trim();

          final bool isVideo =
              (data["callType"]?.toString().toLowerCase() == "video");

          final enums.AppCallType ct = isVideo
              ? enums.AppCallType.video
              : enums.AppCallType.audio;

          final receiverName = (data["toName"] ?? "").toString().trim();
          final receiverPhone = (data["toPhone"] ?? "").toString().trim();

          await repo.CallRepo.instance.upsertCall(
            callId: callID,
            callerId: _myId,
            receiverId: toId,
            callType: ct,
            status: enums.AppCallStatus.canceled,
            endedAt: now,
            durationSec: 0,
            callerName: _myName,
            callerPhone: _myPhone,
            receiverName: receiverName.isEmpty ? null : receiverName,
            receiverPhone: receiverPhone.isEmpty ? null : receiverPhone,
          );
        },
      ),
    );

    _inited = true;
  }

  void uninit() {
    try {
      ZegoUIKitPrebuiltCallInvitationService().uninit();
    } catch (_) {}
    _inited = false;
    _lastOutgoingCallId = null;
    _callData.clear();
  }

  Map<String, dynamic>? _safeDecode(String? customData) {
    if (customData == null) return null;
    final s = customData.trim();
    if (s.isEmpty) return null;
    try {
      final decoded = jsonDecode(s);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}

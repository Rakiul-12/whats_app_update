import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:whats_app/feature/authentication/backend/call_repo/call_repo.dart'
    as callr;

class ZegoService {
  ZegoService._();
  static final ZegoService instance = ZegoService._();

  bool _inited = false;

  late String _myId;
  late String _myName;
  late String _myPhone;

  String? _lastOutgoingCallId;
  final Map<String, Map<String, dynamic>> _callData = {};

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
        // =============================
        // OUTGOING SENT
        // =============================
        onOutgoingCallSent:
            (callID, caller, zegoCallType, callees, customData) async {
              _lastOutgoingCallId = callID;

              final data = _safeDecode(customData);
              if (data != null) _callData[callID] = data;

              final toId =
                  (data?["toId"] ??
                          (callees.isNotEmpty ? callees.first.id : ""))
                      .toString()
                      .trim();

              final convId = (data?["conversationId"] ?? "").toString().trim();

              final bool isVideo =
                  (data?["callType"]?.toString().toLowerCase() == "video");

              // ✅ FIX: use AppCallType
              final callr.AppCallType ct = isVideo
                  ? callr.AppCallType.video
                  : callr.AppCallType.audio;

              await callr.CallRepo.upsertCall(
                callId: callID,
                callerId: _myId,
                receiverId: toId,
                callType: ct,
                status: callr.AppCallStatus.ringing,
                callerName: _myName,
                callerPhone: _myPhone,
              );

              // (optional) show “Calling…” inside chat
              if (convId.isNotEmpty && toId.isNotEmpty) {
                await callr.CallRepo.saveCallMessage(
                  conversationId: convId,
                  fromId: _myId,
                  toId: toId,
                  callType: ct,
                  status: callr.AppCallStatus.ringing,
                  timeMs: DateTime.now().millisecondsSinceEpoch,
                  durationSec: 0,
                  callId: callID,
                );
              }
            },

        // =============================
        // OUTGOING TIMEOUT -> MISSED
        // =============================
        onOutgoingCallTimeout: (callID, callees, isVideoCall) async {
          final now = DateTime.now().millisecondsSinceEpoch;
          final data = _callData[callID];

          final toId =
              (data?["toId"] ?? (callees.isNotEmpty ? callees.first.id : ""))
                  .toString()
                  .trim();

          final convId = (data?["conversationId"] ?? "").toString().trim();

          // ✅ FIX: use AppCallType
          final callr.AppCallType ct = isVideoCall
              ? callr.AppCallType.video
              : callr.AppCallType.audio;

          await callr.CallRepo.upsertCall(
            callId: callID,
            callerId: _myId,
            receiverId: toId,
            callType: ct,
            status: callr.AppCallStatus.missed,
            endedAt: now,
            durationSec: 0,
            callerName: _myName,
            callerPhone: _myPhone,
          );

          if (convId.isNotEmpty && toId.isNotEmpty) {
            await callr.CallRepo.saveCallMessage(
              conversationId: convId,
              fromId: _myId,
              toId: toId,
              callType: ct,
              status: callr.AppCallStatus.missed,
              timeMs: now,
              durationSec: 0,
              callId: callID,
            );
          }
        },

        // =============================
        // OUTGOING CANCEL BUTTON
        // =============================
        onOutgoingCallCancelButtonPressed: () async {
          final callID = _lastOutgoingCallId;
          if (callID == null) return;

          final now = DateTime.now().millisecondsSinceEpoch;
          final data = _callData[callID];

          final toId = (data?["toId"] ?? "").toString().trim();
          final convId = (data?["conversationId"] ?? "").toString().trim();
          final bool isVideo =
              (data?["callType"]?.toString().toLowerCase() == "video");

          final callr.AppCallType ct = isVideo
              ? callr.AppCallType.video
              : callr.AppCallType.audio;

          await callr.CallRepo.upsertCall(
            callId: callID,
            callerId: _myId,
            receiverId: toId,
            callType: ct,
            status: callr.AppCallStatus.canceled,
            endedAt: now,
            durationSec: 0,
            callerName: _myName,
            callerPhone: _myPhone,
          );

          if (convId.isNotEmpty && toId.isNotEmpty) {
            await callr.CallRepo.saveCallMessage(
              conversationId: convId,
              fromId: _myId,
              toId: toId,
              callType: ct,
              status: callr.AppCallStatus.canceled,
              timeMs: now,
              durationSec: 0,
              callId: callID,
            );
          }
        },

        // =============================
        // INCOMING CANCELED (receiver side)
        // =============================
        onIncomingCallCanceled: (callID, caller, customData) async {
          final now = DateTime.now().millisecondsSinceEpoch;

          final data = _safeDecode(customData);
          if (data != null) _callData[callID] = data;

          final fromId = (data?["fromId"] ?? caller.id).toString().trim();
          final convId = (data?["conversationId"] ?? "").toString().trim();
          final bool isVideo =
              (data?["callType"]?.toString().toLowerCase() == "video");

          final callr.AppCallType ct = isVideo
              ? callr.AppCallType.video
              : callr.AppCallType.audio;

          await callr.CallRepo.upsertCall(
            callId: callID,
            callerId: fromId,
            receiverId: _myId,
            callType: ct,
            status: callr.AppCallStatus.canceled,
            endedAt: now,
            durationSec: 0,
          );

          if (convId.isNotEmpty) {
            await callr.CallRepo.saveCallMessage(
              conversationId: convId,
              fromId: fromId,
              toId: _myId,
              callType: ct,
              status: callr.AppCallStatus.canceled,
              timeMs: now,
              durationSec: 0,
              callId: callID,
            );
          }
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

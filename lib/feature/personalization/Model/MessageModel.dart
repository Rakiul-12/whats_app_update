import 'package:whats_app/feature/authentication/backend/call_repo/call_repo.dart';

class Message {
  final String toId;
  final String fromId;
  final String msg;
  final String read;
  final MessageType type;
  final String sent;
  String publicId;

  Message({
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.read,
    required this.type,
    required this.sent,
    required this.publicId,
  });

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'fromId': fromId,
      'msg': msg,
      'read': read,
      'type': type.name,
      'sent': sent,
      'publicId': publicId,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      toId: json['toId'],
      fromId: json['fromId'],
      msg: json['msg'],
      read: json['read'],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      sent: json['sent'],
      publicId: json['publicId'],
    );
  }
}

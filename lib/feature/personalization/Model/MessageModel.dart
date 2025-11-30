class Message {
  Message({
    required this.told,
    required this.msg,
    required this.fromId,
    required this.read,
    required this.sent,
    required this.type,
  });
  late final String told;
  late final String msg;
  late final String fromId;
  late final String read;
  late final String sent;
  late final Type type;

  Message.fromJson(Map<String, dynamic> json) {
    told = json['told'].toString();
    msg = json['msg'].toString();
    fromId = json['fromId'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['told'] = told;
    data['msg'] = msg;
    data['fromId'] = fromId;
    data['read'] = read;
    data['sent'] = sent;
    data['type'] = type.name;
    return data;
  }
}

enum Type { text, image }

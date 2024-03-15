import 'dart:convert';

class Message {
  final String sender;
  final String message;
  final String messageType;
  final String receiver;
  final String chat;
  final DateTime createdAt;
  final DateTime? readDate;

  Message({
    required this.sender,
    required this.message,
    required this.messageType,
    required this.receiver,
    required this.chat,
    required this.createdAt,
    this.readDate,
  });

  Message copyWith({
    String? sender,
    String? message,
    String? messageType,
    String? receiver,
    String? chat,
    DateTime? createdAt,
    DateTime? readDate,
  }) =>
      Message(
        sender: sender ?? this.sender,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        receiver: receiver ?? this.receiver,
        chat: chat ?? this.chat,
        createdAt: createdAt ?? this.createdAt,
        readDate: readDate ?? this.readDate,
      );

  factory Message.fromRawJson(String str) => Message.fromMap(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      sender: json["sender"],
      message: json["message"],
      messageType: json["messageType"],
      receiver: json["receiver"],
      chat: json["chat"],
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      readDate:
          json["readDate"] == null ? null : DateTime.parse(json["readDate"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "sender": sender,
        "message": message,
        "messageType": messageType,
        "receiver": receiver,
        "chat": chat,
        "createdAt": createdAt.toIso8601String(),
        "readDate": readDate ?? readDate?.toIso8601String(),
      };
}

import 'dart:convert';

class Message {
  final String sender;
  final String message;
  final String messageType;
  final String receiver;
  final String chat;
  final DateTime createdAt = DateTime.now();
  final DateTime? updatedAt;
  final DateTime? readDate;

  Message({
    required this.sender,
    required this.message,
    required this.messageType,
    required this.receiver,
    required this.chat,
    this.updatedAt,
    this.readDate,
  });

  Message copyWith({
    String? sender,
    String? message,
    String? messageType,
    String? receiver,
    String? chat,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readDate,
  }) =>
      Message(
        sender: sender ?? this.sender,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        receiver: receiver ?? this.receiver,
        chat: chat ?? this.chat,
        updatedAt: updatedAt ?? this.updatedAt,
        readDate: readDate ?? this.readDate,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        sender: json["sender"],
        message: json["message"],
        messageType: json["messageType"],
        receiver: json["receiver"],
        chat: json["chat"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        readDate:
            json["readDate"] == null ? null : DateTime.parse(json["readDate"]),
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "message": message,
        "messageType": messageType,
        "receiver": receiver,
        "chat": chat,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt ?? updatedAt?.toIso8601String(),
        "readDate": readDate ?? readDate?.toIso8601String(),
      };
}

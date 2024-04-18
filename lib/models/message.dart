import 'dart:convert';

import 'package:uniket/common/enums/message_status_enum.dart';

class Message {
  final String id;
  final String sender;
  String message;
  final String messageType;
  String status;
  final String receiver;
  final String chat;
  final DateTime createdAt;
  DateTime? readDate;

  Message({
    required this.id,
    required this.sender,
    required this.message,
    required this.messageType,
    required this.receiver,
    required this.chat,
    required this.createdAt,
    required this.status,
    this.readDate,
  });
  static Message initMessage() {
    return Message(
      id: "",
      sender: "",
      message: "",
      messageType: "",
      receiver: "",
      chat: "",
      createdAt: DateTime.now(),
      status: "Error",
    );
  }

  Message copyWith({
    String? id,
    String? sender,
    String? message,
    String? messageType,
    String? receiver,
    String? chat,
    String? status,
    DateTime? createdAt,
    DateTime? readDate,
  }) =>
      Message(
        id: id ?? this.id,
        sender: sender ?? this.sender,
        message: message ?? this.message,
        messageType: messageType ?? this.messageType,
        status: status ?? this.status,
        receiver: receiver ?? this.receiver,
        chat: chat ?? this.chat,
        createdAt: createdAt ?? this.createdAt,
        readDate: readDate ?? this.readDate,
      );

  factory Message.fromRawJson(String str) => Message.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      sender: json["sender"],
      message: json["message"],
      messageType: json["messageType"],
      receiver: json["receiver"],
      chat: json["chat"],
      status: json["status"] ?? MessageStatusEnum.received.value,
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      readDate:
          json["readDate"] == null ? null : DateTime.parse(json["readDate"]),
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "sender": sender,
        "message": message,
        "messageType": messageType,
        "receiver": receiver,
        "chat": chat,
        "createdAt": createdAt.toIso8601String(),
        "readDate": readDate?.toIso8601String(),
      };
}

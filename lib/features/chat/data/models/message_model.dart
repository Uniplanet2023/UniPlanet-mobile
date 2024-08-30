// message_model.dart

import 'dart:convert';
import '../../domain/entities/message.dart';

class MessageDBModel extends Message {
  MessageDBModel({
    required super.id,
    required super.sender,
    required super.message,
    required super.messageType,
    required super.receiver,
    required super.chat,
    required super.createdAt,
    required super.status,
    super.readDate,
  });

  factory MessageDBModel.fromMap(Map<String, dynamic> json) {
    return MessageDBModel(
      id: json["id"] as String,
      sender: json["sender"] as String,
      message: json["message"] as String,
      messageType: json["messageType"] as String,
      receiver: json["receiver"] as String,
      chat: json["chat"] as String,
      status: json["status"] ?? "Error",
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      readDate:
          json["readDate"] == null ? null : DateTime.parse(json["readDate"]),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
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

  @override
  String toJson() => json.encode(toMap());

  factory MessageDBModel.fromJson(String source) =>
      MessageDBModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Message toEntity() {
    return Message(
      id: id,
      sender: sender,
      message: message,
      messageType: messageType,
      receiver: receiver,
      chat: chat,
      createdAt: createdAt,
      status: status,
      readDate: readDate,
    );
  }

  //from entity
  factory MessageDBModel.fromEntity(Message message) {
    return MessageDBModel(
      id: message.id,
      sender: message.sender,
      message: message.message,
      messageType: message.messageType,
      receiver: message.receiver,
      chat: message.chat,
      createdAt: message.createdAt,
      status: message.status,
      readDate: message.readDate,
    );
  }
}

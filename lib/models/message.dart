// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uniplanet_mobile/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String message;
  final MessageEnum type;
  final DateTime timestamp;
  final String messageId;
  final bool isSeen;

  Message({
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.type,
    required this.isSeen,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'message': message,
      'type': type.value,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      type: MessageEnumExtension.fromString(map['type'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}

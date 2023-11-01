import 'dart:convert';

import 'package:uniplanet_mobile/common/enums/message_enum.dart';

class Message {
  final String chatRoomId;
  final String senderId;
  final String message;
  final MessageEnum type;
  final DateTime timestamp;
  final String messageId;
  final bool isSeen;

  Message({
    required this.chatRoomId,
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.type,
    required this.isSeen,
    required this.timestamp,
  });
  static initialMessage() {
    return Message(
        chatRoomId: '',
        messageId: '',
        senderId: '',
        message: '',
        type: MessageEnum.text,
        isSeen: false,
        timestamp: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomId': chatRoomId,
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
      chatRoomId: map['chatRoomId'] as String,
      senderId: map['senderId'] as String,
      message: map['message'] as String,
      type: MessageEnum.text,
      timestamp: DateTime.parse(map['timestamp'].toString()),
      messageId: map['_id'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user.dart';

class ChatRoom {
  final String chatRoomId;
  final String name;
  final String type;
  final List<String> msgList;
  final Message? lastMessage;
  final DateTime? lastMessageTime;
  ChatRoom({
    required this.msgList,
    required this.chatRoomId,
    required this.name,
    required this.type,
    this.lastMessage,
    this.lastMessageTime,
  });
  static initialChatRoom() {
    return ChatRoom(
      msgList: [],
      name: "",
      type: "",
      chatRoomId: '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageList': msgList,
      'chatRoomId': chatRoomId,
      'name': name,
      'type': type,
      'lastMessage': lastMessage?.toMap(),
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      msgList: List<String>.from(map['messages']),
      chatRoomId: map['chatRoomId'] as String,
      name: (map['receiver']?['receiverName'] ?? "") as String,
      type: map['type'] as String,
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'] as Map<String, dynamic>)
          : null,
      lastMessageTime: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}

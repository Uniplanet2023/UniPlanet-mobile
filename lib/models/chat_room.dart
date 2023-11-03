// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/models/user.dart';

class ChatRoom {
  final String chatRoomId;
  final User buyer;
  final User seller;
  final List<String> messages;
  final Message? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoom({
    required this.buyer,
    required this.seller,
    required this.messages,
    required this.chatRoomId,
    this.lastMessage,
    this.lastMessageTime,
  });
  static initialChatRoom() {
    return ChatRoom(
      buyer: User.initialUser(),
      seller: User.initialUser(),
      messages: [],
      chatRoomId: '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'buyer': buyer,
      'seller': seller,
      'messages': messages,
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage?.toMap(),
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      buyer: User.fromMap(map['buyer']),
      seller: User.fromMap(map['seller']),
      messages: List<String>.from(map['messages']),
      chatRoomId: map['_id'] as String,
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'])
          : null,
      lastMessageTime: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}

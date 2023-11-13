import 'dart:convert';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user.dart';

class ChatRoom {
  final String chatRoomId;
  final String chatRoomType;
  final Product product;
  final List<String> messages;
  final Message? lastMessage;
  final DateTime? lastMessageTime;

  ChatRoom({
    required this.product,
    required this.chatRoomType,
    required this.messages,
    required this.chatRoomId,
    this.lastMessage,
    this.lastMessageTime,
  });
  static initChatRoom() {
    return ChatRoom(
        product: Product.initProduct(),
        chatRoomType: "",
        messages: [],
        chatRoomId: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatRoomType': chatRoomType,
      'product': product,
      'messages': messages,
      'chatRoomId': chatRoomId,
      'lastMessage': lastMessage?.toMap(),
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      product: Product.fromMap(map['product']),
      messages: List<String>.from(map['messages']),
      chatRoomType: map['chatRoomType'] ?? "",
      chatRoomId: map['_id'] as String,
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'])
          : null,
      lastMessageTime: map['lastMessage'] != null
          ? DateTime.parse(map['lastMessage']['createdAt'].toString())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}

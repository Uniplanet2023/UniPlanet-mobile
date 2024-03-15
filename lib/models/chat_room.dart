import 'dart:convert';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class ChatRoom {
  final String productId;
  final String id;
  final User seller;
  final User buyer;
  final Message? lastMessage;

  ChatRoom(
      {required this.id,
      required this.seller,
      required this.buyer,
      required this.productId,
      this.lastMessage});

  static initChatRoom() {
    return ChatRoom(
      id: "",
      seller: User.initialUser(),
      buyer: User.initialUser(),
      productId: "",
    );
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      seller: User.fromMap(map['seller']),
      buyer: User.fromMap(map['buyer']),
      productId: map['productId'],
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'])
          : null,
    );
  }

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}

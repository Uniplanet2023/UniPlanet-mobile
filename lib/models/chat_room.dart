import 'dart:convert';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class ChatRoom {
  final String productId;
  final String id;
  final User seller;
  final User buyer;
  Message? lastMessage;

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

  //copy with method is used to create a new ChatRoom object with the updated values
  ChatRoom copyWith({
    String? id,
    User? seller,
    User? buyer,
    String? productId,
    Message? lastMessage,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      productId: productId ?? this.productId,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  // This method is used to convert the ChatRoom object to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'seller': seller.toMap(),
      'buyer': buyer.toMap(),
      'productId': productId,
      'lastMessage': lastMessage != null ? lastMessage!.toMap() : null,
    };
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

  // to Json method is used to convert the ChatRoom object to a json string
  String toJson() => json.encode(toMap());
}

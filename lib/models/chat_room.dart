import 'dart:convert';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class ChatRoom {
  final String productId;
  final String id;
  final User seller;
  final User buyer;
  Message? lastMessage;
  int unseenMessageCount;
  ChatRoom({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.productId,
    this.lastMessage,
    this.unseenMessageCount = 0,
  });

  static initChatRoom() {
    return ChatRoom(
      id: "",
      seller: User.initialUser(),
      buyer: User.initialUser(),
      productId: "",
      lastMessage: null,
      unseenMessageCount: 0,
    );
  }

  //copy with method is used to create a new ChatRoom object with the updated values
  ChatRoom copyWith({
    String? id,
    User? seller,
    User? buyer,
    String? productId,
    Message? lastMessage,
    int? unseenMessageCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      productId: productId ?? this.productId,
      lastMessage: lastMessage ?? this.lastMessage,
      unseenMessageCount: unseenMessageCount ?? this.unseenMessageCount,
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
      'unseenMessageCount': unseenMessageCount,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['chat']['id'],
      seller: User.fromMap(map['chat']['seller']),
      buyer: User.fromMap(map['chat']['buyer']),
      productId: map['chat']['productId'],
      lastMessage: map['chat']['lastMessage'] != null
          ? Message.fromMap(map['chat']['lastMessage'])
          : null,
      unseenMessageCount: map['unseenMessageCount'] ?? 0,
    );
  }

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  // to Json method is used to convert the ChatRoom object to a json string
  String toJson() => json.encode(toMap());
}

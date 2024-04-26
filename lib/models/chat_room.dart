import 'dart:convert';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user_model.dart';

class ChatRoom {
  final String productId;
  final String productName;
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
    required this.productName,
    this.lastMessage,
    this.unseenMessageCount = 0,
  });

  static initChatRoom() {
    return ChatRoom(
      id: "",
      seller: User.initialUser(),
      buyer: User.initialUser(),
      productId: "",
      productName: "",
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
    String? productName,
    Message? lastMessage,
    int? unseenMessageCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
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
      'lastMessage': lastMessage?.toMap(),
      'unseenMessageCount': unseenMessageCount,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      seller: User.fromMap(map['seller']),
      buyer: User.fromMap(map['buyer']),
      productId: map['productId'],
      productName: map['productName'] ?? "",
      lastMessage: map['lastMessage'] != null
          ? Message.fromMap(map['lastMessage'])
          : null,
      unseenMessageCount: map['unseenMessageCount'] ?? 0,
    );
  }

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  // to Json method is used to convert the ChatRoom object to a json string
  String toJson() => json.encode(toMap());
}

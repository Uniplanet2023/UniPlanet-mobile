import 'dart:convert';
import 'package:uniplanet/features/auth/data/models/user_model.dart';
import 'package:uniplanet/features/auth/domain/entities/user.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user.dart';

class ChatRoom {
  final String productId;
  final String productName;
  final String id;
  User seller;
  User buyer;
  Message? lastMessage;
  int unseenMessageCount;
  String? deletedFrom;

  ChatRoom({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.productId,
    required this.productName,
    this.lastMessage,
    this.unseenMessageCount = 0,
    this.deletedFrom,
  });

  static initChatRoom() {
    return ChatRoom(
      id: "",
      seller: UserModel.initialUser(),
      buyer: UserModel.initialUser(),
      productId: "",
      productName: "",
      lastMessage: null,
      unseenMessageCount: 0,
      deletedFrom: "",
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
    String? deletedFrom,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      seller: seller ?? this.seller,
      buyer: buyer ?? this.buyer,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      lastMessage: lastMessage ?? this.lastMessage,
      unseenMessageCount: unseenMessageCount ?? this.unseenMessageCount,
      deletedFrom: deletedFrom ?? this.deletedFrom,
    );
  }

  // This method is used to convert the ChatRoom object to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'seller': seller,
      'buyer': buyer,
      'productId': productId,
      'lastMessage': lastMessage?.toMap(),
      'unseenMessageCount': unseenMessageCount,
      'deletedFrom': deletedFrom ?? '',
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      seller: map['seller'] is Map
          ? UserModel.fromMap(map['seller'])
          : UserModel.fromJson(map['seller']),
      buyer: map['buyer'] is Map
          ? UserModel.fromMap(map['buyer'])
          : UserModel.fromJson(map['buyer']),
      productId: map['productId'],
      productName: map['productName'] ?? "",
      lastMessage: map['lastMessage'] != null
          ? map['lastMessage'] is Map
              ? Message.fromMap(map['lastMessage'])
              : Message.fromJson(map['lastMessage'])
          : null,
      unseenMessageCount: map['unseenMessageCount'] != null
          ? int.tryParse(map['unseenMessageCount'].toString()) ?? 0
          : 0,
      deletedFrom: map['deletedFrom'] == null || map['deletedFrom'] == ""
          ? null
          : map['deletedFrom'],
    );
  }

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  // to Json method is used to convert the ChatRoom object to a json string
  String toJson() => json.encode(toMap());
}

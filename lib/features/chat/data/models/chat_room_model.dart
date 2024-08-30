// chat_room_model.dart

import 'dart:convert';
import '../../domain/entities/chat_room.dart';
import 'message_model.dart';
import 'package:uniplanet/core/entities/user.dart';

class ChatRoomDBModel extends ChatRoom {
  ChatRoomDBModel({
    required super.id,
    required super.seller,
    required super.buyer,
    required super.productId,
    required super.productName,
    MessageDBModel? super.lastMessage,
    super.unseenMessageCount,
    super.deletedFrom,
    required super.type,
  });

  factory ChatRoomDBModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomDBModel(
      id: map['id'] as String,
      seller: map['seller'] is Map
          ? User.fromMap(map['seller'])
          : User.fromJson(map['seller']),
      buyer: map['buyer'] is Map
          ? User.fromMap(map['buyer'])
          : User.fromJson(map['buyer']),
      productId: map['productId'] as String,
      productName: map['productName'] ?? "",
      lastMessage: map['lastMessage'] != null
          ? MessageDBModel.fromMap(map['lastMessage'])
          : null,
      unseenMessageCount: map['unseenMessageCount'] != null
          ? int.tryParse(map['unseenMessageCount'].toString()) ?? 0
          : 0,
      deletedFrom: map['deletedFrom'] == null || map['deletedFrom'] == ""
          ? null
          : map['deletedFrom'],
      type: map['type'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seller': seller.toMap(),
      'buyer': buyer.toMap(),
      'productId': productId,
      'productName': productName,
      'lastMessage': lastMessage?.toMap(),
      'unseenMessageCount': unseenMessageCount,
      'deletedFrom': deletedFrom ?? '',
      'type': type,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  factory ChatRoomDBModel.fromJson(String source) =>
      ChatRoomDBModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatRoom toEntity() {
    return ChatRoom(
      id: id,
      seller: seller,
      buyer: buyer,
      productId: productId,
      productName: productName,
      lastMessage: lastMessage,
      unseenMessageCount: unseenMessageCount,
      deletedFrom: deletedFrom,
      type: type,
    );
  }

  //from Entity to Model
  factory ChatRoomDBModel.fromEntity(ChatRoom chatRoom) {
    return ChatRoomDBModel(
      id: chatRoom.id,
      seller: chatRoom.seller,
      buyer: chatRoom.buyer,
      productId: chatRoom.productId,
      productName: chatRoom.productName,
      lastMessage: chatRoom.lastMessage != null
          ? MessageDBModel.fromEntity(chatRoom.lastMessage!)
          : null,
      unseenMessageCount: chatRoom.unseenMessageCount,
      deletedFrom: chatRoom.deletedFrom,
      type: chatRoom.type,
    );
  }
}

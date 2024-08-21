import 'package:isar/isar.dart';
import 'package:uniplanet/core/isar/collection/message.dart';
import 'package:uniplanet/core/isar/collection/user.dart';
import 'package:uniplanet/models/chat_room.dart';
part 'chat_room.g.dart';

@Collection()
class ChatRoomModel {
  Id isarId = Isar.autoIncrement;
  late String productId;
  late String productName;
  late String id;
  late int unseenMessageCount;
  late String? deletedFrom;
  late String type;
  final seller = IsarLink<UserIsarModel>();
  final buyer = IsarLink<UserIsarModel>();
  final lastMessage = IsarLink<MessageModel>();

  ChatRoomModel({
    required this.productId,
    required this.productName,
    required this.id,
    required this.unseenMessageCount,
    required this.deletedFrom,
    required this.type,
  });

  factory ChatRoomModel.fromChatRoom(ChatRoom chatRoom) {
    return ChatRoomModel(
      productId: chatRoom.productId,
      productName: chatRoom.productName,
      id: chatRoom.id,
      unseenMessageCount: chatRoom.unseenMessageCount,
      deletedFrom: chatRoom.deletedFrom,
      type: chatRoom.type,
    );
  }
  Future<ChatRoom> toChatRoom() async {
    await seller.load();
    await buyer.load();
    await lastMessage.load();
    return ChatRoom(
      productId: productId,
      productName: productName,
      id: id,
      unseenMessageCount: unseenMessageCount,
      deletedFrom: deletedFrom,
      seller: seller.value!.toUser(),
      buyer: buyer.value!.toUser(),
      lastMessage: lastMessage.value?.toMessage(),
      type: type,
    );
  }
}

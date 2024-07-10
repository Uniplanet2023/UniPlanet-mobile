import 'package:isar/isar.dart';
import 'package:uniplanet/models/message.dart';
part 'message.g.dart';

@Collection()
class MessageModel {
  Id isarId = Isar.autoIncrement;
  late String id;
  late String sender;
  late String message;
  late String messageType;
  late String status;
  late String receiver;
  late String chat;
  late DateTime createdAt;
  late DateTime? readDate;

  MessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.messageType,
    required this.receiver,
    required this.chat,
    required this.createdAt,
    required this.status,
    this.readDate,
  });
  factory MessageModel.fromMessage(Message msg) {
    return MessageModel(
      id: msg.id,
      sender: msg.sender,
      message: msg.message,
      messageType: msg.messageType,
      receiver: msg.receiver,
      chat: msg.chat,
      createdAt: msg.createdAt,
      status: msg.status,
      readDate: msg.readDate,
    );
  }
  Message toMessage() {
    return Message(
      id: id,
      sender: sender,
      message: message,
      messageType: messageType,
      receiver: receiver,
      chat: chat,
      createdAt: createdAt,
      status: status,
      readDate: readDate,
    );
  }
}

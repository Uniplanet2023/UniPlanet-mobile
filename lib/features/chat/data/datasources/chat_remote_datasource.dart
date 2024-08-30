import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/features/chat/data/models/chat_room_model.dart';
import 'package:uniplanet/features/chat/data/models/message_model.dart';
import 'package:uniplanet/features/chat/domain/entities/chat_room.dart';
import 'package:uniplanet/features/chat/domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Future<ChatRoomDBModel> createChatRoom(String productId, String productName,
      String seller, String buyer, String type, String productType);
  Future<List<MessageDBModel>> getMessages(String chatId, int page);
  Future<List<ChatRoomDBModel>> getChatRooms(int page);
  Future<void> deleteChatRoom(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl({required this.dio});

  @override
  Future<ChatRoomDBModel> createChatRoom(String productId, String productName,
      String seller, String buyer, String type, String productType) async {
    final response = await dio.post(
      '$chatURI/create-chat',
      data: {
        'productId': productId,
        'productName': productName,
        'productType': productType,
        'seller': seller,
        'buyer': buyer,
        'type': type,
      },
    );
    if (response.statusCode == 200) {
      return ChatRoomDBModel.fromMap(response.data['chat']);
    } else {
      throw const ServerException(
        'Failed to create chat room',
      );
    }
  }

  @override
  Future<List<MessageDBModel>> getMessages(String chatId, int page) async {
    final response = await dio.get(
      '$chatURI/get-messages',
      queryParameters: {'chatId': chatId, 'page': page},
    );
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => MessageDBModel.fromMap(json))
          .toList();
    } else {
      throw const ServerException(
        'Failed to get messages',
      );
    }
  }

  @override
  Future<List<ChatRoomDBModel>> getChatRooms(int page) async {
    final response = await dio.get(
      '$chatURI/get-chat-list',
      queryParameters: {'page': page},
    );
    if (response.statusCode == 200) {
      return (response.data['chatList'] as List)
          .map((json) => ChatRoomDBModel.fromMap(json['chat']))
          .toList();
    } else {
      throw const ServerException(
        'Failed to get chat rooms',
      );
    }
  }

  @override
  Future<void> deleteChatRoom(String chatId) async {
    final response = await dio.delete('$chatURI/delete-chat/$chatId');
    if (response.statusCode != 200) {
      throw const ServerException(
        'Failed to delete chat room',
      );
    }
  }
}

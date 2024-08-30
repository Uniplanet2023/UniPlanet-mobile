// chat_repository_impl.dart

import 'package:uniplanet/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:uniplanet/features/chat/domain/entities/chat_room.dart';
import 'package:uniplanet/features/chat/domain/entities/message.dart';
import 'package:uniplanet/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ChatRoom> createChatRoom(
      {required String productId,
      required String productName,
      required String seller,
      required String buyer,
      required String type,
      required String productType}) async {
    final chatRoomModel = await remoteDataSource.createChatRoom(
        productId, productName, seller, buyer, type, productType);
    return chatRoomModel.toEntity();
  }

  @override
  Future<List<Message>> getMessages(
      {required String chatId, required int page}) async {
    final messageModels = await remoteDataSource.getMessages(chatId, page);
    return messageModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ChatRoom>> getChatRooms({required int page}) async {
    final chatRoomModels = await remoteDataSource.getChatRooms(page);
    return chatRoomModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> deleteChatRoom({required String chatId}) async {
    return await remoteDataSource.deleteChatRoom(chatId);
  }
}

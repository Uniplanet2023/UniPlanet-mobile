// chat_repository.dart

import '../entities/chat_room.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<ChatRoom> createChatRoom(
      {required String productId,
      required String productName,
      required String seller,
      required String buyer,
      required String type,
      required String productType});
  Future<List<Message>> getMessages(
      {required String chatId, required int page});
  Future<List<ChatRoom>> getChatRooms({required int page});
  Future<void> deleteChatRoom({required String chatId});
}

import 'package:uniplanet/features/chat/domain/entities/chat_room.dart';
import 'package:uniplanet/features/chat/domain/repository/chat_repository.dart';

class CreateChatRoom {
  final ChatRepository repository;

  CreateChatRoom(this.repository);

  Future<ChatRoom> call(
      {required String productId,
      required String productName,
      required String seller,
      required String buyer,
      required String type,
      required String productType}) {
    return repository.createChatRoom(
        productId: productId,
        productName: productName,
        seller: seller,
        buyer: buyer,
        type: type,
        productType: productType);
  }
}

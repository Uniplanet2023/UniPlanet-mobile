import 'package:uniplanet/features/chat/domain/entities/chat_room.dart';

class GetChatRooms {
  List<ChatRoom> chatRooms;
  int totalUnseenMessageCount;

  GetChatRooms(
      {required this.chatRooms, required this.totalUnseenMessageCount});
}

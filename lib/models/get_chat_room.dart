import 'package:uniplanet_mobile/models/chat_room.dart';

class GetChatRooms {
  List<ChatRoom> chatRooms;
  int totalUnseenMessageCount;

  GetChatRooms(
      {required this.chatRooms, required this.totalUnseenMessageCount});
}

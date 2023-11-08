import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/message_list.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatRepository {
  final Dio dio = Dio();

  Options _getDioOptions() => Options(headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': UserRepository.user.token
      });
  Future<ChatRoom> creatingChatRoom({required String receiverId}) async {
    ChatRoom chatRoom = ChatRoom.initialChatRoom();
    try {
      Response res = await dio.post(
        '$uri/api/createChatRoom',
        options: _getDioOptions(),
        data: {'receiverId': receiverId},
      );

      chatRoom = ChatRoom.fromMap(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return chatRoom;
  }

  Future<List<Message>> getMessages({required String chatRoomId}) async {
    try {
      Response res = await dio.post(
        '$uri/api/getMessages',
        options: _getDioOptions(),
        data: {'chatRoomId': chatRoomId},
      );

      return MessageList.fromMap(res.data).msgList;
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      Response res =
          await dio.get('$uri/api/getChatRooms', options: _getDioOptions());

      return List<ChatRoom>.from(
          res.data.map((data) => ChatRoom.fromMap(data)));
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<Message> sendMessage(
      {required String msg,
      required String chatRoomId,
      required String senderId}) async {
    SocketService.socket!.emit('sendMessage', {msg, chatRoomId});
    return Message(
      chatRoomId: chatRoomId,
      messageId: '',
      senderId: senderId,
      message: msg,
      type: MessageEnum.text,
      isSeen: false,
      timestamp: DateTime.now(),
    );
  }

  void _handleDioException(DioException e) {
    if (e.response != null) {
      SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
    } else {
      print(e);
    }
  }
}

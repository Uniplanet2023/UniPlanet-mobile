import 'dart:async';

import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/message_list.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatRepository {
  final Dio dio = Dio();

  Options _getDioOptions() => Options(headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

  Future<MyChatRoom> creatingChatRoom(
      {required String receiverId, required String productId}) async {
    MyChatRoom chatRoom = MyChatRoom.initMyChatRoom();
    try {
      Response res = await dio.post(
        '$chatURI/api/createChatRoom',
        options: _getDioOptions(),
        data: {'receiverId': receiverId, 'productId': productId},
      );

      chatRoom = MyChatRoom.fromMap(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return chatRoom;
  }

  Future<List<Message>> getMessages(
      {required String myChatRoomId, required int page}) async {
    try {
      Response res = await dio.post(
        '$chatURI/api/getMessages',
        options: _getDioOptions(),
        data: {'myChatRoomId': myChatRoomId, 'page': page},
      );

      return MessageList.fromMap(res.data).msgList;
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<List<MyChatRoom>> getChatRooms() async {
    try {
      Response res =
          await dio.get('$chatURI/api/getChatRooms', options: _getDioOptions());

      return List<MyChatRoom>.from(
          res.data.map((data) => MyChatRoom.fromMap(data)));
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<Message> sendMessage(
      {required String msg,
      required String chatRoomId,
      required String senderId}) async {
    // SocketService.socket!.emit('sendMessage', {msg, chatRoomId});

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

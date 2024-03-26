import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/network/display_error_messages.dart';

class ChatRepository {
  final DioClient _dioClient;

  ChatRepository(this._dioClient);

  Future<ChatRoom> creatingChatRoom(
      {required String productId,
      required User seller,
      required User buyer}) async {
    ChatRoom chatRoom = ChatRoom.initChatRoom();
    try {
      Response res = await _dioClient.dio.post(
        '$chatURI/create-chat',
        options: _dioClient.getDioOptions(),
        data: {
          'productId': productId,
          'seller': seller,
          'buyer': buyer,
        },
      );

      chatRoom = ChatRoom.fromMap(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return chatRoom;
  }

  Future<List<Message>> getMessages(
      {required String chatId, required int page}) async {
    try {
      List<Message> messages = [];
      Response res = await _dioClient.dio.get(
        '$chatURI/get-messages',
        options: _dioClient.getDioOptions(),
        queryParameters: {'chatId': chatId, 'page': page},
      );
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        var dataList = jsonDecode(res.toString());

        if (dataList != null) {
          messages = List<Message>.from(
            dataList.map((data) => Message.fromMap(data)).toList(),
          );
        }
        return messages;
      } else {
        return [];
      }
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      Response res = await _dioClient.dio
          .get('$chatURI/get-chat-list', options: _dioClient.getDioOptions());

      List<ChatRoom> chatRoomList =
          List<ChatRoom>.from(res.data.map((data) => ChatRoom.fromMap(data)));
      return chatRoomList;
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  void _handleDioException(DioException e) {
    if (e.response != null) {
      SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
    } else {
      print(e);
    }
  }
}

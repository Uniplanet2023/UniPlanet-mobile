import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/isar/isar_service.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/models/get_chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';

class ChatRepository {
  final DioHelper _dioClient;

  ChatRepository(this._dioClient);

  Future<ChatRoom> creatingChatRoom(
      {required String productId,
      required String productName,
      required User seller,
      required User buyer}) async {
    ChatRoom chatRoom = ChatRoom.initChatRoom();
    try {
      Response res = await _dioClient.dio.post(
        '$chatURI/create-chat',
        options: _dioClient.getDioOptions(),
        data: {
          'productId': productId,
          'productName': productName,
          'seller': seller,
          'buyer': buyer,
        },
      );

      chatRoom = ChatRoom.fromMap(res.data['chat']);

      bool userOnline = await Initialization.socketService
          .chatRoomCreateAndCheckUserExist(
              chat: chatRoom, existingChat: res.data['msg'] == 'existing chat');
      if (userOnline) {
        getIt<StatusBloc>().add(ConnectedEvent(userId: chatRoom.seller.id));
      }
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

  Future<GetChatRooms> getChatRooms({required int page}) async {
    List<ChatRoom> chatRoomList = [];
    try {
      Response res = await _dioClient.dio.get(
        '$chatURI/get-chat-list',
        options: _dioClient.getDioOptions(),
        queryParameters: {'page': page},
      );
      if (res.data.length == 0) {
        return GetChatRooms(chatRooms: [], totalUnseenMessageCount: 0);
      }
      chatRoomList = List<ChatRoom>.from(
          res.data['chatList'].map((data) => ChatRoom.fromMap(data['chat'])));
      IsarService.instance.saveChatData(chatRoomList);
      return GetChatRooms(
          chatRooms: chatRoomList,
          totalUnseenMessageCount: res.data["totalUnseenMessage"]);
    } on DioException catch (e) {
      _handleDioException(e);
      List<ChatRoom> chatRoomsList = await IsarService.instance.getChatRooms();
      if (page > 1) {
        return GetChatRooms(chatRooms: [], totalUnseenMessageCount: 0);
      } else {
        return GetChatRooms(
            chatRooms: chatRoomsList, totalUnseenMessageCount: 0);
      }
    }
  }

  Future<String> deleteChatRoom({required String chatId}) async {
    try {
      Response res = await _dioClient.dio.delete(
        '$chatURI/delete-chat/$chatId',
        options: _dioClient.getDioOptions(),
      );
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        return "success";
      } else {
        return "failed";
      }
    } on DioException catch (e) {
      _handleDioException(e);
      return "failed";
    }
  }

  void _handleDioException(DioException e) {
    if (e.response != null) {
      SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
    } else {
      log(e);
    }
  }
}

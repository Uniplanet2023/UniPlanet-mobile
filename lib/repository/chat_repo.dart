import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';

import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/message_list.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatRepository {
  Future<List<Message>> getMessages(
      {required String chatRoomId, required List<String> msgList}) async {
    List<Message> listMsg = [];
    try {
      Dio dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('x-auth-token')!;

      Response res = await dio.post(
        '$uri/api/getMessages',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        }),
        data: {'msgList': msgList},
      );

      listMsg = MessageList.fromMap(res.data).msgList;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return listMsg;
  }

  Future<ChatRoom?> creatingChatRoom(
      {required User user, required String receiverId}) async {
    try {
      ChatRoom chatRoom;
      print('creating ChatRoom API triggered');
      Dio dio = Dio();
      Response res = await dio.post(
        '$uri/api/joinChatingRoom',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
        data: {'receiverId': receiverId},
      );

      chatRoom = ChatRoom.fromMap(res.data);

      return chatRoom;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return null;
  }

  Future<List<ChatRoom>> getChatRoom(List<String> chatRoomIds) async {
    List<ChatRoom> chatRoomList = [];
    try {
      Dio dio = Dio();
      print('getChatRoom triggered');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('x-auth-token')!;

      Response res = await dio.get('$uri/api/getChatRooms',
          data: {'chatRoomIds': chatRoomIds},
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          }));

      for (var i = 0; i < res.data.length; i++) {
        ChatRoom chatRoom = ChatRoom.fromMap(res.data[i]);

        chatRoomList.add(chatRoom);
      }

      return chatRoomList;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return chatRoomList;
  }

  Future<Message> sendMessage(
      {required String msg,
      required String chatRoomId,
      required String senderId}) async {
    // receiverId, messages, last Messages
    SocketService.socket!.emit('sendMessage', {msg, chatRoomId});
    Message sMsg = Message(
        chatRoomId: chatRoomId,
        messageId: "",
        senderId: senderId,
        message: msg,
        type: MessageEnum.text,
        isSeen: false,
        timestamp: DateTime.now());
    return sMsg;
  }
}

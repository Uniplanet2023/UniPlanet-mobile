import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/message_list.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ChatRepository {
  static socketio.Socket socket = socketio.io(
      uri,
      socketio.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  ChatRepository() {
    socket.onConnect((_) {
      print('connect');
    });
    socket.onDisconnect((_) => throw Exception('disconnected'));
    socket.onConnectError((data) => throw Exception(data));
    socket.connect();
  }
  Future<List<Message>> getMessages({required List<String> msgList}) async {
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
      print(res.data);
      listMsg = MessageList.fromMap(res.data).msgList;
      print(listMsg);
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
      print(res.data);
      var receiver = "";
      var type = "seller";
      Message? lastMsg;
      if (res.data['lastMessage'] != null) {
        print('lastMessage called');
        lastMsg = Message.fromMap(res.data['lastMessage']);
      }
      print('no lastMessage');
      if (res.data['buyer'] == null) {
        receiver = res.data['seller']['name'];
        type = "buyer";
      } else {
        receiver = res.data['buyer']['name'];
      }

      chatRoom = ChatRoom(
          msgList: res.data['messages'],
          chatRoomId: res.data['_id'],
          name: receiver,
          type: type,
          lastMessage: lastMsg,
          lastMessageTime: lastMsg?.timestamp);

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
        var receiver = "";
        var type = "seller";

        Message? lastMsg;

        if (res.data[i]['lastMessage'] != null) {
          print('lastMessage called');
          lastMsg = Message.fromMap(res.data['lastMessage']);
        }

        if (res.data[i]['buyer'] == null) {
          receiver = res.data[i]['seller']['name'];
          type = "buyer";
        } else {
          receiver = res.data[i]['buyer']['name'];
        }

        ChatRoom chatRoom = ChatRoom(
            msgList: List<String>.from(res.data[i]['messages']),
            chatRoomId: res.data[i]['_id'],
            name: receiver,
            type: type,
            lastMessage: lastMsg,
            lastMessageTime: lastMsg?.timestamp);
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

  Future<Message?> sendMessage(
      {required BuildContext context,
      required String msg,
      required String chatRoomId}) async {
    User user = context.read<UserBloc>().state.user!;
    // receiverId, messages, last Messages
    try {
      Dio dio = Dio();

      Response res = await dio.post(
        '$uri/api/joinChatingRoom',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
        data: {'message': msg, 'user_id': user.id, 'chatroom_id': chatRoomId},
      );
      Message sMsg = Message.fromJson(res.data);
      print(sMsg);
      // Message(messageId: messageId, senderId: senderId, message: message, type: type, isSeen: isSeen, timestamp: timestamp);
      if (!context.mounted) throw Error();
      // httpErrorHandle(
      //   response: res,
      //   context: context,
      //   onSuccess: () {
      //     for (int i = 0; i < res.data.length; i++) {
      //       productList.add(
      //         Product.fromJson(
      //           jsonEncode(
      //             res.data[i],
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // );
      return sMsg;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return null;
  }
}

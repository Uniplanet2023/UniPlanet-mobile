import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
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
  Future<ChatRoom?> creatingChatRoom({required String receiverId}) async {
    try {
      ChatRoom chatRoom;
      var user = UserRepository().getUser;
      Dio dio = Dio();
      Response res = await dio.post(
        '$uri/api/joinChatingRoom',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
        data: {'userId': user.id, 'receiverId': receiverId},
      );

      chatRoom = ChatRoom(receiverName: res.data['receiver']['receiverName']);

      return chatRoom;
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return null;
  }

  Future<Message> sendMessage(
      {required BuildContext context,
      required String msg,
      required String receiverId}) async {
    var user = UserRepository().getUser;
    // receiverId, messages, last Messages
    Message Message1 = Message(
        senderId: user.id,
        recieverid: "recieverid",
        text: "msg",
        type: MessageEnum.text,
        timeSent: DateTime.now(),
        messageId: "messageId",
        isSeen: false,
        repliedMessage: "repliedMessage",
        repliedTo: "repliedTo",
        repliedMessageType: MessageEnum.text);
    try {
      Dio dio = Dio();

      Response res = await dio.post(
        '$uri/api/joinChatingRoom',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
        data: {'message': msg, 'user_id': user.id, 'receiver_id': receiverId},
      );

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
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return Message1;
  }
}

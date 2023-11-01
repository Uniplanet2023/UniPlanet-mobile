import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';

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
          lastMsg = Message.fromMap(res.data[i]['lastMessage']);
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
      print('checking');

      for (var chatRoomId in chatRoomIds) {
        print(chatRoomId);
        socketService.socket!.emit('joinChatRoom', chatRoomId);
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
      {required String msg, required String chatRoomId}) async {
    // receiverId, messages, last Messages
    print("send Message API");
    Message sMsg = Message.initialMessage();

    // try {
    //   print('sendMessage called');

    //   Dio dio = Dio();
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String token = prefs.getString('x-auth-token')!;
    //   Response res = await dio.post(
    //     '$uri/api/message',
    //     options: Options(headers: {
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'x-auth-token': token,
    //     }),
    //     data: {'message': msg, 'chatroom_id': chatRoomId},
    //   );

    //   sMsg = Message.fromJson(res.data);
    // } catch (e) {
    //   if (e is DioException) {
    //     if (e.response != null) {
    //       SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
    //     }
    //   }
    // }
    return sMsg;
  }
}

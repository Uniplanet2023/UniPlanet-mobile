import 'dart:async';

import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/message_list.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatRepository {
  final DioClient _dioClient;

  ChatRepository(this._dioClient);

  Future<ChatRoom> creatingChatRoom(
      {required String productId,
      required String profileImage,
      required User seller}) async {
    ChatRoom chatRoom = ChatRoom.initChatRoom();
    try {
      Response res = await _dioClient.dio.post(
        '$chatURI/create-chat',
        options: _dioClient.getDioOptions(),
        data: {
          'productId': productId,
          'buyerProfileImage': profileImage,
          'sellerId': seller.id,
          'sellerName': seller.name,
          'sellerProfileImage': seller.profileImage,
          'sellerEmail': seller.email,
          'sellerSchool': seller.school,
        },
      );

      chatRoom = ChatRoom.fromMap(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return chatRoom;
  }

  Future<List<Message>> getMessages(
      {required String myChatRoomId, required int page}) async {
    try {
      Response res = await _dioClient.dio.post(
        '$chatURI/api/getMessages',
        options: _dioClient.getDioOptions(),
        data: {'myChatRoomId': myChatRoomId, 'page': page},
      );

      return MessageList.fromMap(res.data).msgList;
    } on DioException catch (e) {
      _handleDioException(e);
      return [];
    }
  }

  Future<List<ChatRoom>> getChatRooms() async {
    try {
      Response res = await _dioClient.dio.get('$chatURI/api/getChatRooms',
          options: _dioClient.getDioOptions());

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
    // SocketService.socket!.emit('sendMessage', {msg, chatRoomId});

    return Message(
      chatRoomId: chatRoomId,
      messageId: '',
      senderId: senderId,
      receiverId: '',
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

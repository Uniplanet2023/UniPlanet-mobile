import 'dart:convert';

import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';

class MyChatRoom {
  final String myChatRoomId;
  final User receiver;
  final String type;
  final ChatRoom chatRoom;
  List<String> unseenMessage;

  MyChatRoom(
      {required this.myChatRoomId,
      required this.receiver,
      required this.type,
      required this.chatRoom,
      required this.unseenMessage});

  static initMyChatRoom() {
    return MyChatRoom(
        myChatRoomId: "",
        receiver: User.initialUser(),
        type: '',
        chatRoom: ChatRoom.initChatRoom(),
        unseenMessage: []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'myChatRoomId': myChatRoomId,
      'receiver': receiver,
      'type': type,
      'chatRoom': chatRoom,
      'unseenMessage': unseenMessage
    };
  }

  factory MyChatRoom.fromMap(Map<String, dynamic> map) {
    return MyChatRoom(
        myChatRoomId: map['_id'],
        receiver: User.fromMap(map['receiver']),
        type: map['type'],
        chatRoom: ChatRoom.fromMap(map['chatRoom']),
        unseenMessage: List<String>.from(map['unseenMessage']));
  }

  String toJson() => json.encode(toMap());

  factory MyChatRoom.fromJson(String source) =>
      MyChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);
}

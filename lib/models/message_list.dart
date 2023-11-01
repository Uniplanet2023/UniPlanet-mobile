import 'dart:convert';

import 'package:uniplanet_mobile/models/message.dart';

class MessageList {
  final List<Message> msgList;
  MessageList({required this.msgList});
  static initMessageList() {
    return MessageList(msgList: []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msgList': msgList.map((x) => x.toMap()).toList(),
    };
  }

  factory MessageList.fromMap(Map<String, dynamic> map) {
    return MessageList(
        msgList: (map['messages'] as List)
            .map((messageMap) =>
                Message.fromMap(messageMap as Map<String, dynamic>))
            .toList()
            .reversed
            .toList());
  }

  String toJson() => json.encode(toMap());

  factory MessageList.fromJson(String source) =>
      MessageList.fromMap(json.decode(source) as Map<String, dynamic>);
}

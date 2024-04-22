import 'dart:convert';
import 'package:uniplanet/models/message.dart';

class ImageMessage {
  final String filePath;
  final Message message;

  ImageMessage({
    required this.filePath,
    required this.message,
  });
  static ImageMessage initMessage() {
    return ImageMessage(
      filePath: "",
      message: Message.initMessage(),
    );
  }

  ImageMessage copyWith({
    String? filePath,
    Message? message,
  }) =>
      ImageMessage(
        filePath: filePath ?? this.filePath,
        message: message ?? this.message,
      );

  factory ImageMessage.fromRawJson(String str) =>
      ImageMessage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ImageMessage.fromMap(Map<String, dynamic> json) {
    return ImageMessage(
      filePath: json["filePath"],
      message: Message.fromMap(json["message"]),
    );
  }
  Map<String, dynamic> toMap() => {
        "filePath": filePath,
        "message": message.toMap(),
      };
}

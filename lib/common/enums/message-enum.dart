enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageEnum(this.type);
  final String type;
}

// Using an extension
// Enhanced enums

extension MessageEnumExtension on MessageEnum {
  String get value {
    switch (this) {
      case MessageEnum.text:
        return 'text';
      case MessageEnum.image:
        return 'image';
      case MessageEnum.audio:
        return 'audio';
      case MessageEnum.video:
        return 'video';
      case MessageEnum.gif:
        return 'gif';
      default:
        return 'text';
    }
  }

  static MessageEnum fromString(String value) {
    switch (value) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}

enum MessageStatusEnum {
  sending('sending'),
  sent('sent'),
  received('received'),
  read('read'),
  error('error');

  const MessageStatusEnum(this.type);
  final String type;
}

// Using an extension
// Enhanced enums

extension MessageEnumExtension on MessageStatusEnum {
  String get value {
    switch (this) {
      case MessageStatusEnum.sending:
        return 'sending';
      case MessageStatusEnum.sent:
        return 'sent';
      case MessageStatusEnum.received:
        return 'received';
      case MessageStatusEnum.read:
        return 'read';
      default:
        return 'error';
    }
  }

  static MessageStatusEnum fromString(String value) {
    switch (value) {
      case 'sending':
        return MessageStatusEnum.sending;
      case 'sent':
        return MessageStatusEnum.sent;
      case 'received':
        return MessageStatusEnum.received;
      case 'read':
        return MessageStatusEnum.read;
      default:
        return MessageStatusEnum.error;
    }
  }
}

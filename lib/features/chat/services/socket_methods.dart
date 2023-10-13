import 'dart:io';

import 'package:socket_io_client/src/socket.dart';
import 'package:uniplanet_mobile/features/chat/services/socket_client.dart';

class SocketMethod {
  final _socketClient = SocketClient.instance.socket!;
  Socket get socketClient => _socketClient;
}

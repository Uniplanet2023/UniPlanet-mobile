import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/constants/global_variables.dart';

class SocketClient {
  socketio.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = socketio.io(
        uri,
        socketio.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket!.onConnect((_) {
      print('connect');
    });
    socket!.onDisconnect((_) => print('disconnect'));
    socket!.onConnectError((data) => print(data));
    socket!.emit('/test', 'hello would');
    socket!.connect();
  }
  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}

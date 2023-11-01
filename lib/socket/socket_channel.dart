import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/constants/global_variables.dart';

class socketService {
  static socketio.Socket? socket;
  socketService() {
    _initSocket();
  }
  _initSocket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('x-auth-token')!;
    if (token.isEmpty) {
      print('There is No token');
    } else {
      socket = socketio.io(
          uri,
          socketio.OptionBuilder()
              .setTransports(['websocket'])
              .setExtraHeaders({
                'x-auth-token': token,
              })
              .disableAutoConnect()
              .build());

      socket!.onConnect((_) {
        print('connect');
      });
      socket!.onDisconnect((_) => throw Exception('disconnected'));
      socket!.onConnectError((data) => throw Exception(data));
      socket!.connect();
    }
  }
}

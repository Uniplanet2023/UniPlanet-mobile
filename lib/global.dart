import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';

class Global {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DioClient.instance.initCookie();
  }
}

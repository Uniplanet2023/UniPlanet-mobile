import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DioHelper {
  static final DioHelper _instance = DioHelper._internal();
  static DioHelper get instance => _instance;

  late Directory _appDocDir;
  late PersistCookieJar _cookieJar;
  late String? _sessionToken;
  late final Dio _dio;

  DioHelper._internal() {
    _dio = Dio();
  }

  Options getDioOptions() => Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        validateStatus: (status) => status! < 500,
      );

  Future<void> init() async {
    // Use the application documents directory to persist cookies
    _appDocDir = await path_provider.getApplicationDocumentsDirectory();
    final appDocPath = _appDocDir.path;

    // Create a cookie jar in a persistent storage directory
    _cookieJar = PersistCookieJar(
      storage: FileStorage(appDocPath), // Store in persistent location
      ignoreExpires: true,
    );

    _dio.interceptors.add(CookieManager(_cookieJar));
    _sessionToken = await getSessionToken();
  }

  Future<void> clearCookies() async {
    final appDocPath = _appDocDir.path;

    var cookieJar = PersistCookieJar(
      storage: FileStorage(appDocPath),
      ignoreExpires: true,
    );
    _sessionToken = null;
    await cookieJar.deleteAll();
  }

  Future<String?> getSessionToken() async {
    final appDocPath = _appDocDir.path;

    var cookieJar = PersistCookieJar(
      storage: FileStorage(appDocPath), // Load from persistent storage
      ignoreExpires: true,
    );

    List<Cookie> cookies = await cookieJar
        .loadForRequest(Uri.parse("https://auth.uniplanet.shop"));

    String? sessionToken;
    await _cookieJar.saveFromResponse(
        Uri.parse("https://auth.uniplanet.shop"), cookies);
    for (var cookie in cookies) {
      if (cookie.name == 'session') {
        sessionToken = cookie.value;
        break;
      }
    }
    _sessionToken = sessionToken;
    return sessionToken;
  }

  String? get session => _sessionToken;
  Dio get dio => _dio;
}

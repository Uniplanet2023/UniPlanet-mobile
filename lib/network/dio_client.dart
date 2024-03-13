import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;
  late Directory _tempDir;
  late String? _sessionToken;
  late final Dio _dio;
  Options getDioOptions() => Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        validateStatus: (status) => status! < 500,
      );
  DioClient._internal() {
    _dio = Dio();
  }

  Future<void> initCookie() async {
    _tempDir = await path_provider.getTemporaryDirectory();
    final tempPath = _tempDir.path;
    var cookieJar = PersistCookieJar(
      storage: FileStorage(tempPath),
      ignoreExpires: true,
    );

    _dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> clearCookie() async {
    final tempPath = _tempDir.path;

    var cookieJar = PersistCookieJar(
      storage: FileStorage(tempPath),
      ignoreExpires: true,
    );
    _sessionToken = null;
    cookieJar.deleteAll();
  }

  Future<void> getSessionToken() async {
    final tempPath = _tempDir.path;

    var cookieJar = PersistCookieJar(
      storage: FileStorage(tempPath),
      ignoreExpires: true,
    );

    // Assuming the server you're connecting to is 'example.com'
    List<Cookie> cookies = await cookieJar
        .loadForRequest(Uri.parse("http://uniplanet-back.autos"));
    String? sessionToken;

    for (var cookie in cookies) {
      if (cookie.name == 'session') {
        sessionToken = cookie.value;
        break;
      }
    }
    _sessionToken = sessionToken;
  }

  String? get session => _sessionToken;
  Dio get dio => _dio;
}

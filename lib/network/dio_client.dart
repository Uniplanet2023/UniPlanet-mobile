import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

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
    Directory tempDir = await path_provider.getTemporaryDirectory();
    final tempPath = tempDir.path;
    var cookieJar = PersistCookieJar(
      storage: FileStorage(tempPath),
      ignoreExpires: true,
    );

    _dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> clearCookie() async {
    Directory tempDir = await path_provider.getTemporaryDirectory();
    final tempPath = tempDir.path;

    var cookieJar = PersistCookieJar(
      storage: FileStorage(tempPath),
      ignoreExpires: true,
    );

    cookieJar.deleteAll();
  }

  Dio get dio => _dio;
}

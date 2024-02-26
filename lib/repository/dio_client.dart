import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;
  late final Dio _dio;

  DioClient._internal() {
    // BaseOptions options = BaseOptions(
    //   baseUrl: "http://your-api-url.com", // Your API base URL
    //   connectTimeout: 5000,
    //   receiveTimeout: 3000,
    // );

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

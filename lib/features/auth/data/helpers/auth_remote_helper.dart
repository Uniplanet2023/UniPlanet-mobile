import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';

Future<Response> postRequest(String url, Map<String, dynamic> data) async {
  return await DioHelper.instance.dio
      .post(url, data: data, options: DioHelper.instance.getDioOptions());
}

Future<Response> putRequest(String url, Map<String, dynamic> data) async {
  return await DioHelper.instance.dio
      .put(url, data: data, options: DioHelper.instance.getDioOptions());
}

Future<Response> deleteRequest(String url) async {
  return await DioHelper.instance.dio
      .delete(url, options: DioHelper.instance.getDioOptions());
}

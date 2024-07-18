import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

Future<Response> postRequest(String url, Map<String, dynamic> data) async {
  return await DioHelper.instance.dio.post(url, data: data);
}

Future<Response> putRequest(String url, Map<String, dynamic> data) async {
  return await DioHelper.instance.dio.put(url, data: data);
}

Future<Response> deleteRequest(String url) async {
  return await DioHelper.instance.dio.delete(url);
}

void saveUserData(Map<String, dynamic> data) {
  SharedPreferencesHelper.instance.saveString('userData', jsonEncode(data));
  AuthRepository.userId = data['id'];
  AuthRepository.school = data['school'];
  AuthRepository.email = data['email'];
  AuthRepository.type = data['type'];
}

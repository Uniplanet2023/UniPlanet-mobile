import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/auth-repository/auth-repo-interface.dart';
import 'package:uniplanet_mobile/repository/dio_client.dart';

class AuthRepository implements IAuthRepository {
  static User user = User.initialUser();

  Options _getDioOptions() => Options(headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

  @override
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
  }) async {
    try {
      String hash = "";
      print('$authURI/signin');
      Response res = await DioClient.instance.dio.post('$authURI/signup',
          data: {
            'name': name,
            'email': email,
            'password': password,
            'school': school
          },
          options: _getDioOptions());
      SnackbarGlobal.showSnackBar(
        'Account created! Please Verify your email',
      );
      hash = res.data['hash'];

      return hash;
    } on DioException catch (e) {
      httpErrorHandle(
        response: e.response!,
        onSuccess: () async {},
      );
    }
    return null;
  }

  @override
  Future<bool> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      Response res =
          await DioClient.instance.dio.post('$authURI/signin', data: {
        'email': email,
        'password': password,
      });

      if (res.data['access']) {
        return res.data['access'];
      }
      return false;
    } on DioException catch (e) {
      //TODO: Handle error
      httpErrorHandle(
        response: e.response!,
        onSuccess: () async {},
      );
    }
    return false;
  }

  @override
  Future<String> logOut() async {
    try {
      user = User.initialUser();

      Response res = await DioClient.instance.dio.delete('$authURI/logout');
      await DioClient.instance.clearCookie();

      if (res.data['message'] != "Logged Out Successfully") {
        return "Logout Failed";
      } else {
        return res.data['message'];
      }
    } on DioException catch (e) {
      httpErrorHandle(
        response: e.response!,
        onSuccess: () async {},
      );
      return "Dio Error";
    }
  }

  @override
  Future<String> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      var res = await DioClient.instance.dio.post('$authURI/sendOtp',
          data: jsonEncode({
            'email': email,
          }));
      if (res.data['message'] == "User with same email already exists!") {
        SnackbarGlobal.showSnackBar(
          "User with same email already exists!",
        );
      }

      return res.data.toString();
    } on DioException catch (e) {
      return "Dio Error";
    }
  }

  @override
  Future<bool> tokenValidation() async {
    try {
      var res = await DioClient.instance.dio
          .post('$authURI/token-login', options: _getDioOptions());

      if (res.data != null &&
          res.data['access'] != null &&
          res.data['access'] == true) {
        return res.data['access'];
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return false;
      }
      httpErrorHandle(
        response: e.response!,
        onSuccess: () async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString('x-auth-token', res.data['token']);
        },
      );
    }
    return false; // Return false if the condition is not met
  }

  @override
  Future<void> forgottenPassword({
    required BuildContext context,
    required String email,
  }) async {
    var res = await DioClient.instance.dio.put('$authURI/forgottenPassword',
        data: jsonEncode({'email': email}),
        options: Options(headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }));

    if (res.data['message'] ==
        "User with the given email address doesn't exists!") {
      SnackbarGlobal.showSnackBar(
        "Email address not found!",
      );
    }
    if (res.data['message'] == "Password updated successfully") {
      SnackbarGlobal.showSnackBar(
        "Password reset successful, Use the temporary password sent to your email to log in ",
      );
    } else {
      SnackbarGlobal.showSnackBar(
        "Something went wrong!",
      );
    }
  }

  @override
  Future<bool> otpValidation(String email, String hash, String otpCode) async {
    try {
      var res = await DioClient.instance.dio.post('$authURI/verify_OTP',
          data: jsonEncode({
            'email': email,
            'otpHash': hash,
            'otpCode': otpCode,
          }));
      if (res.data['message'] == "OTP expired") {
        SnackbarGlobal.showSnackBar(
          "OTP expired",
        );
      }
      if (res.data['message'] == "Invalid Verfication number") {
        SnackbarGlobal.showSnackBar(
          "Invalid Verfication number",
        );
      }
      if (res.data['message'] == "Success") {
        return true;
      }
    } on DioException catch (e) {
      httpErrorHandle(
        response: e.response!,
        onSuccess: () async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString('x-auth-token', res.data['token']);
        },
      );
    }
    return false;
  }
}

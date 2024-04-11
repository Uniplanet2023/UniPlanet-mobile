import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/network/api_def/api_server_address.dart';
import 'package:uniplanet_mobile/network/api_def/display_error_messages.dart';
import 'package:uniplanet_mobile/network/repository/auth_repository/auth_repo_interface.dart';
import 'package:uniplanet_mobile/network/api_def/dio_client.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';

class AuthRepository implements IAuthRepository {
  final DioClient _dioClient;
  static String? userId;
  static String? school;
  static String? email;

  AuthRepository(this._dioClient);
  @override
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
  }) async {
    try {
      Response res = await _dioClient.dio.post('$authURI/signup',
          data: {
            'name': name,
            'email': email,
            'password': password,
            'school': school
          },
          options: _dioClient.getDioOptions());
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        SnackbarGlobal.showSnackBar(
          'Account created! Please Verify your email',
        );
        return res.data['hash'];
      } else {
        return 'Failed';
      }
    } on DioException catch (e) {
      return "Dio Error";
    }
  }

  @override
  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response res = await _dioClient.dio.post('$authURI/signin',
          data: {
            'email': email,
            'password': password,
          },
          options: _dioClient.getDioOptions());

      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        prefs.setString('userData', jsonEncode(res.data));
        userId = res.data['id'];
        school = res.data['school'];
        email = res.data['email'];
      }
      return msg;
    } on DioException catch (e) {
      //TODO: Handle error
      return e.response!.data['message'];
    }
  }

  @override
  Future<String> logOut() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Response res = await _dioClient.dio
          .delete('$authURI/signout', options: _dioClient.getDioOptions());
      await _dioClient.clearCookie();

      if (res.data['message'] != "Logged Out Successfully") {
        prefs.remove('userData');
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
  Future<String> requestOtp({
    required String email,
  }) async {
    try {
      var res = await _dioClient.dio.post('$authURI/request-OTP',
          data: {'email': email}, options: _dioClient.getDioOptions());
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        return res.data['hash'];
      } else {
        return 'Failed';
      }
    } on DioException catch (e) {
      return "Dio Error";
    }
  }

  @override
  Future<bool> tokenValidation() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = prefs.getString('userData');
      var userRecord = jsonDecode(userData.toString());
      var token = await DioClient.instance.getSessionToken();
      if (token == null || userRecord == null) {
        Response res = await _dioClient.dio
            .post('$authURI/token-login', options: _dioClient.getDioOptions());
        if (res.data['id'] != null) {
          prefs.setString('userData', jsonEncode(res.data));
          userId = res.data['id'];
          school = res.data['school'];
          email = res.data['email'];
          return true;
        }
      } else {
        var userInfo = jsonDecode(userData!);
        userId = userInfo['id'];
        school = userInfo['school'];
        email = userInfo['email'];
        return true;
      }
      return false;
    } on DioException catch (e) {
      print(e);
    }
    return false; // Return false if the condition is not met
  }

  @override
  Future<void> forgottenPassword({
    required String email,
  }) async {
    var res = await _dioClient.dio.put('$authURI/forgotten-password',
        data: jsonEncode({'email': email}),
        options: _dioClient.getDioOptions());

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
  Future<String> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    var res = await _dioClient.dio.put('$authURI/password_update',
        data: {'password': password, 'newPassword': newPassword},
        options: _dioClient.getDioOptions());

    if (res.data['message'] == "Password updated successfully") {
      SnackbarGlobal.showSnackBar(
        "Password updated successfully",
      );
      await logOut();
      return "Password Updated Successfully";
    } else {
      SnackbarGlobal.showSnackBar(
        "Something went wrong!",
      );
      return "Password Update Failed";
    }
  }

  @override
  Future<bool> otpValidation(String email, String hash, String otpCode) async {
    try {
      var res = await _dioClient.dio.post('$authURI/verify-OTP',
          data: {
            'email': email,
            'otpHash': hash,
            'otpCode': otpCode,
          },
          options: _dioClient.getDioOptions());
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
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

// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:uniplanet/core/utils/error_handling.dart';
// import 'package:uniplanet/core/utils/utils.dart';
// import 'package:uniplanet/config/api/server_address.dart';
// import 'package:uniplanet/core/utils/display_error_messages.dart';
// import 'package:uniplanet/core/network/repository/auth_repository/auth_repo_interface.dart';
// import 'package:uniplanet/core/helper/dio_helper.dart';
// import 'package:uniplanet/core/helper/shared_preferences_helper.dart';

// class AuthRepository implements IAuthRepository {
//   final DioHelper _dioClient;
  // static String? userId;
  // static String? school;
  // static String? email;
  // static String? type;

//   AuthRepository(this._dioClient);
  // @override
  // Future<String> signUpUser({
  //   required String email,
  //   required String password,
  //   required String name,
  //   required String school,
  //   required String userType,
  // }) async {
  //   try {
  //     Response res = await _dioClient.dio.post('$authURI/signup',
  //         data: {
  //           'name': name,
  //           'email': email,
  //           'password': password,
  //           'school': school,
  //           'userType': userType
  //         },
  //         options: _dioClient.getDioOptions());
  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == "success") {
  //       SnackbarGlobal.showSnackBar(
  //         'Account created! Please Verify your email',
  //       );
  //       return res.data['hash'];
  //     } else {
  //       return 'Failed';
  //     }
  //   } on DioException catch (e) {
  //     log(e);
  //     return "Failed";
  //   }
  // }

  // @override
  // Future<String> signInUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  //     Response res = await _dioClient.dio.post('$authURI/signin',
  //         data: {
  //           'email': email,
  //           'password': password,
  //         },
  //         options: _dioClient.getDioOptions());

  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == "success") {
  //       if (res.data['deletionDate'] != null) {
  //         SnackbarGlobal.showSnackBar(
  //           "Account restored Successfully!",
  //         );
  //       }

  //       prefsHelper.saveString('userData', jsonEncode(res.data));
  //       userId = res.data['id'];
  //       school = res.data['school'];
  //       email = res.data['email'];
  //       type = res.data['type'];
  //     }
  //     return msg;
  //   } on DioException catch (e) {
  //     return e.response!.data['message'];
  //   }
  // }

//   @override
  // Future<String> logOut() async {
  //   try {
  //     final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  //     Response res = await _dioClient.dio
  //         .delete('$authURI/signout', options: _dioClient.getDioOptions());
  //     await _dioClient.init();

  //     if (res.data['message'] != "Logged Out Successfully") {
  //       return "Logout Failed";
  //     } else {
  //       prefsHelper.clear();
  //       return res.data['message'];
  //     }
  //   } on DioException catch (e) {
  //     httpErrorHandle(
  //       response: e.response!,
  //       onSuccess: () async {},
  //     );
  //     return "Dio Error";
  //   }
  // }

//   @override
//   Future<String> requestOtp({
//     required String email,
//   }) async {
//     try {
//       var res = await _dioClient.dio.post('$authURI/request-OTP',
//           data: {'email': email}, options: _dioClient.getDioOptions());
//       String msg = displayErrorMessages(res.toString());
//       if (msg == "success") {
//         return res.data['hash'];
//       } else {
//         return 'Failed';
//       }
//     } on DioException catch (e) {
//       return "Dio Error - $e";
//     }
//   }

  // @override
  // Future<bool> tokenValidation() async {
  //   try {
  //     final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  //     var userData = prefsHelper.getString('userData');
  //     var userRecord = jsonDecode(userData.toString());
  //     var token = await DioHelper.instance.getSessionToken();
  //     if (token == null || userRecord == null) {
  //       Response res = await _dioClient.dio
  //           .post('$authURI/token-login', options: _dioClient.getDioOptions());
  //       if (res.data['id'] != null) {
  //         prefsHelper.saveString('userData', jsonEncode(res.data));
  //         userId = res.data['id'];
  //         school = res.data['school'];
  //         email = res.data['email'];
  //         type = res.data['type'];
  //         return true;
  //       }
  //     } else {
  //       var userInfo = jsonDecode(userData!);
  //       userId = userInfo['id'];
  //       school = userInfo['school'];
  //       email = userInfo['email'];
  //       type = userInfo['type'];
  //       return true;
  //     }
  //     return false;
  //   } on DioException catch (e) {
  //     log(e);
  //   }
  //   return false; // Return false if the condition is not met
  // }

//   @override
//   Future<bool> resetPassword({
//     required String email,
//   }) async {
//     try {
//       var res = await _dioClient.dio.put('$authURI/forgotten-password',
//           data: jsonEncode({'email': email}),
//           options: _dioClient.getDioOptions());

      // if (res.data['message'] ==
      //     "User with the given email address doesn't exists!") {
      //   SnackbarGlobal.showSnackBar(
      //     "Email address not found!",
      //   );
      //   return false;
      // }
      // if (res.data['message'] == "Password updated successfully") {
      //   SnackbarGlobal.showSnackBar(
      //     "Password reset successful, Use the temporary password sent to your email to log in ",
      //   );
      //   return true;
      // } else {
      //   SnackbarGlobal.showSnackBar(
      //     "Something went wrong!",
      //   );
      //   return false;
      // }
//     } catch (e) {
//       return false;
//     }
//   }

  // @override
  // Future<String> updatePassword({
  //   required String password,
  //   required String newPassword,
  // }) async {
  //   var res = await _dioClient.dio.put('$authURI/password_update',
  //       data: {'password': password, 'newPassword': newPassword},
  //       options: _dioClient.getDioOptions());

  //   if (res.data['message'] == "Password updated successfully") {
  //     SnackbarGlobal.showSnackBar(
  //       "Password updated successfully",
  //     );
  //     await logOut();
  //     return "Password Updated Successfully";
  //   } else {
  //     SnackbarGlobal.showSnackBar(
  //       "Something went wrong!",
  //     );
  //     return "Password Update Failed";
  //   }
  // }

  // @override
  // Future<bool> otpValidation(String email, String hash, String otpCode) async {
  //   try {
  //     var res = await _dioClient.dio.post('$authURI/verify-OTP',
  //         data: {
  //           'email': email,
  //           'otpHash': hash,
  //           'otpCode': otpCode,
  //         },
  //         options: _dioClient.getDioOptions());
  //     String msg = displayErrorMessages(res.toString());
  //     if (msg == "success") {
  //       return true;
  //     }
  //   } on DioException catch (e) {
  //     httpErrorHandle(
  //       response: e.response!,
  //       onSuccess: () async {},
  //     );
  //   }
  //   return false;
  // }

//   Future<bool> deleteUser() async {
//     try {
//       var res = await _dioClient.dio
//           .delete('$authURI/delete-user', options: _dioClient.getDioOptions());
//       String msg = displayErrorMessages(res.toString());
//       if (msg == "success") {
//         return true;
//       } else {
//         return false;
//       }
//     } on DioException catch (e) {
//       httpErrorHandle(
//         response: e.response!,
//         onSuccess: () async {},
//       );
//     }
//     return false;
//   }
// }

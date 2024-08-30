import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource.dart';
import 'package:uniplanet/features/auth/data/helpers/auth_remote_helper.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  }) async {
    final response = await postRequest('$authURI/signup', {
      'email': email,
      'password': password,
      'name': name,
      'school': school,
      'userType': getUserType(userType),
      'phoneNumber': phoneNumber,
    });

    String msg = displayErrorMessages(response.toString());
    if (msg == "success") {
      SnackbarGlobal.showSnackBar('Account created! Please Verify your email');
      return response.data['hash'];
    } else {
      return 'Failed';
    }
  }

  @override
  Future<AuthUserEntity> signInUser({
    required String email,
    required String password,
  }) async {
    final response = await postRequest('$authURI/signin', {
      'email': email,
      'password': password,
    });

    String msg = displayErrorMessages(response.toString());
    if (msg == "success") {
      if (response.data['deletionDate'] != null) {
        SnackbarGlobal.showSnackBar("Account restored Successfully!");
      }
      return AuthUserEntity.fromMap(response.data);
    }
    throw Exception("User not found");
  }

  @override
  Future<bool> logOut() async {
    final response = await deleteRequest('$authURI/signout');
    return response.data['message'] == "Logged Out Successfully";
  }

  @override
  Future<String> otpRequest({required String email}) async {
    final response =
        await postRequest('$authURI/request-OTP', {'email': email});

    String msg = displayErrorMessages(response.toString());
    if (msg == "success") {
      SnackbarGlobal.showSnackBar('OTP sent to your email');
      return response.data['hash'];
    } else {
      return 'Failed';
    }
  }

  @override
  Future<AuthUserEntity> tokenValidation() async {
    final response = await postRequest('$authURI/token-login', {});

    if (response.data['id'] != null) {
      AuthUserEntity user = AuthUserEntity.fromMap(response.data);
      return user;
    }
    throw Exception("User not found");
  }

  @override
  Future<bool> resetPassword({required String email}) async {
    final response =
        await putRequest('$authURI/forgotten-password', {'email': email});

    final message = response.data['message'];
    if (message == "User with the given email address doesn't exist!") {
      SnackbarGlobal.showSnackBar("Email address not found!");
      return false;
    } else if (message == "Password updated successfully") {
      SnackbarGlobal.showSnackBar(
        "Password reset successful. Use the temporary password sent to your email to log in.",
      );
      return true;
    } else {
      SnackbarGlobal.showSnackBar("Something went wrong!");
      return false;
    }
  }

  @override
  Future<String> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    final response = await putRequest('$authURI/password_update', {
      'password': password,
      'newPassword': newPassword,
    });

    return response.data['message'];
  }

  @override
  Future<AuthUserEntity> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  }) async {
    final response = await postRequest('$authURI/verify-OTP', {
      'email': email,
      'otpHash': hash,
      'otpCode': otpCode,
    });

    String msg = displayErrorMessages(response.toString());
    if (msg == "success") {
      // if (response.data['deletionDate'] != null) {
      //   SnackbarGlobal.showSnackBar("Account restored Successfully!");
      // }
      return AuthUserEntity.fromMap(response.data);
    }

    throw Exception("User not found");
  }

  @override
  Future<bool> deleteUser() async {
    final response = await deleteRequest('$authURI/delete-user');
    return response.data['message'] == "success";
  }
}

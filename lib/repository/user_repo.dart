import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin_screen.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class UserRepository {
  static User user = User.initialUser();
  final Dio dio = Dio();

  Options _getDioOptions() => Options(headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': UserRepository.user.token
      });
  Future<User> signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String profileImage,
      required String school,
      required bool verified}) async {
    try {
      Response res = await dio.post('$uri/api/signup',
          data: json.encode({
            'email': email,
            'password': password,
            'name': name,
            'profileImage': profileImage,
            'school': school,
            'verified': verified
          }),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));

      user = User.fromMap(res.data);

      httpErrorHandle(
        response: res,
        onSuccess: () {
          SnackbarGlobal.showSnackBar(
            'Account created! Login with the same credentials!',
          );
          Navigator.pushReplacementNamed(context, SigninScreen.routeName);
        },
      );
      return user;
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return user;
  }

  Future<User> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      Response res = await dio.post('$uri/api/signin',
          data: jsonEncode({
            'email': email,
            'password': password,
          }),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));

      httpErrorHandle(
        response: res,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', res.data['token']);
        },
      );

      user = User.fromMap(res.data);
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return user;
  }

  void logOut(BuildContext context) async {
    try {
      print("logOut Event");
      // SocketService.socket!.disconnect();
      context.read<StatusBloc>().add(StatusDisconnectEvent(user.id));
      user = User.initialUser();
      if (!context.mounted) throw Error();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

// get user data
  Future<User> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenRes = await dio.post('$uri/tokenIsValid',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token!
            },
          ));

      var response = tokenRes.data;

      if (response == true) {
        Response userRes = await dio.get(
          '$uri/',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          ),
        );

        user = User.fromMap(userRes.data);
        return user;
      }
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return user;
  }

  Future<Product?> uploadProduct({
    required BuildContext context,
    required String name,
    required bool forSale,
    required String description,
    required double price,
    required String category,
    required List<File> images,
  }) async {
    print('upload product is called');
    Product product;

    try {
      final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Response res = await dio.post('$uri/api/add-product',
          data: {
            'name': name,
            'forSale': forSale,
            'sellerId': UserRepository.user.id,
            'description': description,
            'images': imageUrls,
            'price': price,
            'category': category,
          },
          options: _getDioOptions());

      httpErrorHandle(
        response: res,
        onSuccess: () {
          SnackbarGlobal.showSnackBar('Product Added Successfully!');
          Navigator.pop(context);
        },
      );

      product = Product.fromMap(res.data);
      return product;
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return null;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    try {
      Response res = await dio.post('$uri/api/delete-product',
          data: jsonEncode({'id': product.id}), options: _getDioOptions());

      httpErrorHandle(
        response: res,
        onSuccess: () {
          onSuccess();
        },
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  removeFromLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.delete('$uri/api/remove-from-like/${product.id}',
          options: _getDioOptions());

      httpErrorHandle(
        response: res,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  void addToLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/add-like',
          options: _getDioOptions(),
          data: jsonEncode({
            'id': product.id,
          }));

      httpErrorHandle(
        response: res,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> productList = [];
    try {
      Response res = await dio.get(
        '$uri/api/products/search/$searchQuery',
        options: _getDioOptions(),
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          for (int i = 0; i < res.data.length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  res.data[i],
                ),
              ),
            );
          }
        },
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
    return productList;
  }

  Future<String> sendOtp(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String profileImage,
      required String school,
      required bool verified}) async {
    try {
      var res = await dio.post('$uri/api/sendOtp',
          data: jsonEncode({
            'email': email,
            'name': name,
          }),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));
      if (res.data['message'] == "User with same email already exists!") {
        SnackbarGlobal.showSnackBar(
          "User with same email already exists!",
        );
      }
      // print(res.data);
      if (res.data != null &&
          res.data is Map<String, dynamic> &&
          res.data.containsKey('hash')) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpVerifyScreen(
                  otpHash: res.data['hash'],
                  email: email,
                  password: password,
                  name: name,
                  profileImage: profileImage,
                  school: school,
                  verified: verified)),
        );
        return res.data['hash'];
      } else {
        return 'Something went wrong';
      }
    } on DioException catch (e) {
      _handleDioException(e);
      return "Dio Error";
    }
  }

  Future<String> verifyUser({
    required BuildContext context,
    required String email,
    required String otpHash,
    required String otpCode,
  }) async {
    try {
      var res = await dio.post('$uri/api/verifyOtp',
          data: jsonEncode(
              {'email': email, 'otpHash': otpHash, 'otpCode': otpCode}),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));
      httpErrorHandle(
        response: res,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('x-auth-token', res.data['token']);
        },
      );
      if (res.data != null) {
        return res.data['message'];
      } else {
        return 'Something went wrong';
      }
    } on DioException catch (e) {
      _handleDioException(e);
      return "Dio Error";
    }
  }

  void _handleDioException(DioException e) {
    if (e.response != null) {
      SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
    } else {
      // Log error or handle it accordingly
      print(e);
    }
  }

  Future<void> forgottenPassword({
    required BuildContext context,
    required String email,
  }) async {
    Dio dio = Dio();
    var res = await dio.put('$uri/api/forgottenPassword',
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
}

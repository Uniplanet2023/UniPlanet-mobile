import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/addProduct/screens/admin_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/order.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/sale.dart';
import 'package:uniplanet_mobile/models/user.dart';

class UserRepository {
  static User user = User(
    id: '',
    name: '',
    password: '',
    email: '',
    isOnline: false,
    phoneNumber: '',
    address: '',
    type: '',
    token: '',
    like: [],
  );
  User get getUser {
    return user;
  }

  void initUser() {
    user = User(
      id: '',
      name: '',
      password: '',
      email: '',
      isOnline: false,
      phoneNumber: '',
      address: '',
      type: '',
      token: '',
      like: [],
    );
  }

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    late Dio dio = Dio();
    User user = User(
      id: '',
      name: name,
      password: password,
      email: email,
      isOnline: false,
      phoneNumber: '',
      address: '',
      type: '',
      token: '',
      like: [],
    );

    try {
      Response res = await dio.post('$uri/api/signup',
          data: user.toJson(),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));
      if (!context.mounted) throw Error();

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          SnackbarGlobal.showSnackBar(
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  Future<dynamic> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      late Dio dio = Dio();
      Response res = await dio.post('$uri/api/signin',
          data: jsonEncode({
            'email': email,
            'password': password,
          }),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          }));

      if (!context.mounted) throw Error();

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (!context.mounted) throw Error();

          await prefs.setString('x-auth-token', res.data['token']);

          if (!context.mounted) throw Error();
          user = User.fromMap(res.data);

          Navigator.pushNamedAndRemoveUntil(
            context,
            res.data["type"] == "admin"
                ? AdminScreen.routeName
                : BottomBar.routeName,
            (route) => false,
          );
          return res.data;
        },
      );
      return null;
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return null;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      if (!context.mounted) throw Error();
      initUser();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

// get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      Dio dio = Dio();
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

        if (!context.mounted) throw Error();
        user = User.fromMap(userRes.data);
      }
    } catch (e) {
      if (!context.mounted) throw Error();
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    List<Order> orderList = [];
    try {
      late Dio dio = Dio();

      Response res = await dio.get('$uri/api/orders/me',
          data: user.toJson(),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      if (!context.mounted) throw Error();

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < res.data.length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  res.data[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return orderList;
  }

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    Dio dio = Dio();

    try {
      final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        seller: user.name,
        sellerId: user.id,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      Response res = await dio.post('$uri/api/add-product',
          data: product.toJson(),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json;charset=UTF-8',
            'x-auth-token': user.token
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          SnackbarGlobal.showSnackBar('Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    Dio dio = Dio();

    try {
      Response res = await dio.post('$uri/api/delete-product',
          data: jsonEncode({'id': product.id}),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));
      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orderList = [];
    try {
      Dio dio = Dio();
      Response res = await dio.get('$uri/api/get-orders',
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.data).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  res.data[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/change-order-status',
          data: jsonEncode({'id': order.id, 'status': status}),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      Dio dio = Dio();
      Response res = await dio.get('$uri/api/analytics',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = res.data;
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    Dio dio = Dio();

    try {
      Response res = await dio.post('$uri/api/save-user-address',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }),
          data: jsonEncode({
            'address': address,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          user.copyWith(
            address: res.data['address'],
          );
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  // get all the products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/order',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }),
          data: jsonEncode({
            'like': user.like,
            'address': address,
            'totalPrice': totalSum,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          SnackbarGlobal.showSnackBar('Your order has been placed!');
          user.copyWith(
            like: [],
          );
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  void removeFromLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.delete('$uri/api/remove-from-like/${product.id}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  void addToLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/add-like',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }),
          data: jsonEncode({
            'id': product.id!,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/rate-product',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }),
          data: jsonEncode({
            'id': product.id!,
            'rating': rating,
          }));

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> productList = [];
    try {
      Dio dio = Dio();
      Response res = await dio.get(
        '$uri/api/products/search/$searchQuery',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
      );

      if (!context.mounted) throw Error();
      httpErrorHandle(
        response: res,
        context: context,
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
    } catch (e) {
      SnackbarGlobal.showSnackBar(e.toString());
    }
    return productList;
  }
}

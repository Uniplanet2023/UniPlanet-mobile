import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/addProduct/screens/admin_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/auth_screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signin_screen.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/order.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/sale.dart';
import 'package:uniplanet_mobile/models/user.dart';

class UserRepository {
  static User getUser(BuildContext context) {
    User user = context.read<UserBloc>().state.user!;
    return user;
  }

  Future<User> signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String profileImage,
      required String school,
      required bool verified}) async {
    Dio dio = Dio();
    User user = User.initialUser();
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
      print(res.data);
      user = User.fromMap(res.data);

      httpErrorHandle(
        response: res,
        onSuccess: () {
          SnackbarGlobal.showSnackBar(
            'Account created! Login with the same credentials!',
          );
          // Future.delayed(const Duration(seconds: 1));
          Navigator.pushNamed(context, SigninScreen.routeName);
        },
      );
      return user;
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return user;
  }

  Future<User> signInUser({
    required String email,
    required String password,
  }) async {
    User user = User.initialUser();
    Dio dio = Dio();
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
      if (user.token == '') {
        return user;
      } else {
        return user;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return user;
  }

  void logOut() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

// get user data
  Future<User> getUserData() async {
    User user = User.initialUser();
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

        user = User.fromMap(userRes.data);
        return user;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return user;
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
    User user = context.read<UserBloc>().state.user!;
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

      httpErrorHandle(
        response: res,
        onSuccess: () {
          SnackbarGlobal.showSnackBar('Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    Dio dio = Dio();
    User user = context.read<UserBloc>().state.user!;
    try {
      Response res = await dio.post('$uri/api/delete-product',
          data: jsonEncode({'id': product.id}),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      httpErrorHandle(
        response: res,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orderList = [];
    try {
      Dio dio = Dio();
      User user = context.read<UserBloc>().state.user!;
      Response res = await dio.get('$uri/api/get-orders',
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      httpErrorHandle(
        response: res,
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
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    User user = context.read<UserBloc>().state.user!;
    try {
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/change-order-status',
          data: jsonEncode({'id': order.id, 'status': status}),
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      httpErrorHandle(
        response: res,
        onSuccess: onSuccess,
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  Future<Map<String, dynamic>> getEarnings({
    required BuildContext context,
  }) async {
    User user = context.read<UserBloc>().state.user!;
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      Dio dio = Dio();
      Response res = await dio.get('$uri/api/analytics',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      httpErrorHandle(
        response: res,
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
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  // get all the products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      User user = context.read<UserBloc>().state.user!;
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

      httpErrorHandle(
        response: res,
        onSuccess: () {
          SnackbarGlobal.showSnackBar('Your order has been placed!');
          user.copyWith(
            like: [],
          );
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  void removeFromLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      User user = context.read<UserBloc>().state.user!;
      Dio dio = Dio();
      Response res = await dio.delete('$uri/api/remove-from-like/${product.id}',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': user.token,
          }));

      httpErrorHandle(
        response: res,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  void addToLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      User user = context.read<UserBloc>().state.user!;
      Dio dio = Dio();
      Response res = await dio.post('$uri/api/add-like',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }),
          data: jsonEncode({
            'id': product.id!,
          }));

      httpErrorHandle(
        response: res,
        onSuccess: () {
          user.copyWith(like: res.data['like']);
        },
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    try {
      User user = context.read<UserBloc>().state.user!;
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

      httpErrorHandle(
        response: res,
        onSuccess: () {},
      );
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> productList = [];
    try {
      User user = context.read<UserBloc>().state.user!;
      Dio dio = Dio();
      Response res = await dio.get(
        '$uri/api/products/search/$searchQuery',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        }),
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
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
    }
    return productList;
  }
}

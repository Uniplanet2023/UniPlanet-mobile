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
      });

// get user data
  // Future<User> getUserData() async {

  // }

  Future<Product?> uploadProduct({
    required BuildContext context,
    required String name,
    required bool forSale,
    required String description,
    required double price,
    required String category,
    required List<File> images,
  }) async {
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

      Response res = await dio.post('$authURI/api/add-product',
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
    } on DioException catch (e) {}
    return null;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    try {
      Response res = await dio.post('$authURI/api/delete-product',
          data: jsonEncode({'id': product.id}), options: _getDioOptions());

      httpErrorHandle(
        response: res,
        onSuccess: () {
          onSuccess();
        },
      );
    } on DioException catch (e) {}
  }

  removeFromLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.delete(
          '$authURI/api/remove-from-like/${product.id}',
          options: _getDioOptions());
    } on DioException catch (e) {}
  }

  void addToLikes({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      Dio dio = Dio();
      Response res = await dio.post('$authURI/api/add-like',
          options: _getDioOptions(),
          data: jsonEncode({
            'id': product.id,
          }));
    } on DioException catch (e) {}
  }

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> productList = [];
    try {
      Response res = await dio.get(
        '$authURI/api/products/search/$searchQuery',
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
    } on DioException catch (e) {}
    return productList;
  }
}

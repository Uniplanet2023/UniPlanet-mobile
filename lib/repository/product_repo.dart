import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ProductRepository {
  Dio dio = Dio();
  Options _getDioOptions() => Options(headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': UserRepository.user.token
      });

  Future<List<Product>> fetchAllProducts() async {
    List<Product> productList = [];
    try {
      Response res =
          await dio.get('$uri/api/product', options: _getDioOptions());
      print(
          'fadfadfadsfadsfadsfasdfadsfadsfasdfadfadfadfasdfadfasdfsdfadsfasdfasdfasdfasdf');
      print(res);
      print(
          'fadfadfadsfadsfadsfasdfadsfadsfasdfadfadfadfasdfadfasdfsdfadsfasdfasdfasdfasdf');

      httpErrorHandle(
        response: res,
        onSuccess: () {
          for (int i = 0; i < res.data.length; i++) {
            productList.add(
              Product.fromMap(res.data[i]),
            );
          }
        },
      );
    } on DioException catch (e) {
      // _handleDioException(e);
    }
    return productList;
  }

  Future<List<Product>> fetchCategoryProducts({
    required String category,
  }) async {
    List<Product> productList = [];
    try {
      Dio dio = Dio();

      Response res = await dio.get('$uri/api/products?category=$category',
          options: _getDioOptions());

      httpErrorHandle(
          response: res,
          onSuccess: () {
            for (int i = 0; i < res.data.length; i++) {
              productList.add(Product.fromMap(res.data[i]));
            }
          });
    } on DioException catch (e) {
      // _handleDioException(e);
    }
    return productList;
  }

  // void _handleDioException(DioException e) {
  //   if (e.response != null) {
  //     SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
  //   } else {
  //     // Log error or handle it accordingly
  //     print(e);
  //   }
  // }
}

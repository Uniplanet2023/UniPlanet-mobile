import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/order.dart';
import 'package:uniplanet_mobile/models/product.dart';

class ProductRepository {
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    List<Product> productList = [];
    try {
      Dio dio = Dio();
      Response res = await dio.get('$uri/api/all-products',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }));
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

  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    List<Product> productList = [];
    try {
      Dio dio = Dio();
      print('category ');
      Response res = await dio.get('$uri/api/products?category=$category',
          options: Options(headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }));

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

import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/global.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/api_def/api_server_address.dart';
import 'package:uniplanet_mobile/network/api_def/dio_client.dart';
import 'package:uniplanet_mobile/network/api_def/display_error_messages.dart';

class ProductRepository {
  final DioClient _dioClient;

  ProductRepository(this._dioClient);

  Future<String> deleteProduct({required String productId}) async {
    try {
      final response = await _dioClient.dio.delete(
        '$productURI/delete-product/$productId',
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        return "success";
      }
    } on DioException catch (e) {
      print(e);
    }
    return 'failed';
  }

  Future<List<Product>> searchProduct(int? page, String productName) async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/search-product/$productName',
        queryParameters: {'page': page},
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final obj = jsonDecode(response.data);
        for (int i = 0; i < obj.length; i++) {
          productList.add(Product.fromMap(obj[i]));
        }
        return productList;
      }
    } on DioException catch (e) {
      print(e);
    }
    return productList;
  }

  Future<List<Product>> fetchProducts({int? page, String? category}) async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/get-products',
        queryParameters: {'category': category, 'page': page},
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final obj = jsonDecode(response.data);
        for (int i = 0; i < obj.length; i++) {
          productList.add(Product.fromMap(obj[i]));
        }
        return productList;
      }
    } on DioException catch (e) {
      print(e);
    }
    return productList;
  }

  Future<Product?> updateProduct({
    required String productId,
    String? productName,
    String? status,
    String? description,
    double? price,
    String? category,
    String? location,
    List<String>? images,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '$productURI/update-product/$productId',
        data: {
          'productName': productName,
          'status': status,
          'description': description,
          'images': images,
          'price': price,
          'category': category,
          'location': location,
        },
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final product = Product.fromMap(response.data);
        return product;
      }
    } on DioException catch (e) {
      print("Dio Error - $e");
    }
    return null;
  }

  Future<Product?> uploadProduct({
    required String productName,
    required String status,
    required String description,
    required double price,
    required String category,
    required String location,
    required User seller,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '$productURI/upload-product',
        data: {
          'productName': productName,
          'status': status,
          'description': description,
          'price': price,
          'category': category,
          'location': location,
          'seller': seller,
        },
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        return Product.fromMap(response.data);
      }
    } on DioException catch (e) {
      print(e);
    }
    return null;
  }

  Future<Product?> uploadImagesAndUpdateProduct({
    required List<File> images,
    required String productId,
  }) async {
    try {
      final imageUrls = <String>[];

      // Concurrently upload all images and collect their URLs
      final uploadTasks = images.map((image) async {
        final response = await Global.cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: 'product-images'),
        );
        imageUrls.add(response.secureUrl); // Collect each image URL
      }).toList();

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      // After all uploads, update the product with the collected image URLs
      final product = await updateProduct(
        productId: productId,
        images: imageUrls,
      );

      // Check if the product update was successful
      return product;
    } catch (e) {
      print("An error occurred: $e");
      // Handle errors, e.g., by showing an error message to the user
    }
    return null;
  }

  Future<bool> likeProduct(
      {required String productId, required User user}) async {
    try {
      final response = await _dioClient.dio.post(
        '$productURI/like-product',
        options: _dioClient.getDioOptions(),
        data: {
          'productId': productId,
          'user': user,
        },
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        return true;
      } else {
        throw Exception("Failed to like product");
      }
    } on DioException catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> unlikeProduct(
      {required String productId, required User user}) async {
    try {
      final response = await _dioClient.dio.post(
        '$productURI/unlike-product',
        options: _dioClient.getDioOptions(),
        data: {
          'productId': productId,
          'user': user,
        },
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        return true;
      } else {
        throw Exception("Failed to unlike product");
      }
    } on DioException catch (e) {
      print(e);
    }
    return false;
  }

  Future<List<Product>> getProductLikes() async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/get-like-product',
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        for (int i = 0; i < response.data.length; i++) {
          productList.add(Product.fromJson(response.data[i]));
        }
        return productList;
      }
    } on DioException catch (e) {
      print(e);
    }
    return productList;
  }

  Future<List<Product>> getHotProducts() async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/get-hot-products',
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        var productDataObj = jsonDecode(response.data);
        for (var productData in productDataObj) {
          print(productData);
          productList.add(Product.fromMap(productData));
        }
        return productList;
      }
    } on DioException catch (e) {
      print('DioException occurred: ${e.message}');
    }
    return productList;
  }

  void clickProduct(String productId) async {
    try {
      var response = await _dioClient.dio.get(
        '$productURI/increase-click/$productId',
        options: _dioClient.getDioOptions(),
      );
      print(response.data);
    } on DioException catch (e) {
      print('DioException occurred: ${e.message}');
    }
  }
}

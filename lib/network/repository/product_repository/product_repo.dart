import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:uniket/constants/utils.dart';
import 'package:uniket/global.dart';
import 'package:uniket/models/product.dart';
import 'package:uniket/models/user_model.dart';
import 'package:uniket/network/api_def/api_server_address.dart';
import 'package:uniket/network/api_def/dio_client.dart';
import 'package:uniket/network/api_def/display_error_messages.dart';

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
      log(e);
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
      log(e);
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
      log(e);
    }
    return productList;
  }

  Future<Product?> updateProduct({required Product product}) async {
    try {
      final response = await _dioClient.dio.put(
        '$productURI/update-product/${product.id}',
        data: {
          'productName': product.name,
          'status': product.status,
          'description': product.description,
          'price': product.price,
          'category': product.category,
          'location': product.location,
          'images': product.images,
        },
        options: _dioClient.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final product = Product.fromMap(response.data);
        return product;
      }
    } on DioException catch (e) {
      log("Dio Error - $e");
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
      log(e);
    }
    return null;
  }

  Future<Product?> uploadImagesAndUpdateProduct({
    required List<File>? images,
    required Product product,
  }) async {
    try {
      final imageUrls =
          List<String?>.filled(images?.length ?? 0, null, growable: false);
      print(product.id);
      if (images != null) {
        // Concurrently upload all images and collect their URLs
        final uploadTasks =
            List<Future<void>>.generate(images.length, (index) async {
          final image = images[index];
          final response = await Global.cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path,
                folder: 'product-images/${product.id}'),
          );
          imageUrls[index] = response
              .secureUrl; // Place each image URL in the corresponding position
        });

        // Wait for all uploads to complete
        await Future.wait(uploadTasks);

        // Remove any nulls in case some uploads failed
        product.images.addAll(imageUrls.whereType<String>());
      }

      // After all uploads, update the product with the collected image URLs
      final newProduct = await updateProduct(
        product: product,
      );

      // Check if the product update was successful
      return newProduct;
    } catch (e) {
      log("An error occurred: $e");
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
      log(e);
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
      log(e);
    }
    return false;
  }

  Future<List<Product>> getProductLikes({required int page}) async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/get-like-product',
        queryParameters: {'page': page},
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
      log(e);
    }
    return productList;
  }

  Future<List<Product>> getHotProducts({required int nextPage}) async {
    final productList = <Product>[];
    try {
      final response = await _dioClient.dio.get(
        '$productURI/get-hot-products',
        options: _dioClient.getDioOptions(),
        queryParameters: {'page': nextPage},
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        var productDataObj = jsonDecode(response.data);
        for (var productData in productDataObj) {
          log(productData);
          productList.add(Product.fromMap(productData));
        }
        return productList;
      }
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
    }
    return productList;
  }

  Future<List<Product>?> getMyProduct(
      {required int page, required String status}) async {
    var productList = <Product>[];
    try {
      var response = await _dioClient.dio.get(
        '$productURI/get-my-products/$status',
        queryParameters: {'page': page},
        options: _dioClient.getDioOptions(),
      );

      var productDataObj = jsonDecode(response.data);
      for (var productData in productDataObj) {
        productList.add(Product.fromMap(productData));
      }
      return productList;
    } on DioException catch (e) {
      print('DioException occurred: ${e.message}');
      return null;
    }
  }

  void clickProduct(String productId) async {
    try {
      var response = await _dioClient.dio.get(
        '$productURI/increase-click/$productId',
        options: _dioClient.getDioOptions(),
      );
      log(response.data);
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
    }
  }
}

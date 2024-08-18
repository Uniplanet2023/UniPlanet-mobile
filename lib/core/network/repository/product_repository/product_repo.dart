import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/isar/isar_service.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/utils/display_error_messages.dart';

class ProductRepository {
  ProductRepository();

  Future<Product?> getProduct({required String productId}) async {
    try {
      final response = await DioHelper.instance.dio.get(
        '$productURI/get-product/$productId',
        options: DioHelper.instance.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        return Product.fromJson(response.data);
      }
    } on DioException catch (e) {
      log(e);
    }
    return null;
  }

  Future<String> deleteProduct({required String productId}) async {
    try {
      final response = await DioHelper.instance.dio.delete(
        '$productURI/delete-product/$productId',
        options: DioHelper.instance.getDioOptions(),
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
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      bool? isMySchool = prefsHelper.getBool('isMySchool');
      final response = await DioHelper.instance.dio.get(
        '$productURI/search-product/$productName',
        queryParameters: {
          'page': page,
          'isMySchool': isMySchool ?? false,
        },
        options: DioHelper.instance.getDioOptions(),
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
    List<Product> productList = <Product>[];
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      bool? isMySchool = prefsHelper.getBool('isMySchool');

      final response = await DioHelper.instance.dio.get(
        '$productURI/get-products',
        queryParameters: {
          'category': category,
          'page': page,
          'isMySchool': isMySchool ?? false,
        },
        options: DioHelper.instance.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final obj = jsonDecode(response.data);
        for (int i = 0; i < obj.length; i++) {
          productList.add(Product.fromMap(obj[i]));
        }
        IsarService.instance.saveProductList(productList);
        return productList;
      }
    } catch (e) {
      SnackbarGlobal.showSnackBar("Network is not stable. Please try again.");
      log(e);
    }
    return [];
  }

  Future<List<Product>> getWantedProducts({int? page, String? category}) async {
    final productList = <Product>[];
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      bool? isMySchool = prefsHelper.getBool('isMySchool');
      final response = await DioHelper.instance.dio.get(
        '$productURI/get-wanted-products',
        queryParameters: {
          'category': category,
          'page': page,
          'isMySchool': isMySchool ?? false,
        },
        options: DioHelper.instance.getDioOptions(),
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

  Future<List<Product>> getFreeProducts({int? page, String? category}) async {
    final productList = <Product>[];
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      bool? isMySchool = prefsHelper.getBool('isMySchool');
      if (category == 'Free Products') {
        category = null;
      }
      final response = await DioHelper.instance.dio.get(
        '$productURI/get-free-products',
        queryParameters: {
          'category': category,
          'page': page,
          'isMySchool': isMySchool ?? false,
        },
        options: DioHelper.instance.getDioOptions(),
      );
      final msg = displayErrorMessages(response.toString());
      if (msg == "success") {
        final obj = jsonDecode(response.data);
        for (int i = 0; i < obj.length; i++) {
          Product product = Product.fromMap(obj[i]);
          User user = User.fromMap(obj[i]['seller']);
          product.seller = user;
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
      final response = await DioHelper.instance.dio.put(
        '$productURI/update-product/${product.id}',
        data: {
          'productName': product.name,
          'status': product.status,
          'description': product.description,
          'price': product.price,
          'category': product.category,
          'location': product.location,
          'images': product.images,
          'type': product.type,
          'isNegotiable': product.isNegotiable,
          'stateAddress': product.stateAddress,
          'city': product.city,
          'address': product.address,
          'zipCode': product.zipCode,
        },
        options: DioHelper.instance.getDioOptions(),
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
    required bool isNegotiable,
    required String type,
    required User seller,
    String? stateAddress,
    String? city,
    String? address,
    String? zipCode,
  }) async {
    try {
      final response = await DioHelper.instance.dio.post(
        '$productURI/upload-product',
        data: {
          'productName': productName,
          'status': status,
          'description': description,
          'price': price,
          'category': category,
          'location': location,
          'seller': seller,
          'isNegotiable': isNegotiable,
          'type': type,
          'stateAddress': stateAddress,
          'city': city,
          'address': address,
          'zipCode': zipCode,
        },
        options: DioHelper.instance.getDioOptions(),
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
      log(product.id);
      if (images != null) {
        // Concurrently upload all images and collect their URLs
        final uploadTasks =
            List<Future<void>>.generate(images.length, (index) async {
          final image = images[index];
          final secureUrl = await ImageUploadService()
              .uploadImage(
            image,
            'product-images/${AuthRepository.school}/${product.id}',
          )
              .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Image uploading timed out');
            },
          );

          imageUrls[index] = secureUrl;
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
      final response = await DioHelper.instance.dio.post(
        '$productURI/like-product',
        options: DioHelper.instance.getDioOptions(),
        data: {
          'productId': productId,
          'user': user.toJson(),
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
      final response = await DioHelper.instance.dio.post(
        '$productURI/unlike-product',
        options: DioHelper.instance.getDioOptions(),
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
      final response = await DioHelper.instance.dio.get(
        '$productURI/get-like-product',
        queryParameters: {'page': page},
        options: DioHelper.instance.getDioOptions(),
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

  Future<List<Product>> getHotProducts({required int page}) async {
    final productList = <Product>[];
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      bool? isMySchool = prefsHelper.getBool('isMySchool');
      final response = await DioHelper.instance.dio.get(
        '$productURI/get-hot-products',
        options: DioHelper.instance.getDioOptions(),
        queryParameters: {
          'page': page,
          'isMySchool': isMySchool ?? false,
        },
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
      {required int page,
      required String status,
      required String userId}) async {
    var productList = <Product>[];
    try {
      var response = await DioHelper.instance.dio.get(
        '$productURI/get-my-products/$status',
        queryParameters: {'page': page, 'userId': userId},
        options: DioHelper.instance.getDioOptions(),
      );

      var productDataObj = jsonDecode(response.data);
      for (var productData in productDataObj) {
        productList.add(Product.fromMap(productData));
      }
      return productList;
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
      return null;
    }
  }

  void clickProduct(String productId) async {
    try {
      var response = await DioHelper.instance.dio.get(
        '$productURI/increase-click/$productId',
        options: DioHelper.instance.getDioOptions(),
      );
      log(response.data);
    } on DioException catch (e) {
      log('DioException occurred: ${e.message}');
    }
  }
}

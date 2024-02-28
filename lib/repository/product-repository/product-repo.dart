import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:uniplanet_mobile/constants/error_handling.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/network/api-server-address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/network/display-error-messages.dart';

class ProductRepository {
  Future<List<Product>> fetchProducts({int page = 0, String? category}) async {
    List<Product> productList = [];
    try {
      Response res =
          await DioClient.instance.dio.get('$productURI/get-products',
              queryParameters: {
                'category': category,
                'page': page,
              },
              options: DioClient.instance.getDioOptions());
      String msg = displayErrorMessages(res.toString());

      if (msg == "success") {
        var obj = jsonDecode(res.data);
        for (int i = 0; i < obj.length; i++) {
          productList.add(
            Product.fromMap(obj[i]),
          );
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
    List<String>? images,
  }) async {
    try {
      Response res = await DioClient.instance.dio
          .put('$productURI/update-product/$productId',
              data: {
                'productName': productName,
                'status': status,
                'description': description,
                'images': images,
                'price': price,
                'category': category,
              },
              options: DioClient.instance.getDioOptions());
      String msg = displayErrorMessages(res.toString());
      if (msg == "success") {
        Product product = Product.fromMap(res.data);
        return product;
      }
    } on DioException catch (e) {}
    return null;
  }

  Future<Product?> uploadProduct({
    required String name,
    required String status,
    required String description,
    required double price,
    required String category,
  }) async {
    try {
      Response uploadRes =
          await DioClient.instance.dio.post('$productURI/upload-product',
              data: {
                'productName': name,
                'status': status,
                'description': description,
                'price': price,
                'category': category,
              },
              options: DioClient.instance.getDioOptions());
      String msg = displayErrorMessages(uploadRes.toString());

      if (msg == "success") {
        return Product.fromMap(uploadRes.data);
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
      final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
      List<String> imageUrls = [];

      // Concurrently upload all images and collect their URLs
      List<Future<void>> uploadTasks = images.map((image) async {
        var response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: 'product-images'),
        );
        imageUrls.add(response.secureUrl); // Collect each image URL
      }).toList();

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      // After all uploads, update the product with the collected image URLs
      Product? product = await updateProduct(
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
}

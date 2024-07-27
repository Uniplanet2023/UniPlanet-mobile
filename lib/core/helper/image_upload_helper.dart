import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/upload/domain/entities/housing_post.dart';
import 'package:uniplanet/models/product.dart';

class ImageUploadHelper {
  static final ImageUploadHelper _instance = ImageUploadHelper._internal();
  static ImageUploadHelper get instance => _instance;
  ImageUploadHelper._internal();

  Future<List<String>> uploadImages({
    required List<File> images,
    required Either<Product, HousingPost> post,
  }) async {
    try {
      final imageUrls =
          List<String?>.filled(images.length, null, growable: false);

      // Concurrently upload all images and collect their URLs
      final uploadTasks =
          List<Future<void>>.generate(images.length, (index) async {
        final image = images[index];
        String secureUrl;

        try {
          if (post.isLeft()) {
            final product =
                post.fold((product) => product, (housingPost) => null);
            if (product == null) {
              throw Exception('Product is null');
            }
            secureUrl = await ImageUploadService()
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
          } else {
            final housingPost =
                post.fold((product) => null, (housingPost) => housingPost);
            if (housingPost == null) {
              throw Exception('Housing post is null');
            }
            secureUrl = await ImageUploadService()
                .uploadImage(
              image,
              'housing-images/${AuthRepository.school}/${housingPost.id}',
            )
                .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw TimeoutException('Image uploading timed out');
              },
            );
            imageUrls[index] = secureUrl;
          }
        } catch (e) {
          log('Error uploading image at index $index: $e');
          throw Exception('Failed to upload image at index $index');
        }
      });

      // Wait for all uploads to complete
      await Future.wait(uploadTasks);

      // Remove any nulls in case some uploads failed
      final validUrls = imageUrls.whereType<String>().toList();

      if (post.isLeft()) {
        final product = post.fold((product) => product, (housingPost) => null);
        product!.images.addAll(validUrls);
        return validUrls;
      } else {
        final housingPost =
            post.fold((product) => null, (housingPost) => housingPost);
        housingPost!.images.addAll(validUrls);
        return validUrls;
      }
    } catch (e) {
      log('Image upload failed: $e');
      throw Exception('Image upload failed: $e');
    }
  }
}

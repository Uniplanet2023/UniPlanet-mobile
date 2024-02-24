import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user.dart';

abstract class IUserRepository {
  Future<User> getUserData();

  Future<Product?> uploadProduct({
    required BuildContext context,
    required String name,
    required bool forSale,
    required String description,
    required double price,
    required String category,
    required List<File> images,
  });

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  });

  void removeFromLikes({
    required BuildContext context,
    required Product product,
  });

  void addToLikes({
    required BuildContext context,
    required Product product,
  });

  Future<List<Product>> fetchSearchedProduct({
    required BuildContext context,
    required String searchQuery,
  });
}

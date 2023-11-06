import 'dart:convert';

import 'package:uniplanet_mobile/models/rating.dart';
import 'package:uniplanet_mobile/models/user.dart';

class Product {
  final String name;
  final String seller;
  final String description;
  final bool forSale;
  final List<String> images;
  final String category;
  final double price;
  final String id;
  final DateTime createdAt;
  Product({
    required this.name,
    required this.forSale,
    required this.seller,
    required this.description,
    required this.images,
    required this.category,
    required this.price,
    required this.id,
    required this.createdAt,
  });
  static initProduct() {
    return Product(
        name: "",
        forSale: true,
        seller: "",
        description: "",
        images: [""],
        category: "",
        price: 0,
        id: "",
        createdAt: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'seller': seller,
      'forSale': forSale,
      'description': description,
      'images': images,
      'category': category,
      'price': price,
      'id': id,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'],
      name: map['name'],
      forSale: map['forSale'] as bool,
      seller: map['seller'],
      description: map['description'],
      images: List<String>.from(map['images']),
      price: map['price'].toDouble(),
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

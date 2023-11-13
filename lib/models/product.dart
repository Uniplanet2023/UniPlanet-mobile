import 'dart:convert';
import 'package:uniplanet_mobile/models/user.dart';

class Product {
  final String name;
  final User seller;
  final String description;
  final bool forSale;
  final List<String> images;
  final List<String> likes;
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
    required this.likes,
    required this.category,
    required this.price,
    required this.id,
    required this.createdAt,
  });
  static initProduct() {
    return Product(
        name: "",
        forSale: true,
        seller: User.initialUser(),
        description: "",
        likes: [""],
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
      'likes': likes,
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
      seller: User.fromMap(map['seller']),
      description: map['description'],
      images: List<String>.from(map['images']),
      likes: List<String>.from(map['likes']),
      price: map['price'].toDouble(),
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

import 'dart:convert';
import 'package:uniplanet_mobile/models/user_model.dart';

class Product {
  final String id;
  final String name;
  final User seller;
  final String description;
  final String status;
  final List<String> images;
  final int likes;
  final String category;
  final double price;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.status,
    required this.seller,
    required this.description,
    required this.images,
    required this.likes,
    required this.category,
    required this.price,
    required this.createdAt,
  });
  static initProduct() {
    return Product(
        id: "",
        name: "",
        status: "",
        seller: User.initialUser(),
        description: "",
        likes: 0,
        images: [""],
        category: "",
        price: 0,
        createdAt: DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'seller': seller,
      'status': status,
      'description': description,
      'images': images,
      'likes': likes,
      'category': category,
      'price': price,
      'createdAt': createdAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['productName'] as String,
      status: map['status'] as String,
      seller: User.fromMap(map['seller']),
      description: map['description'] as String,
      images: List<String>.from(map['images']),
      likes: map['likes'] as int,
      price: map['price'].toDouble() as double,
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

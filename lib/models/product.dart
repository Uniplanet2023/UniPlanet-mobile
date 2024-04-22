import 'dart:convert';
import 'package:uniplanet/models/user_model.dart';

class Product {
  final String id;
  String name;
  final User seller;
  final String description;
  String status;
  final List<String> images;
  int likes;
  int numberOfChat;
  String category;
  double price;
  final DateTime createdAt;
  String location;
  Product({
    required this.id,
    required this.name,
    required this.status,
    required this.seller,
    required this.description,
    required this.images,
    this.likes = 0,
    this.numberOfChat = 0,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.location,
  });
  static initProduct() {
    return Product(
        id: "",
        name: "",
        status: "",
        seller: User.initialUser(),
        description: "",
        likes: 0,
        numberOfChat: 0,
        images: [""],
        category: "",
        price: 0,
        location: "",
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
      'numberOfChat': numberOfChat,
      'location': location,
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
      numberOfChat: map['numberOfChat'] as int,
      price: map['price'].toDouble() as double,
      category: map['category'],
      location: map['location'] ?? "",
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

import 'dart:convert';
import 'package:uniplanet/models/user.dart';

class Product {
  final String id;
  String name;
  final String description;
  String status;
  final List<String> images;
  int likes;
  int numberOfChat;
  String category;
  double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  String location;
  bool isAdvertisement;
  bool isNegotiable;
  final String type;
  User seller;
  Product({
    required this.seller,
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.images,
    this.likes = 0,
    this.numberOfChat = 0,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
    this.isAdvertisement = false,
    this.isNegotiable = false,
    required this.type,
  });
  static initProduct() {
    return Product(
      seller: User.initialUser(),
      id: "",
      name: "",
      status: "",
      description: "",
      likes: 0,
      numberOfChat: 0,
      images: [""],
      category: "",
      price: 0,
      location: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isAdvertisement: false,
      type: "",
      isNegotiable: false,
    );
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
      'updatedAt': updatedAt,
      'numberOfChat': numberOfChat,
      'location': location,
      'isAdvertisement': isAdvertisement,
      'isNegotiable': isNegotiable,
      'type': type,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      seller: User.fromMap(map['seller']),
      id: map['id'],
      name: map['productName'] as String,
      status: map['status'] as String,
      description: map['description'] as String,
      images: List<String>.from(map['images']),
      likes: map['likes'] as int,
      numberOfChat: map['numberOfChat'] as int,
      price: map['price'].toDouble() as double,
      category: map['category'],
      location: map['location'] ?? "",
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
      isAdvertisement: map['isAdvertisement'] ?? false,
      isNegotiable: map['isNegotiable'] ?? false,
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
}

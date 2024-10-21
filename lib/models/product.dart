import 'dart:convert';
import 'package:uniplanet/core/entities/user.dart';

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
  final double? originalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  String location;
  bool isAdvertisement;
  bool isNegotiable;
  final String type;
  User seller;
  final String? stateAddress;
  final String? city;
  final String? address;
  final String? zipCode;

  Product({
    required this.seller,
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.images,
    this.originalPrice,
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
    this.stateAddress,
    this.city,
    this.address,
    this.zipCode,
  });

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
      'originalPrice': originalPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'numberOfChat': numberOfChat,
      'location': location,
      'isAdvertisement': isAdvertisement,
      'isNegotiable': isNegotiable,
      'type': type,
      'stateAddress': stateAddress,
      'city': city,
      'address': address,
      'zipCode': zipCode,
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
      originalPrice: map['originalPrice'] == null
          ? null
          : map['originalPrice'].toDouble() as double,
      category: map['category'],
      location: map['location'] ?? "",
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
      isAdvertisement: map['isAdvertisement'] ?? false,
      isNegotiable: map['isNegotiable'] ?? false,
      type: map['type'],
      stateAddress: map['stateAddress'],
      city: map['city'],
      address: map['address'],
      zipCode: map['zipCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));
  //copy with
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? status,
    List<String>? images,
    int? likes,
    int? numberOfChat,
    String? category,
    double? price,
    double? originalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? location,
    bool? isAdvertisement,
    bool? isNegotiable,
    String? type,
    User? seller,
    String? stateAddress,
    String? city,
    String? address,
    String? zipCode,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      numberOfChat: numberOfChat ?? this.numberOfChat,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      isAdvertisement: isAdvertisement ?? this.isAdvertisement,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      type: type ?? this.type,
      seller: seller ?? this.seller,
      stateAddress: stateAddress ?? this.stateAddress,
      city: city ?? this.city,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}

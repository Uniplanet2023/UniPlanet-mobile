import 'package:isar/isar.dart';
import 'package:uniplanet/core/isar/collection/user.dart';
import 'package:uniplanet/models/product.dart';

part 'product.g.dart';

@Collection()
class ProductModel {
  Id isarId = Isar.autoIncrement;
  late String id;
  late String name;
  late String description;
  late String status;
  late List<String> images;
  late int likes;
  late int numberOfChat;
  late String category;
  late double price;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String location;
  late bool isAdvertisement;
  late bool isNegotiable;
  late String type;
  final seller = IsarLink<UserIsarModel>();
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.images,
    required this.likes,
    required this.numberOfChat,
    required this.category,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
    required this.isAdvertisement,
    required this.isNegotiable,
    required this.type,
  });
  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      status: product.status,
      images: product.images,
      likes: product.likes,
      numberOfChat: product.numberOfChat,
      category: product.category,
      price: product.price,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      location: product.location,
      isAdvertisement: product.isAdvertisement,
      isNegotiable: product.isNegotiable,
      type: product.type,
    );
  }

  Future<Product> toProduct() async {
    await seller.load();
    return Product(
      id: id,
      name: name,
      description: description,
      status: status,
      images: images,
      likes: likes,
      numberOfChat: numberOfChat,
      category: category,
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
      location: location,
      isAdvertisement: isAdvertisement,
      isNegotiable: isNegotiable,
      type: type,
      seller: seller.value!.toUser(),
    );
  }
}

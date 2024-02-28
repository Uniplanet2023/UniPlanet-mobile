part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  final String? category;
  final int? page;
  const LoadProductEvent({this.category, this.page});

  @override
  // TODO: implement props
  List<Object?> get props => [category, page];
}

class UploadProductEvent extends ProductEvent {
  final String productName;
  final String status;
  final String description;
  final double price;
  final String category;
  final List<File> images;
  const UploadProductEvent({
    required this.productName,
    required this.status,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
  });
  @override
  List<Object?> get props =>
      [productName, status, description, price, category, images];
}

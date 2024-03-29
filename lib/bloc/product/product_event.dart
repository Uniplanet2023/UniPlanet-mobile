part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  final int? page;
  const LoadProductEvent({this.page});

  @override
  // TODO: implement props
  List<Object?> get props => [page];
}

class UploadProductEvent extends ProductEvent {
  final String productName;
  final String status;
  final String description;
  final double price;
  final String category;
  final List<File> images;
  final User seller;
  const UploadProductEvent({
    required this.productName,
    required this.status,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.seller,
  });
  @override
  List<Object?> get props =>
      [productName, status, description, price, category, images];
}

part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  const LoadProductEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadMoreProductEvent extends ProductEvent {
  const LoadMoreProductEvent();
  @override
  List<Object?> get props => [];
}

class UploadProductEvent extends ProductEvent {
  final String productName;
  final String status;
  final String description;
  final double price;
  final String category;
  final String location;
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
    required this.location,
  });
  @override
  List<Object?> get props => [
        productName,
        status,
        description,
        price,
        category,
        images,
        seller,
        location
      ];
}

class IncreaseClickProductEvent extends ProductEvent {
  final String productId;
  const IncreaseClickProductEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

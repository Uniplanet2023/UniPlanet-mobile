part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class LoadProductEvent extends ProductEvent {
  const LoadProductEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadProductEvent extends ProductEvent {
  final BuildContext context;
  final String name;
  final String status;
  final String description;
  final double price;
  final String category;
  final List<File> images;
  const UploadProductEvent(this.context, this.name, this.status,
      this.description, this.price, this.category, this.images);
  @override
  List<Object?> get props =>
      [name, status, description, price, category, images];
}

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

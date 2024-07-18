part of 'get_product_bloc.dart';

sealed class GetProductState extends Equatable {
  final Product? product;
  const GetProductState({required this.product});

  @override
  List<Object> get props => [];
}

final class GetProductInitial extends GetProductState {
  const GetProductInitial() : super(product: null);
}

final class GetProductLoading extends GetProductState {
  const GetProductLoading() : super(product: null);
}

final class GetProductLoaded extends GetProductState {
  const GetProductLoaded({required super.product});
}

final class GetProductError extends GetProductState {
  final String error;
  const GetProductError({required this.error}) : super(product: null);

  @override
  List<Object> get props => [error];
}

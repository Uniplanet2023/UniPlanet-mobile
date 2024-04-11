part of '../product_bloc.dart';

// ProductDeletingState

class ProductDeletingState extends ProductState {
  const ProductDeletingState({super.productList, super.page});
  @override
  List<Object?> get props => [productList, page];
}

// ProductDeletedState
class ProductDeletedState extends ProductState {
  const ProductDeletedState({super.productList, super.page});
  @override
  List<Object?> get props => [productList, page];
}

// ProductDeleteFailedState
class ProductDeleteFailedState extends ProductState {
  const ProductDeleteFailedState({super.productList, super.page});
  @override
  List<Object?> get props => [productList, page];
}

part of '../product_bloc.dart';

final class ProductUpdatingState extends ProductState {
  const ProductUpdatingState({super.productList, super.page});
}

final class ProductUpdatedState extends ProductState {
  const ProductUpdatedState({super.productList, super.page});
}

final class ProductUpdateFailedState extends ProductState {
  final String error;
  const ProductUpdateFailedState(this.error, {super.productList, super.page});
}

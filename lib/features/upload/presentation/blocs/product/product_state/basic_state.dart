part of '../product_bloc.dart';

sealed class ProductState extends Equatable {
  final List<Product> productList;
  final int page;
  const ProductState({this.page = 1, this.productList = const <Product>[]});

  @override
  List<Object?> get props => [productList, page];
}

final class InitProductState extends ProductState {
  InitProductState() : super(productList: [], page: 0);
}

final class ErrorProductState extends ProductState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
}

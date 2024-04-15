part of '../product_bloc.dart';

final class LoadingProductState extends ProductState {
  const LoadingProductState({super.productList, super.page});
}

final class LoadedProductState extends ProductState {
  const LoadedProductState({super.productList, super.page});
}

final class EndedProductState extends ProductState {
  const EndedProductState({super.productList, super.page});
}

final class ErrorProductLoadState extends ProductState {
  final String errorMessage;
  const ErrorProductLoadState(this.errorMessage,
      {super.productList, super.page});
}

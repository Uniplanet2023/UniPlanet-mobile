part of '../product_bloc.dart';

final class ProductUploadingState extends ProductState {
  const ProductUploadingState({super.productList, super.page});
}

final class ProductUploadedState extends ProductState {
  const ProductUploadedState({super.productList, super.page});
}

final class ProductUploadSuccessState extends ProductState {
  final Product uploadedProduct;
  const ProductUploadSuccessState(
      {super.productList, super.page, required this.uploadedProduct});
}

final class ErrorProductUploadState extends ProductState {
  final String errorMessage;
  const ErrorProductUploadState(this.errorMessage,
      {super.productList, super.page});
}

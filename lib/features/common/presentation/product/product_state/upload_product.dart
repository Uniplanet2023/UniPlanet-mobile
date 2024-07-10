part of '../product_bloc.dart';

final class ProductUploadingState extends ProductState {
  const ProductUploadingState({super.productList, super.page});
}

final class ProductImageUploadedState extends ProductState {
  final Product uploadedProduct;
  const ProductImageUploadedState(
      {super.productList, super.page, required this.uploadedProduct});
}

final class ProductUploadedState extends ProductState {
  const ProductUploadedState({super.productList, super.page});
}

final class ErrorProductUploadState extends ProductState {
  final String errorMessage;
  const ErrorProductUploadState(this.errorMessage,
      {super.productList, super.page});
}

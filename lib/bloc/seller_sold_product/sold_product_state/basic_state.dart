part of '../sold_product_bloc.dart';

sealed class SellerSoldProductState extends Equatable {
  final List<Product> soldProduct;

  final int soldPage;

  const SellerSoldProductState(
      {this.soldProduct = const [], this.soldPage = 1});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class SellerSoldProductInitial extends SellerSoldProductState {
  const SellerSoldProductInitial({super.soldProduct, super.soldPage});
  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class EndSellerSoldProductState extends SellerSoldProductState {
  const EndSellerSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class ErrorSellerSoldProductState extends SellerSoldProductState {
  final String errorMessage;
  const ErrorSellerSoldProductState(this.errorMessage,
      {super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [errorMessage, soldProduct, soldPage];
}

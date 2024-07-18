part of '../sold_product_bloc.dart';

sealed class SoldProductState extends Equatable {
  final List<Product> soldProduct;

  final int soldPage;

  const SoldProductState({this.soldProduct = const [], this.soldPage = 1});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class SoldProductInitial extends SoldProductState {
  const SoldProductInitial({super.soldProduct, super.soldPage});
  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class EndSoldProductState extends SoldProductState {
  const EndSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class ErrorSoldProductState extends SoldProductState {
  final String errorMessage;
  const ErrorSoldProductState(this.errorMessage,
      {super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [errorMessage, soldProduct, soldPage];
}

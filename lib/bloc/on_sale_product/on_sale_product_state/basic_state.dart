part of '../on_sale_product_bloc.dart';

sealed class OnSaleProductState extends Equatable {
  final List<Product> onSaleProduct;
  final int onSalePage;

  const OnSaleProductState(
      {this.onSaleProduct = const [], this.onSalePage = 1});

  @override
  List<Object> get props => [onSaleProduct, onSalePage];
}

final class OnSaleProductInitial extends OnSaleProductState {
  const OnSaleProductInitial({super.onSaleProduct, super.onSalePage});
  @override
  List<Object> get props => [onSaleProduct, onSalePage];
}

final class EndOnSaleProductState extends OnSaleProductState {
  const EndOnSaleProductState({
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [
        onSaleProduct,
        onSalePage,
      ];
}

final class ErrorOnSaleProductState extends OnSaleProductState {
  final String errorMessage;
  const ErrorOnSaleProductState(
    this.errorMessage, {
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [errorMessage, onSaleProduct, onSalePage];
}

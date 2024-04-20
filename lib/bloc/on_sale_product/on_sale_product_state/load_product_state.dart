part of '../on_sale_product_bloc.dart';

final class LoadingOnSaleProductState extends OnSaleProductState {
  const LoadingOnSaleProductState({
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [
        onSaleProduct,
        onSalePage,
      ];
}

final class LoadedOnSaleProductState extends OnSaleProductState {
  const LoadedOnSaleProductState({
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [
        onSaleProduct,
        onSalePage,
      ];
}

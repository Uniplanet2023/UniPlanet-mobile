part of '../sale_product_bloc.dart';

final class LoadingMoreOnSaleProductState extends OnSaleProductState {
  const LoadingMoreOnSaleProductState({
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [
        onSaleProduct,
        onSalePage,
      ];
}

final class LoadedMoreOnSaleProductState extends OnSaleProductState {
  const LoadedMoreOnSaleProductState({
    super.onSaleProduct,
    super.onSalePage,
  });

  @override
  List<Object> get props => [
        onSaleProduct,
        onSalePage,
      ];
}

part of '../seller_sale_product_bloc.dart';

final class LoadingSellerSaleProductState extends SellerSaleProductState {
  const LoadingSellerSaleProductState({super.sellerProduct, super.page});
}

final class LoadedSellerSaleProductState extends SellerSaleProductState {
  const LoadedSellerSaleProductState({super.sellerProduct, super.page});
}

final class ErrorSellerSaleProductState extends SellerSaleProductState {
  const ErrorSellerSaleProductState({super.sellerProduct, super.page});
}

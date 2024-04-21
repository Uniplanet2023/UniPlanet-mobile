part of '../seller_sale_product_bloc.dart';

sealed class SellerSaleProductState extends Equatable {
  final List<Product> sellerProduct;
  final int page;

  const SellerSaleProductState({
    this.sellerProduct = const [],
    this.page = 1,
  });

  @override
  List<Object> get props => [sellerProduct, page];
}

final class SellerSaleProductInitial extends SellerSaleProductState {
  const SellerSaleProductInitial({super.sellerProduct, super.page});
  @override
  List<Object> get props => [sellerProduct, page];
}

//End State
final class EndSellerSaleProductState extends SellerSaleProductState {
  const EndSellerSaleProductState({
    super.sellerProduct,
    super.page,
  });

  @override
  List<Object> get props => [
        sellerProduct,
        page,
      ];
}

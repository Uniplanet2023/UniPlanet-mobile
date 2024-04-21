part of 'seller_sale_product_bloc.dart';

sealed class SellerSaleProductEvent extends Equatable {
  const SellerSaleProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSellerSaleProductEvent extends SellerSaleProductEvent {
  final String userId;
  const LoadSellerSaleProductEvent({required this.userId});
}

class LoadMoreSellerSaleProductEvent extends SellerSaleProductEvent {
  final String userId;
  const LoadMoreSellerSaleProductEvent({required this.userId});
}

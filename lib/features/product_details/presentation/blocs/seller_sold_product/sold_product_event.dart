part of 'sold_product_bloc.dart';

sealed class SellerSoldProductEvent extends Equatable {
  const SellerSoldProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSellerSoldProductEvent extends SellerSoldProductEvent {
  final String userId;
  const LoadSellerSoldProductEvent({required this.userId});
}

class LoadMoreSellerSoldProductEvent extends SellerSoldProductEvent {
  final String userId;
  const LoadMoreSellerSoldProductEvent({required this.userId});
}

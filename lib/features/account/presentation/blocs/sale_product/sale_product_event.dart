part of 'sale_product_bloc.dart';

sealed class OnSaleProductEvent extends Equatable {
  const OnSaleProductEvent();

  @override
  List<Object> get props => [];
}

class LoadOnSaleProductEvent extends OnSaleProductEvent {
  final String userId;
  const LoadOnSaleProductEvent({required this.userId});
}

class LoadMoreOnSaleProductEvent extends OnSaleProductEvent {
  final String userId;
  const LoadMoreOnSaleProductEvent({required this.userId});
}

class AddOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const AddOnSaleProductEvent({required this.product});
}

class DeleteOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const DeleteOnSaleProductEvent({required this.product});
}

class UpdateOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const UpdateOnSaleProductEvent({required this.product});
}

part of 'on_sale_product_bloc.dart';

sealed class OnSaleProductEvent extends Equatable {
  const OnSaleProductEvent();

  @override
  List<Object> get props => [];
}

class LoadOnSaleProductEvent extends OnSaleProductEvent {
  const LoadOnSaleProductEvent();
}

class LoadMoreOnSaleProductEvent extends OnSaleProductEvent {
  const LoadMoreOnSaleProductEvent();
}

class AddOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const AddOnSaleProductEvent({required this.product});
}

class DeleteOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const DeleteOnSaleProductEvent({required this.product});
}

//TODO: Add UpdateOnSaleProductEvent
class UpdateOnSaleProductEvent extends OnSaleProductEvent {
  final Product product;
  const UpdateOnSaleProductEvent({required this.product});
}

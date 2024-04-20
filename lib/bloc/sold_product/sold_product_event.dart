part of 'sold_product_bloc.dart';

sealed class SoldProductEvent extends Equatable {
  const SoldProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSoldProductEvent extends SoldProductEvent {
  final String userId;
  const LoadSoldProductEvent({required this.userId});
}

class LoadMoreSoldProductEvent extends SoldProductEvent {
  final String userId;
  const LoadMoreSoldProductEvent({required this.userId});
}

class AddSoldProductEvent extends SoldProductEvent {
  const AddSoldProductEvent();
}

class DeleteSoldProductEvent extends SoldProductEvent {
  final Product product;
  const DeleteSoldProductEvent({required this.product});
}

class UpdateSoldProductEvent extends SoldProductEvent {
  final Product product;
  const UpdateSoldProductEvent({required this.product});
}

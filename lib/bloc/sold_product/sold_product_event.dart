part of 'sold_product_bloc.dart';

sealed class SoldProductEvent extends Equatable {
  const SoldProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSoldProductEvent extends SoldProductEvent {
  const LoadSoldProductEvent();
}

class LoadMoreSoldProductEvent extends SoldProductEvent {
  const LoadMoreSoldProductEvent();
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

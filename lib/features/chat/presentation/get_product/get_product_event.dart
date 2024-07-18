part of 'get_product_bloc.dart';

sealed class GetProductEvent extends Equatable {
  final String productId;
  const GetProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

final class GetProductLoadEvent extends GetProductEvent {
  const GetProductLoadEvent({required super.productId});

  @override
  List<Object> get props => [];
}

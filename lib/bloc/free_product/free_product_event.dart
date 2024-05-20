part of 'free_product_bloc.dart';

sealed class FreeProductEvent extends Equatable {
  final String? category;
  const FreeProductEvent({this.category});

  @override
  List<Object> get props => [category ?? ''];
}

class LoadFreeProductEvent extends FreeProductEvent {
  const LoadFreeProductEvent({required String category})
      : super(category: category);
  @override
  List<Object> get props => [category ?? ''];
}

class LoadMoreFreeProductEvent extends FreeProductEvent {
  const LoadMoreFreeProductEvent({required String category})
      : super(category: category);
  @override
  List<Object> get props => [category ?? ''];
}

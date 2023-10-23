part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  final List<String>? defaultItems;
  const ProductState({this.defaultItems});

  @override
  List<Object?> get props => [defaultItems];
}

final class InitProductState extends ProductState {
  InitProductState() : super(defaultItems: []);
}

final class LoadingProductState extends ProductState {
  const LoadingProductState({super.defaultItems});
}

final class LoadedProductState extends ProductState {
  const LoadedProductState({super.defaultItems});
}

final class ErrorProductState extends ProductState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
}

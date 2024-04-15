part of 'hot_product_bloc.dart';

sealed class HotProductState extends Equatable {
  final List<Product> hotProducts;
  final int hotProductPage;
  const HotProductState(
      {this.hotProducts = const <Product>[], this.hotProductPage = 1});

  @override
  List<Object> get props => [];
}

final class HotProductInitial extends HotProductState {
  const HotProductInitial()
      : super(
          hotProducts: const <Product>[],
          hotProductPage: 1,
        );
  @override
  List<Object> get props => [hotProducts, hotProductPage];
}

final class LoadingHotProductState extends HotProductState {
  const LoadingHotProductState({
    super.hotProducts,
    super.hotProductPage,
  });
  @override
  List<Object> get props => [hotProducts, hotProductPage];
}

final class LoadedHotProductState extends HotProductState {
  const LoadedHotProductState({
    super.hotProducts,
    super.hotProductPage,
  });
  @override
  List<Object> get props => [hotProducts, hotProductPage];
}

final class EndHotProductState extends HotProductState {
  const EndHotProductState({
    super.hotProducts,
    super.hotProductPage,
  });
  @override
  List<Object> get props => [hotProducts, hotProductPage];
}

final class ErrorHotProductState extends HotProductState {
  final String message;
  const ErrorHotProductState({
    required this.message,
    super.hotProducts,
    super.hotProductPage,
  });
  @override
  List<Object> get props => [message, hotProducts, hotProductPage];
}

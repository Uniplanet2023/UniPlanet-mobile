part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  final List<Product> categoryProducts;
  final List<Product> hotProducts;
  const CategoryState(
      {this.categoryProducts = const <Product>[],
      this.hotProducts = const <Product>[]});
  @override
  List<Object> get props => [categoryProducts, hotProducts];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial()
      : super(
            categoryProducts: const <Product>[],
            hotProducts: const <Product>[]);
}

final class LoadingCategoryState extends CategoryState {
  const LoadingCategoryState({super.categoryProducts, super.hotProducts});
}

final class LoadedCategoryState extends CategoryState {
  const LoadedCategoryState({super.categoryProducts, super.hotProducts});
}

final class LoadingHotProductState extends CategoryState {
  const LoadingHotProductState({super.categoryProducts, super.hotProducts});
}

final class LoadedHotProductState extends CategoryState {
  const LoadedHotProductState({super.categoryProducts, super.hotProducts});
}

final class ErrorCategoryState extends CategoryState {
  final String errorMessage;
  const ErrorCategoryState(this.errorMessage);
}

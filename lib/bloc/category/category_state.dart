part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  final List<Product> categoryProducts;
  final int categoryPage;

  const CategoryState({
    this.categoryProducts = const <Product>[],
    this.categoryPage = 1,
  });
  @override
  List<Object> get props => [categoryProducts, categoryPage];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial()
      : super(
          categoryProducts: const <Product>[],
          categoryPage: 1,
        );
  @override
  List<Object> get props => [categoryProducts, categoryPage];
}

final class LoadingCategoryState extends CategoryState {
  const LoadingCategoryState({
    super.categoryProducts,
    super.categoryPage,
  });
  @override
  List<Object> get props => [categoryProducts, categoryPage];
}

final class LoadedCategoryState extends CategoryState {
  const LoadedCategoryState({
    super.categoryProducts,
    super.categoryPage,
  });
  @override
  List<Object> get props => [categoryProducts, categoryPage];
}

final class EndCategoryState extends CategoryState {
  const EndCategoryState({
    super.categoryProducts,
    super.categoryPage,
  });
  @override
  List<Object> get props => [categoryProducts, categoryPage];
}

final class ErrorCategoryState extends CategoryState {
  final String errorMessage;
  const ErrorCategoryState(this.errorMessage);
}

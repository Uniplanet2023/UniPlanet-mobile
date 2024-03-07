part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  final List<Product> categoryProducts;
  const CategoryState({this.categoryProducts = const <Product>[]});
  @override
  List<Object> get props => [categoryProducts];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial() : super(categoryProducts: const <Product>[]);
}

final class LoadingCategoryState extends CategoryState {
  const LoadingCategoryState({super.categoryProducts});
}

final class LoadedCategoryState extends CategoryState {
  const LoadedCategoryState({super.categoryProducts});
}

final class ErrorCategoryState extends CategoryState {
  final String errorMessage;
  const ErrorCategoryState(this.errorMessage);
}

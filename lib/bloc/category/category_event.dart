part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  final String? category;
  final int page;
  const CategoryEvent({this.category = '', this.page = 1});

  @override
  List<Object> get props => [category ?? '', page];
}

class LoadCategoryEvent extends CategoryEvent {
  const LoadCategoryEvent({required String category, int? page})
      : super(category: category, page: page ?? 1);
}

class GetHotProductsEvent extends CategoryEvent {
  const GetHotProductsEvent();
  @override
  List<Object> get props => [];
}

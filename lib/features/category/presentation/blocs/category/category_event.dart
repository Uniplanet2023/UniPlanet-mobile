part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  final String? category;
  const CategoryEvent({this.category = ''});

  @override
  List<Object> get props => [category ?? ''];
}

class LoadCategoryEvent extends CategoryEvent {
  const LoadCategoryEvent({required String category})
      : super(category: category);
  @override
  List<Object> get props => [category ?? ''];
}

class LoadMoreCategoryEvent extends CategoryEvent {
  const LoadMoreCategoryEvent({required String category})
      : super(category: category);
  @override
  List<Object> get props => [category ?? ''];
}

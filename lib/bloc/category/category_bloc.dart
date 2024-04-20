import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniket/models/product.dart';
import 'package:uniket/network/repository/product_repository/product_repo.dart';

import '../../constants/utils.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository _productRepository;
  CategoryBloc(this._productRepository) : super(const CategoryInitial()) {
    on<LoadCategoryEvent>((event, emit) async {
      await _loadCategoryProduct(event, emit);
    });
    on<LoadMoreCategoryEvent>((event, emit) async {
      await _loadMoreCategoryProduct(event, emit);
    });
  }

  _loadMoreCategoryProduct(LoadMoreCategoryEvent event, emit) async {
    emit(LoadingCategoryState(
      categoryProducts: state.categoryProducts,
      categoryPage: state.categoryPage,
    ));
    List<Product> result = [];
    int nextPage = state.categoryPage + 1;
    try {
      result = await _productRepository.fetchProducts(
          page: nextPage, category: event.category);
    } catch (e) {
      emit(ErrorCategoryState(e.toString()));
    }
    if (result.isEmpty) {
      emit(EndCategoryState(
        categoryProducts: state.categoryProducts,
        categoryPage: state.categoryPage,
      ));
      return;
    } else {
      state.categoryProducts.addAll(result);
      emit(LoadedCategoryState(
        categoryProducts: state.categoryProducts,
        categoryPage: nextPage,
      ));
    }
  }

  _loadCategoryProduct(LoadCategoryEvent event, emit) async {
    emit(const LoadingCategoryState(
      categoryProducts: [],
      categoryPage: 1,
    ));
    List<Product> result = [];
    try {
      result = await _productRepository.fetchProducts(
          page: state.categoryPage, category: event.category);
    } catch (e) {
      emit(ErrorCategoryState(e.toString()));
    }
    if (result.isEmpty) {
      emit(EndCategoryState(
        categoryProducts: state.categoryProducts,
        categoryPage: state.categoryPage,
      ));
      return;
    } else {
      emit(LoadedCategoryState(
        categoryProducts: result,
        categoryPage: 1,
      ));
    }
  }

  @override
  void onChange(Change<CategoryState> change) {
    super.onChange(change);
    log(change);
  }

  @override
  void onTransition(Transition<CategoryEvent, CategoryState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}

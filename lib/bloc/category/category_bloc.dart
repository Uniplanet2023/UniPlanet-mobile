import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/product_repository/product_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRepository _productRepository;
  CategoryBloc(this._productRepository) : super(const CategoryInitial()) {
    on<LoadCategoryEvent>((event, emit) async {
      await _loadCategoryProduct(event, emit);
    });
    on<GetHotProductsEvent>((event, emit) async {
      await _getHotProducts(event, emit);
    });
  }

  _getHotProducts(GetHotProductsEvent event, emit) async {
    emit(const LoadingCategoryState());
    List<Product> result = await _productRepository.getHotProducts();
    emit(LoadedCategoryState(categoryProducts: result));
  }

  _loadCategoryProduct(LoadCategoryEvent event, emit) async {
    emit(const LoadingCategoryState());
    List<Product> result = await _productRepository.fetchProducts(
        page: event.page, category: event.category);
    emit(LoadedCategoryState(categoryProducts: result));
  }

  @override
  void onChange(Change<CategoryState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<CategoryEvent, CategoryState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}

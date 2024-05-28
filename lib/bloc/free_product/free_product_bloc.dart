import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/api/repository/index.dart';

part 'free_product_event.dart';
part 'free_product_state.dart';

class FreeProductBloc extends Bloc<FreeProductEvent, FreeProductState> {
  final ProductRepository _productRepository;
  FreeProductBloc(this._productRepository) : super(const FreeProductInitial()) {
    on<LoadFreeProductEvent>((event, emit) async {
      await _loadFreeProduct(event, emit);
    });
    on<LoadMoreFreeProductEvent>((event, emit) async {
      await _loadMoreFreeProduct(event, emit);
    });
  }
  _loadFreeProduct(LoadFreeProductEvent event, emit) async {
    emit(const LoadingFreeProductState(productList: [], page: 1));
    List<Product> result = await _productRepository.getFreeProducts(
        page: 1, category: event.category);
    if (result.isEmpty) {
      emit(const EndFreeProductState(productList: [], page: 1));
      return;
    }
    emit(LoadedFreeProductState(productList: result, page: 1));
  }

  _loadMoreFreeProduct(LoadMoreFreeProductEvent event, emit) async {
    emit(LoadingMoreFreeProductState(
      productList: state.productList,
      page: state.page,
    ));
    List<Product> result = [];
    int nextPage = state.page + 1;
    try {
      result = await _productRepository.getFreeProducts(
          page: nextPage, category: event.category);
    } catch (e) {
      emit(ErrorFreeProductState(e.toString()));
    }
    if (result.isEmpty) {
      emit(EndFreeProductState(
        productList: state.productList,
        page: state.page,
      ));
      return;
    } else {
      state.productList.addAll(result);
      emit(LoadedFreeProductState(
        productList: state.productList,
        page: nextPage,
      ));
    }
  }
}

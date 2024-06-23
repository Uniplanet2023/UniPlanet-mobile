import 'package:equatable/equatable.dart';
import 'package:uniplanet/api/repository/product_repository/product_repo.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/models/product.dart';

part 'wanted_product_event.dart';
part 'wanted_product_state.dart';

class WantedProductBloc extends Bloc<WantedProductEvent, WantedProductState> {
  final ProductRepository _productRepository;
  WantedProductBloc(this._productRepository) : super(WantedProductInitial()) {
    on<LoadWantedProductEvent>((event, emit) async {
      await _loadWantedProduct(event, emit);
    });
    on<LoadMoreWantedProductEvent>((event, emit) async {
      await _loadMoreWantedProduct(event, emit);
    });
  }
  _loadMoreWantedProduct(LoadMoreWantedProductEvent event, emit) async {
    emit(LoadingMoreWantedProductState(
        productList: state.productList, page: state.page));
    int nextPage = state.page + 1;
    List<Product> result = [];
    try {
      result = await _productRepository.getWantedProducts(page: nextPage);
    } catch (e) {
      emit(ErrorWantedProductLoadState(e.toString()));
    }
    if (result.isEmpty) {
      emit(EndedWantedProductState(
        productList: state.productList,
        page: state.page,
      ));

      return;
    }
    state.productList.addAll(result);
    emit(LoadedWantedProductState(
        productList: state.productList, page: nextPage));
  }

  _loadWantedProduct(LoadWantedProductEvent event, emit) async {
    emit(const LoadingWantedProductState(
      productList: [],
      page: 1,
    ));
    List<Product> result = [];
    try {
      result = await _productRepository.getWantedProducts(page: 1);
      if (result.isEmpty) {
        emit(const EndedWantedProductState(productList: [], page: 1));
        return;
      }
    } catch (e) {
      emit(ErrorWantedProductLoadState(e.toString()));
    }

    if (result.isEmpty) {
      emit(EndedWantedProductState(productList: state.productList, page: 1));
      return;
    }
    emit(LoadedWantedProductState(productList: result, page: 1));
  }
}

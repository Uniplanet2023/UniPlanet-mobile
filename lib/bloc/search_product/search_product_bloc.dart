import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniket/constants/utils.dart';
import 'package:uniket/models/product.dart';
import 'package:uniket/network/repository/product_repository/product_repo.dart';

part 'search_product_event.dart';
part 'search_product_state/basic_state.dart';
part 'search_product_state/load_product.dart';
part 'search_product_state/load_more_product.dart';

class SearchProductBloc
    extends Bloc<BaseSearchProductEvent, SearchProductState> {
  final ProductRepository _productRepository;

  SearchProductBloc(this._productRepository)
      : super(const SearchProductInitial(productList: [])) {
    on<LoadSearchProductEvent>((event, emit) async {
      await _searchProduct(event, emit);
    });
    on<LoadMoreSearchProductEvent>((event, emit) async {
      await _loadMoreSearchProduct(event, emit);
    });
    on<InitalSearchProductEvent>((event, emit) async {
      emit(const SearchProductInitial(productList: []));
    });
  }

  _loadMoreSearchProduct(LoadMoreSearchProductEvent event,
      Emitter<SearchProductState> emit) async {
    emit(LoadingMoreSearchingProductState(
        productList: state.productList,
        page: state.page,
        query: event.productName));
    int page = state.page + 1;
    List<Product> result =
        await _productRepository.searchProduct(page, event.productName);
    if (result.isEmpty) {
      emit(EndSearchingProductState(
          productList: state.productList,
          page: state.page,
          query: event.productName));
      return;
    }
    state.productList.addAll(result);
    emit(LoadedMoreSearchingProductState(
        productList: state.productList, page: page, query: event.productName));
  }

  _searchProduct(
      LoadSearchProductEvent event, Emitter<SearchProductState> emit) async {
    emit(LoadingSearchingProductState(
        productList: state.productList, page: 1, query: event.productName));
    List<Product> result =
        await _productRepository.searchProduct(state.page, event.productName);

    emit(LoadedSearchingProductState(
        productList: result, page: 1, query: event.productName));
  }

  @override
  void onChange(Change<SearchProductState> change) {
    super.onChange(change);
    log(change);
  }

  @override
  void onTransition(
      Transition<BaseSearchProductEvent, SearchProductState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}

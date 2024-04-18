import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<SearchProductEvent>((event, emit) async {
      await _searchProduct(event, emit);
    });
    on(<InitalSearchProductEvent>(event, emit) =>
        emit(const SearchProductInitial()));
  }
  _searchProduct(
      SearchProductEvent event, Emitter<SearchProductState> emit) async {
    emit(LoadingSearchingProductState(productList: state.productList));
    List<Product> result =
        await _productRepository.searchProduct(event.page, event.productName);
    emit(LoadedSearchingProductState(productList: result));
  }

  @override
  void onChange(Change<SearchProductState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(
      Transition<BaseSearchProductEvent, SearchProductState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}

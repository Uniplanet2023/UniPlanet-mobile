import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(InitProductState()) {
    on<LoadProductEvent>((event, emit) async {
      await _loadProduct(event, emit);
    });
  }
  _loadProduct(LoadProductEvent event, emit) async {
    emit(LoadingProductState(productList: state.productList));
    List<Product> result = await _productRepository.fetchAllProducts();
    emit(LoadedProductState(productList: result));
  }

  // @override
  // void onChange(Change<ProductState> change) {
  //   super.onChange(change);
  //   print(change);
  // }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}

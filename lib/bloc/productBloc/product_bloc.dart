import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(InitProductState()) {
    on<DefaultLoadProductEvent>((event, emit) {
      // await _defaultLoadProduct(event,emit);
    }, transformer: concurrent());
    add(DefaultLoadProductEvent());
  }
  _defaultLoadProduct(DefaultLoadProductEvent event, emit) async {
    emit(LoadingProductState(defaultItems: state.defaultItems));
    // var result = await
  }
}

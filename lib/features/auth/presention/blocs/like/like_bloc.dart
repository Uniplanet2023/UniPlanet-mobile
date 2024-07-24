import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/network/notification/notification_scheduling.dart';
import 'package:uniplanet/core/utils/utils.dart';
// Repositories
import 'package:uniplanet/core/network/repository/product_repository/product_repo.dart';
import 'package:uniplanet/core/entities/user.dart';
// Models
import 'package:uniplanet/models/product.dart';
// Parts of the bloc
part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final ProductRepository _likeRepository;
  LikeBloc(this._likeRepository)
      : super(const LikeInitial(likeProduct: [], page: 1)) {
    on<AddLikeEvent>((event, emit) async {
      await _addLike(event, emit);
    });
    on<RemoveLikeEvent>((event, emit) async {
      await _removeLike(event, emit);
    });
    on<LoadLikeEvent>((event, emit) async {
      await _loadLike(event, emit);
    });
    on<LoadMoreLikeEvent>((event, emit) async {
      await _loadMoreLike(event, emit);
    });
  }
  _loadMoreLike(LoadMoreLikeEvent event, emit) async {
    emit(LikeLoadingMore(likeProduct: state.likeProduct, page: state.page));
    try {
      int nextPage = state.page + 1;
      List<Product> likeProduct =
          await _likeRepository.getProductLikes(page: nextPage);
      if (likeProduct.isEmpty) {
        emit(LikeEnd(likeProduct: state.likeProduct, page: state.page));
        return;
      }
      state.likeProduct.addAll(likeProduct);
      emit(LikeLoadedMore(likeProduct: state.likeProduct, page: nextPage));
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  _loadLike(LoadLikeEvent event, emit) async {
    emit(const LikeLoading(likeProduct: [], page: 1));
    try {
      List<Product> likeProduct =
          await _likeRepository.getProductLikes(page: state.page);
      if (likeProduct.isEmpty) {
        emit(const LikeEnd(likeProduct: [], page: 1));
        return;
      } else {
        notificationScheduling(likeProduct, 11);
      }
      emit(LikeLoaded(likeProduct: likeProduct, page: state.page));
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  _addLike(AddLikeEvent event, emit) async {
    emit(LikeAdding(likeProduct: state.likeProduct));
    try {
      bool success = await _likeRepository.likeProduct(
          productId: event.product.id, user: event.user);
      if (success) {
        // Create a new mutable list from the existing unmodifiable list
        List<Product> updatedLikeProduct = List.from(state.likeProduct);
        updatedLikeProduct.add(event.product);

        emit(LikeAdded(
            likeProduct: updatedLikeProduct, addedProduct: event.product));
      } else {
        emit(const LikeError(message: "Error liking product"));
        return;
      }
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  _removeLike(RemoveLikeEvent event, emit) async {
    emit(LikeRemoving(likeProduct: state.likeProduct));
    try {
      bool success = await _likeRepository.unlikeProduct(
          productId: event.product.id, user: event.user);
      if (!success) {
        emit(const LikeError(message: "Error unliking product"));
        return;
      }
      state.likeProduct
          .removeWhere((element) => element.id == event.product.id);
      // Remove like
      emit(LikeRemoved(
          likeProduct: state.likeProduct, removedProduct: event.product));
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  @override
  void onChange(Change<LikeState> change) {
    super.onChange(change);
    log(change);
  }
}

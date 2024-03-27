part of 'like_bloc.dart';

sealed class LikeState extends Equatable {
  final List<Product> likeProduct;
  const LikeState({this.likeProduct = const []});

  @override
  List<Object> get props => [likeProduct];
}

final class LikeInitial extends LikeState {
  const LikeInitial({required super.likeProduct});
}

//Like Loading
final class LikeLoading extends LikeState {
  const LikeLoading({required super.likeProduct});
}

final class LikeLoaded extends LikeState {
  const LikeLoaded({required super.likeProduct});
}

//Like Adding
final class LikeAdding extends LikeState {
  const LikeAdding({required super.likeProduct});
}

// ignore: must_be_immutable
final class LikeAdded extends LikeState {
  Product? addedProduct;
  LikeAdded({required super.likeProduct, this.addedProduct});
}

// Like Removing
final class LikeRemoving extends LikeState {
  const LikeRemoving({required super.likeProduct});
}

// ignore: must_be_immutable
final class LikeRemoved extends LikeState {
  Product? removedProduct;
  LikeRemoved({required super.likeProduct, this.removedProduct});
}

final class LikeError extends LikeState {
  final String message;
  const LikeError({required this.message});
}

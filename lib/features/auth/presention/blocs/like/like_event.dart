part of 'like_bloc.dart';

sealed class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

final class LikeInitialEvent extends LikeEvent {
  const LikeInitialEvent();
}

// Load Like
final class LoadLikeEvent extends LikeEvent {
  const LoadLikeEvent();
  @override
  List<Object> get props => [];
}

// Load More Like
final class LoadMoreLikeEvent extends LikeEvent {
  const LoadMoreLikeEvent();
  @override
  List<Object> get props => [];
}

// Add Like
final class AddLikeEvent extends LikeEvent {
  final Product product;
  final User user;
  const AddLikeEvent({required this.product, required this.user});
  @override
  List<Object> get props => [product, user];
}

// Remove Like
final class RemoveLikeEvent extends LikeEvent {
  final Product product;
  final User user;
  const RemoveLikeEvent({required this.product, required this.user});
  @override
  List<Object> get props => [product, user];
}

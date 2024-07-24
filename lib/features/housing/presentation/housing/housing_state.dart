part of 'housing_bloc.dart';

sealed class GetHousingState extends Equatable {
  final List<HousingPost> housingPosts;
  final int pageNumber;
  const GetHousingState({this.housingPosts = const [], this.pageNumber = 1});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class HousingInitial extends GetHousingState {
  const HousingInitial({super.pageNumber, super.housingPosts});
  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class HousingPostsLoading extends GetHousingState {
  const HousingPostsLoading({super.pageNumber, super.housingPosts});
  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class HousingPostsLoaded extends GetHousingState {
  const HousingPostsLoaded({super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class HousingPostsEnd extends GetHousingState {
  const HousingPostsEnd({super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class DeletingHousingPost extends GetHousingState {
  const DeletingHousingPost({super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class DeletedHousingPost extends GetHousingState {
  const DeletedHousingPost({super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class FetchingHousingPost extends GetHousingState {
  const FetchingHousingPost({super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts];
}

final class FetchedHousingPost extends GetHousingState {
  final HousingPost currentHousingPost;
  const FetchedHousingPost(
      {required this.currentHousingPost, super.housingPosts, super.pageNumber});

  @override
  List<Object> get props => [pageNumber, housingPosts, currentHousingPost];
}

final class HousingPostsError extends GetHousingState {
  final String message;

  const HousingPostsError(this.message);

  @override
  List<Object> get props => [message];
}

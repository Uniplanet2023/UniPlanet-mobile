import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/housing/domain/entities/housing_post.dart';
import 'package:uniplanet/features/housing/domain/usecases/delete_housing_post.dart';
import 'package:uniplanet/features/housing/domain/usecases/fetch_housing_post.dart';
import 'package:uniplanet/features/housing/domain/usecases/fetch_my_housing_posts.dart';
import 'package:uniplanet/features/housing/domain/usecases/get_housing_posts.dart';

part 'housing_event.dart';
part 'housing_state.dart';

class GetHousingBloc extends Bloc<GetHousingEvent, GetHousingState> {
  final GetHousingPosts getHousingPosts;
  final FetchMyHousingPosts fetchMyHousingPosts;
  final DeleteHousingPost deleteHousingPost;
  final FetchHousingPost fetchHousingPost;
  GetHousingBloc(this.getHousingPosts, this.fetchMyHousingPosts,
      this.deleteHousingPost, this.fetchHousingPost)
      : super(const HousingInitial(housingPosts: [], pageNumber: 1)) {
    on<GetMyHousingPosts>((event, emit) async {
      await getMyHousingPosts(event, emit);
    });
    on<GetMoreMyHousingPosts>((event, emit) async {
      await getMoreMyHousingPosts(event, emit);
    });
    on<FetchHousingPosts>((event, emit) async {
      await fetchHousingPosts(event, emit);
    });
    on<FetchMoreHousingPosts>((event, emit) async {
      await fetchHousingPostsMore(event, emit);
    });
    on<DeleteHousingPostEvent>((event, emit) async {
      await deleteHousingPostRequest(event, emit);
    });
    on<FetchHousingPostEvent>((event, emit) async {
      await fetchHousingPostRequest(event, emit);
    });
  }
  fetchHousingPostRequest(FetchHousingPostEvent event, emit) async {
    emit(FetchingHousingPost(
        housingPosts: state.housingPosts, pageNumber: state.pageNumber));
    final currentHousingPost = await fetchHousingPost(event.housingId);
    emit(FetchedHousingPost(
        housingPosts: state.housingPosts,
        pageNumber: state.pageNumber,
        currentHousingPost: currentHousingPost));
  }

  deleteHousingPostRequest(DeleteHousingPostEvent event, emit) async {
    emit(DeletingHousingPost(housingPosts: state.housingPosts));
    await deleteHousingPost(event.id);
    state.housingPosts.removeWhere((element) => element.id == event.id);
    emit(DeletedHousingPost(housingPosts: state.housingPosts));
  }

  getMyHousingPosts(GetMyHousingPosts event, emit) async {
    emit(const HousingPostsLoading(housingPosts: [], pageNumber: 1));

    final List<HousingPost> housingPosts =
        await fetchMyHousingPosts(pageNumber: 1, status: 'On Sale');

    if (housingPosts.length < 10) {
      return emit(HousingPostsEnd(housingPosts: housingPosts, pageNumber: 1));
    }

    emit(HousingPostsLoaded(housingPosts: housingPosts, pageNumber: 1));
  }

  getMoreMyHousingPosts(
      GetMoreMyHousingPosts event, Emitter<GetHousingState> emit) async {
    emit(HousingPostsLoading(housingPosts: state.housingPosts, pageNumber: 1));

    final housingPosts =
        await getHousingPosts(pageNumber: state.pageNumber + 1);

    if (housingPosts.length < 10) {
      emit(HousingPostsEnd(
          housingPosts: state.housingPosts, pageNumber: state.pageNumber));
    } else {
      emit(HousingPostsLoaded(
          housingPosts: state.housingPosts + housingPosts,
          pageNumber: state.pageNumber + 1));
    }
  }

  fetchHousingPosts(
      FetchHousingPosts event, Emitter<GetHousingState> emit) async {
    emit(const HousingPostsLoading(housingPosts: [], pageNumber: 1));
    final housingPosts = await getHousingPosts(pageNumber: state.pageNumber);
    emit(HousingPostsLoaded(housingPosts: housingPosts));
  }

  fetchHousingPostsMore(
      FetchMoreHousingPosts event, Emitter<GetHousingState> emit) async {
    final housingPosts =
        await getHousingPosts(pageNumber: state.pageNumber + 1);
    if (housingPosts.isEmpty) {
      emit(HousingPostsEnd(
          housingPosts: state.housingPosts, pageNumber: state.pageNumber));
    } else {
      emit(HousingPostsLoaded(
          housingPosts: state.housingPosts + housingPosts,
          pageNumber: state.pageNumber + 1));
    }
  }
}

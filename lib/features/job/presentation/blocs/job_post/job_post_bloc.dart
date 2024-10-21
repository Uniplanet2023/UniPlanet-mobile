import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/job/domain/entities/job_post.dart';
import 'package:uniplanet/features/job/domain/usecases/get_job_posts.dart';
import 'package:uniplanet/features/job/domain/usecases/remove_job_post_usecase.dart';

part 'job_post_event.dart';
part 'job_post_state.dart';

class JobPostBloc extends Bloc<JobPostEvent, JobPostState> {
  final GetJobPosts getJobPosts;
  final RemoveJobUseCase removeJobPost;

  JobPostBloc({required this.getJobPosts, required this.removeJobPost})
      : super(const JobPostInitial()) {
    on<FetchJobPosts>((event, emit) async {
      await onFetchJobPosts(event, emit);
    });
    on<RemoveJobPost>((event, emit) async {
      await onRemoveJobPost(event, emit);
    });
  }

  Future<void> onRemoveJobPost(
      RemoveJobPost event, Emitter<JobPostState> emit) async {
    emit(JobPostLoading(state.jobPosts));

    try {
      await removeJobPost(event.jobId);
      final jobPosts =
          state.jobPosts.where((jobPost) => jobPost.id != event.jobId).toList();
      emit(JobPostLoaded(jobPosts));
    } catch (e) {
      emit(JobPostError(e.toString(), state.jobPosts));
    }
  }

  Future<void> onFetchJobPosts(
      FetchJobPosts event, Emitter<JobPostState> emit) async {
    emit(JobPostLoading(state.jobPosts));

    try {
      final jobPosts = await getJobPosts(event.page, event.limit);
      emit(JobPostLoaded(jobPosts));
    } catch (e) {
      emit(JobPostError(e.toString(), state.jobPosts));
    }
  }
}

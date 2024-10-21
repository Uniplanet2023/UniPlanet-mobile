part of 'job_post_bloc.dart';

sealed class JobPostEvent extends Equatable {
  const JobPostEvent();

  @override
  List<Object> get props => [];
}

final class FetchJobPosts extends JobPostEvent {
  final int page;
  final int limit;

  const FetchJobPosts(this.page, this.limit);

  @override
  List<Object> get props => [page, limit];
}

final class FetchMoreJobPosts extends JobPostEvent {
  final int page;
  final int limit;

  const FetchMoreJobPosts(this.page, this.limit);

  @override
  List<Object> get props => [page, limit];
}

final class RefreshJobPosts extends JobPostEvent {
  final int page;
  final int limit;

  const RefreshJobPosts(this.page, this.limit);

  @override
  List<Object> get props => [page, limit];
}

final class RemoveJobPost extends JobPostEvent {
  final String jobId;

  const RemoveJobPost(this.jobId);

  @override
  List<Object> get props => [jobId];
}

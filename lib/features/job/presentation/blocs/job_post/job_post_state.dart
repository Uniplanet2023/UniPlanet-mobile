part of 'job_post_bloc.dart';

sealed class JobPostState extends Equatable {
  final List<JobPost> jobPosts;
  const JobPostState({this.jobPosts = const <JobPost>[]});

  @override
  List<Object> get props => [];
}

final class JobPostInitial extends JobPostState {
  const JobPostInitial() : super(jobPosts: const <JobPost>[]);

  @override
  List<Object> get props => [];
}

final class JobPostLoading extends JobPostState {
  const JobPostLoading(List<JobPost> jobPosts) : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [];
}

final class JobPostLoaded extends JobPostState {
  const JobPostLoaded(List<JobPost> jobPosts) : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [jobPosts];
}

final class JobPostError extends JobPostState {
  final String message;

  const JobPostError(this.message, List<JobPost> jobPosts)
      : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [message];
}

//remove job post

final class JobPostRemoving extends JobPostState {
  const JobPostRemoving(List<JobPost> jobPosts) : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [];
}

final class JobPostRemoved extends JobPostState {
  final String jobId;

  const JobPostRemoved(this.jobId, List<JobPost> jobPosts)
      : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [jobId];
}

final class JobPostRemoveError extends JobPostState {
  final String message;

  const JobPostRemoveError(this.message, List<JobPost> jobPosts)
      : super(jobPosts: jobPosts);

  @override
  List<Object> get props => [message];
}

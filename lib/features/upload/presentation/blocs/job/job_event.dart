part of 'job_bloc.dart';

sealed class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

final class PostJob extends JobEvent {
  final JobPost post;

  const PostJob(this.post);

  @override
  List<Object> get props => [post];
}

part of 'job_bloc.dart';

sealed class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

final class JobInitial extends JobState {}

final class JobPostInProgress extends JobState {}

final class JobPostSuccess extends JobState {}

final class JobPostFailure extends JobState {
  final String message;

  const JobPostFailure(this.message);

  @override
  List<Object> get props => [message];
}

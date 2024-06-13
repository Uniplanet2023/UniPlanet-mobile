part of 'report_bloc.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

class ReportingUserState extends ReportState {
  const ReportingUserState();

  @override
  List<Object> get props => [];
}

class ReportedUserState extends ReportState {
  const ReportedUserState();

  @override
  List<Object> get props => [];
}

class FailedToReportUserState extends ReportState {
  final String message;
  const FailedToReportUserState({required this.message});

  @override
  List<Object> get props => [message];
}

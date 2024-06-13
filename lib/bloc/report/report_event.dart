part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

final class ReportUserEvent extends ReportEvent {
  final String description;
  final String reportedUserId;
  final String reportType;
  final String productId;

  const ReportUserEvent(
      {required this.description,
      required this.reportedUserId,
      required this.reportType,
      required this.productId});
  @override
  List<Object> get props =>
      [description, reportedUserId, reportType, productId];
}

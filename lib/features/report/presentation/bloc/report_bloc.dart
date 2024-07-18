import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/core/network/repository/account_repository/account_repo.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final AccountRepository _accountRepository;
  ReportBloc(this._accountRepository) : super(ReportInitial()) {
    on<ReportUserEvent>((event, emit) async {
      await _reportUser(event, emit);
    });
  }
  Future<void> _reportUser(ReportUserEvent event, emit) async {
    emit(const ReportingUserState());
    try {
      bool isSent = await _accountRepository.reportUser(
          reportedUserId: event.reportedUserId,
          description: event.description,
          reportType: event.reportType,
          productId: event.productId);
      if (isSent) {
        emit(const ReportedUserState());
      } else {
        emit(const FailedToReportUserState(message: 'Fail to report user'));
      }
    } catch (e) {
      emit(const FailedToReportUserState(message: 'An error occurred'));
    }
  }
}

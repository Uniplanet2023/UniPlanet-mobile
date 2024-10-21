import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/send_ad_complain_mail.dart';

part 'mail_event.dart';
part 'mail_state.dart';

// Mail Bloc
class MailBloc extends Bloc<MailEvent, MailState> {
  final SendAdComplainMailUseCase sendAdComplainMailUseCase;

  MailBloc(this.sendAdComplainMailUseCase) : super(MailInitial()) {
    on<SendAdComplainMailEvent>(_onSendAdComplainMailEvent);
  }

  Future<void> _onSendAdComplainMailEvent(
    SendAdComplainMailEvent event,
    Emitter<MailState> emit,
  ) async {
    emit(MailLoading());
    try {
      await sendAdComplainMailUseCase.call(event.mailRequest);
      emit(MailSuccess());
    } catch (e) {
      emit(MailFailure(e.toString()));
    }
  }
}

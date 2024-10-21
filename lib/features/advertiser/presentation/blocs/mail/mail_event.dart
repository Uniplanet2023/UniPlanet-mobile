part of 'mail_bloc.dart';

sealed class MailEvent extends Equatable {
  const MailEvent();

  @override
  List<Object> get props => [];
}

class SendAdComplainMailEvent extends MailEvent {
  final AdMailRequest mailRequest;

  const SendAdComplainMailEvent(this.mailRequest);

  @override
  List<Object> get props => [mailRequest];
}

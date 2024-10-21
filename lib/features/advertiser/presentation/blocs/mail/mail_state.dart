part of 'mail_bloc.dart';

sealed class MailState extends Equatable {
  const MailState();

  @override
  List<Object> get props => [];
}

final class MailInitial extends MailState {}

class MailLoading extends MailState {}

class MailSuccess extends MailState {}

class MailFailure extends MailState {
  final String message;

  const MailFailure(this.message);

  @override
  List<Object> get props => [message];
}
